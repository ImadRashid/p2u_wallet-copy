import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'onboarding_provider.dart';

/// A [Screen]/[View] that shows the [OnBoardingScreen] when
/// the [user] installs the [application] and opens it for the
/// first time.
class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // onboarding provider
      create: (context) => OnBoardingProvider(),
      child: Consumer<OnBoardingProvider>(
        builder: (context, model, child) {
          return Scaffold(
            body: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Stack(
                children: [
                  Container(
                    // Page View builder
                    child: PageView.builder(
                      controller: model.pageController,
                      itemCount: model.images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                              ),

                              // Slider Image
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 2.3,
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Image.asset("${model.images[index]}"),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              // Title text
                              Text(
                                model.titleList[index].tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              // Content text
                              Text(
                                model.subTitleList[index].toString().tr,
                                style: TextStyle(
                                  color: Color(0xff838799),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Progress indicator
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Get.width > 390 ? 170 : 150),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          model.images.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                            height: 6.0,
                            width:
                                model.currentPage.round() == index ? 60 : 35.0,
                            decoration: BoxDecoration(
                              color: model.currentPage.round() == index
                                  ? primaryColor70
                                  : Color(0XFF256075).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  ),
                  ),

                  // Next Button
                  model.currentPage.round() == model.titleList.length - 1
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: SafeArea(
                            top: false,
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: 20,
                                left: 10,
                                right: 10,
                              ),
                              child: CustomMaterialButton(
                                onPressed: () {
                                  model.onBoardingScreensWatched();
                                },
                                btnColor: primaryColor70,
                                title: "next".tr,
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
