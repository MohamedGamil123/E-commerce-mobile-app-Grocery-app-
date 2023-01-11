import 'package:flutter/material.dart';

class dotIndicator extends StatelessWidget {
  bool isActive = false;
  dotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOutCubicEmphasized,
      duration: Duration(milliseconds: 1000),
      height: isActive == true ? 20 : 10,
      width: isActive == true ? 10 : 5,
      decoration: BoxDecoration(
          color: isActive == true ? Colors.orange : Colors.grey.shade500,
          borderRadius: BorderRadius.circular(20)),
    );
  }
}
