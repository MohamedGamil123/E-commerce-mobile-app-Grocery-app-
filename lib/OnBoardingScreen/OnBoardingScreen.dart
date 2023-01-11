import 'package:flutter/material.dart';
import 'package:grocery_app/Auth/LoginScreen.dart';
import 'package:grocery_app/OnBoardingScreen/DotIndicator.dart';
import 'package:grocery_app/OnBoardingScreen/OnBoardingContent.dart';
import 'package:grocery_app/Widgets/customText.dart';
import 'package:grocery_app/componants/AppLocals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OnBoardModel.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  storOnBoardInfo() async {
    int isViewed = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("onBoardViewed", isViewed);
  }

  @override
  Widget build(BuildContext context) {
    List<OnBoard> onBoardList = [
      OnBoard(
          tittle: "onboardingTittle1".tr(context),
          description: "onboardingdescription1".tr(context),
          image: "assets/images/OnBoarding/Ecommerce campaign-rafiki.png"),
      OnBoard(
          tittle: "onboardingTittle2".tr(context),
          description: "onboardingdescription2".tr(context),
          image: "assets/images/OnBoarding/Product hunt-amico.png"),
      OnBoard(
          tittle: "onboardingTittle3".tr(context),
          description: "onboardingdescription3".tr(context),
          image: "assets/images/OnBoarding/Online Groceries-cuate.png"),
      OnBoard(
          tittle: "onboardingTittle4".tr(context),
          description: "onboardingdescription4".tr(context),
          image: "assets/images/OnBoarding/Successful purchase-cuate.png"),
      OnBoard(
          tittle: "onboardingTittle5".tr(context),
          description: "onboardingdescription5".tr(context),
          image: "assets/images/OnBoarding/In no time-pana.png"),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: onBoardList.length,
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                itemBuilder: (context, index) => OnBoardingContent(
                    tittle: onBoardList[index].tittle,
                    description: onBoardList[index].description,
                    image: onBoardList[index].image),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: pageIndex == onBoardList.length - 1
                            ? Container(
                                child: ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: CustomText(
                                      text: "Get started".tr(context),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () async {
                                    await storOnBoardInfo();
                                    Navigator.of(context).pushReplacementNamed(
                                        LoginScreen.logid);
                                  },
                                ),
                              )
                            : ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: CustomText(
                                    text: "Next".tr(context),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {
                                  print(pageIndex);
                                  print(onBoardList.length);
                                  pageController.nextPage(
                                      curve: Curves.easeInOutCubicEmphasized,
                                      duration: Duration(milliseconds: 1500));
                                },
                              ))),
                Spacer(),
                ...List.generate(
                    onBoardList.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: dotIndicator(
                            isActive: index == pageIndex,
                          ),
                        )),
              ],
            )
          ],
        )),
      ),
    );
  }
}
