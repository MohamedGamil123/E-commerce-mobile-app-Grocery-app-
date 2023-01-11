import 'package:flutter/material.dart';
import 'package:grocery_app/Widgets/customText.dart';

class OnBoardingContent extends StatelessWidget {
  String tittle, description, image;
  OnBoardingContent({
    required this.tittle,
    required this.description,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Spacer(),
      Image.asset(image),
      Spacer(),
      CustomText(
        text: tittle,
        istitle: true,
      ),
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(
          text: description,
        ),
      ),
      Spacer(),
    ]);
  }
}
