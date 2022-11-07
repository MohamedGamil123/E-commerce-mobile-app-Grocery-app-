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
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Uncorrect email!',
        desc: 'Uncorrect email!!',
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
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Email sent',
            desc: 'An email has been sent to your email',
            btnOkOnPress: () {},
          ).show();
        print("email sent");
      } on FirebaseException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'user-not-found') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'user not found!',
            desc: 'No user found for that email!',
            btnOkOnPress: () {},
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'there where an error!',
            desc: '$e',
            btnOkOnPress: () {},
          ).show();
        }
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
                        text: "Forget password",
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
                                    borderSide: const BorderSide(color: Colors.white),
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
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Email...",
                                hintStyle: const TextStyle(color: Colors.white)),
                          ),

                          //password Form
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomAuthButton(
                        ontap: ()async {
                          resetPassword();
                        },
                        widget: CustomText(text: "Reset now"),
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
