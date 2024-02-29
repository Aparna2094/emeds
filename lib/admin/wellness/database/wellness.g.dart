// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WellnessAdapter extends TypeAdapter<Wellness> {
  @override
  final int typeId = 5;

  @override
  Wellness read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wellness(
      proname: fields[0] as String,
      procategory: fields[1] as String,
      proprice: fields[2] as String,
      image2: fields[3] as String,
      countryOforigin: fields[4] as String,
      id3: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Wellness obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.proname)
      ..writeByte(1)
      ..write(obj.procategory)
      ..writeByte(2)
      ..write(obj.proprice)
      ..writeByte(3)
      ..write(obj.image2)
      ..writeByte(4)
      ..write(obj.countryOforigin)
      ..writeByte(5)
      ..write(obj.id3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellnessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
