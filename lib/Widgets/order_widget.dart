import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Models/Product_Model.dart';
import 'package:grocery_app/Widgets/Alertdialoge.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';
import 'package:grocery_app/Widgets/custom_button.dart';
import 'package:provider/provider.dart';

class Order_Widget extends StatelessWidget {
  Order_Widget();
final User? user = authinstance.currentUser;
  @override
  Widget build(BuildContext context) {
   
    var setsize = Utils(context).getsize();
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Product_details.produtdetails,);
      },
      child: Container(
        padding: EdgeInsets.only(top: 15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
                          icon: Icon(IconlyLight.delete),
                          onPressed: () {
                            customAlertDialoge(
                              context,
                              title: "Clear Order!",
                              content: CustomText(
                                text: "Your item will be cleared from Orders!",
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "fresh fruits  " "X1",
                              istitle: true,
                              titletextsize: 20,
                              color: Colors.grey.shade800,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CustomText(
                                text: "20/9/2022",
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(children: [
                                CustomText(
                                  text: "Paid: ",
                                  color: Colors.grey.shade700,
                                ),
                                CustomText(
                                  text: r"$" "${40}",
                                  color: Colors.green.shade500,
                                  istitle: true,
                                  titletextsize: 18,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                CustomText(
                                  text: r"$" "${80}",
                                  lineThrough: true,
                                  color: Colors.grey.shade700,
                                )
                              ]),
                            ),
                            CustomButton(ontap: () {}, text: "Reorder again")
                          ],
                        )
                      ]),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: -40,
              child: Image.asset(
                "assets/images/cat/fruits.png",
                height: setsize.height * 0.14,
                width: setsize.height * 0.14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
