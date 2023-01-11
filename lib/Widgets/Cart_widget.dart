import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';
import 'package:grocery_app/Models/Cart_Model.dart';

import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class Cart_widget extends StatefulWidget {
  const Cart_widget({Key? key}) : super(key: key);

  @override
  State<Cart_widget> createState() => _Cart_widgetState();
}

class _Cart_widgetState extends State<Cart_widget> {
  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    final productprovider = Provider.of<ProductProvider>(context);
    final cartmodel = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final String cartId = cartmodel.productId;
    final productbyId = productprovider.getproductById(cartId);
    double currentPrice = productbyId.isOnSale
        ? double.parse(productbyId.salePrice)
        : double.parse(productbyId.price);
    double totalPrice = currentPrice * cartmodel.quantity;
    final wishProvider = Provider.of<Wishlist_provider>(context);
    bool? isinWishlist =
        wishProvider.getWishListitems.containsKey(productbyId.id);
    final viewedProvider = Provider.of<ViewdProvider>(context);
    return InkWell(
      onTap: () {
        if (viewedProvider.getviewedItems.containsKey(productbyId.id)) {
          null;
        } else {
          viewedProvider.addViewedItem(
              proid: productbyId.id, time: DateTime.now().toString());
        }
        Navigator.of(context).pushNamed(Product_details.produtdetails,
            arguments: productbyId.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.grey)]),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Flexible(
                flex: 1,
                child: Hero(
                  tag: productbyId.isOnSale
                      ? productbyId.id + "1"
                      : productbyId.id,
                  child: CachedNetworkImage(
                    imageUrl: productbyId.imageUrl,
                    fit: BoxFit.contain,
                    key: UniqueKey(),
                    height: setsize.height * 0.14,
                    width: setsize.width * 0.3,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          iselipsis: true,
                          text: "Name: ".tr(context),
                        ),
                        CustomText(
                          iselipsis: true,
                          text: "${productbyId.title.toString()}",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "Type: ".tr(context),
                        ),
                        CustomText(
                          text: "${productbyId.productCategoryName.toString()}",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: setsize.height * 0.005,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "Price: ".tr(context),
                        ),
                        CustomText(
                          text: "${currentPrice.toString()} ",
                        ),
                        CustomText(
                          text: r"$".tr(context),
                        ),
                        CustomText(
                          text: productbyId.isPiece
                              ? " /Peice".tr(context)
                              : " /Kg".tr(context),
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: setsize.height * 0.005,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "Total price: ".tr(context),
                        ),
                        CustomText(
                          iselipsis: true,
                          text: "$totalPrice ",
                        ),
                        CustomText(
                          iselipsis: true,
                          text: r"$".tr(context),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "From: ".tr(context),
                        ),
                        CustomText(
                          iselipsis: true,
                          text: Jiffy(cartmodel.createdAt).fromNow(),
                        ),
                      ],
                    ),
                    Container(
                      width: setsize.width * 0.55,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Amount: ".tr(context),
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.plus),
                            onPressed: () async {
                              await cartProvider.increaseQuantityBy1(
                                  productId: productbyId.id,
                                  quantity: cartmodel.quantity,
                                  cartId: cartmodel.id,
                                  createdAt: cartmodel.createdAt);
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CustomText(
                            text: cartmodel.quantity.toString(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.minus),
                            onPressed: () async {
                              await cartProvider.reduceQuantityBy1(
                                  cartId: cartmodel.id,
                                  createdAt: cartmodel.createdAt,
                                  quantity: cartmodel.quantity,
                                  productId: productbyId.id);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: setsize.height * 0.009,
                    ),
                  ],
                ),
              )
            ]),
            Container(
              decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        isinWishlist ? IconlyBold.heart : IconlyLight.heart,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        if (isinWishlist == true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            content: CustomText(
                              text: "Already in wishlist".tr(context),
                              color: Colors.white,
                            ),
                          ));
                        } else {
                          await wishProvider.add__WishList_FS(
                              productID: productbyId.id);
                          await wishProvider.getWichListFromFS();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            content: CustomText(
                              text:
                                  "Added to wishlist Successfully".tr(context),
                              color: Colors.white,
                            ),
                          ));
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(IconlyLight.delete),
                      onPressed: () {
                        AwesomeDialog(
                          titleTextStyle: TextStyle(
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold),
                          descTextStyle: TextStyle(
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.normal),
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Clear cart!'.tr(context),
                          desc: 'Do you wante to clear cart!'.tr(context),
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            await cartProvider.removeOneCart(
                                productId: cartmodel.productId,
                                cartId: cartmodel.id,
                                quantity: cartmodel.quantity,
                                createdAt: cartmodel.createdAt);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              content: CustomText(
                                text: " Cart cleared successfully".tr(context),
                                color: Colors.white,
                              ),
                            ));
                          },
                        ).show();
                      },
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
