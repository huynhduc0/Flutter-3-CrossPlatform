class NotificationModel{
  int status;
  List<Notifications> notifications;

  NotificationModel({this.status, this.notifications});
 factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        status: json["status"],
        notifications: List<Notifications>.from(json["notifications"].map((x) => Notifications.fromJson(x))),
      );
}

class Notifications{
  int id;
  String title;
  String content;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  int isRead;

  Notifications({
    this.id,
    this.title,
    this.content,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.isRead,
  });
  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isRead: json["isRead"],
  );
}
