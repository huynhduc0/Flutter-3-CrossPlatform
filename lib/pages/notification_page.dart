import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/credentials.dart';
import 'package:flutter_food_ordering/model/notification_model.dart';
import 'package:flutter_food_ordering/model/services/auth_serivce.dart';
import 'package:flutter_food_ordering/widgets/noti_card.dart';
import 'package:skeleton_text/skeleton_text.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future<NotificationModel> notificationModels;

  Future<NotificationModel> fetchAllNotification() async {
    setState(() {
      notificationModels = null;
    });
    print("token-------");
    AuthService auth = AuthService();
    String tokenF = await auth.getToken();
    print(tokenF);
    var dio = Dio();
    dio.options.connectTimeout = 5000;
 
    dio.options.headers["Authorization"] = "Bearer $tokenF";
    print("Noti-------");
    try {
      var response = await dio.get('$BASE_URL/api/notification');
      print(response);
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        print("Dio Error: " + e.message);
        throw SocketException(e.message);
      } else {
        print("Type error: " + e.toString());
        throw Exception(e.toString());
      }
    }
  }

  @override
  void initState() {
    notificationModels = fetchAllNotification();
    super.initState();
  }

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
            buildNotification()
          ],
        ),
      ),
    );
  }

  Widget buildNotification() {
    return Expanded(
      child: FutureBuilder<NotificationModel>(
        future: notificationModels,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
        
            return GridView.count(
              shrinkWrap: true,
              childAspectRatio: 3,
              mainAxisSpacing: 1.5,
              crossAxisSpacing: 1,
              crossAxisCount: 1,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data.notifications.length > 0
                  ? snapshot.data.notifications.map((notification) {
                      return NotificationCard(notification);
                    }).toList()
                  : [Text("Nothing to show")],
              // children: [Text("aaaaaaaa")],
            );
          } 
          else if (snapshot.hasError) {
            // r
            return Center(child: Text(snapshot.error.toString()));
          }
          return GridView.count(
            shrinkWrap: true,
            childAspectRatio: 10,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            crossAxisCount: 1,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(1, (index) {
              return Text("Loading...");
            }),
          );
        },
      ),
    );
  }
}
