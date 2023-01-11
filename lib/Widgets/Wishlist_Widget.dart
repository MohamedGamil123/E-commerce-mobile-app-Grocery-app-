import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Models/Wishlist_model.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class Wishlist_Widget extends StatelessWidget {
  const Wishlist_Widget();

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<ProductProvider>(context);

    final wishModel = Provider.of<WishlistModel>(context);

    final productById = productprovider.getproductById(wishModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isIncart = cartProvider.getcartItems.containsKey(productById.id);
    final wishProvider = Provider.of<Wishlist_provider>(context);
    var setsize = Utils(context).getsize();
    String currentPrice =
        productById.isOnSale ? productById.salePrice : productById.price;
    final viewedProvider = Provider.of<ViewdProvider>(context);
    return InkWell(
      onTap: () {
        if (viewedProvider.getviewedItems.containsKey(productById.id)) {
          null;
        } else {
          viewedProvider.addViewedItem(
              proid: productById.id, time: DateTime.now().toString());
        }
        Navigator.of(context).pushNamed(Product_details.produtdetails,
            arguments: productById.id);
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
                              titleTextStyle: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.bold),
                              descTextStyle: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.normal),
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: 'Clear wish item!'.tr(context),
                              desc: 'Do you wante to clear wish item!'
                                  .tr(context),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                await wishProvider.removeOneWishItem(
                                    wishId: wishModel.wishId,
                                    productID: productById.id,
                                    createdAt: wishModel.craetedAt);
                                await wishProvider.getWichListFromFS();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: CustomText(
                                    text: " Wish item cleared successfully"
                                        .tr(context),
                                    color: Colors.white,
                                  ),
                                ));
                              },
                            ).show();
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
                            const Flexible(child: SizedBox()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            visible: productById.isOnSale
                                                ? true
                                                : false,
                                            child: Row(
                                              children: [
                                                CustomText(
                                                  text: "${productById.price}",
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
                                            text: productById.isPiece
                                                ? "Peice".tr(context)
                                                : "Kg".tr(context),
                                            color: Colors.grey.shade700,
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                  CustomText(
                                    text: Jiffy(wishModel.craetedAt).fromNow(),
                                  )
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
                                  onPressed: () async {
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
                                          productId: productById.id,
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
              left: setsize.width * 0,
              top: setsize.height * -0.017,
              child: Hero(
                tag: productById.id,
                child: CachedNetworkImage(
                  imageUrl: productById.imageUrl,
                  key: UniqueKey(),
                  height: setsize.height * 0.153,
                  width: setsize.width * 0.53,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
