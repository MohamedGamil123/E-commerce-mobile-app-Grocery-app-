import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Widgets/customText.dart';

class CustomAuthButton extends StatelessWidget {
  Function ontap;
  Widget widget;
  CustomAuthButton({required this.ontap,required this.widget});

  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: setsize.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.withOpacity(0.4)),
        child: Center(
            child: widget),
      ),
    );
  }
}
