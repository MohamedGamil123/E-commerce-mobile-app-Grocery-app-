import 'package:flutter/material.dart';

class WishlistModel extends ChangeNotifier {
  String wishId, productId, craetedAt;
  WishlistModel({
    required this.wishId,
    required this.productId,
    required this.craetedAt,
  });
}
