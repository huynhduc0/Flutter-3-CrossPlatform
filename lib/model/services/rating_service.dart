import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_food_ordering/credentials.dart';

class RatingService {
  final storage = new FlutterSecureStorage();
  Dio dio = new Dio();

  Future addRating(File image, title, content, numberStar, foodID) async {
    String token = await storage.read(key: "jwt");
    dio.options.headers["Authorization"] = "Bearer ${token}";

    String fileName = image.path.split('/').last;
    FormData data = FormData.fromMap({
      "title": title,
      "content": content,
      "image": await MultipartFile.fromFile(
        image.path,
        filename: fileName
      ),
      "rate": numberStar,
      "food_id": foodID
    });

    String url = 'api/review/save';
    try {
      var response = await dio.post(
          '${BASE_URL}/${url}',
          data: data
      );

      return true;
    } catch (e) {
      print(e);
      if (e is DioError) {
        return e.response.data['message'];
      } else {}
    }
  }
}
