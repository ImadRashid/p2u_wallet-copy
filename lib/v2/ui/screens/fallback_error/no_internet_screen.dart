import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:p2u_wallet/v2/ui/screens/splash_screen.dart';
import '../../../core/constants/colors.dart';
import '../../components/restart_widget.dart';
import '../../widgets/custom_button.dart';

/// A [Screen] or [View] made of [StatelessWidget] that is only shown when there is
/// an [error] in [API] request.
class NoInternetScreen extends StatelessWidget {
  /// A [constructor] which accepts two parameters:
  /// - [error] - a value of type [integer]
  /// - [msg] - a value of type [String]
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Error Image
            Image.asset("assets/svg_icons/no_internet.png"),
            //Error Message
            Text(
              "No Internet Connection",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: CustomMaterialButton(
          onPressed: () async {
            // reset current app state
            await Get.deleteAll(force: true);
            // restart app
            RestartWidget.restartApp(Get.context!);
            // reset get state
            Get.reset();
          },
          btnColor: primaryColor70,
          title: "Retry",
          textColor: Colors.white,
        ),
      ),
    );
  }
}
