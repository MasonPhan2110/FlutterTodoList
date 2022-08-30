import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String des;
  TaskCardWidget(
      {this.title = "(Unnamed Task)", this.des = "No Description Added"});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        margin: EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Color(0xFF211551),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                des,
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  color: Color(0xFF86829D),
                ),
              ),
            )
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;
  TodoWidget({this.text = "(Unnamed Todo)", this.isDone = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(children: [
        Container(
          margin: EdgeInsets.only(right: 16.0),
          child: isDone
              ? Image(
                  image: AssetImage('assets/images/check.png'),
                  width: 20,
                  height: 20,
                )
              : Image(
                  image: AssetImage('assets/images/check-box-empty.png'),
                  width: 20.0,
                  height: 20.0,
                ),
        ),
        Text(
          text,
          style: TextStyle(
              color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
              fontSize: 16.0,
              fontWeight: isDone ? FontWeight.bold : FontWeight.w500),
        )
      ]),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
