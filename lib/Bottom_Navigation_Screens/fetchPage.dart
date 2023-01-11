import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/CustomShimmer.dart';
import 'package:provider/provider.dart';

import '../Providers/OrdersProvider.dart';

class fetchPage extends StatefulWidget {
  static String fetch = "fetch";
  const fetchPage({super.key});

  @override
  State<fetchPage> createState() => _fetchPageState();
}

class _fetchPageState extends State<fetchPage> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      final CartProvider cartprovider =
          Provider.of<CartProvider>(context, listen: false);
      Wishlist_provider wishProvider =
          Provider.of<Wishlist_provider>(context, listen: false);
      OrdersProvider orderProvider =
          Provider.of<OrdersProvider>(context, listen: false);

      final User? user = authinstance.currentUser;
      print(user == null);
      try {
        if (user != null) {
          print(".........................");
          await Provider.of<ProductProvider>(context, listen: false)
              .fetchProductsFromFS();

          await cartprovider.getCartFromFS();
          await wishProvider.getWichListFromFS();
          await orderProvider.fetchOrdersFromFS();
          print(orderProvider.getOrdersList.length);
          print(".........................");
        } else {
          await Provider.of<ProductProvider>(context, listen: false)
              .fetchProductsFromFS();
          cartprovider.clearLocalCArts();
          wishProvider.clearLocalWishs();
        }
      } catch (e) {
        print("$e");
      }

      Navigator.of(context)
          .pushReplacementNamed(UseBottomNavigationBarr_page.bottomnavigation);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    Locale myLocale = Localizations.localeOf(context);
    print('my locale ${myLocale.languageCode}');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: setsize.height * 0.02),
                      CustomShimmer.rectangular(
                        height: setsize.height * 0.03,
                        width: setsize.width * 0.56,
                      ),
                      SizedBox(height: setsize.height * 0.02),
                      CustomShimmer.rectangular(
                          height: setsize.height * 0.012,
                          width: setsize.width * 0.35),
                    ]),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: setsize.height * 0.27,
                child: Swiper(
                  duration: 3500,
                  autoplay: true,
                  curve: Curves.easeInOutCubicEmphasized,
                  autoplayDelay: 5000,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.all(10),
                        child: CustomShimmer.circular(
                            width: setsize.width * 0.65,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))));
                  },
                  itemCount: 5,
                  viewportFraction: 0.8,
                  scale: 0.9,
                ),
              ),
              SizedBox(
                height: setsize.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      CustomShimmer.rectangular(
                        height: setsize.height * 0.031,
                        width: setsize.width * 0.35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomShimmer.circular(
                          height: setsize.height * 0.031,
                          width: setsize.width * 0.1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)))
                    ]),
                    CustomShimmer.rectangular(
                        height: setsize.height * 0.02,
                        width: setsize.width * 0.23),
                  ],
                ),
              ),
              SizedBox(
                height: setsize.height * 0.04,
              ),
              SizedBox(
                height: setsize.height * 0.265,
                width: setsize.width,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.all(10),
                        child: CustomShimmer.circular(
                            width: setsize.width * 0.65,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      CustomShimmer.rectangular(
                        height: setsize.height * 0.031,
                        width: setsize.width * 0.42,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ]),
                    CustomShimmer.rectangular(
                      height: setsize.height * 0.02,
                      width: setsize.width * 0.23,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: setsize.height * 0.04,
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 280,
                    mainAxisSpacing: 10),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.all(10),
                      child: CustomShimmer.circular(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
