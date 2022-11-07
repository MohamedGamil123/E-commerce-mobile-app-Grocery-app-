

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Widgets/customText.dart';
import '../Bottom_Navigation_Screens/BottomNavigationBar.dart';

class CustomGoogleButton extends StatelessWidget {
  CustomGoogleButton({super.key});

  final User? user = authinstance.currentUser;
  Future signinWithGoogle(context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    final googleaccount = await _googleSignIn.signIn();
    if (googleaccount != null) {
      final googleAuth = await googleaccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        try {
          await authinstance.signInWithCredential(GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken));
          if (user != null) {
            Navigator.of(context).pushReplacementNamed(
                UseBottomNavigationBarr_page.bottomnavigation);
          }
        } on FirebaseAuthException catch (e) {
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
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'there where an error!',
            desc: '$e',
            btnOkOnPress: () {},
          ).show();
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        signinWithGoogle(context);
      },
      child: Container(
          height: 48,
          // padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Image.asset("assets/images/google.png")),
              SizedBox(
                width: 10,
              ),
              CustomText(
                text: "Sign in with Google",
                color: Colors.white,
              )
            ],
          )),
    );
  }
}
