import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DeviceType {
  var width = Get.width;
  var height = Get.height;

  double sizedBoxHeight = 20;
  var largeTextStyle;
  var mediumTextStyle;
  var samalGreyTextStyle;

  DeviceType() {
    debugPrint("device type class registered");
    debugPrint("width of the device:" + width.toString());
    initSizes();
  }

  initSizes() async {
    debugPrint("init fun called for sizes");

    /// if Size is less than 390
    ///
    ///

    if (width < 390) {
      sizedBoxHeight = 10;

      largeTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
      mediumTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      samalGreyTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color(0xff838799),
      );
    } else if (width >= 390 && width <= 428) {
      /// if Size is less than 390

      sizedBoxHeight = 20;
      largeTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );
      mediumTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
      samalGreyTextStyle = TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff838799));
    } else {
      sizedBoxHeight = 22;

      sizedBoxHeight = 20;
      largeTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );
      mediumTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
      samalGreyTextStyle = TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff838799));
    }
  }

  bool isTablet() {
    return width > 600;
  }

  bool isSmallPhone() {
    return width < 390;
  }
}

class Sizes {
  final deviceType = DeviceType();

  double headerTopPadding = 0.0;
  double headerBottomPadding = 0.0;
  double headerLeftPadding = 0.0;
  double headerRightPadding = 0.0;

  double? titleFontSize;
  double? subtitleFontSize;
  double? descriptionFontSize;
  double? countFontSize;

  assignPaddings() {
    if (deviceType.isSmallPhone()) {
      headerTopPadding = 19.w;
      headerRightPadding = 19.w;
      headerTopPadding = 8.h;
      headerBottomPadding = 0;
      countFontSize = 50.sp;
      titleFontSize = 28.sp;
      subtitleFontSize = 15.sp;
    } else {
      headerTopPadding = 19.w;
      headerRightPadding = 19.w;
      headerTopPadding = 8.h;
      headerBottomPadding = 0;
      countFontSize = 68.sp;
      titleFontSize = 28.sp;
      subtitleFontSize = 14.sp;
    }
  }
}
