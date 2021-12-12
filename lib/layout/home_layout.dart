// ignore_for_file: avoid_print, invalid_return_type_for_catch_error, must_be_immutable

import 'package:botcamp_flutter_challenge/shared/cubit/cubit.dart';
import 'package:botcamp_flutter_challenge/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodoApp extends StatelessWidget {
  //this list for multi app bar text

//this var for detect is the bottom sheet shown or hidden

//this key for scaffold and form
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
//this controller for text form field
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
//this for toggle between icons

  //this var for create database

  TodoApp({Key? key}) : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates states) {
        if (states is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppStates states) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              elevation: 5.0,
              onTap: (index) {
                cubit.changeIndex(index);
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
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    // cubit
                    //     .insertToDatabase(
                    //   time: timeController.text,
                    //   date: dateController.text,
                    //   title: titleController.text,
                    // )!
                    //     .then((value) {
                    //   cubit
                    //       .getDataFromDatabase(cubit.dataBase)
                    //       .then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShown = false;
                    //     //   fabIcon = Icons.edit;
                    //     //   tasks = value;
                    //     // });
                    //     cubit.changeBottomSheetsStates({icon: Icons.edit,isShow: false} )
                    //     {};
                    //   });
                    // });
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
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
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
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
                                    }).catchError((error) =>
                                        print('onError when chose the time '));
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
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
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
                                      dateController.text = DateFormat.yMMMd()
                                          .format(value!)
                                          .toString();
                                      // dateController.text = value!.format(context);
                                    }).catchError((error) =>
                                        print('error when insert the time '));
                                  },
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      //this use for closed bottom sheet <Future>
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
            ),
            // condition: state is! AppGetDatabaseLoadingState,
            // builder: (context) => cubit.screens[cubit.currentIndex],
            // fallback: (context) => Center(child: CircularProgressIndicator()),
            body: states is! AppGetDatabaseLoadingState
                ? cubit.screens[cubit.currentIndex]
                : const Center(child: CircularProgressIndicator()));
      }),
    );
  }
}
