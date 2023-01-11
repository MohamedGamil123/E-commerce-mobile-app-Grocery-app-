import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Widgets/customText.dart';

Widget customlisttile({
  required String title,
  String? subtitle,
  IconData? leadingicon,
  required Function ontap,
}) {
  return ListTile(
    onTap: () {
      ontap();
    },
    leading: Icon(leadingicon),
    title: CustomText(
      text: title,
      color: Colors.black,
      titletextsize: 20,
    ),
    subtitle: CustomText(
      text: subtitle ?? "",
    ),
    trailing: const Icon(IconlyLight.arrowRight2),
  );
}
