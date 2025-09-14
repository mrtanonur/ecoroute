import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoroute/core/utils/local_data_source/favorite_local_data_source.dart';
import 'package:ecoroute/core/utils/local_data_source/main_local_data_source.dart';
import 'package:ecoroute/models/park_model.dart';
import 'package:ecoroute/services/firebase_authentication_service.dart';
import 'package:ecoroute/services/firebase_firestore_service.dart';
import 'package:ecoroute/services/googlemaps_service.dart';
import 'package:ecoroute/services/open_weather_service.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:ecoroute/view_models/favorite_view_model.dart';
import 'package:ecoroute/view_models/location_view_model.dart';
import 'package:ecoroute/view_models/main_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future initializeDependencies() async {
  await dotenv.load();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ParkModelAdapter());
  await MainLocalDataSource.openBox();
  await FavoriteLocalDataSource.openBox();

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);

  sl.registerLazySingleton<FirebaseAuthenticationService>(
    () => FirebaseAuthenticationService(),
  );
  sl.registerLazySingleton<FirebaseFirestoreService>(
    () => FirebaseFirestoreService(),
  );
  sl.registerLazySingleton<GoogleMapsService>(() => GoogleMapsService());
  sl.registerLazySingleton<OpenWeatherService>(() => OpenWeatherService());

  sl.registerLazySingleton(() => AuthViewModel());
  sl.registerLazySingleton(() => MainViewModel());
  sl.registerLazySingleton(() => LocationViewModel());
  sl.registerLazySingleton(() => FavoriteViewModel());
}
