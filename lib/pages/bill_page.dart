import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/cart_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../credentials.dart';

class BillPage extends StatefulWidget {
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> with SingleTickerProviderStateMixin {
  var now = DateTime.now();
  get weekDay => DateFormat('EEEE').format(now);
  get day => DateFormat('dd').format(now);
  get month => DateFormat('MMMM').format(now);
  double oldTotal = 0;
  double total = 0;

  ScrollController scrollController = ScrollController();
  AnimationController animationController;

  onCheckOutClick(MyCart cart) async {
    try {
      List<Map> data = List.generate(cart.cartItems.length, (index) {
        return {
          "id": cart.cartItems[index].food.id,
          "quantity": cart.cartItems[index].quantity
        };
      }).toList();

      var response = await Dio().post('$BASE_URL/api/order/food',
          queryParameters: {"token": token}, data: data);
      print(response.data);

      if (response.data['status'] == 1) {
        cart.clearCart();
        Navigator.of(context).pop();
      } else {
        Toast.show(response.data['message'], context);
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  void initState() {
    animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<MyCart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Order'),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...buildHeader(),
              //cart items list
              // ListView.builder(
              //   itemCount: cart.cartItems.length,
              //   shrinkWrap: true,
              //   controller: scrollController,
              //   itemBuilder: (BuildContext context, int index) {
              //     return buildCartItemList(cart, cart.cartItems[index]);
              //   },
              // ),
              buildShippingAddress(),
              buildBagSummary(),
              buildPaymentType(),
              SizedBox(height: 16),
              Divider(),
              orderButton(cart, context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildHeader() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Text('Bill', style: headerStyle),
      ),
    ];
  }

  Widget orderButton(MyCart cart, context) {
    return Container(
      margin: EdgeInsets.only(top: 24, bottom: 64),
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          'Order',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          onCheckOutClick(cart);
        },
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
        color: mainColor,
        shape: StadiumBorder(),
      ),
    );
  }

  Widget buildShippingAddress() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Container(
        // height: 100,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.location_on),
            ),
            Flexible(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Shipping address",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigator.pushNamed(context, "");
                                            print("Clicked");
                                          },
                                          onLongPress: (){
                                            // open dialog OR navigate OR do what you want
                                          },
                                          child: new Text(
                                            'Change',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      )
                                  )
                              )
                            ],
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            "Anh Phang",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "01 Chu Lai, phường Hòa Hải, Quận Ngũ Hành Sơn, Đà Nẵng",
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBagSummary() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Container(
        // height: 100,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.card_travel),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Bag summary",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.pushNamed(context, "");
                                          print("Clicked");
                                        },
                                        onLongPress: (){
                                          // open dialog OR navigate OR do what you want
                                        },
                                        child: new Text(
                                          'See all',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    )
                                )
                            )
                          ],
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Iphone 12",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(
                                      "\$999",
                                      style: TextStyle(
                                        color: Colors.grey
                                      ),
                                    )
                                  )
                              )
                          )
                        ],
                      )
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Quantity",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        child: Text(
                                          "x2",
                                          style: TextStyle(
                                              color: Colors.grey
                                          ),
                                        )
                                    )
                                )
                            )
                          ],
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Total",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Text(
                                  "\$1998",
                                  style: TextStyle(
                                      color: Colors.orange,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              )
                            )
                          )
                        ],
                      )
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentType() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Container(
        // height: 100,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.payments),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Payment type",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pushNamed(context, "");
                                    print("Clicked");
                                  },
                                  onLongPress: (){
                                    // open dialog OR navigate OR do what you want
                                  },
                                  child: new Text(
                                    'Change',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              )
                            )
                          )
                        ],
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          "Anh Phang",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "*** **** ***2424",
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.pushNamed(context, "");
                                      print("Clicked");
                                    },
                                    onLongPress: (){
                                      // open dialog OR navigate OR do what you want
                                    },
                                    child: new InkWell(
                                      child: Icon(Icons.payment),
                                    ),
                                  ),
                                )
                            )
                          )
                        ],
                      )
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }




  Widget buildCartItemList(MyCart cart, CartItem cartModel) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        height: 100,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: Image.network(
                // '$BASE_URL/uploads/${cartModel.food.images[0]}',
                cartModel.food.images,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 45,
                    child: Text(
                      cartModel.food.name,
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        customBorder: roundedRectangle4,
                        onTap: () {
                          cart.decreaseItem(cartModel);
                          // animationController.reset();
                          // animationController.forward();
                        },
                        child: Icon(Icons.remove_circle),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
                        child: Text('${cartModel.quantity}', style: titleStyle),
                      ),
                      InkWell(
                        customBorder: roundedRectangle4,
                        onTap: () {
                          cart.increaseItem(cartModel);
                          // animationController.reset();
                          // animationController.forward();
                        },
                        child: Icon(Icons.add_circle),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 70,
                    child: Text(
                      '\$ ${cartModel.food.price}',
                      style: titleStyle,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cart.removeAllInCart(cartModel.food);
                      // animationController.reset();
                      // animationController.forward();
                    },
                    customBorder: roundedRectangle12,
                    child: Icon(Icons.delete_sweep, color: Colors.red),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
