import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';

void showPasswordSnackBar(String message, Color textColor) {
  Get.closeAllSnackbars();
  Get.snackbar(
    "pass_verify".tr,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.white,
    colorText: textColor,
    borderRadius: 0,
    margin: EdgeInsets.zero,
  );
}

void showCustomSnackBar(String title, String message, Color textColor,
    {Duration duration = const Duration(seconds: 3)}) {
  Get.closeAllSnackbars();
  Get.snackbar(
    title.tr,
    message.tr,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.white,
    colorText: textColor,
    borderRadius: 0,
    margin: EdgeInsets.zero,
    duration: duration, //default is 3 secs
  );
}

void showPersistentSnackBar(
  String title,
  String message,
) {
  Get.showSnackbar(
    GetSnackBar(
      title: title,
      message: message.tr,
      icon: Icon(
        Icons.lightbulb_rounded,
        color: Colors.yellow,
      ),
      backgroundColor: greyColor100,
      duration: Duration(seconds: 2),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      borderRadius: 8,
      snackPosition: SnackPosition.BOTTOM,
    ),
  );
}

void showInternetConnectionSnackBar({required bool isOnline}) {
  Get.closeAllSnackbars();
  Get.showSnackbar(
    GetSnackBar(
      icon: Icon(
        isOnline ? Icons.wifi : Icons.wifi_off_rounded,
        color: isOnline ? successColor30 : dangerColor10,
      ),
      message: isOnline ? "Internet restored" : "No internet Connection",
      // backgroundColor: isOnline ? successColor30 : greyColor100,
      duration: Duration(seconds: 2),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      borderRadius: 8,
      snackPosition: SnackPosition.TOP,
    ),
  );
}

void showCustomBetaSnackBar() {
  Get.closeAllSnackbars();
  Get.snackbar(
    "Warning / 경고",
    "베타버전에만 현 포인트를 사용 할 수 있습니다.\nOnly beta versions period can use this point",
    backgroundColor: Colors.black,
    colorText: Colors.white,
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    borderRadius: 8,
    snackPosition: SnackPosition.BOTTOM,
    icon: Icon(
      Icons.warning_amber,
      color: Colors.amber,
    ),

    duration: const Duration(seconds: 3), //default is 3 secs
  );
}
