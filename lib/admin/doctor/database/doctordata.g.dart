// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctordata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctordataAdapter extends TypeAdapter<Doctordata> {
  @override
  final int typeId = 3;

  @override
  Doctordata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Doctordata(
      docname: fields[0] as String,
      doccategory: fields[1] as String,
      exp: fields[2] as String,
      image1: fields[3] as String,
      education: fields[4] as String,
      id1: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Doctordata obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.docname)
      ..writeByte(1)
      ..write(obj.doccategory)
      ..writeByte(2)
      ..write(obj.exp)
      ..writeByte(3)
      ..write(obj.image1)
      ..writeByte(4)
      ..write(obj.education)
      ..writeByte(5)
      ..write(obj.id1);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctordataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
