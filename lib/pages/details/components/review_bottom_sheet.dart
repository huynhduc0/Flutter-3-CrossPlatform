import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/cart_model.dart';
import 'package:flutter_food_ordering/model/food_model.dart';
import 'package:flutter_food_ordering/model/review_model.dart';
import 'package:flutter_food_ordering/pages/checkout_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../credentials.dart';

class ReviewBottomSheet extends StatefulWidget {
  final Food food;

  const ReviewBottomSheet({Key key, this.food}) : super(key: key);
  @override
  _ReviewBottomSheetState createState() => _ReviewBottomSheetState(food);
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final Food food;
  Future<ReviewModel> reviewModels;
  bool loading = false;

  _ReviewBottomSheetState(this.food);
  @override
  void initState() {
    reviewModels = fetchAllReview();
    super.initState();
  }

  Future<ReviewModel> fetchAllReview() async {
    print("id ne may thang lol ${food.id}");
    setState(() {
      reviewModels = null;
    });
    var dio = Dio();
    dio.options.connectTimeout = 5000;
    try {
      this.setState(() {
        loading = true;
      });
      // var response = await dio.get('$BASE_URL/api/foods');
      var response = await dio.get('$BASE_URL/api/review/food/${food.id}');
      print('$BASE_URL/api/review/food/${food.id}');
      print(response.data);

      if (this.mounted) {
        this.setState(() {
          loading = false;
        });
      }
      return ReviewModel.fromJson(response.data);
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
    return FutureBuilder<ReviewModel>(
        future: reviewModels,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Container(
                      width: 90,
                      height: 8,
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(), color: Colors.black26),
                    ),
                  ),
                  buildTitle(food.name),
                  Divider(),
                  // RaisedButton.icon(
                  //   icon: Icon(Icons.add),
                  //   color: Colors.green,
                  //   shape: StadiumBorder(),
                  //   splashColor: Colors.white60,
                  //   onPressed: () => {},
                  //   textColor: Colors.white,
                  //   label: Text('Add review'),
                  // ),
                  if (snapshot.data.reviews.length <= 0)
                    noItemWidget()
                  else
                    buildItemsList(snapshot.data),
                  Divider(),
                  // buildPriceInfo(snapshot.data.reviews),
                  SizedBox(height: 8),
                  // addToCardButton(snapshot.data.reviews, context),
                ],
              ),
            );
          } else
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Container(
                      width: 90,
                      height: 8,
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(), color: Colors.black26),
                    ),
                  ),
                  buildTitle(food.name),
                  Divider(),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitSquareCircle(
                      color: mainColor,
                    ),
                  )),
                  Divider(),
                  // buildPriceInfo(snapshot.data.reviews),
                  SizedBox(height: 8),
                  // addToCardButton(snapshot.data.reviews, context),
                ],
              ),
            );
        });
    //});
  }

  Widget buildTitle(cart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('REVIEW', style: headerStyle.copyWith(fontSize: 20), textAlign: TextAlign.center,),
        RaisedButton.icon(
          icon: Icon(Icons.add),
          color: Colors.green,
          shape: StadiumBorder(),
          splashColor: Colors.white60,
          onPressed: () => {},
          textColor: Colors.white,
          label: Text('Add review'),
        ),
      ],
    );
  }

  Widget buildItemsList(ReviewModel reviews) {
    return Expanded(
      child: ListView.builder(
        itemCount: reviews.reviews.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            // child: ListTile(
            //   leading: CircleAvatar(
            //     // backgroundImage: NetworkImage('$BASE_URL/uploads/${cart.cartItems[index].food.images[0]}')),
            //       backgroundImage:
            //       NetworkImage(reviews.reviews[index].profile_image)),
            //   title: Text('${reviews.reviews[index].name}',
            //       style: subtitleStyle),
            //   subtitle: Text('${reviews.reviews[index].name}:${reviews.reviews[index].title}'),
            //   // trailing:
            //   // trailing: Text(': ${reviews.reviews[index].content}',
            //   //     style: subtitleStyle),
            // ),
            child: Card(
              elevation: 3,
              color: Colors.white,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                        reviews.reviews[index].profile_image,
                        fit: BoxFit.fill,
                      ),
                      ),
                      
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${reviews.reviews[index].title}",
                          style: new TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        new Text(
                          "${reviews.reviews[index].content}",
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${reviews.reviews[index].name}',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.all(8),
                              child: CircleAvatar(
                                    // backgroundImage: NetworkImage('$BASE_URL/uploads/${cart.cartItems[index].food.images[0]}')),
                                backgroundImage: NetworkImage(
                                    reviews.reviews[index].profile_image,),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget noItemWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('No review here!', style: titleStyle2),
            SizedBox(height: 16),
            Icon(Icons.hourglass_empty_rounded, size: 40),
          ],
        ),
      ),
    );
  }

  Widget buildPriceInfo(ReviewModel reviewModel) {
    double total = 0;
    // for (Review review in reviewModel.reviews) {
    //   total += review.food.price * cartModel.quantity;
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Total:', style: headerStyle),
        Text('\$ ${total.toStringAsFixed(2)}', style: headerStyle),
      ],
    );
  }

  Widget addToCardButton(cart, context) {
    return Center(
      child: RaisedButton(
        child: Text('CheckOut',
            style: TextStyle(
              color: Colors.white,
            )),
        onPressed: cart.cartItems.length == 0
            ? null
            : () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CheckOutPage()));
              },
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
        color: mainColor,
        shape: StadiumBorder(),
      ),
    );
  }
}
