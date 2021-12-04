// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

/*
* one you want to crate a database
* 1 - create database
* 2 - crate tables
* 3 - open database
* 4 - insert to database
* 5 - get from database
* 6 - update in database
* 7 - delete form database
* */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  _TodoAppState createState() => _TodoAppState();
}

List<String> titleText = ['New Task', 'Done Task', 'Archived Task'];

int currentIndex = 0;
bool isBottomSheetShown = false;
var scaffoldKey = GlobalKey<ScaffoldState>();
var formKey = GlobalKey<FormState>();
var titleController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();
IconData fabIcon = Icons.edit;

class _TodoAppState extends State<TodoApp> {
  Database? dataBase;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titleText[currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 5.0,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archived'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(fabIcon),
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                time: timeController.text,
                date: dateController.text,
                title: titleController.text,
              )!
                  .then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldKey.currentState!.showBottomSheet(
              (context) => Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsetsDirectional.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        decoration: InputDecoration(
                          label: const Text('Title Task'),
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'title must not be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: timeController,
                        decoration: InputDecoration(
                          label: const Text('Time Task'),
                          prefixIcon: const Icon(Icons.watch_later),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ' time must not be empty';
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            timeController.text =
                                value!.format(context).toString();
                          }).catchError(
                              (error) => print('onError when chose the time '));
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: dateController,
                        decoration: InputDecoration(
                          label: const Text('Archived Task'),
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'archived must not be empty';
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-09-03'),
                          ).then((value) {
                            dateController.text =
                                DateFormat.yMMMd().format(value!).toString();
                            // dateController.text = value!.format(context);
                          }).catchError(
                              (error) => print('error when insert the time '));
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
            isBottomSheetShown = true;
          }
        },
      ),
    );
  }

  //this method for crate database
  void createDataBase() {
    openDatabase(
      'todo1.db',
      onOpen: (dataBase) {
        this.dataBase = dataBase;
        print('the database is opened');
      },
      version: 1,
      //in onCreated you can created the database
      /*
      * id integer
      * title string
      * date string
      * time string
      * status string
      *  */
      onCreate: (database, version) {
        database
            .execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY,'
                'title TEXT , date TEXT ,time TEXT,status TEXT )')
            .then((value) {})
            .catchError((error) {});
      },
    ).then((value) {
      print('database created $value');
    }).catchError((error) {
      print('error when the database created');
    });
  }

  insertToDatabase(
          {required String title, required String time, required date}) =>
      dataBase?.transaction((txn) async {
        return await txn
            .rawInsert('INSERT INTO  tasks (title , date , time , status )'
                'VALUES("$title","$time","$date","Good")')
            .then((value) => {print('$value insert successfully')})
            .catchError((error) {
          print('Error When Inserting New Record $error');
        });
      });
}
