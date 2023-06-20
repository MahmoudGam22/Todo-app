import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class Appcubit extends Cubit<Appstates> {
  Appcubit() : super(AppInitialState());
  static Appcubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  late Database database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New tasks',
    'Done tasks',
    'Archived tasks',
  ];
  void changeindex(int index) {
    currentIndex = index;
    emit(AppchangebottomNavbarstate());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE TASKS(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,statues TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getdatafromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppcreateDatabasestate());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async =>
      await database.transaction((txn) {
        return txn
            .rawInsert(
                'INSERT INTO tasks(title,date,time,statues) VALUES ("$title","$date","$time","new")')
            .then((value) {
          print('$value inserted');
          emit(AppInsertDatabasestate());
          getdatafromDatabase(database);
        }).catchError((error) {
          print('error while insert raw ${error.toString()}');
        });
      });
  void getdatafromDatabase(database) {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    emit(AppGetDatabaseloadingstate());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['statues'] == 'new') {
          newtasks.add(element);
        } else if (element['statues'] == 'done') {
          donetasks.add(element);
        } else {
          archivedtasks.add(element);
        }
      });
      emit(AppGetDatabasestate());
    });
  }

  void updatedata({
    required String statues,
    required int id,
  }) {
    database.rawUpdate('UPDATE tasks SET statues = ? WHERE id = ?',
        ['$statues', id]).then((value) {
      getdatafromDatabase(database);
      emit(AppupdateDatabasestate());
    });
  }

 void deletedata({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      getdatafromDatabase(database);
      emit(AppdeleteDatabasestate());
    });
  }
  bool isbuttonsheetshown = false;
  IconData fabicon = Icons.edit;
  void Changebottomsheetstate({
    required bool isshow,
    required IconData icon,
  }) {
    isbuttonsheetshown = isshow;
    fabicon = icon;
    emit(Appchangebottomsheetrstate());
  }
}
