import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/style.dart';

class SettingScreenWidget extends StatelessWidget {
  const SettingScreenWidget(
      {Key? key,
      required this.onTap,
      required this.title,
      this.isLogout = false})
      : super(key: key);
  final void Function() onTap;
  final String title;
  final bool isLogout;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 5),
      visualDensity: VisualDensity(vertical: -4),
      onTap: onTap,
      title: Text(
        title,
        style: isLogout
            ? poppinsTextStyle(16, FontWeight.w500, dangerColor10)
            : poppinsTextStyle(16, FontWeight.w500, greyColor100),
      ),
    );
  }
}
