import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import 'divider_widget.dart';

/// Custom Made Generic AppBar
/// Only required value is [title]
///
/// * [Title] - a value of type [String]
/// * [backArrow] - a value of type [boolean]
/// * [isBottomBorder] - a value of type [boolean]
/// * [center] - a value of type [boolean]
/// * [elevation] - a value of type [double]
/// * [backArrowFunction] - a value of type [Function]

AppBar customAppBar(

    /// String value
    String title,
    {

    /// show a back arrow
    bool backArrow = false,

    /// show a border.
    bool isBottomBorder = true,

    /// Place title in center
    bool center = false,

    /// Appbar Elevation
    double? elevation,

    ///Function for back arrow
    void Function()? backArrowFunction}) {
  return AppBar(
    ///show back arrow if backArrow true
    automaticallyImplyLeading: backArrow,

    ///title
    title: Text(
      title.tr,

      ///generic TextStyle
      style: poppinsTextStyle(20, FontWeight.w600, greyColor100),
    ),

    ///show center title if center true
    centerTitle: center,

    ///elevation of the appbar
    elevation: elevation ?? 0,

    ///Size of left side icon
    leadingWidth: backArrow ? 56 : 0,

    ///show BackArrow if backArrow true
    leading: backArrow
        ? IconButton(
            onPressed: backArrowFunction ??
                () {
                  /// [OnTap] get Back to previous screen
                  Get.back();
                },
            icon: Icon(Icons.arrow_back),
          )
        : Container(child: null),

    ///show a bottom border if isBottomBorder true
    bottom: isBottomBorder
        ? PreferredSize(
            child: DividerWidget(),
            preferredSize: Size.fromHeight(1.0),
          )
        : null,
  );
}
