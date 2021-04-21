import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/model/food_model.dart';
import 'package:flutter_food_ordering/pages/components/title_price_rating.dart';

import '../../credentials.dart';
import 'item_image.dart';
import 'order_button.dart';

class Body extends StatelessWidget {
  Food food;
  Body(this.food);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemImage(
          imgSrc: this.food.images,
        ),
        Expanded(
          child: ItemInfo(this.food),
        ),
      ],
    );
  }
}

class ItemInfo extends StatelessWidget {
  Food food;
  // const ItemInfo(
  //   this.food, {
  //   Key key,
  // }) : super(key: key);
  ItemInfo(this.food);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          shopeName(name: this.food.shop.name),
          TitlePriceRating(
            name: this.food.name,
            numOfReviews: 24,
            rating: 4,
            price: this.food.price.toInt(),
            onRatingChanged: (value) {},
          ),

          Text(
            this.food.description,
            style: TextStyle(
              height: 1.5,
            ),
          ),
          Spacer(),
          SizedBox(height: size.height * 0.1),
          // Free space  10% of total height
          OrderButton(
            size: size,
            press: () {},
          )
        ],
      ),
    );
  }

  Row shopeName({String name}) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: ksecondaryColor,
        ),
        SizedBox(width: 10),
        Text(name),
      ],
    );
  }
}
