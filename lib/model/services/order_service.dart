import 'package:dio/dio.dart';
import 'package:flutter_food_ordering/model/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_food_ordering/credentials.dart';

class OrderService {
  final storage = new FlutterSecureStorage();
  Dio dio = new Dio();

  Future order(cart, total, payment_id) async {
    String token = await storage.read(key: "jwt");
    dio.options.headers["Authorization"] = "Bearer ${token}";
    List foods = [];
    var food;

    cart.cartItems.forEach((item) => {
      food = {
        "food_id": item.food.v, // vũ trụ, id rỗng, và "v" sẽ là id
        "quantity": item.quantity,
        "price": item.food.price,
        "shop_id": item.food.shop.id
      },

      foods.add(food)
    });

    String url = 'api/order/save';
    try {
      var response = await dio.post(
          '${BASE_URL}/${url}',
          data: {
            "totalPrice": total,
            "foods": foods,
            "payment_id": payment_id
          }
      );

      return true;
    } catch (e) {
      print(e);
      if (e is DioError) {
        return e.response.data['message'];
      } else {}
    }
  }

  Future getPaymentToken() async {
    String token = await storage.read(key: "jwt");
    dio.options.headers["Authorization"] = "Bearer ${token}";
    String payment_key;

    String url = 'api/payment/1';
    try {
      var response = await dio.get('${BASE_URL}/${url}');
      payment_key = response.data['payment']['public_key'];

      return payment_key;
    } catch (e) {
      print(e);
      if (e is DioError) {
        return e.response.data['message'];
      } else {}
    }
  }

  Future getMe() async {
    String token = await storage.read(key: "jwt");
    dio.options.headers["Authorization"] = "Bearer ${token}";
    UserDataProfile user;

    String url = 'api/user/me';
    try {
      var response = await dio.get('${BASE_URL}/${url}' );

      user = new UserDataProfile(
        id: response.data['user']['id'],
        email: response.data['user']['email'],
        avatar: response.data['user']['profile_image'],
        phoneNumber: response.data['user']['phone'],
        name: response.data['user']['name'],
        address: response.data['user']['address'],
      );

      return user;
    } catch (e) {
      print(e);
      if (e is DioError) {
        return e.response.data['message'];
      } else {}
    }
  }
}