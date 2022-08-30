class Todo {
  final int id;
  final String title;
  final int taskID;
  final int isDone;
  Todo({this.id = 0, this.title = "", this.taskID = 0, this.isDone = 0});
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'taskID': taskID, 'isDone': isDone};
  }
}
