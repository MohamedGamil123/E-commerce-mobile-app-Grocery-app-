import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({required this.isLoading, required this.child});
  bool isLoading;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                color: Colors.black.withOpacity(0.8),
                child: const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 50.0,
                ),
              )
            : Container()
      ],
    );
  }
}
