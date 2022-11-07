import 'package:flutter/material.dart';

class WishlistModel extends ChangeNotifier {
  String id, productId;
  WishlistModel({
    required this.id,
    required this.productId,
  });
}
