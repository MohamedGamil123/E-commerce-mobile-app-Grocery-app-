import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';

class Empty_cart extends StatelessWidget {
  const Empty_cart({Key? key}) : super(key: key);

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
                child: Container(
                  child: Image.asset(
                    "assets/images/empty_page/Online Groceries-cuate.png",
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
                flex: 3,
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: CustomText(
                      text:
                          "your cart is empty, add something and make me happy :) "
                              .tr(context),
                    )),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        UseBottomNavigationBarr_page.bottomnavigation);
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: CustomText(text: "Shop now".tr(context)),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          UseBottomNavigationBarr_page.bottomnavigation);
                    },
                  ),
                ),
              ),
              Expanded(child: Container())
            ],
          )),
    );
  }
}
