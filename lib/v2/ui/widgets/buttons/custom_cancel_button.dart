import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';

class CustomCancelButton extends StatelessWidget {
  const CustomCancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text("cancel".tr,
          style: poppinsTextStyle(14, FontWeight.w500, greyColor100)),
    );
  }
}
