class FoodModel {
  int status;
  String message;
  List<Food> foods;

  FoodModel({this.status, this.message, this.foods});

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        status: json["status"],
        message: json["message"],
        foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
      );
}

class Food {
  String images;
  int id;
  String name;
  String description;
  double price;
  double rating;
  Shop shop;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Food({
    this.images,
    this.id,
    this.name,
    this.description,
    this.price,
    this.rating,
    this.shop,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        // images: String.from(json["images"].map((x) => x)),
        // images: json["images"],
        images:
            "https://i1.wp.com/www.eatthis.com/wp-content/uploads/2020/12/unhealthiest-foods-planet.jpg?resize=640%2C360&ssl=1",
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
        rating: json["rating"],
        // shop: Shop(id: "1",name: "1",email: "1"),
        shop: Shop.fromJson(json["shop"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["id"],
      );
}

class Shop {
  int id;
  String name;
  String email;

  Shop({this.id, this.name, this.email});

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );
}

class FoodCategory {
  int id;
  String name;

  FoodCategory(this.id, this.name);
  factory FoodCategory.fromJson(Map<String, dynamic> json) =>
      FoodCategory(json["id"], json["name"]);
}

class FoodCategoryModel {
  int status;
  String message;
  List<FoodCategory> categories;

  FoodCategoryModel({this.status, this.message, this.categories});

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) =>
      FoodCategoryModel(
        status: json["status"],
        message: json["message"],
        categories: List<FoodCategory>.from(
            json["categories"].map((x) => FoodCategory.fromJson(x))),
      );
}

enum FoodTypes {
  StreetFood,
  All,
  Coffee,
  Asian,
  Burger,
  Dessert,
}
