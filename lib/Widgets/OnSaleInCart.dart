import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Models/Product_Model.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:provider/provider.dart';

class OnSaleINCart extends StatelessWidget {
  OnSaleINCart();
  final User? user = authinstance.currentUser;
  @override
  Widget build(BuildContext context) {
    final productmodel = Provider.of<ProductModel>(context);
    String currentPrice =
        productmodel.isOnSale ? productmodel.salePrice : productmodel.price;
    var setsize = Utils(context).getsize();
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isIncart = cartProvider.getcartItems.containsKey(productmodel.id);
    final wishProvider = Provider.of<Wishlist_provider>(context);
    bool? isinWishlist =
        wishProvider.getWishListitems.containsKey(productmodel.id);
    final viewedProvider = Provider.of<ViewdProvider>(context);
    return InkWell(
      onTap: () {
        viewedProvider.addViewedItem(
            proid: productmodel.id, time: DateTime.now().toString());
        Navigator.of(context).pushNamed(Product_details.produtdetails,
            arguments: productmodel.id);
      },
      child: Container(
        padding: EdgeInsets.only(top: setsize.height * 0.03),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
                        Container(
                          child: Column(children: [
                            IconButton(
                              icon: Icon(
                                isinWishlist
                                    ? IconlyBold.heart
                                    : IconlyLight.heart,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                if (user != null) {
                                  if (isinWishlist == true) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: CustomText(
                                        text: "Already in wishlist".tr(context),
                                        color: Colors.white,
                                      ),
                                    ));
                                  } else {
                                    await wishProvider.add__WishList_FS(
                                        productID: productmodel.id);
                                    await wishProvider.getWichListFromFS();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: CustomText(
                                        text: "Added to wishlist Successfully"
                                            .tr(context),
                                        color: Colors.white,
                                      ),
                                    ));
                                  }
                                } else {
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
                                    title: "User not found ".tr(context),
                                    desc: "No user found, please login first!"
                                        .tr(context),
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isIncart ? IconlyBold.bag2 : IconlyLight.buy,
                                color: Colors.grey.shade700,
                              ),
                              onPressed: () async {
                                if (user != null) {
                                  if (isIncart == true) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: CustomText(
                                        text: "Already in cart".tr(context),
                                        color: Colors.white,
                                      ),
                                    ));
                                  } else {
                                    await cartProvider.addProducttoCart_FS(
                                        productId: productmodel.id,
                                        quantity: 1);
                                    await cartProvider.getCartFromFS();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: CustomText(
                                        text: "Added to cart Successfully"
                                            .tr(context),
                                        color: Colors.white,
                                      ),
                                    ));
                                  }
                                } else {
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
                                    title: "User not found ".tr(context),
                                    desc: "No user found, please login first!"
                                        .tr(context),
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              },
                            ),
                          ]),
                        ),
                        Row(
                          children: [
                            CustomText(
                              text: "5",
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomText(
                              text: productmodel.isPiece
                                  ? "Peice".tr(context)
                                  : "Kg".tr(context),
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                        CustomText(
                          iselipsis: true,
                          text: productmodel.title,
                          istitle: true,
                          titletextsize: 20,
                          color: Colors.grey.shade800,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(children: [
                                CustomText(
                                  text: "$currentPrice",
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
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: "${productmodel.price}",
                                  lineThrough: true,
                                  color: Colors.grey.shade700,
                                ),
                                CustomText(
                                  text: r"$".tr(context),
                                  lineThrough: true,
                                  color: Colors.grey.shade700,
                                ),
                              ]),
                            ),
                          ],
                        )
                      ]),
                ),
              ),
            ),
            Positioned(
              left: setsize.width * 0.0009,
              top: setsize.height * -0.05,
              child: Hero(
                tag: productmodel.id + "1",
                child: CachedNetworkImage(
                  imageUrl: productmodel.imageUrl,
                  key: UniqueKey(),
                  height: setsize.height * 0.2,
                  width: setsize.height * 0.14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
