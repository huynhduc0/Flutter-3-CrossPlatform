import 'package:flutter/cupertino.dart';

class NotificationsDetails extends StatefulWidget {
  final noti;
  NotificationsDetails(
    this.noti,
  );
  @override
  _NotificationsDetailsState createState() => _NotificationsDetailsState();
}

class _NotificationsDetailsState extends State<NotificationsDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("data"),
    );
  }
}