// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParkModelAdapter extends TypeAdapter<ParkModel> {
  @override
  final int typeId = 0;

  @override
  ParkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParkModel(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ParkModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
