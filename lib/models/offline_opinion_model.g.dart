// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_opinion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineOpinionAdapter extends TypeAdapter<OfflineOpinion> {
  @override
  final int typeId = 1;

  @override
  OfflineOpinion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineOpinion(
      name: fields[0] as String,
      id: fields[1] as String,
      rating: fields[2] as double,
      comment: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineOpinion obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineOpinionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
