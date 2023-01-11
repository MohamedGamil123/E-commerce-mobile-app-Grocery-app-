import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/Widgets/customText.dart';

class Empty_products extends StatelessWidget {
  const Empty_products({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  "assets/images/box.png",
                ),
              ),
              CustomText(
                text: "Sorry!",
                color: Colors.red,
                istitle: true,
                titletextsize: 40,
              ),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: CustomText(
                    text: "No products added yet!,\nStay tuned ",
                  )),
              SizedBox(
                height: setsize.height * 0.05,
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
                      text: "Continue shopping",
                      istitle: true,
                    )),
              )
            ],
          )),
    );
  }
}
