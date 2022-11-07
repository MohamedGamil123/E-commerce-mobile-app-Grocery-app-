import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Models/Product_Model.dart';
import 'package:grocery_app/Models/Wishlist_model.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/Alertdialoge.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class Wishlist_Widget extends StatelessWidget {
  Wishlist_Widget();

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);

    final wishModel = Provider.of<WishlistModel>(context);

    final productById = productprovider.getproductById(wishModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isIncart = cartProvider.getcartItems.containsKey(productById.id);
     final wishProvider = Provider.of<Wishlist_provider>(context);
    var setsize = Utils(context).getsize();
    double currentPrice =
        productById.isOnSale ? productById.salePrice : productById.price;
         final viewedProvider = Provider.of<ViewdProvider>(context);
    return InkWell(
      onTap: () {
          if (viewedProvider.getviewedItems.containsKey(productById.id)) {
         null;
        }else{
 viewedProvider.addViewedItem(proid: productById.id,time:Jiffy().format("MMMM do yyyy, h:mm: a").toString());
        }
         Navigator.of(context).pushNamed(Product_details.produtdetails,arguments: productById.id);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              height: setsize.height * 0.2,
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
                              AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Clear wish item!',
                        desc: 'Do you wante to clear wish item!',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          wishProvider.removeOneWishItem(productID: productById.id);
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 600),
                          content: CustomText(
                              text: " Wish item cleared successfully",
                              color: Colors.white,
                              ),
                        ));
                        },
                      )..show();
                          },
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: CustomText(
                                text: productById.title,
                                iselipsis: true,
                                istitle: true,
                                titletextsize: 20,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Flexible(
                             
                              child: SizedBox()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child:  Row(
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
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Visibility(
                                    visible:
                                        productById.isOnSale ? true : false,
                                    child: CustomText(
                                      text: r"$"
                                          "${productById.price.toStringAsFixed(2)}",
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
                                    text: productById.isPiece ? "Peice" : "Kg",
                                    color: Colors.grey.shade700,
                                  ),
                                ]),
                              ),
                              
                            ],
                          ),
                            ),
                            Container(
                              child: Row(children: [
                                IconButton(
                                  icon: Icon(
                                    isIncart
                                        ? IconlyBold.bag2
                                        : IconlyLight.buy,
                                    color: Colors.grey.shade700,
                                  ),
                                  onPressed: () {
                                    if (isIncart == true) {
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
                                          productId: productById.id,
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
                                  },
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
              right: setsize.width * 0,
              top: setsize.height * -0.017,
              child: Image.network(
                productById.imageUrl,
                height: setsize.height * 0.153,
                width: setsize.width * 0.53,
              ),
            )
          ],
        ),
      ),
    );
  }
}
