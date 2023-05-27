import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {Key? key,
      required this.title,
      required this.message,
      required this.actions,
      this.align = MainAxisAlignment.end})
      : super(key: key);

  final String title;
  final String message;
  final actions;
  final MainAxisAlignment align;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.tr,
            textAlign: TextAlign.center,
            style: poppinsTextStyle(20, FontWeight.w500, greyColor100),
          ),
          SizedBox(
            height: 20,
          ),
          Text(message.tr,
              textAlign: TextAlign.center,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50)),
        ],
      ),
      actionsAlignment: align,
      actions: actions,
    );
  }
}
