import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/Home_page.dart';

class Empty_cart extends StatelessWidget {
  const Empty_cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Image.asset(
                  "assets/images/cart.png",
                ),
              ),
              CustomText(
                text: "Whoops!",
                color: Colors.red,
                istitle: true,
                titletextsize: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                    "your cart is empty, add something and make me happy :) "),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(UseBottomNavigationBarr_page.bottomnavigation);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(20),
                    child: CustomText(
                      text: "Shop now",
                      istitle: true,
                    )),
              )
            ],
          )),
    );
  }
}
