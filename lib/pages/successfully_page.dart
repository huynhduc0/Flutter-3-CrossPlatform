import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:lottie/lottie.dart';

class SuccessOrderPage extends StatefulWidget {
  @override
  _SuccessOrderPageState createState() => _SuccessOrderPageState();
}

class _SuccessOrderPageState extends State<SuccessOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
               child: Lottie.asset('assets/start.json'),
            ),
            Text("An order confirmation and purchase", style: headerStyle,),
            Text("An order confirmation and purchase", style: titleStyle,),
            Spacer(),

          ]
        )
      )
    );
  }

  Widget backHomeBottom(cart, context) {
    return Center(
      child: RaisedButton(
        child: Text('Back to home', style: TextStyle(
          color: Colors.white,
        )),
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
        color: mainColor,
        shape: StadiumBorder(),
      ),
    );
  }
}
