import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoroute/dependency_injection.dart';
import 'package:ecoroute/models/park_model.dart';
import 'package:ecoroute/models/user_model.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore = sl.get<FirebaseFirestore>();
  final FirebaseAuth _firebaseAuth = sl.get<FirebaseAuth>();
  final String _userCollection = "user";
  final String _favoriteCollection = "favorite";

  Future<Either<String, void>> storeUserData(UserModel userModel) async {
    try {
      await _firebaseFirestore
          .collection(_userCollection)
          .doc(userModel.id)
          .set(userModel.toJson());

      return const Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, UserModel>> getUserData() async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      final response = await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .get();
      final UserModel userModel = UserModel.fromJson(response.data()!);

      return Right(userModel);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> addFavorite(ParkModel parkModel) async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .doc(parkModel.id)
          .set(parkModel.toJson());
      return const Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> removeFavorite(String parkId) async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .doc(parkId)
          .delete();
      return const Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, List<ParkModel>>> getFavorites() async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      final snapshot = await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .get();

      List<ParkModel> list = snapshot.docs
          .map((doc) => ParkModel.fromFirestore(doc.data()))
          .toList();
      return Right(list);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }
}
