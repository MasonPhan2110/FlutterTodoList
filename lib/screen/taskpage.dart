import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  final String date;
  TaskPage({required this.task, required this.date});

  var title, Description = "";
  var listTodo = <Todo>[];
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper dbHelper = DatabaseHelper();
  String _taskTitle = "";
  @override
  void initState() {
    if (widget.task.id != 0) {
      _taskTitle = widget.task.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 6.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Image(
                            image: AssetImage("assets/images/left-arrow.png"),
                            width: 35.0,
                            height: 35.0,
                          )),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () async {
                              if (widget.task.id != 0) {
                                await dbHelper.deleteTask(widget.task.id);
                                print("Delete Success");
                              } else {
                                List<Task> listTask = await dbHelper.getTasks();
                                Task newTask = Task(
                                    id: listTask.length + 1,
                                    title: widget.title,
                                    description: widget.Description,
                                    date: widget.date);
                                await dbHelper.insertTask(newTask);
                                // ignore: avoid_print
                                print("New Task has been created");
                              }

                              Navigator.pop(context);
                            },
                            child: Container(
                                decoration: const BoxDecoration(),
                                child:
                                    Text(widget.task.id == 0 ? "Add" : "Delete",
                                        style: const TextStyle(
                                          color: Color(0xFF088DF4),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        )))),
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  onSubmitted: (value) async {
                    if (value != "") {
                      if (widget.task.id == 0) {
                        widget.title = value;
                      } else {
                        print("Updating the existing task");
                      }
                    }
                  },
                  controller: TextEditingController()..text = _taskTitle,
                  decoration: const InputDecoration(
                      hintText: "Enter Task Title ...",
                      border: InputBorder.none),
                  style: const TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF211551)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    onSubmitted: (value) {
                      widget.Description = value;
                    },
                    decoration: const InputDecoration(
                        hintText: "Enter Description for the task ...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.0)),
                  )),
              Expanded(
                  child: ScrollConfiguration(
                      behavior: NoGlowBehavior(),
                      child: FutureBuilder(
                        future: dbHelper.getTodos(widget.task.id),
                        builder:
                            (context, AsyncSnapshot<List<Todo?>> snapshot) {
                          return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    await dbHelper
                                        .updateTodo(snapshot.data![index]);
                                    print("Update Success");
                                    setState(() {});
                                  },
                                  child: TodoWidget(
                                    text: snapshot.data != null
                                        ? snapshot.data![index]!.title
                                        : "(unannamed todo)",
                                    isDone: snapshot.data != null
                                        ? snapshot.data![index]!.isDone == 1
                                        : false,
                                  ),
                                );
                              });
                        },
                      ))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      child: const Image(
                        image: AssetImage('assets/images/check-box-empty.png'),
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                    Expanded(
                        child: TextField(
                      onSubmitted: (value) async {
                        if (value != "") {
                          if (widget.task.id != 0) {
                            List<Todo?> listTodos =
                                await dbHelper.getTodos(widget.task.id);
                            Todo newTodo = Todo(
                                title: value,
                                taskID: widget.task.id,
                                id: listTodos.length);
                            await dbHelper.insertTodo(newTodo);
                            setState(() {});
                            // ignore: avoid_print
                            print("New Todo has been created");
                          } else {
                            List<Task> listTask = await dbHelper.getTasks();
                            List<Todo?> listTodos =
                                await dbHelper.getTodos(widget.task.id);
                            Todo newTodo = Todo(
                                title: value,
                                taskID: listTask.length + 1,
                                id: listTodos.length);
                            widget.listTodo.add(newTodo);
                          }
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter Todo item",
                          border: InputBorder.none),
                    ))
                  ],
                ),
              )
            ],
          ),
          // Positioned(
          //     bottom: 24.0,
          //     right: 24.0,
          //     child: )
        ],
      ),
    ));
  }
}
