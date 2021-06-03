import 'package:flutter_food_ordering/model/food_model.dart';

class OrderModel {
  int status;
  String message;
  List<Order> order;

  OrderModel({
    this.status,
    this.message,
    this.order,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        status: json["status"],
        message: json["message"],
        order: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );
}

class Order {
  String id;
  DateTime orderDate;
  List<OrderDetail> detail;
  num totalPrice;
  // Customer shop;
  // Customer customer;
  DateTime createdAt;
  DateTime updatedAt;
  String orderCode;
  // int v;

  Order({
    this.id,
    this.orderDate,
    this.detail,
    this.totalPrice,
    // this.shop,
    // this.customer,
    this.createdAt,
    this.updatedAt,
    this.orderCode,
    // this.v,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderDate: DateTime.parse(json["order_date"]),
        detail: List<OrderDetail>.from(
            json["detail"].map((x) => OrderDetail.fromJson(x))),
        totalPrice: json["totalPrice"],
        // shop: Customer.fromJson(json["shop"]),
        // customer: Customer.fromJson(json["customer"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        orderCode: json['order_code'],
        // v: json["__v"],
      );
}

class Customer {
  String id;
  String name;
  String email;

  Customer({
    this.id,
    this.name,
    this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}

class OrderDetail {
  String id;
  int orderId;
  Food food;
  int quantity;
  int price;

  OrderDetail({this.id, this.food, this.quantity, this.orderId, this.price});

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
      id: json["id"],
      food: Food.fromJson(json["food"]),
      quantity: json["quantity"],
      orderId: json['order_id'],
      price: json['price']);
}

class Food {
  String id;
  String name;
  String description;
  num price;
  String image;
  Customer shop;

  Food(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.image,
      this.shop});

  factory Food.fromJson(Map<String, dynamic> json) => Food(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: json["price"],
      image: json['image'],
      shop: Customer.fromJson(json["shop"]));
}
