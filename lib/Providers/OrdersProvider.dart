import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Models/OrdersModel.dart';

class OrdersProvider with ChangeNotifier {
  final Map<String, OrdersModel> _ordersitems = {};
  Map<String, OrdersModel> get getOrdersList {
    return _ordersitems;
  }

  Future<void> fetchOrdersFromFS() async {
    String uid = authinstance.currentUser!.uid;
    DocumentSnapshot userref =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final leng = userref.get("userOrders").length;
    for (int i = 0; i < leng; i++) {
      _ordersitems.putIfAbsent(
          await userref.get("userOrders")[i]["productId"],
          () => OrdersModel(
                orderId: userref.get("userOrders")[i]["orderId"],
                productId: userref.get("userOrders")[i]["productId"],
                imageUrl: userref.get("userOrders")[i]["imageUrl"],
                userId: userref.get("userOrders")[i]["userId"],
                price: userref.get("userOrders")[i]["price"].toString(),
                totalPrice:
                    userref.get("userOrders")[i]["totalPrice"].toString(),
                quantity: userref.get("userOrders")[i]["quantity"],
                username: userref.get("userOrders")[i]["username"],
                createdAt: userref.get("userOrders")[i]["createdAt"],
              ));
    }
    notifyListeners();
  }

  Future<void> clearAllOrder() async {
    User? user = authinstance.currentUser;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);
    docRef.update({"userOrders": []});
    clearLocalOrders();
    notifyListeners();
  }

  void clearLocalOrders() {
    _ordersitems.clear();
  }
}
