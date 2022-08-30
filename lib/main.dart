import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/screen/homepage.dart';

import 'database_helper.dart';
import 'models/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final DatabaseHelper _dbHelper = DatabaseHelper();
    var listTask = <Task>[];
    void _getTaskWithDate(String date) async {
      listTask = await _dbHelper.getTaskwithDate(date);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme:
                GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme)),
        home: Homepage(
          listTask: listTask,
        ));
  }
}
