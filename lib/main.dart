import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_app/Auth/ForgetpassScreen.dart';
import 'package:grocery_app/Auth/LoginScreen.dart';
import 'package:grocery_app/Auth/registerScreen.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/fetchPage.dart';
import 'package:grocery_app/Constants/Fire_consts.dart';
import 'package:grocery_app/Inner_Screens/AllProducts_Screen.dart';
import 'package:grocery_app/Inner_Screens/CategoryProductsScreen.dart';
import 'package:grocery_app/Inner_Screens/Onsale_Screen.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/BottomNavigationBar.dart';
import 'package:grocery_app/OnBoardingScreen/OnBoardingScreen.dart';
import 'package:grocery_app/Providers/Cart_Provider.dart';
import 'package:grocery_app/Providers/OrdersProvider.dart';
import 'package:grocery_app/Providers/Product_Provider.dart';
import 'package:grocery_app/Providers/Viewed_Provider.dart';
import 'package:grocery_app/Providers/Wishlist_provider.dart';
import 'package:grocery_app/Bottom_Navigation_Screens/Home_page.dart';
import 'package:grocery_app/Inner_Screens/Product_details.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:grocery_app/screens/Orders/Orders_Screen.dart';
import 'package:grocery_app/screens/Viewed/Viewed_screen.dart';
import 'package:grocery_app/screens/Wishlist/Wishlist.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  isViewed = pref.getInt("onBoardViewed");
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
          return MaterialApp(
            theme: ThemeData(
                fontFamily: "Tajawal",
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    selectedLabelStyle: TextStyle(
                  fontFamily: "Tajawal",
                ))),
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
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              )
            ],
            child: MaterialApp(
              locale: Locale('ar'),
              supportedLocales: const [Locale('ar'), Locale('en')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (deviceLocale != null &&
                      deviceLocale.languageCode == locale.languageCode) {
                    return deviceLocale;
                  }
                }

                return supportedLocales.first;
              },
              routes: {
                Product_details.produtdetails: (context) =>
                    const Product_details(),
                Homepage.home: (context) => const Homepage(),
                UseBottomNavigationBarr_page.bottomnavigation: (context) =>
                    const UseBottomNavigationBarr_page(),
                Onsale_Screen.onsalSc: (context) => const Onsale_Screen(),
                Allproducts_Screen.AllproSc: (context) => Allproducts_Screen(),
                Wishlist.wishid: (context) => const Wishlist(),
                Orders_Screen.orderid: (context) => const Orders_Screen(),
                Viewed_Screen.viewedid: (context) => const Viewed_Screen(),
                LoginScreen.logid: (context) => const LoginScreen(),
                RegistreScreen.regid: (context) => const RegistreScreen(),
                ForgetPassScreen.forgetid: (context) =>
                    const ForgetPassScreen(),
                CategoryProducts.catPro: (context) => const CategoryProducts(),
                fetchPage.fetch: (context) => const fetchPage()
              },
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(scaffoldBackgroundColor: Colors.white),
              home: isViewed != 0
                  ?const OnBoardingScreen()
                  : authinstance.currentUser != null
                      ? const fetchPage()
                      : const LoginScreen(),
            ),
          );
        }
      },
    );
  }
}
