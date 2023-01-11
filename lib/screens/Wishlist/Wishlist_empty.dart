import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';

class Wishlist_empty extends StatelessWidget {
  const Wishlist_empty({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return Scaffold(
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 15,
                child: SizedBox(
                  height: setsize.height * 0.5,
                  child: Image.asset(
                    "assets/images/empty_page/Ecommerce campaign-rafiki.png",
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  text: "Whoops!".tr(context),
                  color: Colors.red,
                  istitle: true,
                  titletextsize: 40,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                      "your Wishlist is empty, Explore more and shortlist some items :) "
                          .tr(context)),
                ),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: CustomText(text: "Add a wish".tr(context)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        UseBottomNavigationBarr_page.bottomnavigation);
                  },
                ),
              ),
              Expanded(
                child: Container(),
              )
            ],
          )),
    );
  }
}
