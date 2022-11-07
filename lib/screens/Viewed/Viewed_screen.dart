import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Widgets/Alertdialoge.dart';
import 'package:grocery_app/Widgets/Cart_widget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/screens/Viewed/Viewed_empty.dart';
import 'package:grocery_app/screens/Viewed/Viewed_full.dart';
import 'package:provider/provider.dart';

class Viewed_Screen extends StatefulWidget {
  static final viewedid = "viewedid";
  const Viewed_Screen({Key? key}) : super(key: key);

  @override
  State<Viewed_Screen> createState() => _Viewed_ScreenState();
}

class _Viewed_ScreenState extends State<Viewed_Screen> {
  bool Viewed_Screen_empty = false;
  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewdProvider>(context);
    final viewedList =
        viewedProvider.getviewedItems.values.toList().reversed.toList();
    var setsize = Utils(context).getsize();
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                IconlyLight.arrowLeft2,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          title: CustomText(
            text: "My History ",
            istitle: true,
          ),
          actions: [
            viewedList.isEmpty
                ? SizedBox(
                    width: 1,
                  )
                : IconButton(
                    color: Colors.black,
                    icon: Icon(IconlyLight.delete),
                    onPressed: () {
                      customAlertDialoge(
                        context,
                        title: "Clear History!",
                        content: CustomText(
                          text: "Your item will be cleared from history!",
                        ),
                      );
                    },
                  )
          ],
        ),
        body: viewedList.isEmpty ? Viewed_empty() : Viewed_full());
  }
}
