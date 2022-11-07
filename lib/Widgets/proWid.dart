import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class ProWid extends StatelessWidget {
  ProWid();
  final User? user = authinstance.currentUser;
  @override
  Widget build(BuildContext context) {
    final productmodel = Provider.of<ProductModel>(context);
    double currentPrice =
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
         viewedProvider.addViewedItem(proid: productmodel.id,time:Jiffy().format("MMMM do yyyy, h:mm: a").toString());
        Navigator.of(context).pushNamed(Product_details.produtdetails,
            arguments: productmodel.id);
      },
      child: Container(
        padding: EdgeInsets.only(top: setsize.height * 0.03),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
                                 isinWishlist?IconlyBold.heart: IconlyLight.heart,
                                  color: Colors.red,
                                ),
                               onPressed: () {
                                if(user!=null){
 if (isinWishlist==true) {
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
                                      productID: productmodel.id);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 600),
                                    content: CustomText(
                                      text: "Added to wishlist Successfully",
                                      color: Colors.white,
                                    ),
                                  ));
                                  }
                                }else{
                                      AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: "User not found ",
                    desc: "No user found, please login first!",
                  
                    btnOkOnPress: () { },
                  )
                    ..show();
                                }
                                  
                                
                                },
                              ),
                            IconButton(
                              icon: Icon(
                                   isIncart? IconlyBold.bag2:IconlyLight.buy,
                                color: Colors.grey.shade700,
                              ),
                              onPressed: () {
                                if(user!=null){
   if (isIncart==true) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 600),
                                      content: CustomText(
                                        text: "Already in cart",
                                        color: Colors.white,
                                      ),
                                    ));
                                  } else {
                                    cartProvider.addProducttoCart(
                                        productId: productmodel.id,
                                        quantity: 1);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 600),
                                      content: CustomText(
                                        text: "Added to cart Successfully",
                                        color: Colors.white,
                                      ),
                                    ));
                                  }
                                }else{
                                      AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: "User not found ",
                    desc: "No user found, please login first!",
                  
                    btnOkOnPress: () { },
                  )
                    ..show();
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
                            SizedBox(
                              width: 5,
                            ),
                            CustomText(
                              text: productmodel.isPiece ? "Peice" : "Kg",
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
                                  text:
                                      r"$" "${currentPrice.toStringAsFixed(2)}",
                                  color: Colors.green.shade500,
                                  istitle: true,
                                  titletextsize: 18,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: r"$"
                                      "${productmodel.price.toStringAsFixed(2)}",
                                  lineThrough: true,
                                  color: Colors.grey.shade700,
                                )
                              ]),
                            ),
                          ],
                        )
                      ]),
                ),
              ),
            ),
            Positioned(
              right: setsize.width * 0.0009,
              top: setsize.height * -0.05,
              child: Image.network(
                productmodel.imageUrl,
                height: setsize.height * 0.2,
                width: setsize.height * 0.14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
