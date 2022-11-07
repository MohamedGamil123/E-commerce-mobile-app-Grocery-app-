import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_app/Auth/ForgetpassScreen.dart';
import 'package:grocery_app/Auth/LoginScreen.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Widgets/Alertdialoge.dart';
import 'package:grocery_app/Widgets/ListTile.dart';
import 'package:grocery_app/Widgets/LoadingWidget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/screens/Orders/Orders_Screen.dart';
import 'package:grocery_app/screens/Viewed/Viewed_screen.dart';
import 'package:grocery_app/screens/Wishlist/Wishlist.dart';

class User_page extends StatefulWidget {
  User_page({Key? key}) : super(key: key);

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
   if(address_controller.text.isNotEmpty){
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
          duration: Duration(milliseconds: 2000),
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
   }else{
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: CustomText(
            text: "Please enter your address",
            color: Colors.white,
          ),
        ));
   }
  }

  @override
  Widget build(BuildContext context) {
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
                      CustomText(
                        text: " Hi, ${_name}",
                        istitle: true,
                        color: Colors.cyan,
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
                  title: "Your address",
                  subtitle: _shippingAdrress,
                  leadingicon: IconlyLight.location,
                  ontap: () async {
                    await customAlertDialoge(context,
                        title: "Updat Address",
                        content: TextField(
                          
                          decoration:
                              const InputDecoration(hintText: "Your Address"),
                          controller: address_controller,
                          onSubmitted: (value) {
                            setState(() {
                              address_controller.text = value;
                              FocusScope.of(context).unfocus();
                              updatAddress();
                            });

                            print("${address_controller.text}");
                          },
                        ),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("updat"),
                            onPressed: () async {
                              updatAddress();
                            },
                          )
                        ]);
                  }),
              customlisttile(
                  title: "Orders",
                  leadingicon: IconlyLight.buy,
                  ontap: () {
                    Navigator.of(context).pushNamed(Orders_Screen.orderid);
                  }),
              customlisttile(
                  title: "Wishlist",
                  leadingicon: IconlyLight.heart,
                  ontap: () {
                    Navigator.of(context).pushNamed(Wishlist.wishid);
                  }),
              customlisttile(
                  title: "Viewed",
                  leadingicon: IconlyLight.show,
                  ontap: () {
                    Navigator.of(context).pushNamed(Viewed_Screen.viewedid);
                  }),
              customlisttile(
                  title: "Forget Password",
                  leadingicon: IconlyLight.lock,
                  ontap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ForgetPassScreen.forgetid);
                  }),
              customlisttile(
                  title: "Dark mode",
                  leadingicon: FontAwesomeIcons.lightbulb,
                  ontap: () {}),
              user != null
                  ? customlisttile(
                      title: "Logout",
                      leadingicon: IconlyLight.logout,
                      ontap: () async {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: "Sign out",
                          desc: "Do you wante to sign out !",
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            authinstance.signOut();

                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.logid);
                          },
                        ).show();
                      })
                  : customlisttile(
                      title: "Sign in",
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
