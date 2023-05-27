import 'package:p2u_wallet/v2/core/device_type.dart';
import '../../../../locator.dart';
import "../authentications/login/login_screen.dart";
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A [ViewModel] that fetches data from [Model] and transmits it
/// to our [View] which here is [OnBoardingScreen].
class OnBoardingProvider extends ChangeNotifier {
  /// [PageController] object that handles page scrolling anf other controls.
  PageController pageController = PageController(initialPage: 0);

  /// [Integer] value that stores current [page] index to render the
  /// corresponding view.
  int pageIndex = 0;

  /// [Double] value that stores current [page] index to render the
  /// corresponding view.
  double currentPage = 0.0;

  /// A [constructor] that initializes the important [data] variables.
  OnBoardingProvider() {
    // calls set page
    setPage();
  }

  /// A [Function] that attaches listener to [pageController] that changes
  /// [currentPage] on the which [page] the [user] should be.
  setPage() {
    // attach listener
    pageController.addListener(() {
      // assign pag controller page index to currentPage
      currentPage = pageController.page!;
      notifyListeners();
    });
    notifyListeners();
  }

  /// [List] of types [String] that contains the images which
  /// need to be shown during [OnBoarding].
  List<String> images = [
    "assets/v2/onboarding1.png",
    "assets/v2/onboarding2.png",
    "assets/v2/onboarding3.png",
    "assets/v2/onboarding4.png",
  ];

  /// [List] of types [String] that contains the images title which
  /// need to be shown with images during [OnBoarding].
  List<String> titleList = [
    "buy_products",
    "token_transfer",
    "secure_layer",
    "discounted_products",
  ];

  /// [List] of types [String] that contains the images subtitles which
  /// need to be shown with image titles during [OnBoarding].
  List<String> subTitleList = [
    "boarding_screen_tagline_1",
    "boarding_screen_tagline_2",
    "boarding_screen_tagline_3",
    "boarding_screen_tagline_4",
  ];

  /// [Function] that sets onboarding to true.
  onBoardingScreensWatched() async {
    debugPrint("On Boarding Screens Done");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onBoarding", true);
    Get.off(() => LoginScreen());
  }
}
