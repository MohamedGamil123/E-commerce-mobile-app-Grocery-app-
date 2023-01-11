import 'package:flutter/widgets.dart';

class OrdersModel with ChangeNotifier {
  String orderId,
      productId,
      userId,
      username,
      price,
      createdAt,
      imageUrl,
      totalPrice;

  int quantity;
  OrdersModel({
    required this.orderId,
    required this.productId,
    required this.userId,
    required this.createdAt,
    required this.username,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.totalPrice,
  });
}
