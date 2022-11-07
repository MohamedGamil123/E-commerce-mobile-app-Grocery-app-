
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  Size getsize() {
    return MediaQuery.of(context).size;
  }
}


