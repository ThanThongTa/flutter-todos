import 'package:hive_flutter/hive_flutter.dart';

import 'aufgabe.dart';

class ToDoList {
  // --------- static strings used as keys ---------
  static const String toDoBoxKey = "toDoBox"; // name of the box
  static const String toDoListKey = "TODOLIST"; // name of an item in the box
  static const String aufgabenListKey =
      "AUFGABENLIST"; // name of an item in the box
  // --------- end of static strings

  // --------- variables ---------
  List aufgabenListe = [];

  List aufgaben = [];
  // wir erstellen einen Verweis zu unserer Hive-Box,
  // welche wir in der main.dart geöffnet haben
  final myToDoBox = Hive.box(toDoBoxKey);

  // --------- methods ---------

  // Funktion zum ersten Befüllen der Aufgabenliste, bei Erststart der App
  void createInitialData() {
    aufgabenListe = [
      ["Platzhalter Aufgabe", false],
      ["Aufgabe 2", false]
    ];

    aufgaben = [
      Aufgabe(name: "Platzhalter Aufgabe", description: "Eine Beschreibung"),
      Aufgabe(name: "Aufgabe 2", description: "eine andere Beschreibung"),
    ];
  }

  // Funktion zum Befüllen der Aufgaben-Liste aus der ToDoBox
  void loadData() {
    aufgabenListe = myToDoBox.get(toDoListKey);
    aufgaben = myToDoBox.get(aufgabenListKey);
  }

  // Funktion zum aktualisieren der Box
  void updateDatabase() {
    myToDoBox.put(toDoListKey, aufgabenListe);
    myToDoBox.put(aufgabenListKey, aufgaben);
  }
}
