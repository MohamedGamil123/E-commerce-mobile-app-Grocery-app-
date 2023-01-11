import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Models/Cart_Model.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getcartItems {
    return _cartItems;
  }

  Future<void> addProducttoCart_FS(
      {required String productId, required int quantity}) async {
    String uid = authinstance.currentUser!.uid;
    User? user = authinstance.currentUser;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(uid);
    final uuid = const Uuid().v4();
    if (user != null) {
      try {
        await userRef.update({
          "userCart": FieldValue.arrayUnion([
            {
              "cartId": uuid,
              "productId": productId,
              "quantity": quantity,
              "createdAt": DateTime.now().toString()
            }
          ])
        });
      } catch (e) {
        print(e);
      }
    }
    notifyListeners();
  }

  Future<void> getCartFromFS() async {
    String uid = authinstance.currentUser!.uid;
    DocumentSnapshot userRef =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    final leng = userRef.get("userCart").length;
    for (int i = 0; i < leng; i++) {
      _cartItems.putIfAbsent(
          await userRef.get("userCart")[i]["productId"],
          () => CartModel(
              id: userRef.get("userCart")[i]["cartId"],
              productId: userRef.get("userCart")[i]["productId"],
              quantity: userRef.get("userCart")[i]["quantity"],
              createdAt: userRef.get("userCart")[i]["createdAt"]));
    }
    notifyListeners();
  }

  Future<void> reduceQuantityBy1({
    required String createdAt,
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    String uid = authinstance.currentUser!.uid;

    DocumentReference docref =
        FirebaseFirestore.instance.collection("users").doc(uid);
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    docsnap.get("userCart");
    await docref.update({
      "userCart": FieldValue.arrayUnion([
        {
          "cartId": cartId,
          "productId": productId,
          "quantity": quantity - 1,
          "createdAt": createdAt
        }
      ])
    });
    _cartItems.update(
        productId,
        ((value) => CartModel(
            id: value.id,
            productId: productId,
            quantity: value.quantity - 1,
            createdAt: value.createdAt)));
    await docref.update({
      "userCart": FieldValue.arrayRemove([
        {
          "cartId": cartId,
          "productId": productId,
          "quantity": quantity,
          "createdAt": createdAt
        }
      ])
    });
    getCartFromFS();
    notifyListeners();
  }

  Future<void> increaseQuantityBy1({
    required String createdAt,
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    String uid = authinstance.currentUser!.uid;

    DocumentReference docref =
        FirebaseFirestore.instance.collection("users").doc(uid);
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    docsnap.get("userCart");
    await docref.update({
      "userCart": FieldValue.arrayUnion([
        {
          "cartId": cartId,
          "productId": productId,
          "quantity": quantity + 1,
          "createdAt": createdAt
        }
      ])
    });
    _cartItems.update(
        productId,
        ((value) => CartModel(
            id: value.id,
            productId: productId,
            quantity: value.quantity + 1,
            createdAt: value.createdAt)));
    await docref.update({
      "userCart": FieldValue.arrayRemove([
        {
          "cartId": cartId,
          "productId": productId,
          "quantity": quantity,
          "createdAt": createdAt
        }
      ])
    });
    getCartFromFS();
    notifyListeners();
  }

  Future<void> removeOneCart(
      {required String productId,
      required String cartId,
      required int quantity,
      required String createdAt}) async {
    String uid = authinstance.currentUser!.uid;
    CollectionReference userdoc =
        FirebaseFirestore.instance.collection("users");
    await userdoc.doc(uid).update({
      "userCart": FieldValue.arrayRemove([
        {
          "cartId": cartId,
          "productId": productId,
          "quantity": quantity,
          "createdAt": createdAt
        }
      ])
    });

    _cartItems.remove(productId);
    await getCartFromFS();
    notifyListeners();
  }

  Future<void> clearAllCarts() async {
    final String uid = authinstance.currentUser!.uid;
    DocumentReference userdoc =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await userdoc.update({"userCart": []});
    clearLocalCArts();
    await getCartFromFS();
    notifyListeners();
  }

  void clearLocalCArts() {
    _cartItems.clear();
  }
}
