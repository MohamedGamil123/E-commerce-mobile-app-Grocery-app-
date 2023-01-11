import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Models/Wishlist_model.dart';
import 'package:uuid/uuid.dart';

class Wishlist_provider extends ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};
  Map<String, WishlistModel> get getWishListitems {
    return _wishlistItems;
  }

  Future<void> add__WishList_FS({required String productID}) async {
    final User? user = authinstance.currentUser;
    String uid = user!.uid;
    DocumentReference userref =
        FirebaseFirestore.instance.collection("users").doc(uid);
    String uuid = const Uuid().v4();
    await userref.update({
      "userWish": FieldValue.arrayUnion([
        {
          "wishId": uuid,
          "productId": productID,
          "createdAt": DateTime.now().toString()
        }
      ])
    });
    // _wishlistItems.putIfAbsent(
    //     productID,
    //     () =>
    //         WishlistModel(id: DateTime.now().toString(), productId: productID));
    notifyListeners();
  }

  Future<void> getWichListFromFS() async {
    final User? user = authinstance.currentUser;
    String uid = user!.uid;
    DocumentSnapshot docref =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    var wishleng = docref.get("userWish").length;
    for (int i = 0; i < wishleng; i++) {
      _wishlistItems.putIfAbsent(
          await docref.get("userWish")[i]["productId"],
          () => WishlistModel(
              wishId: docref.get("userWish")[i]["wishId"],
              productId: docref.get("userWish")[i]["productId"],
              craetedAt: docref.get("userWish")[i]["createdAt"]));
    }
    notifyListeners();
  }

  Future<void> removeOneWishItem({
    required String wishId,
    required String productID,
    required String createdAt,
  }) async {
    final User? user = authinstance.currentUser;
    String uid = user!.uid;
    DocumentReference docref =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await docref.update({
      "userWish": FieldValue.arrayRemove([
        {"wishId": wishId, "productId": productID, "createdAt": createdAt}
      ])
    });
    _wishlistItems.remove(productID);
    notifyListeners();
  }

  Future<void> clearAllWishs() async {
    final User? user = authinstance.currentUser;
    String uid = user!.uid;
    DocumentReference docref =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await docref.update({"userWish": []});
    clearLocalWishs();
    notifyListeners();
  }

  void clearLocalWishs() {
    _wishlistItems.clear();
  }
}
