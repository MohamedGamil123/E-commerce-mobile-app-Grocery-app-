import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/OrdersProvider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Widgets/Cart_widget.dart';
import 'package:grocery_app/Widgets/LoadingWidget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Cart_full extends StatefulWidget {
  const Cart_full({Key? key}) : super(key: key);

  @override
  State<Cart_full> createState() => _Cart_fullState();
}

class _Cart_fullState extends State<Cart_full> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    double total = 0.0;
    final cartprovider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final cartList =
        cartprovider.getcartItems.values.toList().reversed.toList();
    cartprovider.getcartItems.forEach(
      (key, value) {
        final currentProduct = productProvider.getproductById(value.productId);
        total += (currentProduct.isOnSale
                ? double.parse(currentProduct.salePrice)
                : double.parse(currentProduct.price)) *
            value.quantity;
      },
    );
    var setsize = Utils(context).getsize();
    final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
    return Scaffold(
      body: LoadingScreen(
        isLoading: isloading,
        child: SizedBox(
          height: setsize.height,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(text: "Check out".tr(context)),
                        ),
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });
                          String uuid = Uuid().v4();
                          User? user = authinstance.currentUser;
                          final productsProvider = Provider.of<ProductProvider>(
                              context,
                              listen: false);
                          final cartprovider =
                              Provider.of<CartProvider>(context, listen: false);
                          String uid = authinstance.currentUser!.uid;
                          cartprovider.getcartItems.forEach(
                            (key, value) async {
                              final currentProduct = productsProvider
                                  .getproductById(value.productId);
                              DocumentReference userRef = FirebaseFirestore
                                  .instance
                                  .collection("users")
                                  .doc(uid);
                              try {
                                setState(() {
                                  isloading = true;
                                });

                                await userRef.update({
                                  "userOrders": FieldValue.arrayUnion([
                                    {
                                      "orderId": uuid,
                                      "productId": value.productId,
                                      "userId": user!.uid,
                                      "createdAt": DateTime.now().toString(),
                                      "imageUrl": currentProduct.imageUrl,
                                      "username": user.displayName,
                                      "quantity": value.quantity,
                                      "price": (currentProduct.isOnSale
                                              ? double.parse(
                                                  currentProduct.salePrice)
                                              : double.parse(
                                                  currentProduct.price)) *
                                          value.quantity,
                                      "totalPrice": total.toString()
                                    }
                                  ])
                                });
                                await orderProvider.fetchOrdersFromFS();
                                setState(() {
                                  isloading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isloading = false;
                                });
                                print(e);
                              }
                            },
                          );
                          await cartprovider.clearAllCarts();
                          cartprovider.clearLocalCArts();
                        },
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "Total: ".tr(context),
                          ),
                          CustomText(
                            text: "${total.toStringAsFixed(2)}",
                          ),
                          CustomText(
                            text: r"$".tr(context),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChangeNotifierProvider.value(
                                value: cartList[index],
                                child: const Cart_widget());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
