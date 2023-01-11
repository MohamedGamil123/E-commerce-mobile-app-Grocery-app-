import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/OrdersProvider.dart';
import 'package:provider/provider.dart';

import '../../Widgets/order_widget.dart';

class Order_full extends StatelessWidget {
  const Order_full({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context);
    final ordersList =
        orderProvider.getOrdersList.values.toList().reversed.toList();
    var setsize = Utils(context).getsize();
    return Scaffold(
      body: SizedBox(
        height: setsize.height,
        width: double.infinity,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ordersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChangeNotifierProvider.value(
                        value: ordersList[index], child: Order_Widget());
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
