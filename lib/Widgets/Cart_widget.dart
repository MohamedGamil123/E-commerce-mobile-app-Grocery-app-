import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';
import 'package:grocery_app/Models/Cart_Model.dart';
import 'package:grocery_app/Models/Product_Model.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:provider/provider.dart';

class Cart_widget extends StatefulWidget {
  Cart_widget({Key? key}) : super(key: key);

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
    double currentPrice =
        productbyId.isOnSale ? productbyId.salePrice : productbyId.price;
    double totalPrice = currentPrice * cartmodel.quantity;
    final wishProvider = Provider.of<Wishlist_provider>(context);
    bool? isinWishlist =
        wishProvider.getWishListitems.containsKey(productbyId.id);
    final viewedProvider = Provider.of<ViewdProvider>(context);
    return InkWell(
      onTap: () {
        if (viewedProvider.getviewedItems.containsKey(productbyId.id)) {
         null;
        }else{
 viewedProvider.addViewedItem(proid: productbyId.id,time: DateTime.now().toString());
        }
        Navigator.of(context).pushNamed(Product_details.produtdetails,
            arguments: productbyId.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)]),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: setsize.height * 0.28,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Flexible(
                flex: 2,
                child: Image.network(
                  productbyId.imageUrl,
                  height: setsize.height * 0.14,
                  width: setsize.width * 0.3,
                ),
              ),
              VerticalDivider(
                color: Colors.orange.shade600,
                thickness: 5,
                endIndent: 20,
                indent: 20,
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            iselipsis: true,
                            text: "Name: " "${productbyId.title.toString()}",
                          ),
                          CustomText(
                            text: "Type: "
                                "${productbyId.productCategoryName.toString()}",
                          ),
                          Row(
                            children: [
                              CustomText(
                                text: "Price: "
                                    r"$"
                                    "${currentPrice.toString()} ",
                              ),
                              CustomText(
                                text: productbyId.isPiece ? " /Peice" : " /Kg",
                                color: Colors.grey.shade700,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                text: "Total price: ",
                              ),
                              CustomText(
                                iselipsis: true,
                                text: r"$" "${totalPrice.toStringAsFixed(2)} ",
                              ),
                            ],
                          ),
                        ]),
                    Row(
                      children: [
                        CustomText(
                          text: "Amount: ",
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.minus),
                          onPressed: () {
                            cartProvider.reduceQuantityBy1(
                                productId: productbyId.id);
                          },
                        ),
                        CustomText(
                          text: "${cartmodel.quantity.toString()}",
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.plus),
                          onPressed: () {
                            cartProvider.increaseQuantityBy1(
                                productId: productbyId.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ]),
            Container(
              decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        isinWishlist ? IconlyBold.heart : IconlyLight.heart,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        if (isinWishlist == true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 600),
                            content: CustomText(
                              text: "Already in wishlist",
                              color: Colors.white,
                            ),
                          ));
                        } else {
                          wishProvider.add_Item_to_WishList(
                              productID: productbyId.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 600),
                            content: CustomText(
                              text: "Added to wishlist Successfully",
                              color: Colors.white,
                            ),
                          ));
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(IconlyLight.delete),
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Clear cart!',
                          desc: 'Do you wante to clear cart!',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            cartProvider.removeOneCart(
                                productId: productbyId.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 600),
                              content: CustomText(
                                text: " Cart cleared successfully",
                                color: Colors.white,
                              ),
                            ));
                          },
                        )..show();
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
