import 'package:hive/hive.dart';

part 'aufgabe.g.dart';

@HiveType(typeId: 1)
class Aufgabe extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool done = false;

  Aufgabe({
    required this.name,
    required this.description,
  });
}
