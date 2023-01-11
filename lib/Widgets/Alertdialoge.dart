import 'package:flutter/material.dart';

Future<void> customAlertDialoge(BuildContext context,
    {required String title, required content, List<Widget>? actions}) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(title),
          content: content,
          actions: actions,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
        );
      });
}
