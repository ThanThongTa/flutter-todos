// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aufgabe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AufgabeAdapter extends TypeAdapter<Aufgabe> {
  @override
  final int typeId = 1;

  @override
  Aufgabe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Aufgabe(
      name: fields[0] as String,
      description: fields[1] as String,
    )..done = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, Aufgabe obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.done);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AufgabeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
