import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:provider/provider.dart';

class Product_details extends StatefulWidget {
  static String produtdetails = "produtdetails";
  const Product_details({Key? key}) : super(key: key);

  @override
  State<Product_details> createState() => _Product_detailsState();
}

class _Product_detailsState extends State<Product_details> {
  int amount = 1;
  final User? user = authinstance.currentUser;
  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productbyId = productprovider.getproductById(productId);
    var setsize = Utils(context).getsize();
    double currentPrice = productbyId.isOnSale
        ? double.parse(productbyId.salePrice)
        : double.parse(productbyId.price);
    double totalPrice = currentPrice * amount;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isIncart = cartProvider.getcartItems.containsKey(productbyId.id);
    final wishProvider = Provider.of<Wishlist_provider>(context);
    bool? isinWishlist =
        wishProvider.getWishListitems.containsKey(productbyId.id);
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: setsize.height * 0.06,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(25),
                            height: 15,
                            width: 15,
                            child: const Icon(IconlyLight.arrowLeft2),
                          ),
                        )
                      ]),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey.shade300,
                            spreadRadius: 5)
                      ],
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: setsize.height * 0.1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: productbyId.title,
                                  istitle: true,
                                  titletextsize: 25,
                                  color: Colors.green,
                                  maxlines: 2,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (user != null) {
                                    if (isinWishlist == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content: CustomText(
                                          text:
                                              "Already in wishlist".tr(context),
                                          color: Colors.white,
                                        ),
                                      ));
                                    } else {
                                      await wishProvider.add__WishList_FS(
                                          productID: productbyId.id);
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
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.orange.shade200,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Center(
                                      child: Icon(
                                    isinWishlist
                                        ? IconlyBold.heart
                                        : IconlyLight.heart,
                                    color: Colors.red,
                                  )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ExpandableText(
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Tajawal",
                                fontWeight: FontWeight.w600),
                            'Product details'.tr(context),
                            expandText: 'show more'.tr(context),
                            collapseText: 'show less'.tr(context),
                          ),
                          const SizedBox(height: 10.0),
                          ExpandableText(
                            style:
                                TextStyle(fontSize: 15, fontFamily: "Tajawal"),
                            " ${productbyId.description}",
                            expandText: 'show more'.tr(context),
                            collapseText: 'show less'.tr(context),
                            maxLines: 1,
                            linkColor: Colors.blue,
                            animation: true,
                          ),
                          const SizedBox(
                            height: 25,
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
                                    width: 15,
                                  ),
                                  Visibility(
                                    visible:
                                        productbyId.isOnSale ? true : false,
                                    child: Row(
                                      children: [
                                        CustomText(
                                          text: "${productbyId.price}",
                                          lineThrough: true,
                                          color: Colors.grey.shade700,
                                          titletextsize: 24,
                                        ),
                                        CustomText(
                                          text: r"$".tr(context),
                                          lineThrough: true,
                                          color: Colors.grey.shade700,
                                          titletextsize: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomText(
                                    text: " /",
                                    color: Colors.grey.shade700,
                                  ),
                                  CustomText(
                                    text: productbyId.isPiece
                                        ? "Peice".tr(context)
                                        : "Kg".tr(context),
                                    color: Colors.grey.shade700,
                                  ),
                                ]),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(15)),
                                child: CustomText(
                                  text: "Free delivery".tr(context),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: setsize.height * 0.081,
                          ),
                          Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Center(
                                          child: Icon(FontAwesomeIcons.plus)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        amount += 1;
                                      });
                                    },
                                  ),
                                  CustomText(
                                    text: "$amount",
                                    istitle: true,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Center(
                                          child: Icon(FontAwesomeIcons.minus)),
                                    ),
                                    onPressed: () {
                                      if (amount > 1) {
                                        setState(() {
                                          amount--;
                                        });
                                      } else {
                                        setState(() {
                                          amount = 1;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: setsize.height * 0.081,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.orange.shade200,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "Total".tr(context),
                                          istitle: true,
                                          color: Colors.red,
                                        ),
                                        Row(
                                          children: [
                                            CustomText(
                                              text: "$totalPrice ",
                                            ),
                                            CustomText(
                                              text: r"$".tr(context),
                                            ),
                                            CustomText(
                                              text: productbyId.isPiece
                                                  ? " /Peice".tr(context)
                                                  : " /Kg".tr(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            CustomText(
                                              text: isIncart
                                                  ? "In cart".tr(context)
                                                  : "Add to cart".tr(context),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              isIncart
                                                  ? IconlyBold.bag2
                                                  : IconlyLight.buy,
                                              color: Colors.grey.shade300,
                                            )
                                          ],
                                        )),
                                    onPressed: () async {
                                      if (user != null) {
                                        if (isIncart == true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration:
                                                const Duration(seconds: 1),
                                            content: CustomText(
                                              text:
                                                  "Already in cart".tr(context),
                                              color: Colors.white,
                                            ),
                                          ));
                                        } else {
                                          await cartProvider
                                              .addProducttoCart_FS(
                                                  productId: productbyId.id,
                                                  quantity: amount);
                                          await cartProvider.getCartFromFS();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration:
                                                const Duration(seconds: 1),
                                            content: CustomText(
                                              text: "Added to cart Successfully"
                                                  .tr(context),
                                              color: Colors.white,
                                            ),
                                          ));
                                        }
                                      } else {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.rightSlide,
                                          title: "User not found ".tr(context),
                                          desc:
                                              "No user found, please login first!"
                                                  .tr(context),
                                          btnOkOnPress: () {},
                                        ).show();
                                      }
                                    },
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: setsize.height * 0.018,
                          )
                        ]),
                  ),
                ),
              )
            ],
          )),
          Positioned(
              top: setsize.height * 0.145,
              left: setsize.width * 0.2,
              child: Hero(
                tag: productbyId.isOnSale
                    ? productbyId.id + "1"
                    : productbyId.id,
                child: CachedNetworkImage(
                  imageUrl: productbyId.imageUrl,
                  filterQuality: FilterQuality.low,
                  key: UniqueKey(),
                  height: setsize.height * 0.3,
                  width: setsize.width * 0.6,
                ),
              ))
        ],
      ),
    );
  }
}
