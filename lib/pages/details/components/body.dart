import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/food_model.dart';

import 'backdrop_rating.dart';
import 'cast_and_crew.dart';
import 'genres.dart';
import 'title_duration_and_fav_btn.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class Body extends StatelessWidget {
  final Food food;

  const Body({Key key, this.food}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.6;
    // it will provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackdropAndRating(size: size, food: food),
          SizedBox(height: kDefaultPadding / 2),
          TitleDurationAndFabBtn(food: food),
          // Genres(food: food),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "About this food",
              style: headerStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              "${food.description}",
              // food.price.toString(),
              style: TextStyle(
                color: Color(0xFF737599),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "More Foods",
              style: headerStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              "May be you likes",
              // food.price.toString(),
              style: TextStyle(
                color: Color(0xFF737599),
              ),
            ),
          ),
          // CastAndCrew(casts: food.cast),
        ],
      ),
    );
  }
}
