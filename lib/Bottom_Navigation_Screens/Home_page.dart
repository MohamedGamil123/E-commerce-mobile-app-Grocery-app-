import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Swipimages.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Inner_Screens/AllProducts_Screen.dart';
import 'package:grocery_app/Inner_Screens/Onsale_Screen.dart';
import 'package:grocery_app/Models/Product_Model.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Widgets/Onsale_cart.dart';
import 'package:grocery_app/Widgets/proWid.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  static String home = "home";
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    // all product //
    //instance of product provider
    final productprovider = Provider.of<ProductProvider>(context);
    // return is a list take it in instance of list of product model
    List<ProductModel> allProducts = productprovider.getAllProductList;
    // on sale //
    //instance of onSale provider

    // return is a list take it in instance of list of product model
    List<ProductModel> onsaleproduct = productprovider.getOnsaleProducts;
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
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "My Grocery ".tr(context),
                        istitle: true,
                        color: Colors.green.shade800,
                        titletextsize: 33,
                      ),
                      CustomText(
                        text: "Premium Quality Products ".tr(context),
                        textsize: 13,
                        color: Colors.grey.shade800,
                      ),
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
                  pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                          color: Colors.white60,
                          activeColor: Colors.orange.shade800,
                          size: 15.0,
                          activeSize: 18.0)),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                SwipImages.home_swipimage[index],
                              ))),
                    );
                  },
                  itemCount: SwipImages.home_swipimage.length,
                  viewportFraction: 0.8,
                  scale: 0.8,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      CustomText(
                        text: "ON SALE".tr(context),
                        istitle: true,
                        color: Colors.orange.shade800,
                        titletextsize: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        IconlyBold.discount,
                        color: Colors.orange.shade800,
                      )
                    ]),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Onsale_Screen.onsalSc);
                      },
                      child: CustomText(
                        textsize: 15,
                        text: "See all ...".tr(context),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: setsize.height * 0.265,
                width: setsize.width,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      onsaleproduct.length <= 7 ? onsaleproduct.length : 7,
                  itemBuilder: (BuildContext context, int index) {
                    return ChangeNotifierProvider.value(
                        value: onsaleproduct[index], child: OnSaleCart());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      CustomText(
                        text: "Our Products".tr(context),
                        istitle: true,
                        color: Colors.black,
                        titletextsize: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ]),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Allproducts_Screen.AllproSc);
                      },
                      child: CustomText(
                        text: "See all ...".tr(context),
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 280,
                    mainAxisSpacing: 10),
                itemCount: allProducts.length < 10 ? allProducts.length : 10,
                itemBuilder: (BuildContext context, int index) {
                  return ChangeNotifierProvider.value(
                      value: allProducts[index], child: ProWid());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
