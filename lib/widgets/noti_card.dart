import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/model/notification_model.dart';

class NotificationCard extends StatefulWidget {
  final Notifications notification;
  NotificationCard(this.notification);
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  Notifications get notification => widget.notification;
  @override
  void initState() {
    // print("1231313312313123");
    // print(widget.food.updatedAt.toUtc());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(notification.title);
    print("2323*&(&&&^^#^#^#^##213");
    return Container(
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print('Card tapped.');
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.fastfood,
                    color: Color(0xFFF17808),
                  ),
                  trailing: Text(
                      notification.createdAt.day.toString() +
                          '/' +
                          notification.createdAt.month.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Poppins")),
                  title: Text(notification.title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins")),
                  subtitle: Text(notification.content,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Poppins")),
                )
              ])),
        ),
      ),
    );
    ;
  }
}
