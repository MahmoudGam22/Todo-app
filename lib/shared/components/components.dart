import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultbutton({
  double width = double.infinity,
  Color background = Colors.blue,
  double borderradius = 3,
  required VoidCallback function,
  required String text,
  bool isuppercase = true,
}) =>
    Container(
      height: 40,
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isuppercase ? text.toUpperCase() : text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderradius),
        color: background,
      ),
    );

Widget defaultff({
  required TextEditingController controller,
  required TextInputType kType,
  void Function(String)? onsubmit,
  required String? Function(String?)? validate,
  required String label,
  required Icon prefix,
  IconData? suffix,
  bool ispassword = false,
  void Function()? suffixpressed,
  void Function()? tap,
  bool isclickable = true,
}) =>
    TextFormField(
      obscureText: ispassword,
      validator: validate,
      controller: controller,
      keyboardType: kType,
      onFieldSubmitted: onsubmit,
      onTap: tap,
      enabled: isclickable,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: prefix,
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixpressed, icon: Icon(suffix))
            : null,
      ),
    );
Widget buildtaskitem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Text(
                '${model['time']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                Appcubit.get(context)
                    .updatedata(statues: 'done', id: model['id']);
              },
              icon: Icon(Icons.check_box),
              color: Color.fromARGB(255, 145, 184, 101),
              padding: EdgeInsets.all(8),
              splashRadius: 20,
              tooltip: 'done',
            ),
            IconButton(
              onPressed: () {
                Appcubit.get(context)
                    .updatedata(statues: 'archived', id: model['id']);
              },
              icon: Icon(Icons.archive),
              color: Colors.lightBlue,
              padding: EdgeInsets.all(8),
              splashRadius: 20,
              tooltip: 'Archive',
            ),
          ],
        ),
      ),
   onDismissed: (direction){
    Appcubit.get(context).deletedata(id: model['id']);
   },
    );
Widget tasksbuilder(
  {
    required List<Map>tasks,
  }
)=>
ConditionalBuilder(
          condition: tasks.length > 0,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  buildtaskitem(tasks[index], context),
              separatorBuilder: (context, index) => Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
              itemCount: tasks.length),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 50,
                  color: Colors.grey,
                ),
                Text(
                  'NO Tasks Yet, please add some tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );