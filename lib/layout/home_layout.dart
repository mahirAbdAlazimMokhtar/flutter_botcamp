// ignore_for_file: avoid_print

import 'package:botcamp_flutter_challenge/components/components.dart';
import 'package:botcamp_flutter_challenge/modules/archived_tatsks/archived_task_screen.dart';
import 'package:botcamp_flutter_challenge/modules/done_tasks/done_task_screen.dart';
import 'package:botcamp_flutter_challenge/modules/new_tasks/new_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  List<Widget> screens = [
    const NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchivedTaskScreen(),
  ];
  Database? database;
  List<String> titles = ['New Task', 'Done Task', 'Archived Task'];
  int currentIndex = 0;
  IconData fabIcon = Icons.edit;
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
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
                (context) => Form(
                      key: formKey,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'title must not be empty';
                                  } else {
                                    return null;
                                  }
                                },
                                label: 'Task Title',
                                prefix: Icons.title),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                controller: timeController,
                                onTap: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((value) {
                                    //this for catch the time by controller
                                    timeController.text =
                                        value!.format(context).toString();
                                  });
                                },
                                type: TextInputType.datetime,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                },
                                label: 'Time Task',
                                prefix: Icons.watch_later),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                controller: dateController,
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2022-02-03'))
                                      .then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                type: TextInputType.datetime,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                },
                                label: 'Task Date',
                                prefix: Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                elevation: 20.0);
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
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
      body: screens[currentIndex],
    );
  }

  Future<String> getName() async {
    return "Mahir Ali";
  }

  createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('the database created $database');
        database
            .execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY , '
                'title TEXT , '
                'date TEXT ,'
                ' time TEXT ,'
                'status TEXT )')
            .then((value) => () {
                  print('table created');
                })
            .catchError((onError) {
          print('Error When Creating Table ${onError.toString()}');
        });
      },
      onOpen: (database) {
        print('the database opened $database');
      },
    );
  }

  Future? insertToDatabase(
          {required String title, required String time, required date}) =>
      database?.transaction((txn) async {
        txn
            .rawInsert(
                'INSERT INTO  tasks (title , date , time , status )VALUES("$title","$time","$date","Good")')
            .then((value) => {print('$value insert successfully')})
            .catchError((error) {
          print('Error When Inserting New Record $error');
        });
        return null;
      });
}
