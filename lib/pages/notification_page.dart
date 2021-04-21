import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text('NOTIFICATIONS',
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Text("YOUR ACTIVITY",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins")),
            ),
            buildNotification("title", "content", 1),
            buildNotification("title", "content", 1),
            buildNotification("title", "content", 1)
          ],
        ),
      ),
    );
  }

  Widget buildNotification(String title, String content, int user_id) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const ListTile(
            leading: Icon(
              Icons.fastfood,
              color: Color(0xFFF17808),
            ),
            trailing: Text("17/03/1999 ",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Poppins")),
            title: Text("foodshopname ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins")),
            subtitle: Text(
                "Error: Too many positional arguments: 1 allowed, but 11 found",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Poppins")),
          )
        ]),
      ),
    );
  }
}
