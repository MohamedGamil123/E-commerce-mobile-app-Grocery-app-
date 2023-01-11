import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/Cart/Cart_page.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/Categories_page.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/Home_page.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/User_page.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:provider/provider.dart';

class UseBottomNavigationBarr_page extends StatefulWidget {
  static String bottomnavigation = "bottomnavigation";
  const UseBottomNavigationBarr_page({Key? key}) : super(key: key);

  @override
  State<UseBottomNavigationBarr_page> createState() =>
      _UseBottomNavigationBarr_pageState();
}

class _UseBottomNavigationBarr_pageState
    extends State<UseBottomNavigationBarr_page> {
  List<Map<String, dynamic>> pages = [
    {"page": const Homepage(), "tittle": "Homepage"},
    {"page": const Categories_page(), "tittle": "Categories"},
    {"page": const Cart_page(), "tittle": "Cart"},
    {"page": const User_page(), "tittle": "Account"}
  ];
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    final cartprovider = Provider.of<CartProvider>(context);
    final cartList =
        cartprovider.getcartItems.values.toList().reversed.toList();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black12,
        selectedItemColor: Colors.green,
        currentIndex: selectedindex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(selectedindex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home".tr(context),
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedindex == 1
                ? IconlyBold.category
                : IconlyLight.category),
            label: "Category".tr(context),
          ),
          BottomNavigationBarItem(
            icon: Badge(
                toAnimate: true,
                animationDuration: const Duration(seconds: 1),
                animationType: BadgeAnimationType.slide,
                padding: const EdgeInsets.all(6),
                gradient:
                    const LinearGradient(colors: [Colors.yellow, Colors.red]),
                badgeContent: FittedBox(
                  child: Text(
                    '${cartList.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                position: BadgePosition.topEnd(top: -12, end: -15),
                child: Icon(
                    selectedindex == 2 ? IconlyBold.buy : IconlyLight.buy)),
            label: "Cart".tr(context),
          ),
          BottomNavigationBarItem(
            icon:
                Icon(selectedindex == 3 ? IconlyBold.user2 : IconlyLight.user2),
            label: "Account".tr(context),
          ),
        ],
        onTap: (value) {
          setState(() {
            selectedindex = value;
          });
        },
      ),
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          pages[selectedindex]["tittle"],
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),*/
      body: pages[selectedindex]["page"],
    );
  }
}
