import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/Models/Product_Model.dart';

class ProductProvider with ChangeNotifier {
  static final List<ProductModel> _productList = [];
  List<ProductModel> get getAllProductList {
    return _productList;
  }

  Future<void> fetchProductsFromFS() async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .orderBy("createdAt", descending: false)
          .get()
          .then(
        (QuerySnapshot productSnapshot) {
          print(productSnapshot.docs.length);
          for (var element in productSnapshot.docs) {
            _productList.insert(
                0,
                ProductModel(
                    id: element.get("id"),
                    imageUrl: element.get("imageUrl"),
                    isOnSale: element.get("isOnSale"),
                    price: element.get("price"),
                    isPiece: element.get("isPiece"),
                    productCategoryName: element.get("productCategoryName"),
                    salePrice: element.get("salePrice"),
                    title: element.get("title"),
                    description: element.get("description")));
          }
          print(_productList.length);
        },
      );
    } catch (e) {
      print("..............");
      print(e);
      print("............................");
    }

    notifyListeners();
  }

  List<ProductModel> get getOnsaleProducts {
    return _productList.where((element) => element.isOnSale).toList();
  }

  ProductModel getproductById(String productId) {
    return _productList.firstWhere(
      (element) => element.id == productId,
    );
  }

  List<ProductModel> getproductByCategory(String proCategory) {
    return _productList
        .where(
          (element) =>
              element.productCategoryName.toLowerCase() ==
              proCategory.toLowerCase(),
        )
        .toList();
  }

  List<ProductModel> getProductBySearch(String searchtext) {
    return _productList
        .where((element) =>
            element.title.toLowerCase().contains(searchtext.toLowerCase()))
        .toList();
  }
}
