import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/food_model.dart';

class Genres extends StatelessWidget {
  const Genres({
    Key key,
    @required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: food.name.length,
          // itemBuilder: (context, index) => GenreCard(
          //   genre: food.name[index],
          // ),
          itemBuilder: (context, index) => Text(
            food.name[index] + " ",
          ),
        ),
      ),
    );
  }
}
