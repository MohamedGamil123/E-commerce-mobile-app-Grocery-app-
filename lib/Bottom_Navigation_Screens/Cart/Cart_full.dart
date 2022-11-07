import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Widgets/Cart_widget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:provider/provider.dart';

class Cart_full extends StatefulWidget {
  const Cart_full({Key? key}) : super(key: key);

  @override
  State<Cart_full> createState() => _Cart_fullState();
}

class _Cart_fullState extends State<Cart_full> {
  @override
  Widget build(BuildContext context) {
    final cartprovider = Provider.of<CartProvider>(context);
    final cartList =
        cartprovider.getcartItems.values.toList().reversed.toList();
    var setsize = Utils(context).getsize();
    return Scaffold(
      body: Container(
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
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(15),
                      child: CustomText(
                        text: "Order now",
                      ),
                    ),
                    CustomText(
                      text: "Total: " r"$" "40",
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChangeNotifierProvider.value(
                              value: cartList[index], child: Cart_widget());
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
    );
  }
}
