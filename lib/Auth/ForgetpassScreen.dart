import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Swipimages.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Widgets/CustomAuthButton.dart';
import 'package:grocery_app/Widgets/LoadingWidget.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';

class ForgetPassScreen extends StatefulWidget {
  static const String forgetid = "forgetid";
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  void resetPassword() async {
    if (_emailController.text.isEmpty ||
        !_emailController.text.contains("@") ||
        !_emailController.text.contains(".com")) {
      AwesomeDialog(
        titleTextStyle:
            TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
        descTextStyle:
            TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.normal),
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Uncorrect email!'.tr(context),
        desc: 'Please enter a valid email address '.tr(context),
        btnOkOnPress: () {},
      ).show();
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        await authinstance.sendPasswordResetEmail(
            email: _emailController.text.toLowerCase());
        AwesomeDialog(
          titleTextStyle:
              TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold),
          descTextStyle:
              TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.normal),
          context: context,
          dialogType: DialogType.infoReverse,
          animType: AnimType.rightSlide,
          title: 'Email sent'.tr(context),
          desc: 'A link has been sent to your email'.tr(context),
          btnOkOnPress: () {},
        ).show();
        print("email sent");
      } on FirebaseException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'user-not-found'.tr(context)) {
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
        setState(() {
          isLoading = false;
        });
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
                        text: "Forget password".tr(context),
                        istitle: true,
                        color: Colors.white,
                        titletextsize: 35,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Form(
                        key: formstate,
                        child: Column(children: [
                          //Email Form
                          TextField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {},
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
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

                          //password Form
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomAuthButton(
                        ontap: () async {
                          resetPassword();
                        },
                        widget: CustomText(text: "Reset now".tr(context)),
                      ),
                      const Spacer(flex: 3),
                    ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
