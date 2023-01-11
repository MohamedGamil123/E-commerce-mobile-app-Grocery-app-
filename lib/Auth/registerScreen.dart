import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Auth/LoginScreen.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/fetchPage.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Swipimages.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Widgets/CustomAuthButton.dart';
import 'package:grocery_app/Widgets/LoadingWidget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';

class RegistreScreen extends StatefulWidget {
  static const String regid = "regid";
  const RegistreScreen({super.key});

  @override
  State<RegistreScreen> createState() => _RegistreScreenState();
}

class _RegistreScreenState extends State<RegistreScreen> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController shipAdrController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();
  final shipAdrFocusNode = FocusNode();
  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    shipAdrController.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
    shipAdrFocusNode.dispose();
    super.dispose();
  }

  bool isLoading = false;
  void submitFormOnSignup() async {
    if (formstate.currentState!.validate()) {
      formstate.currentState!.save();
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });
      try {
        User? user = authinstance.currentUser;
        await authinstance.createUserWithEmailAndPassword(
            email: emailController.text.toLowerCase().trim(),
            password: passwordController.text.toLowerCase().trim());
        user!.updateDisplayName(fullNameController.text.toString());
        user.reload();
        print("register sucsess......");

        print(authinstance.currentUser!.uid);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authinstance.currentUser!.uid)
            .set({
          "uid": authinstance.currentUser!.uid,
          "name": fullNameController.text.toString(),
          "email": emailController.text.toString(),
          "shipping_address": shipAdrController.text.toString(),
          "userWish": [],
          "userCart": [],
          "createdAt": Timestamp.now()
        });
        print("firestor data sucsess......");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 5000),
          content: Row(
            children: [
              CustomText(
                text: "Welcome ".tr(context),
                color: Colors.white,
              ),
              CustomText(
                text: " ${fullNameController.text.toString()} ",
                color: Colors.orange,
                iselipsis: true,
              ),
            ],
          ),
        ));
        Navigator.of(context).pushReplacementNamed(fetchPage.fetch);

        print("sucsess......");
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          AwesomeDialog(
            titleTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
            descTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.normal),
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'weak-password!'.tr(context),
            desc: 'Please enter strong password'.tr(context),
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
            titleTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
            descTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.normal),
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'email already in use!'.tr(context),
            desc: 'Please enter another valid email'.tr(context),
            btnOkOnPress: () {},
          ).show();
        } else {
          AwesomeDialog(
            titleTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
            descTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.normal),
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'there where an error!'.tr(context),
            desc: '$e',
            btnOkOnPress: () {},
          ).show();
        }
        print(e);
      } catch (e) {
        AwesomeDialog(
          titleTextStyle:
              TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
          descTextStyle:
              TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.normal),
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'there where an error!'.tr(context),
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

  bool obscure_text = true;
  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return Scaffold(
      body: LoadingScreen(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: SizedBox(
            height: setsize.height,
            width: setsize.width,
            child: Stack(children: [
              Swiper(
                duration: 1000,
                autoplay: true,
                curve: Curves.easeInSine,
                autoplayDelay: 5000,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              SwipImages.Auth_Swipimage[index],
                            ))),
                  );
                },
                itemCount: SwipImages.Auth_Swipimage.length,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.black.withOpacity(0.7),
                child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 1),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            IconlyLight.arrowLeft2,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomText(
                        text: "Welcome ".tr(context),
                        istitle: true,
                        color: Colors.white,
                        titletextsize: 35,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomText(
                        text: "Sign up to continue".tr(context),
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Form(
                        key: formstate,
                        child: Column(children: [
                          //Full name
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: fullNameController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return "Please enter a strong name".tr(context);
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(emailFocusNode),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green.shade600),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                label: Text(
                                  "Full name".tr(context),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Tajawal"),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Full name...".tr(context),
                                hintStyle:
                                    const TextStyle(fontFamily: "Tajawal")),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //Email
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            focusNode: emailFocusNode,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !value.contains("@") ||
                                  !value.contains(".com")) {
                                return "Please enter a valid email address "
                                    .tr(context);
                              } else {
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(passFocusNode),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green.shade600),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                label: Text(
                                  "Email".tr(context),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Tajawal"),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Email...".tr(context),
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Tajawal")),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //password
                          TextFormField(
                            obscureText: obscure_text,
                            keyboardType: TextInputType.visiblePassword,
                            focusNode: passFocusNode,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return "Please enter a strong password"
                                    .tr(context);
                              } else if (value.length > 6) {
                                return "Too long password".tr(context);
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(shipAdrFocusNode);
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        obscure_text = !obscure_text;
                                      });
                                    },
                                    child: Icon(
                                      obscure_text
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green.shade600),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                label: Text(
                                  "Password".tr(context),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Tajawal"),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Password...".tr(context),
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Tajawal")),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //Shipping address
                          TextFormField(
                            focusNode: shipAdrFocusNode,
                            textInputAction: TextInputAction.done,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              submitFormOnSignup();
                            },
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return "Please enter a strong address"
                                    .tr(context);
                              }
                              return null;
                            },
                            controller: shipAdrController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green.shade600),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                label: Text(
                                  "Shipping address".tr(context),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Tajawal"),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Shipping address...".tr(context),
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Tajawal")),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomAuthButton(
                        ontap: () {
                          submitFormOnSignup();
                        },
                        widget: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomText(text: "Sign up".tr(context)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "Already a user?".tr(context),
                            color: Colors.white,
                          ),
                          TextButton(
                            child: CustomText(
                              text: "Sign in".tr(context),
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(LoginScreen.logid);
                            },
                          )
                        ],
                      ),
                      const Spacer(flex: 1),
                    ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
