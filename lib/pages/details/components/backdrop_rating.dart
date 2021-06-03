import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/food_model.dart';
import 'package:flutter_food_ordering/pages/details/components/review_bottom_sheet.dart';
import 'package:flutter_food_ordering/widgets/cart_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:flutter_food_ordering/model/services/rating_service.dart';

class BackdropAndRating extends StatefulWidget {
  final Size size;
  final Food food;
  const BackdropAndRating({
    Key key,
    @required this.size,
    @required this.food,
  }) : super(key: key);

  @override
  _BackdropAndRatingState createState() => _BackdropAndRatingState();
}

class _BackdropAndRatingState extends State<BackdropAndRating> {
  final _formKey = GlobalKey<FormState>();
  File imageFile;
  int numberStar;
  String title;
  String content;

  RatingService ratingService = RatingService();

  showCart(context) {

    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
      builder: (context) => CartBottomSheet(),
    );
  }
  showReview(context,food) {
    print(food.id.toString());
    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
        isScrollControlled:true,
      builder: (context) => ReviewBottomSheet(food: food),
    );
  }
  @override
  Widget build(BuildContext context) {
    print("hero tag ${widget.food.name}");
    return Container(
      // 40% of our total height
      height: widget.size.height * 0.4,
      child: Stack(
        children: <Widget>[
          // Hero(
          //   tag: "${food.name}",
          //   child:
          Container(
            height: widget.size.height * 0.4 - 50,
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
                image: NetworkImage(widget.food.images),
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
              width: widget.size.width * 0.9,
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
                    GestureDetector(
                      onTap: ()=> showReview(context,this.widget.food),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // SvgPicture.asset("icons/star_fill.svg"),
                          SizedBox(height: kDefaultPadding / 4),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "${widget.food.rating}/",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                TextSpan(text: "5\n"),
                                TextSpan(
                                  text: "69 times\n",
                                  style: TextStyle(color: kTextLightColor),
                                ),
                                TextSpan(
                                  text: "View →",
                                  style: TextStyle(color: kTextLightColor).copyWith(fontWeight: FontWeight.bold),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Rate this
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("icons/star.svg"),
                        SizedBox(height: kDefaultPadding / 4),
                        InkWell(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Text("Rate This", style: Theme.of(context).textTheme.bodyText2),
                        )
                      ],
                    ),
                    // Metascore
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: mainColor,
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
          SafeArea(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.orange),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Spacer(),
                Stack(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.shopping_cart), onPressed: ()=> showCart(context)),
                    Positioned(
                      right: 0,
                      child: Container(
                        // color: ,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4),
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: mainColor),
                        child: Text(
                          '',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ),
        ],
      ),
    );
  }

  // RATING
  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    if(imageFile != null) {
      showDiaLogAddReview(context);
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    if(imageFile != null) {
      showDiaLogAddReview(context);
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void showDiaLogAddReview(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('Update avatar'),
        // content: const Text('Are you sure you want to delete this address?'),
        scrollable: true,
        actions: <Widget>[
          (imageFile != null) ?
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 150,
                child: ClipRRect(
                  child: Image.file(imageFile, fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ) :
          Container(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: (){
                  _showPicker(context);
                },
                child: new Container(
                  width: 300.0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Default_Thumbnail.jpg"),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Align(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // print(rating);
                    setState(() {
                      numberStar = rating.toInt();
                    });
                  },
                ),
              )
          ),

          SizedBox(height: 10),
          Flexible(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildFormFieldTitle(),
                  buildFormFieldReview(),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel', style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    ratingService.addRating(imageFile, title, content, numberStar, widget.food.v).then((result) => {
                      if(result == true) {
                        Toast.show('Add review success', context),
                        Navigator.of(context).pop(),
                        setState(() {
                          // initPage();
                        }),
                      } else {
                        Toast.show('Please try again later', context),
                      }
                    });
                  }
                },
                child: const Text(
                  'Add',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  TextFormField buildFormFieldReview() {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onSaved: (newValue) => content = newValue,
      showCursor: true,//add this line
      // readOnly: true,
      onChanged: (value) {
        setState(() {
          content = value;
        });
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your review";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Write a review",
        hintText: "Write a review...",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFormFieldTitle() {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onSaved: (newValue) => title = newValue,
      showCursor: true,//add this line
      // readOnly: true,
      onChanged: (value) {
        setState(() {
          title = value;
        });
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter title";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Write title",
        hintText: "Write a title...",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
