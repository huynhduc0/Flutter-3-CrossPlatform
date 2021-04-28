class NotificationModel{
  int status;
  List<Notification> notifications;

  NotificationModel({this.status, this.notifications});
 factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        status: json["status"],
        notifications: List<Notification>.from(json["notifications"].map((x) => Notification.fromJson(x))),
      );
}


class Notification{
  int id;
  String title;
  String content;
  int user_id;
  DateTime created_at;
  DateTime updated_at;
  int isRead;

  Notification({
    this.id,
    this.title,
    this.content,
    this.user_id,
    this.created_at,
    this.updated_at,
    this.isRead,
  });
  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    user_id: json["user_id"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
    isRead: json["isRead"],
  );
}
