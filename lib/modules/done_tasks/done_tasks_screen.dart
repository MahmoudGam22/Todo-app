import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Appcubit, Appstates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = Appcubit.get(context).donetasks;
        return tasksbuilder(tasks: tasks);
      },
    );
  }
}
