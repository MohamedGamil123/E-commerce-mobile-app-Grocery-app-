import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/Auth/ForgetpassScreen.dart';
import 'package:grocery_app/Auth/registerScreen.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Constants/Swipimages.dart';
import 'package:grocery_app/Constants/Utils.dart';
import 'package:grocery_app/Widgets/CustomAuthButton.dart';
import 'package:grocery_app/Widgets/LoadingWidget.dart';
import 'package:grocery_app/Widgets/customGoogleButton.dart';
import 'package:grocery_app/Widgets/customText.dart';

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
        
           Navigator.of(context).pushReplacementNamed(
              UseBottomNavigationBarr_page.bottomnavigation);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: CustomText(
            text: "Welcome ${""} ",
            color: Colors.white,
          ),
        ));
        print("login success");
      } on FirebaseAuthException catch (e) {
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
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'wrong password!',
            desc: 'Wrong password provided for that user!',
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
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future signinWithGoogle(context) async {
    setState(() {
      isLoading = true;
    });
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
                        text: "Welcome Back",
                        istitle: true,
                        color: Colors.white,
                        titletextsize: 35,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomText(
                        text: "Sign in to continue",
                        color: Colors.white,
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
                                return "Please enter a valid email address ";
                              } else {
                                return null;
                              }
                            },
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
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
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    gapPadding: 15),
                                hintText: "Email...",
                                hintStyle: TextStyle(color: Colors.white)),
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
                              if (value!.isEmpty || value.length < 7) {
                                return "Please enter a strong password";
                              }
                            },
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              submitFormOnLogin();
                            },
                            style: TextStyle(color: Colors.white),
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
                                    borderSide: BorderSide(color: Colors.white),
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
                                text: "Forget password?",
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
                            : CustomText(text: "Sign in"),
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
                                  text: "Sign in with Google",
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
                            text: "OR",
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
                          Navigator.of(context).pushReplacementNamed(
                              UseBottomNavigationBarr_page.bottomnavigation);
                        },
                        widget: CustomText(text: "Continue as a guest"),
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "Don't have an account?",
                            color: Colors.white,
                          ),
                          TextButton(
                            child: CustomText(
                              text: "Sign up",
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
