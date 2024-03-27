// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:futures_local_storage_and_database/database/aufgabe.dart';
import 'package:futures_local_storage_and_database/screens/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import 'database/todoliste.dart';

void main() async {
  // Initialisierung von Hive
  await Hive.initFlutter(); // Hive_flutter importieren
  // Adapter für die Aufgabe registrieren
  Hive.registerAdapter(AufgabeAdapter());
  // wir öffnen/erstellen eine Hive-Box, in welche wir unsere Daten ablegen können
  // (Es sind beliebig viele Boxen möglich)
  await Hive.openBox(
      ToDoList.toDoBoxKey); // sonst können wir nicht auf Inhalt zugreifen

  await Hive.openBox<Aufgabe>("aufgaben"); // in diese Box kommen nur Aufgaben

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ToDos(),
        );
      },
    );
  }
}
