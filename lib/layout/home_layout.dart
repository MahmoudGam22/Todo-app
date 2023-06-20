// ignore_for_file: unused_local_variable, must_be_immutable, unused_import
import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class Homelayout extends StatelessWidget {
  
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

 
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>Appcubit()..createDatabase(),
      child: BlocConsumer < Appcubit,Appstates>(
        listener: (BuildContext context, state) {
          if(state is AppInsertDatabasestate){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {   
        Appcubit cubit=Appcubit.get(context);
        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetDatabaseloadingstate,
            builder: (context) => cubit.screens[cubit.currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isbuttonsheetshown) {
                if (formkey.currentState!.validate()) {
                  cubit.insertToDatabase(title: titlecontroller.text, time: timecontroller.text, date: datecontroller.text);
                 
                } 
              } else {
                scaffoldkey.currentState
                    ?.showBottomSheet(
                      (context) => Container(
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultff(
                                  controller: titlecontroller,
                                  kType: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'task title',
                                  prefix: Icon(Icons.title)),
                              SizedBox(
                                height: 15,
                              ),
                              defaultff(
                                  controller: timecontroller,
                                  kType: TextInputType.datetime,
                                  tap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timecontroller.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'task time',
                                  prefix: Icon(Icons.watch_later_outlined)),
                              SizedBox(
                                height: 15,
                              ),
                              defaultff(
                                  controller: datecontroller,
                                  kType: TextInputType.datetime,
                                  tap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-06-28'),
                                    ).then((value) {
                                      datecontroller.text = DateFormat('yyyy-MM-dd').format(value!);
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'task date',
                                  prefix: Icon(Icons.calendar_today)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .closed
                    .then((value) {
                  cubit.Changebottomsheetstate(isshow: false, icon: Icons.edit);
                });
                cubit.Changebottomsheetstate(isshow: true, icon: Icons.add);
              } 
            },
            child: Icon(cubit.fabicon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
             cubit.changeindex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline,
                ),
                label: 'done',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.architecture_outlined,
                ),
                label: 'archived',
              ),
            ],
          ),
        );
        },
      ),
    );
  }
}
  