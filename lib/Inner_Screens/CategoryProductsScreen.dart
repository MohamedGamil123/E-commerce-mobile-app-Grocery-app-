import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Inner_Screens/empty_products_dcreens.dart';
import 'package:grocery_app/Models/Product_Model.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/Widgets/proWid.dart';
import 'package:provider/provider.dart';

class CategoryProducts extends StatelessWidget {
  static const catPro = "catPro";
  const CategoryProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allproductProvider = Provider.of<ProductProvider>(context);
    final String categoryname =
        ModalRoute.of(context)!.settings.arguments as String;
    final List<ProductModel> catproducts =
        allproductProvider.getproductByCategory(categoryname);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              IconlyLight.arrowLeft2,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        title: CustomText(
          text: categoryname,
          istitle: true,
          color: Colors.black,
        ),
      ),
      body: catproducts.isEmpty
          ? Empty_products()
          : ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green.shade600),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            label: Text(
                              "Search products ...",
                              style: TextStyle(color: Colors.black),
                            ),
                            prefixIcon: Icon(IconlyLight.search),
                            prefixIconColor: Colors.green.shade600,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(15),
                                gapPadding: 15),
                            hintText: "What's in your mind..."),
                      ),
                    ),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 250,
                              mainAxisSpacing: 10),
                      itemCount: catproducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider.value(
                            value: catproducts[index], child: ProWid());
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
