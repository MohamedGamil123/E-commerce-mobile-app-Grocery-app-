import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/Auth/ForgetpassScreen.dart';
import 'package:grocery_app/Auth/LoginScreen.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Widgets/Alertdialoge.dart';
import 'package:grocery_app/Widgets/ListTile.dart';
import 'package:grocery_app/Widgets/LoadingWidget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:grocery_app/screens/Orders/Orders_Screen.dart';
import 'package:grocery_app/screens/Viewed/Viewed_screen.dart';
import 'package:grocery_app/screens/Wishlist/Wishlist.dart';
import 'package:provider/provider.dart';

class User_page extends StatefulWidget {
  const User_page({Key? key}) : super(key: key);

  @override
  State<User_page> createState() => _User_pageState();
}

class _User_pageState extends State<User_page> {
  @override
  void initState() {
    getdatefromFirestore();
    super.initState();
  }

  TextEditingController address_controller = TextEditingController(text: "");
  final User? user = authinstance.currentUser;
  String? _name;
  String? _email;
  String? _shippingAdrress;
  bool isLoading = false;

  getdatefromFirestore() async {
    if (authinstance.currentUser != null) {
      try {
        setState(() {
          isLoading = true;
        });
        final DocumentSnapshot<Map<String, dynamic>> userdoc =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(authinstance.currentUser!.uid)
                .get();
        _name = userdoc.get("name");
        _email = userdoc.get("email");
        _shippingAdrress = userdoc.get("shipping_address");
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'there where an error!',
          desc: '$e',
          btnOkOnPress: () {},
        ).show();
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  updatAddress() async {
    if (address_controller.text.isNotEmpty) {
      try {
        Navigator.of(context).pop();
        setState(() {
          isLoading = true;
        });
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authinstance.currentUser!.uid)
            .update({"shipping_address": address_controller.text});

        setState(() {
          _shippingAdrress = address_controller.text;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 2000),
          content: CustomText(
            text: "Address updated successfully",
            color: Colors.white,
          ),
        ));
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'there where an error!',
          desc: '$e',
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        content: CustomText(
          text: "Please enter your address",
          color: Colors.white,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartrpovider = Provider.of<CartProvider>(context);
    final wishprovider = Provider.of<Wishlist_provider>(context);
    return Scaffold(
      body: LoadingScreen(
        isLoading: isLoading,
        child: ListView(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: " Hi, ".tr(context),
                            istitle: true,
                            color: Colors.cyan,
                          ),
                          CustomText(
                            text: "$_name",
                            istitle: true,
                            color: Colors.cyan,
                          ),
                        ],
                      ),
                      CustomText(
                        text: "$_email",
                      ),
                    ]),
              ),
              const Divider(
                color: Colors.black,
              ),
              customlisttile(
                  title: "Your address".tr(context),
                  subtitle: _shippingAdrress,
                  leadingicon: IconlyLight.location,
                  ontap: () async {
                    await customAlertDialoge(context,
                        title: "Updat Address".tr(context),
                        content: TextField(
                          decoration: InputDecoration(
                              hintText: "Your address".tr(context)),
                          controller: address_controller,
                          onSubmitted: (value) {
                            setState(() {
                              address_controller.text = value;
                              FocusScope.of(context).unfocus();
                              updatAddress();
                            });

                            print(address_controller.text);
                          },
                        ),
                        actions: [
                          TextButton(
                            child: Text("Cancel".tr(context)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Updat".tr(context)),
                            onPressed: () async {
                              updatAddress();
                            },
                          )
                        ]);
                  }),
              customlisttile(
                  title: "Orders".tr(context),
                  leadingicon: IconlyLight.buy,
                  ontap: () {
                    Navigator.of(context).pushNamed(Orders_Screen.orderid);
                  }),
              customlisttile(
                  title: "Wishlist".tr(context),
                  leadingicon: IconlyLight.heart,
                  ontap: () {
                    Navigator.of(context).pushNamed(Wishlist.wishid);
                  }),
              customlisttile(
                  title: "Viewed".tr(context),
                  leadingicon: IconlyLight.show,
                  ontap: () {
                    Navigator.of(context).pushNamed(Viewed_Screen.viewedid);
                  }),
              customlisttile(
                  title: "Forget Password".tr(context),
                  leadingicon: IconlyLight.lock,
                  ontap: () {
                    Navigator.of(context).pushNamed(ForgetPassScreen.forgetid);
                  }),
              customlisttile(
                  title: "Dark mode".tr(context),
                  leadingicon: FontAwesomeIcons.lightbulb,
                  ontap: () {}),
              user != null
                  ? customlisttile(
                      title: "Logout".tr(context),
                      leadingicon: IconlyLight.logout,
                      ontap: () async {
                        AwesomeDialog(
                          titleTextStyle: TextStyle(
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold),
                          descTextStyle: TextStyle(
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.normal),
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: "Sign out".tr(context),
                          desc: "Do you wante to sign out !".tr(context),
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            authinstance.signOut();
                            cartrpovider.clearLocalCArts();
                            wishprovider.clearLocalWishs();
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.logid);
                          },
                        ).show();
                      })
                  : customlisttile(
                      title: "Sign in".tr(context),
                      leadingicon: IconlyLight.login,
                      ontap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.logid);
                      })
            ]),
          ],
        ),
      ),
    );
  }
}
