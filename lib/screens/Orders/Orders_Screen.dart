import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/OrdersProvider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:grocery_app/screens/Orders/Orders_empty.dart';
import 'package:grocery_app/screens/Orders/Orders_full.dart';
import 'package:provider/provider.dart';

class Orders_Screen extends StatefulWidget {
  static const orderid = "orderid";
  const Orders_Screen({Key? key}) : super(key: key);

  @override
  State<Orders_Screen> createState() => _Orders_ScreenState();
}

class _Orders_ScreenState extends State<Orders_Screen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context);
    final ordersList = orderProvider.getOrdersList;
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: "My Orders".tr(context),
                istitle: true,
              ),
              CustomText(
                text: "(${ordersList.length}) ",
                istitle: true,
              ),
            ],
          ),
          actions: [
            IconButton(
              color: Colors.black,
              icon: const Icon(IconlyLight.delete),
              onPressed: () {
                AwesomeDialog(
                  titleTextStyle: TextStyle(
                      fontFamily: "Tajawal", fontWeight: FontWeight.bold),
                  descTextStyle: TextStyle(
                      fontFamily: "Tajawal", fontWeight: FontWeight.normal),
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: 'Clear all orders!'.tr(context),
                  desc: 'Do you wante to clear all orders!'.tr(context),
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    await orderProvider.clearAllOrder();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(milliseconds: 1000),
                      content: CustomText(
                        text: "All orders cleared successfully".tr(context),
                        color: Colors.white,
                      ),
                    ));
                  },
                ).show();
              },
            )
          ],
        ),
        body: ordersList.isEmpty ? const Order_empty() : const Order_full());
  }
}
