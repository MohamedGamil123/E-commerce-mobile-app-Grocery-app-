import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier {
  final String id,
      title,
      imageUrl,
      productCategoryName,
      price,
      salePrice,
      description;

  final bool isOnSale, isPiece;

  ProductModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.productCategoryName,
      required this.price,
      required this.salePrice,
      required this.isOnSale,
      required this.description,
      required this.isPiece});
}
