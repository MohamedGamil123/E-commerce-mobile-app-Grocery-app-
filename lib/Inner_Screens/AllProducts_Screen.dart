import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Models/Product_Model.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';

import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Widgets/proWid.dart';
import 'package:grocery_app/componants/AppLocals.dart';

import 'package:provider/provider.dart';

class Allproducts_Screen extends StatefulWidget {
  static const AllproSc = "AllproSc";
  const Allproducts_Screen({Key? key}) : super(key: key);

  @override
  State<Allproducts_Screen> createState() => _Allproducts_ScreenState();
}

class _Allproducts_ScreenState extends State<Allproducts_Screen> {
  TextEditingController textSearchController = TextEditingController();
  FocusNode textSearchfocusnode = FocusNode();

  List<ProductModel> productSearch = [];
  @override
  void dispose() {
    textSearchController.dispose();
    textSearchfocusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allproductProvider = Provider.of<ProductProvider>(context);
    final List<ProductModel> allProducts = allproductProvider.getAllProductList;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              IconlyLight.arrowLeft2,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        title: CustomText(
          text: "All products".tr(context),
          istitle: true,
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textSearchController,
                  focusNode: textSearchfocusnode,
                  onChanged: (val) {
                    final List<ProductModel> getSearch =
                        allproductProvider.getProductBySearch(val);
                    setState(() {
                      productSearch = getSearch;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade600),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      label: Text(
                        "Search products ...".tr(context),
                        style: TextStyle(
                            color: Colors.black, fontFamily: "Tajawal"),
                      ),
                      prefixIcon: const Icon(IconlyLight.search),
                      prefixIconColor: Colors.green.shade600,
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                          gapPadding: 15),
                      hintText: "What's in your mind...".tr(context),
                      hintStyle: const TextStyle(fontFamily: "Tajawal")),
                ),
              ),
              textSearchController.text.isEmpty
                  ? GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 270,
                              mainAxisSpacing: 10),
                      itemCount: allProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider.value(
                            value: allProducts[index], child: ProWid());
                      },
                    )
                  : productSearch.isNotEmpty
                      ? GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 270,
                                  mainAxisSpacing: 10),
                          itemCount: productSearch.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChangeNotifierProvider.value(
                                value: productSearch[index], child: ProWid());
                          },
                        )
                      : Center(
                          child: CustomText(
                              text: "Product not found".tr(context))),
            ],
          ),
        ],
      ),
    );
  }
}
