import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/cart_model.dart';
import 'package:flutter_food_ordering/model/user_model.dart';
import 'package:flutter_food_ordering/pages/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flutter_food_ordering/model/services/auth_serivce.dart';
import 'package:flutter_food_ordering/model/services/order_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

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
  UserDataProfile user;
  MyCart cart;

  AuthService auth = AuthService();
  OrderService orderService = OrderService();
  final storage = new FlutterSecureStorage();

  ScrollController scrollController = ScrollController();
  AnimationController animationController;

  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController expYearController = new TextEditingController();
  TextEditingController expMonthController = new TextEditingController();

  @override
  void initState() {
    animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      ..forward();
    super.initState();
    getUserFromApi();
  }

  void getUserFromApi() async {
    orderService.getMe().then((value) => {
      if(value != null) {
        setState(() {
          user = value;
        }),
      }
    });

    orderService.getPaymentToken().then((STRIPE_PAYMENT_KEY) => {
      //stripe payment
      StripePayment.setOptions(
        StripeOptions(
          publishableKey: STRIPE_PAYMENT_KEY,
        )
      ),
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      cart = Provider.of<MyCart>(context);
      oldTotal = total;
      total = 0;
      for (CartItem cart in cart.cartItems) {
        total += cart.food.price * cart.quantity;
      }
    });

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
        onPressed: () async {
          PaymentMethod paymentMethod = PaymentMethod();
          paymentMethod = await StripePayment.paymentRequestWithCardForm(
            CardFormPaymentRequest(),
          ).then((PaymentMethod paymentMethod) {
            return paymentMethod;
          }).catchError((e) {
            print('Error Card: ${e.toString()}');
          });

          orderService.order(cart, total, paymentMethod.id).then((value) async => {
            if(value == true) {
              Toast.show('Order success', context),
              cart.clearCart(),
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyHomePage()),
              )
            } else {
              Toast.show('Order failed', context),
            }
          });
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
                            (user != null && user.name != null) ? user.name : 'Your name',
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
                            (user != null && user.address != null) ? user.address : 'Your address',
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

                    ListView.builder(
                      itemCount: cart.cartItems.length,
                      shrinkWrap: true,
                      controller: scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      cart.cartItems[index].food.name,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 2,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: Text(
                                              "\$${cart.cartItems[index].food.price} x ${cart.cartItems[index].quantity}",
                                              style: TextStyle(
                                                  color: Colors.grey
                                              ),
                                            )
                                        )
                                    )
                                )
                              ],
                            )
                        );
                      },
                    ),

                    // Padding(
                    //     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    //     child: Row(
                    //       children: [
                    //         Flexible(
                    //           flex: 3,
                    //           child: Align(
                    //             alignment: Alignment.centerLeft,
                    //             child: Text(
                    //               "Quantity",
                    //               style: TextStyle(
                    //                 color: Colors.grey,
                    //               ),
                    //               textAlign: TextAlign.start,
                    //             ),
                    //           ),
                    //         ),
                    //         Flexible(
                    //             flex: 1,
                    //             child: Align(
                    //                 alignment: Alignment.centerRight,
                    //                 child: Padding(
                    //                     padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    //                     child: Text(
                    //                       "x2",
                    //                       style: TextStyle(
                    //                           color: Colors.grey
                    //                       ),
                    //                     )
                    //                 )
                    //             )
                    //         )
                    //       ],
                    //     )
                    // ),

                    SizedBox(height: 10),
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
                                  "\$${total}",
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
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: new Text(
                    //       "Anh Phang",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.left,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Credit card",
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
}
