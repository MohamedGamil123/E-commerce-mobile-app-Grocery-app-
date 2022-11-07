import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Widgets/Alertdialoge.dart';
import 'package:grocery_app/Widgets/Cart_widget.dart';
import 'package:grocery_app/Widgets/Onsale_cart.dart';
import 'package:grocery_app/Widgets/Wishlist_Widget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Widgets/order_widget.dart';
import 'package:grocery_app/screens/Orders/Orders_empty.dart';
import 'package:grocery_app/screens/Orders/Orders_full.dart';
import 'package:grocery_app/screens/Wishlist/Wishlist_empty.dart';
import 'package:grocery_app/screens/Wishlist/Wishlist_full.dart';

class Orders_Screen extends StatefulWidget {
  static final orderid = "orderid";
  const Orders_Screen({Key? key}) : super(key: key);

  @override
  State<Orders_Screen> createState() => _Orders_ScreenState();
}

class _Orders_ScreenState extends State<Orders_Screen> {
  bool Orders_Screen_empty = false;
  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                IconlyLight.arrowLeft2,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          title: CustomText(
            text: "My Orders ",
            istitle: true,
          ),
          actions: [
            Orders_Screen_empty
                ? SizedBox(
                    width: 1,
                  )
                : IconButton(
                    color: Colors.black,
                    icon: Icon(IconlyLight.delete),
                    onPressed: () {
                      customAlertDialoge(context,
                          content: CustomText(text: "Do you want to clear all orders!"),
                          title: "Clear all orders history!",
                         actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Ok"),
                          onPressed: () {},
                        )
                      ]);
                    },
                  )
          ],
        ),
        body: Orders_Screen_empty ? Order_empty() : Order_full());
  }
}
