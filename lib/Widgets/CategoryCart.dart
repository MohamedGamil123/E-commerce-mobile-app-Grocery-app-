import 'package:flutter/material.dart';
import 'package:grocery_app/Inner_Screens/CategoryProductsScreen.dart';
import 'package:grocery_app/Widgets/customText.dart';

class CustomCard extends StatelessWidget {
  String title;
  String image;
  Color? color;

  CustomCard({
    required this.title,
    required this.image,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CategoryProducts.catPro, arguments: title);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            width: double.infinity,
            height: 150,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: color,
              elevation: 10,
              shadowColor: Colors.grey.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        istitle: true,
                        titletextsize: 20,
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ]),
              ),
            ),
          ),
          Positioned(
            left: 40,
            top: -30,
            child: Image.asset(
              image,
              height: 150,
              width: 150,
            ),
          )
        ],
      ),
    );
  }
}
