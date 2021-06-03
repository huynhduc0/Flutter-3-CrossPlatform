import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/food_model.dart';

import '../details_screen.dart';

class CastCard extends StatelessWidget {
  final Food food;

  const CastCard({Key key, this.food}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: kDefaultPadding),
      width: 80,
      child: GestureDetector(
        onTap: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailsScreen(food);
          }))
        },
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    food.images,
                  ),
                ),
              ),
            ),
            SizedBox(height: kDefaultPadding / 2),
            Text(
              food.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 2,
            ),
            SizedBox(height: kDefaultPadding / 4),
            Text(
              food.shop.name,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(color: kTextLightColor),
            ),
          ],
        ),
      ),
    );
  }
}
