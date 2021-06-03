import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/cart_model.dart';
import 'package:flutter_food_ordering/model/food_model.dart';
import 'package:provider/provider.dart';

class TitleDurationAndFabBtn extends StatefulWidget {
  const TitleDurationAndFabBtn({
    Key key,
    @required this.food,
    bool isAdded,
  }) : super(key: key);

  final Food food;

  @override
  _TitleDurationAndFabBtnState createState() =>
      _TitleDurationAndFabBtnState(food);
}

class _TitleDurationAndFabBtnState extends State<TitleDurationAndFabBtn> {
  bool isAdded = false;
  int quantity = 0;
  final Food food;

  _TitleDurationAndFabBtnState(this.food);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<MyCart>(context);
    for (int i = 0; i < cart.cartItems.length; i++)
      if (cart.cartItems[i].food.name == food.name) {
        print(true);
        setState(() {
          this.quantity = cart.cartItems[i].quantity;
          this.isAdded = true;
        });
      }
    // print(cart.cartItems[i])
    // print("namek" + cart.cartItems[i].food.name);
    // print(cart.cartItems.length.toString());
    cart.items.map((e) {
      print(e.food.id.toString());
      print(food.id);
      if (e.food.id == food.id) {
        print(true);
        setState(() {
          this.isAdded = true;
        });
      }
    });
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.food.name,
                  style: headerStyle,
                ),
                SizedBox(height: kDefaultPadding / 2),
                Text(
                  '\$${widget.food.price}',
                  style: titleStyle2.copyWith(fontWeight: FontWeight.bold),
                  // style: TextStyle(color: kTextLightColor),
                ),
                SizedBox(width: kDefaultPadding),
                Row(
                  children: <Widget>[
                    Text(
                      "${widget.food.shop.name}",
                      style: TextStyle(color: kTextLightColor),
                    ),
                    SizedBox(width: kDefaultPadding),
                    Text(
                      "2h 32min",
                      style: TextStyle(color: kTextLightColor),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ButtonAppear(),
                isAdded
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FlatButton(
                          // height: 15,
                          minWidth: 30,
                          onPressed: () {
                            // bool isAddSuccess =

                            if (quantity == 1)
                              Provider.of<MyCart>(context, listen: false)
                                  .removeAllInCart(food);
                            else
                              Provider.of<MyCart>(context, listen: false)
                                  .decreaseDeItem(CartItem(food: food));
                            this.setState(() {
                              isAdded = false;
                            });
                            // .addItem(
                            // CartItem(food: widget.food, quantity: -1));
                            // if (isAddSuccess) {
                            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            // } else {}
                            // ScaffoldMessenger.of(context).removeCurrentSnackBar();
                            // Navigator.pushReplacementNamed(context, '/dashboard');
                          },
                          color: mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.remove,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Spacer(),
                isAdded
                    ? Text(
                        quantity.toString(),
                        style: headerStyle,
                      )
                    : Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FlatButton(
                    minWidth: 30,
                    onPressed: () {
                      bool isAddSuccess = Provider.of<MyCart>(context,
                              listen: false)
                          .addItem(CartItem(food: widget.food, quantity: 1));

                      if (isAddSuccess) {
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {}
                      // ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      // Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.add,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

    // addItemToCard() {
  }
}

class ButtonAppear extends StatefulWidget {
  @override
  _ButtonAppearState createState() => _ButtonAppearState();
}

class _ButtonAppearState extends State<ButtonAppear>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  // AnimationController

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..repeat();
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FlutterLogo(size: 30.0),
      ),
    );
  }
}
