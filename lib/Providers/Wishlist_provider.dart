import 'package:flutter/material.dart';
import 'package:grocery_app/Models/Wishlist_model.dart';

class Wishlist_provider extends ChangeNotifier {
  Map<String, WishlistModel> get getWishListitems {
    return _wishlistItems;
  }

  Map<String, WishlistModel> _wishlistItems = {};
  void add_Item_to_WishList({required String productID}) {
    _wishlistItems.putIfAbsent(
        productID,
        () =>
            WishlistModel(id: DateTime.now().toString(), productId: productID));
    notifyListeners();
  }

  void removeOneWishItem({required String productID}) {
    _wishlistItems.remove(productID);
    notifyListeners();
  }

  void clearAllWishs() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
