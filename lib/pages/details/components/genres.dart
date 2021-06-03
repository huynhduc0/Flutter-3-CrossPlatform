import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/food_model.dart';

import '../../../credentials.dart';
import 'cast_card.dart';
import 'gender_card.dart';

class Genres extends StatefulWidget {
  final Food food;
  Genres({
    Key key,
    @required this.food,
  }) : super(key: key);

  @override
  _GenresState createState() => _GenresState(food);
}

class _GenresState extends State<Genres> {
  Food food;
  Future<FoodModel> foodModels;
  bool loading = false;
  _GenresState(this.food);
  @override
  void initState() {
    foodModels = fetchAllFoods();
    super.initState();
  }


  Future<FoodModel> fetchAllFoods() async {
    print("id ne may thang lol ${food.id}");
    setState(() {
      foodModels = null;
    });
    var dio = Dio();
    dio.options.connectTimeout = 5000;
    try {
      this.setState(() {
        loading = true;
      });
      // var response = await dio.get('$BASE_URL/api/foods');
      var response = await dio.get('$BASE_URL/api/food/recommend/${food.id}/${food.shop.id}');
      print('$BASE_URL/api/recommend/${food.id}/${food.shop.id}');
      print(response.data);

      if (this.mounted) {
        this.setState(() {
          loading = false;
        });

      }
      return FoodModel.fromJson(response.data);
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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: foodModels,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.foods.length,
                  itemBuilder: (context, index) =>
                      CastCard(
                        food: snapshot.data.foods[index],
                      ),
                  // itemBuilder: (context, index) => Text(
                  //   food.name[index] + " ",
                  // ),
                ),
              ),
            );
          }
          else return Text("nothing");
        }
    );
  }
}
