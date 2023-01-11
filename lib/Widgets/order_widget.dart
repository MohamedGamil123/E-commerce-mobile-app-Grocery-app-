import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Models/OrdersModel.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Widgets/Alertdialoge.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';

import 'package:grocery_app/componants/AppLocals.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class Order_Widget extends StatelessWidget {
  Order_Widget();
  final User? user = authinstance.currentUser;
  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrdersModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final proById = productProvider.getproductById(ordersModel.productId);
    var setsize = Utils(context).getsize();
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Product_details.produtdetails,
            arguments: ordersModel.productId);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              height: setsize.height * 0.21,
              width: setsize.width,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.grey.shade50,
                elevation: 10,
                shadowColor: Colors.grey.withOpacity(0.3),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          color: Colors.black,
                          icon: const Icon(IconlyLight.delete),
                          onPressed: () {
                            customAlertDialoge(
                              context,
                              title: "Clear Order!".tr(context),
                              content: CustomText(
                                text: "Your item will be cleared from Orders!"
                                    .tr(context),
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: proById.title,
                                  istitle: true,
                                  titletextsize: 20,
                                  color: Colors.grey.shade800,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text:
                                      "X" "${ordersModel.quantity.toString()}",
                                  titletextsize: 20,
                                  color: Colors.grey.shade800,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CustomText(
                                text: Jiffy(ordersModel.createdAt).fromNow(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    CustomText(
                                      text: "Total: ".tr(context),
                                      color: Colors.grey.shade700,
                                    ),
                                    CustomText(
                                      text: "${ordersModel.price}",
                                      color: Colors.green.shade500,
                                      istitle: true,
                                      titletextsize: 18,
                                    ),
                                    CustomText(
                                      text: r"$".tr(context),
                                      color: Colors.green.shade500,
                                      istitle: true,
                                      titletextsize: 18,
                                    ),
                                  ]),
                                  Row(children: [
                                    CustomText(
                                      text: "Paid: ".tr(context),
                                      color: Colors.grey.shade700,
                                    ),
                                    CustomText(
                                      text: "${ordersModel.totalPrice}",
                                      color: Colors.green.shade500,
                                      istitle: true,
                                      titletextsize: 18,
                                    ),
                                    CustomText(
                                      text: r"$".tr(context),
                                      color: Colors.green.shade500,
                                      istitle: true,
                                      titletextsize: 18,
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade700,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              child:
                                  CustomText(text: "Reorder again".tr(context)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            Positioned(
              left: setsize.width * 0.05,
              top: -setsize.height * 0.02,
              child: Hero(
                tag: ordersModel.productId,
                child: CachedNetworkImage(
                  imageUrl: ordersModel.imageUrl,
                  key: UniqueKey(),
                  height: setsize.height * 0.1,
                  width: setsize.width * 0.3,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
