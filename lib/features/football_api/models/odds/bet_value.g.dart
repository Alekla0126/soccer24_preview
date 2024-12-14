// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bet_value.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BetValueAdapter extends TypeAdapter<BetValue> {
  @override
  final int typeId = 2;

  @override
  BetValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BetValue(
      value: fields[0] as String,
      odd: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BetValue obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.odd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BetValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
