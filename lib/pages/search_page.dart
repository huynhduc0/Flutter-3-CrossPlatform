import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/food_model.dart';
import 'package:flutter_food_ordering/model/services/auth_serivce.dart';
import 'package:flutter_food_ordering/widgets/food_card.dart';
import 'package:lottie/lottie.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../credentials.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  String _keyword;
  bool loading = true;
  Future<FoodModel> foodModels;
  AuthService auth = AuthService();

  Future<FoodModel> fetchSearchFoods(String keyword) async {
    setState(() {
      foodModels = Future<FoodModel>(null);
    });
    var dio = Dio();
    String tokenF = await auth.getToken();
    print("2312312312312");
    print(tokenF);
    dio.options.connectTimeout = 5000;
    try {
      // var response = await dio.get('$BASE_URL/api/foods');
      var response =
          await dio.get('$BASE_URL/api/food/search?keyword=$keyword');
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

  // Future<FoodModel> fetchSearchFoods(String keyword) async {
  //   setState(() {
  //     foodModels = Future<FoodModel>(null);
  //   });
  //   var dio = Dio();
  //   dio.options.connectTimeout = 5000;
  //   print('lo con chiêm');
  //   dio.options.headers['content-Type'] = 'application/json';
  //   print('$BASE_URL/api/food/search?keyword=$keyword');
  //   try {
  //     var response = await dio.get('$BASE_URL/api/food/search?keyword=$keyword');
  //     print(response);
  //     print("dit con me may");
  //     return FoodModel.fromJson(response.data);
  //   } catch (e) {
  //     if (e is DioError) {
  //       print("Dio Error: " + e.message);
  //       throw SocketException(e.message);
  //     } else {
  //       print("Type error: " + e.toString());
  //       throw Exception(e.toString());
  //     }
  //   }
  // }

  @override
  void initState() {
    _keyword = '';
    // foodModels = fetchSearchFoods(_keyword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: mainColor,
          elevation: 0.0,
          centerTitle: true,
          leading: BackButton(),
          title: Container(
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: TextField(
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 40,
                          minHeight: 20,
                        ),
                      ),
                      onEditingComplete: () {
                        print("@@@@@@@@@@@@@@@@@");
                        setState(() {
                          _keyword =
                              searchTextEditingController.text.toString();
                          foodModels = null;
                        });
                        setState(() {
                          print(_keyword);
                          foodModels = fetchSearchFoods(_keyword);
                        });
                        // searchTextEditingController.text.toString();
                        // fetchSearchFoods(_keyword).then((value) {
                        //   setState(() {
                        //     foodModels = value as Future<FoodModel>;
                        //   });
                        // });
                      },
                    ))
              ],
            ),
          )),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: ListView(
          children: <Widget>[buildFoodSearch()],
        ),
      ),
    );
  }

  Widget buildFoodSearch() {
    return Expanded(
        child: FutureBuilder<FoodModel>(
            future: foodModels,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: 0.65,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data.foods.length > 0
                      ? snapshot.data.foods.map((food) {
                          return FoodCard(food);
                        }).toList()
                      : [Text("Nothing to show")],
                );
              } else {
                return Center(
                    child: Row(
                  children: [
                    SizedBox(height: 150),
                    Container(
                      height: 300,
                      width: 300,
                      child: Lottie.asset('assets/search.json'),
                    ),
                  ],
                ));
              }
            }));
  }
}
