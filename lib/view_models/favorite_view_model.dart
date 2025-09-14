import 'package:ecoroute/core/utils/local_data_source/favorite_local_data_source.dart';
import 'package:ecoroute/models/park_model.dart';
import 'package:ecoroute/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';

enum FavoriteStatus { initial, favoritesLoaded, failure }

class FavoriteViewModel extends ChangeNotifier {
  final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();
  List<ParkModel?> favoriteParks = [];
  String? error;
  FavoriteStatus status = FavoriteStatus.initial;

  Future getFavorites() async {
    final response = await firestoreService.getFavorites();
    response.fold(
      (String errorMessage) {
        favoriteParks = FavoriteLocalDataSource.readAll();
        error = errorMessage;
        status = FavoriteStatus.failure;
        print("provider failure");
      },
      (List<ParkModel> favorites) {
        favoriteParks = favorites;
        status = FavoriteStatus.favoritesLoaded;
      },
    );
    notifyListeners();
  }

  Future favorite(ParkModel parkModel) async {
    if (favoriteParks.any((park) => park?.id == parkModel.id)) {
      favoriteParks.removeWhere((item) => item?.id == parkModel.id);

      await FavoriteLocalDataSource.delete(parkModel.id);

      await firestoreService.removeFavorite(parkModel.id);
    } else {
      favoriteParks.add(parkModel);
      await FavoriteLocalDataSource.add(parkModel);
      await firestoreService.addFavorite(parkModel);
    }
    notifyListeners();
  }

  bool isFavorite(ParkModel parkModel) {
    if (favoriteParks.any((park) => park?.id == parkModel.id)) {
      return true;
    } else {
      return false;
    }
  }
}
