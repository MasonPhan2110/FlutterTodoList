class Task {
  final int id;
  final String date;
  final String title;
  final String description;
  Task({this.id = 0, this.title = "", this.date = "", this.description = ""});

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'title': title, 'description': description};
  }
}
