import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  double height;
  double width;
  ShapeBorder shape;
  CustomShimmer.rectangular({this.height = 10, this.width = 20})
      : shape = const RoundedRectangleBorder();
  CustomShimmer.circular(
      {this.height = 10, this.width = 20, this.shape = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(color: Colors.grey[400], shape: shape),
      ),
    );
  }
}
