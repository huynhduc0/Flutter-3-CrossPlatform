import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/cart_model.dart';
import 'package:flutter_food_ordering/model/food_model.dart';
import 'package:flutter_food_ordering/pages/user_profile.dart';
import 'package:flutter_food_ordering/widgets/cart_bottom_sheet.dart';
import 'package:flutter_food_ordering/widgets/food_card.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int value = 0;
  bool loading = true;

  Future<FoodModel> foodModels;
  Future<FoodCategoryModel> foodCategories;

  Future<FoodModel> fetchAllFoods() async {
    setState(() {
      foodModels = null;
    });
    var dio = Dio();
    dio.options.connectTimeout = 5000;
    print('lo con chiêm');
    try {
      this.setState(() {
        loading = true;
      });
      // var response = await dio.get('$BASE_URL/api/foods');
      var response = await dio.get('$BASE_URL/api/food');
      this.setState(() {
        loading = false;
      });
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

  Future<FoodModel> fetchFoodByCate(int categoryId) async {
    setState(() {
      foodModels =  Future<FoodModel>(null);
    });
    var dio = Dio();
    dio.options.connectTimeout = 5000;
    try {
      // var response = await dio.get('$BASE_URL/api/foods');
      var response = await dio.get('$BASE_URL/api/category/$categoryId/food');
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

  Future<FoodCategoryModel> fetchAllCate() async {
    var dio = Dio();
    dio.options.connectTimeout = 5000;
    print('lo con chiêm');
    try {
      // var response = await dio.get('$BASE_URL/api/foods');
      var response = await dio.get('$BASE_URL/api/category');
      // print(response.data.toString());
      return FoodCategoryModel.fromJson(response.data);
      // .toList();
      // .fromJson(response.data["categories"]);
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

  showCart() {
    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
      builder: (context) => CartBottomSheet(),
    );
  }

  viewProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserProfilePage()),
    );
  }

  @override
  void initState() {
    foodModels = fetchAllFoods();
    foodCategories = fetchAllCate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: <Widget>[
            buildAppBar(),
            buildFoodFilter(),
            Divider(),
            buildFoodList(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    int items = 0;
    Provider.of<MyCart>(context).cartItems.forEach((cart) {
      items += cart.quantity;
    });
    return SafeArea(
      child: Row(
        children: <Widget>[
          Text('MENU', style: headerStyle),
          Spacer(),
          IconButton(icon: Icon(Icons.person), onPressed: viewProfile),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                foodModels = fetchAllFoods();
                foodCategories = fetchAllCate();
                setState(() {});
              }),
          Stack(
            children: <Widget>[
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: showCart),
              Positioned(
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: mainColor),
                  child: Text(
                    '$items',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFoodFilter() {
    return Container(
      height: 50,
      child: FutureBuilder<FoodCategoryModel>(
        future: foodCategories,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: snapshot.data.categories
                    .map(
                      (category) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChoiceChip(
                          selectedColor: mainColor,
                          labelStyle: TextStyle(
                              color: value == category.id
                                  ? Colors.white
                                  : Colors.black),
                          label: Text(category.name),
                          selected: value == category.id,
                          onSelected: (selected) {
                            setState(() {
                              value = category.id;
                              foodModels = null;
                            });
                            setState(() {
                              value = category.id;
                              foodModels = category.id == 0
                                  ? fetchAllFoods()
                                  : fetchFoodByCate(category.id);
                            });
                          },
                        ),
                      ),
                    )
                    .toList());
          } else {
            return Text("Loading");
          }
          ;
        },
      ),
      //color: Colors.red,
      // child: ListView(
      //   scrollDirection: Axis.horizontal,
      //   physics: BouncingScrollPhysics(),
      //   children: foodCategories.asStream().map((event) =>
      //   // List.generate(foodCategories, (index) {
      //     return Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: ChoiceChip(
      //         selectedColor: mainColor,
      //         labelStyle: TextStyle(
      //             color: value == index ? Colors.white : Colors.black),
      //         label: Text(FoodTypes.values[index].toString().split('.').last),
      //         selected: value == index,
      //         onSelected: (selected) {
      //           setState(() {
      //             value = index;
      //           });
      //         },
      //       ),
      //     );
      //   // }
      //   ),
      // ),
    );
  }

  Widget buildFoodList() {
    return Expanded(
      child: FutureBuilder<FoodModel>(
        future: foodModels,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              childAspectRatio: 0.65,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: 2,
              physics: BouncingScrollPhysics(),
              children: snapshot.data.foods.length > 0
                  ? snapshot.data.foods.map((food) {
                      return FoodCard(food);
                    }).toList()
                  : [Text("Nothing to show")],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          // return Center(child: CircularProgressIndicator());
          return GridView.count(
            childAspectRatio: 0.65,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            crossAxisCount: 2,
            physics: BouncingScrollPhysics(),
            children: List.generate(4, (index) {
              return Container(
                child: Card(
                  shape: roundedRectangle12,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          buildImage(),
                          buildTitle(),
                          buildRating(),
                          buildPriceInfo(),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12)),
                          ),
                         child: Text("Loading")
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget buildImage() {
    return SkeletonAnimation(
      shimmerColor: Colors.grey,
      borderRadius: BorderRadius.circular(20),
      shimmerDuration: 1000,
      child: Container(
        height: MediaQuery.of(context).size.width / 2.5,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return SkeletonAnimation(
      shimmerColor: Colors.grey,
      // borderRadius: BorderRadius.circular(20),
      shimmerDuration: 1000,
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "\t\t\t",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
            Text(
                "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: infoStyle,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildRating() {
    return SkeletonAnimation(
      shimmerColor: Colors.grey,
      shimmerDuration: 1000,
      child:  Padding(
      padding: const EdgeInsets.only(left: 4, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
                mainAxisSize: MainAxisSize.max,
                // width:MediaQuery.of(context).size.width / 2.5,
              ),
              Text('\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t',),
        ],
      ),
    ),
    );
  }

  Widget buildPriceInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SkeletonAnimation(
              shimmerColor: Colors.grey,
              shimmerDuration: 1000,
              child: Text(
                '\t\t\t\t\t\t\t\t\t\t\t\t\t\t',
                style: titleStyle,
                overflow: TextOverflow.clip,
              )),
          Card(
            margin: EdgeInsets.only(right: 0),
            shape: roundedRectangle4,
            color: mainColor,
            child: InkWell(
              splashColor: Colors.white70,
              customBorder: roundedRectangle4,
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
