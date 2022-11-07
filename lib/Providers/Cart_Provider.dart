import 'package:flutter/cupertino.dart';
import 'package:grocery_app/Models/Cart_Model.dart';
import 'package:grocery_app/Models/Product_Model.dart';

class CartProvider extends ChangeNotifier {
  Map<String, CartModel> get getcartItems {
    return _cartItems;
  }

  Map<String, CartModel> _cartItems = {};

  void addProducttoCart({required String productId, required int quantity}) {
    _cartItems.putIfAbsent(
        productId,
        () => CartModel(
            id: DateTime.now().toString(),
            productId: productId,
            quantity: quantity));
    notifyListeners();
  }

  void reduceQuantityBy1({required String productId}) {
    _cartItems.update(
        productId,
        ((value) => CartModel(
            id: value.id, productId: productId, quantity: value.quantity - 1)));
    notifyListeners();
  }

  void increaseQuantityBy1({required String productId}) {
    _cartItems.update(
        productId,
        ((value) => CartModel(
            id: value.id, productId: productId, quantity: value.quantity + 1)));
    notifyListeners();
  }

  void removeOneCart({required String productId}) {
    _cartItems.remove(productId);
      notifyListeners();
  }
  void clearAllCarts() {
    _cartItems.clear();
      notifyListeners();
  }
}
