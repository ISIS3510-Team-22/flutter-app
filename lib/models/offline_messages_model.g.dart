// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_messages_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineMessageAdapter extends TypeAdapter<OfflineMessage> {
  @override
  final int typeId = 1;

  @override
  OfflineMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineMessage(
      senderId: fields[0] as String,
      receiverId: fields[1] as String,
      texto: fields[2] as String,
      timestamp: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.senderId)
      ..writeByte(1)
      ..write(obj.receiverId)
      ..writeByte(2)
      ..write(obj.texto)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
