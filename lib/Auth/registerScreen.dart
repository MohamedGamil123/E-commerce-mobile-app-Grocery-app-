import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Auth/LoginScreen.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Swipimages.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Widgets/CustomAuthButton.dart';
import 'package:grocery_app/Widgets/LoadingWidget.dart';
import 'package:grocery_app/Widgets/customText.dart';

import '../Bottom_Navigation_Screens/BottomNavigationBar.dart';

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

  final User? user = authinstance.currentUser;
  bool isLoading = false;
  void submitFormOnSignup() async {
    if (formstate.currentState!.validate()) {
      formstate.currentState!.save();
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });
      try {
        await authinstance.createUserWithEmailAndPassword(
            email: emailController.text.toLowerCase().trim(),
            password: passwordController.text.toLowerCase().trim());

        print("register sucsess......");

        print("${authinstance.currentUser!.uid}");
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
          duration: Duration(milliseconds: 2000),
          content: CustomText(
            text: "Welcome ${fullNameController.text.toString()} ",
            color: Colors.white,
          ),
        ));
        Navigator.of(context).pushReplacementNamed(
            UseBottomNavigationBarr_page.bottomnavigation);

        print("sucsess......");
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'weak-password!',
            desc: 'Please enter strong password',
            btnOkOnPress: () {},
          )..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'email already in use!',
            desc: 'Please enter another valid email',
            btnOkOnPress: () {},
          )..show();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'there where an error!',
            desc: '$e',
            btnOkOnPress: () {},
          )..show();
        }
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'there where an error!',
          desc: '$e',
          btnOkOnPress: () {},
        )..show();
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
          child: Container(
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
                        text: "Welcome ",
                        istitle: true,
                        color: Colors.white,
                        titletextsize: 35,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomText(
                        text: "Sign up to continue",
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
                                return "Please enter a strong name";
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
                                label: const Text(
                                  "Full name",
                                  style: TextStyle(color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Full name...",
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //Email
                          TextFormField(
                            focusNode: emailFocusNode,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !value.contains("@") ||
                                  !value.contains(".com")) {
                                return "Please enter a valid email address ";
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
                                label: const Text(
                                  "Email",
                                  style: TextStyle(color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Email...",
                                hintStyle:
                                    const TextStyle(color: Colors.white)),
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
                              if (value!.isEmpty || value.length < 7) {
                                return "Please enter a strong password";
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
                                label: const Text(
                                  "Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Password...",
                                hintStyle:
                                    const TextStyle(color: Colors.white)),
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
                                return "Please enter a strong address";
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
                                label: const Text(
                                  "Shipping address",
                                  style: TextStyle(color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Shipping address...",
                                hintStyle:
                                    const TextStyle(color: Colors.white)),
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
                            : CustomText(text: "Sign up"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "Already a user?",
                            color: Colors.white,
                          ),
                          TextButton(
                            child: CustomText(
                              text: "Sign in",
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
