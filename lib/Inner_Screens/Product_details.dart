import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:grocery_app/Widgets/custom_button.dart';
import 'package:provider/provider.dart';

class Product_details extends StatefulWidget {
  static String produtdetails = "produtdetails";
  Product_details({Key? key}) : super(key: key);

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
    double currentPrice =
        productbyId.isOnSale ? productbyId.salePrice : productbyId.price;
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
                child: Container(
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
                                onTap: () {
                                  if (user != null) {
                                    if (isinWishlist == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(milliseconds: 600),
                                        content: CustomText(
                                          text: "Already in wishlist",
                                          color: Colors.white,
                                        ),
                                      ));
                                    } else {
                                      wishProvider.add_Item_to_WishList(
                                          productID: productbyId.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(milliseconds: 600),
                                        content: CustomText(
                                          text:
                                              "Added to wishlist Successfully",
                                          color: Colors.white,
                                        ),
                                      ));
                                    }
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.rightSlide,
                                      title: "User not found ",
                                      desc:
                                          "No user found, please login first!",
                                      btnOkOnPress: () {},
                                    ).show();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
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
                          const ExpandableText(
                            'Product details',
                            expandText: 'show more',
                            collapseText: 'show less',
                          ),
                          const SizedBox(height: 10.0),
                          const ExpandableText(
                            'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
                            expandText: 'show more',
                            collapseText: 'show less',
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
                                    text: r"$"
                                        "${currentPrice.toStringAsFixed(2)}",
                                    color: Colors.green.shade500,
                                    titletextsize: 24,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Visibility(
                                    visible:
                                        productbyId.isOnSale ? true : false,
                                    child: CustomText(
                                      text: r"$"
                                          "${productbyId.price.toStringAsFixed(2)}",
                                      lineThrough: true,
                                      color: Colors.grey.shade700,
                                      titletextsize: 24,
                                    ),
                                  ),
                                  CustomText(
                                    text: " /",
                                    color: Colors.grey.shade700,
                                  ),
                                  CustomText(
                                    text: productbyId.isPiece ? "Peice" : "Kg",
                                    color: Colors.grey.shade700,
                                  ),
                                ]),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade200,
                                    borderRadius: BorderRadius.circular(15)),
                                child: CustomText(
                                  text: "Free delivery",
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
                                  SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
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
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                          child: Icon(FontAwesomeIcons.minus)),
                                    ),
                                  ),
                                  CustomText(
                                    text: "${amount}",
                                    istitle: true,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        amount += 1;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                          child: Icon(FontAwesomeIcons.plus)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: setsize.height * 0.081,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 15, bottom: 15, left: 15, right: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.orange.shade200,
                                borderRadius: BorderRadius.circular(15)),
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
                                          text: "Total",
                                          istitle: true,
                                          color: Colors.red,
                                        ),
                                        Row(
                                          children: [
                                            CustomText(
                                              text: r"$"
                                                  "${totalPrice.toStringAsFixed(2)} ",
                                            ),
                                            CustomText(
                                              text:
                                                  productbyId.isPiece ? " /Peice" : " /Kg",
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomButton(
                                      ontap: () {
                                        if (user != null) {
                                          if (isIncart == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              duration:
                                                  Duration(milliseconds: 600),
                                              content: CustomText(
                                                text: "Already in cart",
                                                color: Colors.white,
                                              ),
                                            ));
                                          } else {
                                            cartProvider.addProducttoCart(
                                                productId: productbyId.id,
                                                quantity: amount);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              duration:
                                                  Duration(milliseconds: 600),
                                              content: CustomText(
                                                text:
                                                    "Added to cart Successfully",
                                                color: Colors.white,
                                              ),
                                            ));
                                          }
                                        } else {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            animType: AnimType.rightSlide,
                                            title: "User not found ",
                                            desc:
                                                "No user found, please login first!",
                                            btnOkOnPress: () {},
                                          )..show();
                                        }
                                      },
                                      text:
                                          isIncart ? "In cart" : "Add to cart")
                                ]),
                          )
                        ]),
                  ),
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
                ),
              )
            ],
          )),
          Positioned(
              top: setsize.height * 0.145,
              left: setsize.width * 0.2,
              child: Image.network(
                filterQuality: FilterQuality.low,
                productbyId.imageUrl,
                height: setsize.height * 0.3,
                width: setsize.width * 0.6,
              ))
        ],
      ),
    );
  }
}
