import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/model/food_model.dart';

import 'components/app_bar.dart';
import 'components/body.dart';

class DetailsScreen extends StatefulWidget {
  Food food;

  DetailsScreen(this.food);
  @override
  _DetailsScreenState createState() => _DetailsScreenState(this.food);
}

class _DetailsScreenState extends State<DetailsScreen> {
  Food food;
  _DetailsScreenState(this.food);
  @override
  Widget build(BuildContext context) {
    print(food.toString());
    return Scaffold(
      // backgroundColor: mainColor,
      body: Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: detailsAppBar(context),
            body: Body(food),
          ),
        ],
      ),
    );
  }
}
