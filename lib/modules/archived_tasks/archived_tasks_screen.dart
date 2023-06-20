import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';

import '../../shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<Appcubit, Appstates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = Appcubit.get(context).archivedtasks;
        return tasksbuilder(tasks: tasks);
      },
    );
    
    
  }
}