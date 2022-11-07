import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/Alertdialoge.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/screens/Wishlist/Wishlist_empty.dart';
import 'package:grocery_app/screens/Wishlist/Wishlist_full.dart';
import 'package:provider/provider.dart';

class Wishlist extends StatefulWidget {
  static final wishid = "wishid";
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
 
  @override
  Widget build(BuildContext context) {
    final wishProvider = Provider.of<Wishlist_provider>(context);
   final list_of_Wishlist= wishProvider.getWishListitems.values.toList();
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
          title: CustomText(
            text: " My Wishlist",
            istitle: true,
          ),
          actions: [
            list_of_Wishlist.isEmpty
                ? SizedBox(
                    width: 1,
                  )
                : IconButton(
                    color: Colors.black,
                    icon: Icon(IconlyLight.delete),
                    onPressed: () {
                        AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Clear all wish items!',
                        desc: 'Do you wante to clear all wish items!',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          wishProvider.clearAllWishs();
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 600),
                          content: CustomText(
                              text: "All wish items cleared successfully",
                              color: Colors.white,
                              ),
                        ));
                        },
                      )..show();
                    },
                  )
          ],
        ),
        body: list_of_Wishlist.isEmpty ? const Wishlist_empty() : const wishlist_full());
  }
}
