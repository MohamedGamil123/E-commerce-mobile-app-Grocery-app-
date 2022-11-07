import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/Auth/ForgetpassScreen.dart';
import 'package:grocery_app/Auth/LoginScreen.dart';
import 'package:grocery_app/Auth/registerScreen.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Inner_Screens/AllProducts_Screen.dart';
import 'package:grocery_app/Inner_Screens/CategoryProductsScreen.dart';
import 'package:grocery_app/Inner_Screens/Onsale_Screen.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/Home_page.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';
import 'package:grocery_app/screens/Orders/Orders_Screen.dart';
import 'package:grocery_app/screens/Viewed/Viewed_screen.dart';
import 'package:grocery_app/screens/Wishlist/Wishlist.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final User? user = authinstance.currentUser;
  // This widget is the root of your application.
  final Future<FirebaseApp> _appinitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _appinitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            )),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
                body: Center(
              child: Text("there where something wrong"),
            )),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ProductProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => Wishlist_provider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewdProvider(),
              )
            ],
            child: MaterialApp(
              routes: {
                Product_details.produtdetails: (context) => Product_details(),
                Homepage.home: (context) => const Homepage(),
                UseBottomNavigationBarr_page.bottomnavigation: (context) =>
                    UseBottomNavigationBarr_page(),
                Onsale_Screen.onsalSc: (context) => const Onsale_Screen(),
                Allproducts_Screen.AllproSc: (context) =>
                    const Allproducts_Screen(),
                Wishlist.wishid: (context) => const Wishlist(),
                Orders_Screen.orderid: (context) => const Orders_Screen(),
                Viewed_Screen.viewedid: (context) => const Viewed_Screen(),
                LoginScreen.logid: (context) => const LoginScreen(),
                RegistreScreen.regid: (context) => const RegistreScreen(),
                ForgetPassScreen.forgetid: (context) =>
                    const ForgetPassScreen(),
                CategoryProducts.catPro: (context) => const CategoryProducts()
              },
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(scaffoldBackgroundColor: Colors.white),
              home: authinstance.currentUser != null
                  ? const UseBottomNavigationBarr_page()
                  : const LoginScreen(),
            ),
          );
        }
      },
    );
  }
}
