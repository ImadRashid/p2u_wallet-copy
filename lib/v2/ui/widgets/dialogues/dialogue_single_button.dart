import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/colors.dart';

class DialogSingleMaterialButton extends StatelessWidget {
  const DialogSingleMaterialButton(
      {Key? key,
      required this.onPressed,
      required this.passwordVerified,
      required this.buttonTitle})
      : super(key: key);
  final void Function() onPressed;
  final bool passwordVerified;
  final String buttonTitle;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 300.h,
      height: 50.h,
      onPressed: onPressed,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: !passwordVerified
          ? Text(
              buttonTitle,
              style: interTextStyle(14, FontWeight.w600, Colors.white),
            )
          : CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: bluishColor,
            ),
      color: bluishColor,
    );
  }
}
