import 'package:flutter/material.dart';
import 'package:grocery_app/Widgets/customText.dart';

class CustomButton extends StatelessWidget {
  Function ontap;
  String text;
  CustomButton({required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(15)),
        child: CustomText(
          text: text,
        ),
      ),
    );
  }
}
