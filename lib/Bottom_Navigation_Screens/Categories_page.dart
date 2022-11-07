import 'package:flutter/material.dart';
import 'package:grocery_app/Inner_Screens/CategoryProductsScreen.dart';
import 'package:grocery_app/Widgets/CategoryCart.dart';
import 'package:grocery_app/Widgets/customText.dart';

class Categories_page extends StatefulWidget {
  Categories_page({Key? key}) : super(key: key);

  @override
  State<Categories_page> createState() => _Categories_pageState();
}

class _Categories_pageState extends State<Categories_page> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 40, left: 15, right: 15),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Categories",
                  color: Colors.green.shade800,
                  istitle: true,
                ),
                CustomText(
                  text: "Choose which category you love",
                 textsize: 12,
                  color: Colors.grey.shade700,
                ),
                SizedBox(height: 20,),
                CustomCard(
                
                  title: "Fruits",
                  image: "assets/images/cat/fruits.png",
                  color: Colors.red.shade100,
                ),
                CustomCard(
                
                  title: "Vegetables",
                  image: "assets/images/cat/veg.png",
                  color: Colors.green.shade100,
                ),
                CustomCard(
                
                  title: "Herbs",
                  image: "assets/images/cat/Spinach.png",
                  color: Colors.blue.shade100,
                ),
                CustomCard(
                 
                  title: "Nuts",
                  image: "assets/images/cat/nuts.png",
                  color: Colors.brown.shade100,
                ),
                CustomCard(
               
                  title: "Spices",
                  image: "assets/images/cat/spices.png",
                  color: Colors.orange.shade100,
                ),
                CustomCard(
                 
                  title: "Grains",
                  image: "assets/images/cat/grains.png",
                  color: Colors.yellow.shade100,
                ),
              ],
            ),
          )),
    );
  }
}
