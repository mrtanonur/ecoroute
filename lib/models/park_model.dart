import 'dart:core';

import 'package:hive_flutter/hive_flutter.dart';

part 'park_model.g.dart';

@HiveType(typeId: 0)
class ParkModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String address;
  @HiveField(3)
  final double latitude;
  @HiveField(4)
  final double longitude;

  ParkModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  ParkModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return ParkModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory ParkModel.fromJson(Map<String, dynamic> json) {
    return ParkModel(
      id: json["id"],
      name: json["displayName"]["text"],
      address: json["formattedAddress"],
      latitude: json["location"]["latitude"],
      longitude: json["location"]["longitude"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "displayName": name,
      "formattedAddress": address,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  factory ParkModel.fromFirestore(Map<String, dynamic> json) {
    return ParkModel(
      id: json['id'] ?? '',
      name: json['displayName'] ?? '',
      address: json['formattedAddress'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}
