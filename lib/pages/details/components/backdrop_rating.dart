import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/food_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackdropAndRating extends StatelessWidget {
  const BackdropAndRating({
    Key key,
    @required this.size,
    @required this.food,
  }) : super(key: key);

  final Size size;
  final Food food;

  @override
  Widget build(BuildContext context) {
    print("hero tag ${food.name}");
    return Container(
      // 40% of our total height
      height: size.height * 0.4,
      child: Stack(
        children: <Widget>[
          // Hero(
          //   tag: "${food.name}",
          //   child:
          Container(
            height: size.height * 0.4 - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
              // image: Hero(tag: tag, child: child)
              // Hero(tag: "${food.id}",
              // child: DecorationImage(
              //   fit: BoxFit.cover,
              //   image: NetworkImage(food.images),),
              // image: NetworkImage(

              // )
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(food.images),
              ),
            ),
          ),
          // ),
          // Hero(
          //   tag: "${food.id}+1",
          //   child: Image.network(food.images),
          // ),
          // Rating Box
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              // it will cover 90% of our total width
              width: size.width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 50,
                    color: Color(0xFF12153D).withOpacity(0.2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("icons/star_fill.svg"),
                        SizedBox(height: kDefaultPadding / 4),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "${food.rating}/",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: "10\n"),
                              TextSpan(
                                text: "69 times",
                                style: TextStyle(color: kTextLightColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Rate this
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("icons/star.svg"),
                        SizedBox(height: kDefaultPadding / 4),
                        Text("Rate This",
                            style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                    // Metascore
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xFF51CF66),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            // "${food.}",
                            69.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: kDefaultPadding / 4),
                        Text(
                          "Order times",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        // Text(
                        //   "62 critic reviews",
                        //   style: TextStyle(color: kTextLightColor),
                        // )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          // Back Button
          SafeArea(child: BackButton()),
        ],
      ),
    );
  }
}
