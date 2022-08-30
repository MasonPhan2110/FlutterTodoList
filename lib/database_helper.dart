import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/models/todo.dart';

import 'models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(join(await getDatabasesPath(), 'todo_Database.db'),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, date TEXT, title TEXT, description TEXT)");
      await db.execute(
          "CREATE TABLE todos(id INTEGER, title TEXT, taskID INTEGER, isDone INTEGER)");
    }, version: 1);
  }

  Future<void> insertTask(Task task) async {
    Database _db = await database();
    await _db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    print("taskMap $taskMap");
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          date: taskMap[index]['date']);
    });
  }

  Future<List<Task>> getTaskwithDate(String date) async {
    Database _db = await database();
    print("Date in get Task: $date");
    List<Map<String, dynamic>> taskMap =
        await _db.rawQuery("SELECT * FROM tasks WHERE date LIKE $date");
    print(taskMap);
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          date: taskMap[index]['date']);
    });
  }

  Future<List<Todo?>> getTodos(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * From todos WHERE taskID = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          taskID: todoMap[index]['taskID'],
          isDone: todoMap[index]['isDone']);
    });
    // List<Todo?> todos = new List.empty(growable: true);
    // for (var i = 0; i < list.length; i++) {
    //   if (list[i] != null) {
    //     todos.add(list[i]);
    //   }
    // }
    // print("Todo List length: " + todos.length.toString());
    // // print("Todo List: " + listTodo[0].toString());
    // return todos;
  }

  Future<void> updateTodo(Todo? todo) async {
    Database _db = await database();
    await _db.execute(
        '''UPDATE todos SET isDone = ? WHERE id = ? AND taskID = ? ''',
        [todo?.isDone == 0 ? 1 : 0, todo?.id, todo?.taskID]);
  }

  Future<void> deleteTask(int taskID) async {
    Database _db = await database();
    await _db.execute('''DELETE FROM tasks WHERE id = $taskID;''');
    await _db.execute('''DELETE FROM todos WHERE taskID = $taskID;''');
  }

  Future<void> deleteAllTasksAndTodos() async {
    Database _db = await database();
    _db.execute("delete from tasks");
    _db.execute("delete from todos");
  }
}
