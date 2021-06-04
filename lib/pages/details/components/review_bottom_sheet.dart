import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/cart_model.dart';
import 'package:flutter_food_ordering/model/food_model.dart';
import 'package:flutter_food_ordering/model/review_model.dart';
import 'package:flutter_food_ordering/pages/checkout_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_food_ordering/model/services/rating_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../../../credentials.dart';

class ReviewBottomSheet extends StatefulWidget {
  final Food food;

  const ReviewBottomSheet({Key key, this.food}) : super(key: key);
  @override
  _ReviewBottomSheetState createState() => _ReviewBottomSheetState(food);
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final Food food;
  Future<ReviewModel> reviewModels;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  File imageFile;
  int numberStar;
  String title;
  String content;

  RatingService ratingService = RatingService();

  _ReviewBottomSheetState(this.food);
  @override
  void initState() {
    reviewModels = fetchAllReview();
    super.initState();
  }

  Future<ReviewModel> fetchAllReview() async {
    print("id ne may thang lol ${food.id}");
    setState(() {
      reviewModels = null;
    });
    var dio = Dio();
    dio.options.connectTimeout = 5000;
    try {
      this.setState(() {
        loading = true;
      });
      // var response = await dio.get('$BASE_URL/api/foods');
      var response = await dio.get('$BASE_URL/api/review/food/${food.id}');
      print('$BASE_URL/api/review/food/${food.id}');
      print(response.data);

      if (this.mounted) {
        this.setState(() {
          loading = false;
        });
      }
      return ReviewModel.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        print("Dio Error: " + e.message);
        throw SocketException(e.message);
      } else {
        print("Type error: " + e.toString());
        throw Exception(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReviewModel>(
        future: reviewModels,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Container(
                      width: 90,
                      height: 8,
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(), color: Colors.black26),
                    ),
                  ),
                  buildTitle(food.name),
                  Divider(),
                  // RaisedButton.icon(
                  //   icon: Icon(Icons.add),
                  //   color: Colors.green,
                  //   shape: StadiumBorder(),
                  //   splashColor: Colors.white60,
                  //   onPressed: () => {},
                  //   textColor: Colors.white,
                  //   label: Text('Add review'),
                  // ),
                  if (snapshot.data.reviews.length <= 0)
                    noItemWidget()
                  else
                    buildItemsList(snapshot.data),
                  Divider(),
                  // buildPriceInfo(snapshot.data.reviews),
                  SizedBox(height: 8),
                  // addToCardButton(snapshot.data.reviews, context),
                ],
              ),
            );
          } else
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Container(
                      width: 90,
                      height: 8,
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(), color: Colors.black26),
                    ),
                  ),
                  buildTitle(food.name),
                  Divider(),
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SpinKitSquareCircle(
                          color: mainColor,
                        ),
                      )),
                  Divider(),
                  // buildPriceInfo(snapshot.data.reviews),
                  SizedBox(height: 8),
                  // addToCardButton(snapshot.data.reviews, context),
                ],
              ),
            );
        });
    //});
  }

  Widget buildTitle(cart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('REVIEW', style: headerStyle.copyWith(fontSize: 20), textAlign: TextAlign.center,),
        RaisedButton.icon(
          icon: Icon(Icons.add),
          color: Colors.green,
          shape: StadiumBorder(),
          splashColor: Colors.white60,
          onPressed: () => {
            _showPicker(context)
          },
          textColor: Colors.white,
          label: Text('Add review'),
        ),
      ],
    );
  }

  Widget buildItemsList(ReviewModel reviews) {
    return Expanded(
      child: ListView.builder(
        itemCount: reviews.reviews.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            // child: ListTile(
            //   leading: CircleAvatar(
            //     // backgroundImage: NetworkImage('$BASE_URL/uploads/${cart.cartItems[index].food.images[0]}')),
            //       backgroundImage:
            //       NetworkImage(reviews.reviews[index].profile_image)),
            //   title: Text('${reviews.reviews[index].name}',
            //       style: subtitleStyle),
            //   subtitle: Text('${reviews.reviews[index].name}:${reviews.reviews[index].title}'),
            //   // trailing:
            //   // trailing: Text(': ${reviews.reviews[index].content}',
            //   //     style: subtitleStyle),
            // ),
            child: Card(
              elevation: 3,
              color: Colors.white,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          reviews.reviews[index].image,
                          fit: BoxFit.fill,
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${reviews.reviews[index].title}",
                          style: new TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        new Text(
                          "${reviews.reviews[index].content}",
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${reviews.reviews[index].name}',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.all(8),
                              child: CircleAvatar(
                                // backgroundImage: NetworkImage('$BASE_URL/uploads/${cart.cartItems[index].food.images[0]}')),
                                backgroundImage: NetworkImage(
                                  reviews.reviews[index].profile_image,),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget noItemWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('No review here!', style: titleStyle2),
            SizedBox(height: 16),
            Icon(Icons.hourglass_empty_rounded, size: 40),
          ],
        ),
      ),
    );
  }

  Widget buildPriceInfo(ReviewModel reviewModel) {
    double total = 0;
    // for (Review review in reviewModel.reviews) {
    //   total += review.food.price * cartModel.quantity;
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Total:', style: headerStyle),
        Text('\$ ${total.toStringAsFixed(2)}', style: headerStyle),
      ],
    );
  }

  Widget addToCardButton(cart, context) {
    return Center(
      child: RaisedButton(
        child: Text('CheckOut',
            style: TextStyle(
              color: Colors.white,
            )),
        onPressed: cart.cartItems.length == 0
            ? null
            : () {
          Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CheckOutPage()));
        },
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
        color: mainColor,
        shape: StadiumBorder(),
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