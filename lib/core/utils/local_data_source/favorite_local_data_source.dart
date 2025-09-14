import 'package:ecoroute/models/park_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteLocalDataSource {
  static Box<ParkModel>? box;
  static Future openBox() async {
    box = await Hive.openBox("park");
  }

  static read(ParkModel park) {
    box!.get(park.id);
  }

  static List<ParkModel?> readAll() {
    return box!.values.toList();
  }

  static Future add(ParkModel park) async {
    await box!.put(park.id, park);
  }

  static Future delete(String id) async {
    await box!.delete(id);
  }

  static Future clear() async {
    await box!.clear();
  }
}
