import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/Auth/ForgetpassScreen.dart';
import 'package:grocery_app/Auth/registerScreen.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/fetchPage.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Swipimages.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Widgets/CustomAuthButton.dart';
import 'package:grocery_app/Widgets/LoadingWidget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';

class LoginScreen extends StatefulWidget {
  static const String logid = "loid";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final passFocusNode = FocusNode();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passFocusNode.dispose();
    super.dispose();
  }

  final User? user = authinstance.currentUser;
  bool isLoading = false;
  void submitFormOnLogin() async {
    if (formstate.currentState!.validate()) {
      formstate.currentState!.save();
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });
      try {
        await authinstance.signInWithEmailAndPassword(
            email: emailController.text.toLowerCase().trim(),
            password: passwordController.text.toLowerCase().trim());
        final User? user = authinstance.currentUser;
        String uid = user!.uid;
        DocumentSnapshot userdoc =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();
        String name = userdoc.get("name");
        Navigator.of(context).pushReplacementNamed(fetchPage.fetch);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 5000),
          content: Row(
            children: [
              CustomText(
                text: "Welcome back".tr(context),
                color: Colors.white,
              ),
              CustomText(
                text: name,
                color: Colors.orange,
                iselipsis: true,
              ),
            ],
          ),
        ));
        print("login success");
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'user-not-found') {
          AwesomeDialog(
            titleTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
            descTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.normal),
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'user not found!'.tr(context),
            desc: 'No user found for that email!'.tr(context),
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            titleTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
            descTextStyle:
                TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.normal),
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'wrong password!'.tr(context),
            desc: 'Wrong password provided for that user!'.tr(context),
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

  Future signinWithGoogle(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    GoogleSignIn googleSignIn = GoogleSignIn();
    final googleaccount = await googleSignIn.signIn();
    if (googleaccount != null) {
      final googleAuth = await googleaccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        try {
          final authresult = await authinstance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          if (user != null) {
            if (authresult.additionalUserInfo!.isNewUser) {
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(authresult.user!.uid)
                  .set({
                "email": authresult.user!.email,
                "uid": authresult.user!.uid,
                "name": authresult.user!.displayName,
                "shipping_address": "",
                "userWish": [],
                "userCart": [],
                "createdAt": Timestamp.now()
              });
            }

            Navigator.of(context).pushReplacementNamed(fetchPage.fetch);
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            isLoading = false;
          });
          if (e.code == 'user-not-found') {
            AwesomeDialog(
              titleTextStyle:
                  TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
              descTextStyle: TextStyle(
                  fontFamily: "Tajawal", fontWeight: FontWeight.normal),
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'user not found!'.tr(context),
              desc: 'No user found for that email!'.tr(context),
              btnOkOnPress: () {},
            ).show();
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'there where an error!'.tr(context),
              desc: '$e',
              btnOkOnPress: () {},
            ).show();
          }
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
                      CustomText(
                        text: "Welcome back".tr(context),
                        istitle: true,
                        color: Colors.white,
                        titletextsize: 35,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomText(
                        text: "Sign in to continue".tr(context),
                        color: Colors.white,
                        istitle: true,
                        titletextsize: 15,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomText(
                        text:
                            "Save data and receive gifts for fast delivery experience"
                                .tr(context),
                        color: Colors.white,
                        textsize: 13,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Form(
                        key: formstate,
                        child: Column(children: [
                          //Email Form
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(passFocusNode),
                            keyboardType: TextInputType.emailAddress,
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
                            controller: emailController,
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
                          //password Form
                          TextFormField(
                            obscureText: obscure_text,
                            keyboardType: TextInputType.visiblePassword,
                            focusNode: passFocusNode,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a strong password"
                                    .tr(context);
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              submitFormOnLogin();
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
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(ForgetPassScreen.forgetid);
                              },
                              child: CustomText(
                                text: "Forget password?".tr(context),
                                color: Colors.blue,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomAuthButton(
                        ontap: () {
                          submitFormOnLogin();
                        },
                        widget: isLoading
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : CustomText(text: "Sign in".tr(context)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          signinWithGoogle(context);
                        },
                        child: Container(
                            height: 48,
                            // padding: EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue),
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Image.asset(
                                        "assets/images/google.png")),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: "Sign in with Google".tr(context),
                                  color: Colors.white,
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(
                            color: Colors.white,
                            thickness: 1,
                          )),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            text: "OR".tr(context),
                            istitle: true,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Expanded(
                              child: Divider(
                            color: Colors.white,
                            thickness: 1,
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomAuthButton(
                        ontap: () {
                          if (authinstance.currentUser != null) {
                            authinstance.signOut();
                          }
                          Navigator.of(context)
                              .pushReplacementNamed(fetchPage.fetch);
                        },
                        widget:
                            CustomText(text: "Continue as a guest".tr(context)),
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "Don't have an account?".tr(context),
                            color: Colors.white,
                          ),
                          TextButton(
                            child: CustomText(
                              text: "Sign up".tr(context),
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(RegistreScreen.regid);
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
