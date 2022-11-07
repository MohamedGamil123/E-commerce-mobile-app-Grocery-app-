import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Inner_Screens/empty_products_dcreens.dart';
import 'package:grocery_app/Models/Product_Model.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';

import 'package:grocery_app/Widgets/OnSaleInCart.dart';
import 'package:grocery_app/Widgets/Onsale_cart.dart';

import 'package:grocery_app/Widgets/customText.dart';
import 'package:provider/provider.dart';

class Onsale_Screen extends StatelessWidget {
  static String onsalSc = "onsalSc";
  const Onsale_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // on sale //
    //instance of onSale provider
    final onsaleprovider = Provider.of<ProductProvider>(context);
    // return is a list take it in instance of list of product model
    List<ProductModel> onsaleproduct = onsaleprovider.getOnsaleProducts;
   
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              IconlyLight.arrowLeft2,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        title: CustomText(
          text: "Products on sale",
          istitle: true,
          color: Colors.black,
        ),
      ),
      body: onsaleproduct.isEmpty
          ? Empty_products()
          : GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 280, mainAxisSpacing: 10),
              itemCount: onsaleproduct.length,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                    value: onsaleproduct[index], child: OnSaleINCart());
              },
            ),
    );
  }
}
