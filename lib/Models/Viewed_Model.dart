import 'package:flutter/material.dart';

class ViewedModel extends ChangeNotifier {
  String id, productId, time;

  ViewedModel({
    required this.id,
    required this.productId,
    required this.time,
  });
}
