import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/Cart/Cart_full.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/Cart/empty_cart.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:provider/provider.dart';

class Cart_page extends StatefulWidget {
  const Cart_page({Key? key}) : super(key: key);

  @override
  State<Cart_page> createState() => _Cart_pageState();
}

class _Cart_pageState extends State<Cart_page> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartList = cartProvider.getcartItems.values.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              text: "My Cart".tr(context),
              istitle: true,
            ),
            CustomText(
              text: " (${cartList.length})",
              istitle: true,
            ),
          ],
        ),
        actions: [
          cartList.isEmpty
              ? Container()
              : IconButton(
                  icon: const Icon(
                    IconlyLight.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    AwesomeDialog(
                      titleTextStyle: TextStyle(
                          fontFamily: "Tajawal", fontWeight: FontWeight.bold),
                      descTextStyle: TextStyle(
                          fontFamily: "Tajawal", fontWeight: FontWeight.normal),
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Clear all carts!'.tr(context),
                      desc: 'Do you wante to clear all carts!'.tr(context),
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        await cartProvider.clearAllCarts();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(milliseconds: 1000),
                          content: CustomText(
                            text: "All carts cleared successfully".tr(context),
                            color: Colors.white,
                          ),
                        ));
                      },
                    ).show();
                  },
                ),
        ],
      ),
      body: cartList.isEmpty ? const Empty_cart() : const Cart_full(),
    );
  }
}
