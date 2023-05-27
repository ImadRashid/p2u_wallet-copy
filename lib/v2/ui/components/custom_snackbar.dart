import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

customSnackBar(BuildContext context, String message,
    {Duration? duration,
    SnackBarAction? action,
    SnackBarBehavior behavior = SnackBarBehavior.floating}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context)
      .showSnackBar(behavior == SnackBarBehavior.floating
          ? SnackBar(
              behavior: behavior,
              margin: EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ),
              // width: ,
              action: action,
              duration: duration ?? Duration(seconds: 4),
              content: Text('$message'),
            )
          : SnackBar(
              behavior: behavior,
              action: action,
              duration: duration ?? Duration(seconds: 3),
              content: SafeArea(
                child: Text('$message'),
              ),
            ));
}

showToast({required String message}) {
  Get.closeAllSnackbars();
  Get.showSnackbar(
    GetSnackBar(
      maxWidth: 150,
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      borderRadius: 25,
      snackPosition: SnackPosition.BOTTOM,
    ),
  );
}
