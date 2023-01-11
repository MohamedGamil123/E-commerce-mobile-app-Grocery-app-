import 'package:flutter/material.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Widgets/viewed_Widget.dart';
import 'package:provider/provider.dart';

class Viewed_full extends StatelessWidget {
  const Viewed_full({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewdProvider>(context);
    final viewedList =
        viewedProvider.getviewedItems.values.toList().reversed.toList();
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
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 275,
                      mainAxisSpacing: 10),
                  itemCount: viewedList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChangeNotifierProvider.value(
                        value: viewedList[index], child: Viewed_Widget());
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
