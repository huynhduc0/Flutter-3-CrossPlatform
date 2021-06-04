class Review{
  int id;
  String title;
  String content;
  String image;
  String name;
  String profile_image;
  DateTime created_at;
  DateTime updated_at;

  Review({
    this.id,
    this.title,
    this.content,
    this.image,
    this.name,
    this.profile_image,
    this.created_at,
    this.updated_at,
  });
  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    image: json["image"],
    // image: "https://i1.wp.com/www.eatthis.com/wp-content/uploads/2020/12/unhealthiest-foods-planet.jpg?resize=640%2C360&ssl=1",
    name: json["name"],
    profile_image: json["profile_image"],
    // profile_image: "https://i1.wp.com/www.eatthis.com/wp-content/uploads/2020/12/unhealthiest-foods-planet.jpg?resize=640%2C360&ssl=1",
    created_at: DateTime.parse(json["created_at"]),
    updated_at: DateTime.parse(json["updated_at"]),
  );
}
class ReviewModel{
  int status;
  List<Review> reviews;

  ReviewModel({this.status, this.reviews});
  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    status: json["status"],
    reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
  );
}
