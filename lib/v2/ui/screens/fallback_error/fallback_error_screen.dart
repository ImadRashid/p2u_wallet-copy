import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/custom_button.dart';

/// A [Screen] or [View] made of [StatelessWidget] that is only shown when there is
/// an [error] in [API] request.
class FallbackErrorScreen extends StatelessWidget {
  /// A [constructor] which accepts two parameters:
  /// - [error] - a value of type [integer]
  /// - [msg] - a value of type [String]
  const FallbackErrorScreen({Key? key, required this.error, required this.msg})
      : super(key: key);

  /// An [integer] value that can be 404, 500 or 502
  final int error;

  /// A [String] value that carries message with respect to
  /// the [error] code
  final String msg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Error Image
          SvgPicture.asset("assets/v2/${error.toString()}.svg"),
          //Error Message
          Text(
            msg.tr,
            style: TextStyle(
              fontSize: 20.sp,
            ),
          ),
          // Button to navigate back to main screen
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: CustomMaterialButton(
              onPressed: () {
                /*Get.until((route) =>
                    (Get.currentRoute == '/BottomNavigation') ||
                    (Get.currentRoute == '/LoginScreen'));*/
                Get.until((route) {
                  if (msg != "error_$error") {
                    if (Platform.isAndroid) SystemNavigator.pop();
                  }
                  if (route.settings.name == '/BottomNavigation') {
                    return true;
                  } else if (route.settings.name == '/LoginScreen') {
                    return true;
                  }
                  return false;
                });
              },
              btnColor: primaryColor70,
              title: "Back to Home Page",
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
