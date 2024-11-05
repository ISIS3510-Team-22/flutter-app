// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_profile_update_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineProfileUpdateAdapter extends TypeAdapter<OfflineProfileUpdate> {
  @override
  final int typeId = 2;

  @override
  OfflineProfileUpdate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineProfileUpdate(
      userId: fields[0] as String,
      name: fields[1] as String?,
      profilePictureUrl: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineProfileUpdate obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.profilePictureUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineProfileUpdateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
