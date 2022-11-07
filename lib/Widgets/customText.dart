import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  double textsize;
  double titletextsize;
  bool istitle;
  int maxlines;
  bool lineThrough;
  bool iselipsis;
  CustomText(
      {required this.text,
      this.iselipsis=false,
      this.color = Colors.black,
      this.textsize = 16,
      this.istitle = false,
      this.maxlines = 10,
      this.titletextsize = 23,
      this.lineThrough = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          overflow: iselipsis? TextOverflow.ellipsis:null,
          decoration: lineThrough ? TextDecoration.lineThrough : null,
          fontSize: istitle ? titletextsize : textsize,
          color: color,
          fontWeight: istitle ? FontWeight.bold : FontWeight.normal),
    );
  }
}
