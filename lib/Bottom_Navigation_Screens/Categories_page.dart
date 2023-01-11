import 'package:flutter/material.dart';
import 'package:grocery_app/Widgets/CategoryCart.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';

class Categories_page extends StatefulWidget {
  const Categories_page({Key? key}) : super(key: key);

  @override
  State<Categories_page> createState() => _Categories_pageState();
}

class _Categories_pageState extends State<Categories_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Categories".tr(context),
                  color: Colors.green.shade800,
                  istitle: true,
                ),
                CustomText(
                  text: "Choose which category you love".tr(context),
                  textsize: 12,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomCard(
                  title: "الفواكة",
                  image: "assets/images/cat/fruits.png",
                  color: Colors.red.shade100,
                ),
                CustomCard(
                  title: "الخضروات",
                  image: "assets/images/cat/veg.png",
                  color: Colors.green.shade100,
                ),
                CustomCard(
                  title: "الأعشاب",
                  image: "assets/images/cat/Spinach.png",
                  color: Colors.blue.shade100,
                ),
                CustomCard(
                  title: "المكسرات",
                  image: "assets/images/cat/nuts.png",
                  color: Colors.brown.shade100,
                ),
                CustomCard(
                  title: "البهارات والتوبل",
                  image: "assets/images/cat/spices.png",
                  color: Colors.orange.shade100,
                ),
                CustomCard(
                  title: "البقوليات",
                  image: "assets/images/cat/grains.png",
                  color: Colors.yellow.shade100,
                ),
              ],
            ),
          )),
    );
  }
}
