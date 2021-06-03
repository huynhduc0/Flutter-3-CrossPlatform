import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/model/food_model.dart';

class MyCart extends ChangeNotifier {
  List<CartItem> items = [];
  List<CartItem> get cartItems => items;

  bool addItem(CartItem cartItem) {
    for (CartItem cart in cartItems) {
      if (cartItem.food.shop.id != cart.food.shop.id) {
        return false;
      }
      if (cartItem.food.name == cart.food.name) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        notifyListeners();
        return true;
      }
    }

    items.add(cartItem);
    notifyListeners();
    return true;
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  void decreaseItem(CartItem cartModel) {
    if (cartItems[cartItems.indexOf(cartModel)].quantity <= 1) {
      return;
    }
    cartItems[cartItems.indexOf(cartModel)].quantity--;
    notifyListeners();
  }

  void decreaseDeItem(CartItem cartModel) {
    CartItem old;
    int key;
    print("---" + cartItems.length.toString());
    // cartItems.
    // cartItems.forEach((e) {
    //   if (e.food.name == cartModel.food.name) old = e;
    // });
    for (var i = 0; i < cartItems.length; i++)
      if (cartItems[i].food.name == cartModel.food.name) key = i;
    // .map((e) {
    //   print("tr-" + cartModel.food.name + " - " + e.food.name);
    //   if (e.food.name == cartModel.food.name) old = e;
    // });
    print(key);
    if (cartItems[key].quantity <= 1) {
      // return;
      cartItems.removeAt(key);
    }
    cartItems[key].quantity--;
    notifyListeners();
  }

  void increaseItem(CartItem cartModel) {
    cartItems[cartItems.indexOf(cartModel)].quantity++;
    notifyListeners();
  }

  void removeAllInCart(Food food) {
    cartItems.removeWhere((f) {
      return f.food.name == food.name;
    });
    notifyListeners();
  }
}

class CartItem {
  Food food;
  int quantity;

  CartItem({this.food, this.quantity});
}