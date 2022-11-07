import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Widgets/Wishlist_Widget.dart';

import '../../Widgets/order_widget.dart';

class Order_full extends StatelessWidget {
  const Order_full({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      var setsize = Utils(context).getsize();
    return Scaffold
    (


      body:  Container(
          height: setsize.height,
          width: double.infinity,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  ListView.builder(
                    
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Order_Widget();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}