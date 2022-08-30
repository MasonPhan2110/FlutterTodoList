import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/screen/taskpage.dart';
import 'package:todolist/widgets.dart';

import '../models/task.dart';

class Homepage extends StatefulWidget {
  List<Task> listTask;
  Homepage({required this.listTask});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  void _getTaskWithDate(String date) async {
    widget.listTask = await _dbHelper.getTaskwithDate(date);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _getTaskWithDate(
        "${_focusedDay.year}${_focusedDay.month}${_focusedDay.day}");
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      widget.listTask = <Task>[];
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _getTaskWithDate(
            "${selectedDay.year}${selectedDay.month}${selectedDay.day}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _dbHelper.deleteAllTasksAndTodos();
    return Scaffold(
      body: SafeArea(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              color: const Color(0xFFF6F6F6),
              child: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              const EdgeInsets.only(bottom: 32.0, top: 32.0),
                          child: const Image(
                            image: AssetImage('assets/images/slack.png'),
                            height: 40,
                            width: 40,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: TableCalendar(
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            firstDay: DateTime.utc(2010, 10, 16),
                            focusedDay: _focusedDay,
                            lastDay: DateTime.utc(2030, 3, 14),
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            calendarFormat: _calendarFormat,
                            rangeSelectionMode: _rangeSelectionMode,
                            calendarStyle: const CalendarStyle(
                              // Use `CalendarStyle` to customize the UI
                              outsideDaysVisible: false,
                            ),
                            onDaySelected: _onDaySelected,
                          ),
                        ),
                        Expanded(
                            child: ScrollConfiguration(
                                behavior: NoGlowBehavior(),
                                child: FutureBuilder(
                                  future: _dbHelper.getTaskwithDate(
                                      "${_focusedDay.year}${_focusedDay.month}${_focusedDay.day}"),
                                  builder: (context,
                                      AsyncSnapshot<List<Task>> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          itemCount: snapshot.data?.length,
                                          itemBuilder: ((context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      TaskPage(
                                                                        task: snapshot
                                                                            .data![index],
                                                                        date: snapshot
                                                                            .data![index]
                                                                            .date,
                                                                      )))
                                                      .then((value) =>
                                                          setState(() {
                                                            _getTaskWithDate(
                                                                "${_selectedDay?.year}${_selectedDay?.month}${_selectedDay?.day}");
                                                          }));
                                                },
                                                child: TaskCardWidget(
                                                  title: snapshot
                                                      .data![index].title,
                                                ));
                                          }));
                                    }
                                    return Container();
                                  },
                                )))
                      ]),
                  Positioned(
                      bottom: 24.0,
                      right: 0.0,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskPage(
                                    task: Task(),
                                    date:
                                        "${_selectedDay?.year}${_selectedDay?.month}${_selectedDay?.day}",
                                  ),
                                )).then((value) {
                              setState(() {
                                _getTaskWithDate(
                                    "${_selectedDay?.year}${_selectedDay?.month}${_selectedDay?.day}");
                              });
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: const Image(
                              image: AssetImage("assets/images/add.png"),
                              width: 60.0,
                              height: 60.0,
                            ),
                          )))
                ],
              ))),
    );
  }
}
