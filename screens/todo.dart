// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:futures_local_storage_and_database/database/aufgabe.dart';
import 'package:futures_local_storage_and_database/database/todoliste.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

// import 'login.dart';

class ToDos extends StatefulWidget {
  const ToDos({super.key});

  @override
  State<ToDos> createState() => _ToDosState();
}

class _ToDosState extends State<ToDos> with SingleTickerProviderStateMixin {
  // Lokale Aufgabenliste
  ToDoList aufgaben = ToDoList();
  var meineHiveBox = Hive.box(ToDoList.toDoBoxKey);
  var meinAufgabenController = TextEditingController();
  late final meinSlidableController = SlidableController(this);

  @override
  void initState() {
    meineHiveBox = Hive.box(ToDoList.toDoBoxKey);
    // falls die Aufgabenliste noch nicht initiiert ist
    if (meineHiveBox.get(ToDoList.toDoListKey) == null ||
        meineHiveBox.get(ToDoList.aufgabenListKey) == null) {
      // lade die Initialdaten
      aufgaben.createInitialData();
      // speichere die Initialdaten in die Box
      aufgaben.updateDatabase();
      // lade die Initialdaten aus der Box ins Key Value Pair
      aufgaben.loadData();
    } else {
      // ansonsten lade einfach die Daten aus der Box
      aufgaben.loadData();
    }
    // init der Oberklasse
    super.initState();
  }

  @override
  void dispose() {
    // Box wieder schließen
    meineHiveBox.close();
    // dispose der Oberklasse
    super.dispose();
  }

// changes the done property of the custom Aufgabe
  void changeAufgabeDone({required int index}) {
    setState(() {
      aufgaben.aufgaben[index].done = !aufgaben.aufgaben[index].done;
    });
    aufgaben.updateDatabase();
  }

// deletes the Aufgabe
  void deleteAufgabe({required int index}) {
    setState(() {
      aufgaben.aufgaben.remove(aufgaben.aufgaben[index]);
    });
    aufgaben.updateDatabase();
  }

// saves the Aufgabe
  void saveNewAufgabe() {
    setState(() {
      aufgaben.aufgaben
          .add(Aufgabe(name: meinAufgabenController.text, description: ""));
      meinAufgabenController.clear();
    });
    aufgaben.updateDatabase();
  }

// changes the value of the checkbox for finished todo's
  void changeDone({required int index}) {
    setState(() {
      aufgaben.aufgabenListe[index][1] = !aufgaben.aufgabenListe[index][1];
    });
    aufgaben.updateDatabase();
  }

// deletes the todo
  void deleteToDo({required int index}) {
    setState(() {
      aufgaben.aufgabenListe.remove(aufgaben.aufgabenListe[index]);
    });
    aufgaben.updateDatabase();
  }

// saves a new todo
  void saveNewToDo() {
    setState(() {
      aufgaben.aufgabenListe.add([meinAufgabenController.text, false]);
      meinAufgabenController.clear();
    });
    aufgaben.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(ToDoList.toDoBoxKey).listenable(),
        builder: (context, box, widget) {
          return Scaffold(
            appBar: AppBar(
              title: Text("ToDo's"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    // the form to create a new todo
                    createNewToDoForm(),
                    // the created todo's
                    ListView.builder(
                      itemCount: aufgaben.aufgabenListe.length,
                      // to make the list scrollable
                      physics: PageScrollPhysics(),
                      // ohne shrinkWrap gibt es die Fehlermeldung, dass die Size nicht angegeben ist
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return createToDoItem(index);
                      },
                    ),
                    ListView.builder(
                      itemCount: aufgaben.aufgaben.length,
                      physics: PageScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return createAufgabenItem(index);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget createToDoItem(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.w,
        vertical: 1.0.h,
      ),
      child: Container(
        color: Colors.amber,
        height: 7.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // zwei Rows, damit eines linksbündig und das andere rechtsbündig ist

            // Row für die SizeBox und den Namen der ToDo, linksbündig mit 4.0.w Abstand
            Row(
              children: [
                SizedBox(
                  width: 4.0.w,
                ),
                Text(
                  aufgaben.aufgabenListe[index][0],
                  // strike through finished todo's
                  style: TextStyle(
                    decoration: aufgaben.aufgabenListe[index][1]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
            // Row für die Checkbox und das Delete Icon, rechtsbündig
            // chekcbox und iconbutton compact, damit der Abstand zum Titel etwas grüößer ist
            Row(
              children: [
                // checkbox for finished todo's
                Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: aufgaben.aufgabenListe[index][1],
                  onChanged: (value) => changeDone(index: index),
                ),
                // delete todo's
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => deleteToDo(index: index),
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createAufgabenItem(int index) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) => deleteAufgabe(index: index),
          backgroundColor: Colors.teal,
          icon: Icons.delete_outline,
          label: "Löschen",
        ),
      ]),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0.w,
          vertical: 1.0.h,
        ),
        child: Container(
          color: Colors.amber,
          height: 7.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // zwei Rows, damit eines linksbündig und das andere rechtsbündig ist

              // Row für die SizeBox und den Namen der ToDo, linksbündig mit 4.0.w Abstand
              Row(
                children: [
                  SizedBox(
                    width: 4.0.w,
                  ),
                  Text(
                    aufgaben.aufgaben[index].name,
                    // strike through finished todo's
                    style: TextStyle(
                      decoration: aufgaben.aufgaben[index].done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
              // Row für die Checkbox und das Delete Icon, rechtsbündig
              // chekcbox und iconbutton compact, damit der Abstand zum Titel etwas grüößer ist
              Row(
                children: [
                  // checkbox for finished todo's
                  Checkbox(
                    visualDensity: VisualDensity.compact,
                    value: aufgaben.aufgaben[index].done,
                    onChanged: (value) => changeAufgabeDone(index: index),
                  ),
                  // delete todo's
                  // IconButton(
                  //   visualDensity: VisualDensity.compact,
                  //   onPressed: () => deleteAufgabe(index: index),
                  //   icon: Icon(Icons.delete_outline),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox createNewToDoForm() {
    return SizedBox(
      height: 27.h,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0.w,
          vertical: 1.0.h,
        ),
        child: Container(
          color: Colors.amber,
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          child: Column(
            children: [
              Text("Aufgabe erstellen"),
              TextField(
                controller: meinAufgabenController,
                decoration: InputDecoration(
                  hintText: "Neue Aufgabe",
                  hintStyle: TextStyle(color: Colors.black45),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              ElevatedButton(
                onPressed: () => saveNewToDo(),
                child: Text("Speichern als ToDo"),
              ),
              SizedBox(
                height: 5.0,
              ),
              ElevatedButton(
                onPressed: () => saveNewAufgabe(),
                child: Text("Speichern als Aufgabe"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
