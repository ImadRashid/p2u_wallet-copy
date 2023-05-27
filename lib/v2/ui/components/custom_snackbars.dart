import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBars {
  ///error snackBar
  static SnackbarController errorSnackBar(
    String title,
    description,
  ) {
    return Get.snackbar(
      title,
      description,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      colorText: Colors.red,
      snackPosition: SnackPosition.TOP,
    );
  }

  ///warning snackBar
  static SnackbarController warningSnackBar(String title, description) {
    return Get.snackbar(
      title,
      description,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  ///info snackBar
  static SnackbarController infoSnackBar(
      String title, description, SnackPosition position) {
    return Get.snackbar(
      title,
      description,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      colorText: Colors.white,
      snackPosition: position,
    );
  }

  ///Success snackBar
  static SnackbarController successSnackBar(String title, description) {
    return Get.snackbar(
      title,
      description,
      duration: const Duration(seconds: 5),
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,

    );
  }
}
