import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/model/food_model.dart';

import 'components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Food food;

  DetailsScreen(this.food);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(food: food),
    );
  }
}
