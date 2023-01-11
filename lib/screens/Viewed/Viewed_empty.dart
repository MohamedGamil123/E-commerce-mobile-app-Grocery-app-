import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';

class Viewed_empty extends StatelessWidget {
  const Viewed_empty({Key? key}) : super(key: key);

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset(
                  "assets/images/history.png",
                ),
              ),
              CustomText(
                text: "Whoops!".tr(context),
                color: Colors.red,
                istitle: true,
                titletextsize: 40,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                    "your history is empty, No products has been viewed yet! :) "
                        .tr(context)),
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
                    padding: const EdgeInsets.all(20),
                    child: CustomText(
                      text: "Shop now".tr(context),
                      istitle: true,
                    )),
              )
            ],
          )),
    );
  }
}
