import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/Wishlist_Widget.dart';
import 'package:provider/provider.dart';



class wishlist_full extends StatelessWidget {
  const wishlist_full({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishProvider = Provider.of<Wishlist_provider>(context);
    final list_of_Wishlist = wishProvider.getWishListitems.values.toList().reversed.toList();
    var setsize = Utils(context).getsize();
    return Scaffold(
      body: Container(
        height: setsize.height,
        width: double.infinity,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list_of_Wishlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChangeNotifierProvider.value(
                        value: list_of_Wishlist[index],
                        child: Wishlist_Widget());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
