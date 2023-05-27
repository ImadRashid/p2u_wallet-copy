import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/style.dart';

/// A [Button] when pressed will attempt the requested
/// [SocialMedia] login, which are [Google], [Facebook]
/// and [Apple].

class LoginButton extends StatelessWidget {
  /// A [constructor] which accepts:
  /// - An [asset] of type [String]
  /// - An [option] of type [String]
  /// - A [onTap] function
  const LoginButton({
    Key? key,
    required this.asset,
    required this.option,
    this.onTap,
    this.RTL = false, // temporary patch for ME-728
  }) : super(key: key);

  final bool RTL;

  /// Name of [Image] to be rendered.
  final String asset;

  /// [SocialMedia] option name like [Google],[Facebook],[Apple]
  /// that are to shown on the button
  final String option;

  /// [Function] that decides what to do when the button is pressed.
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(52),
            side: BorderSide(width: 1, color: greyColor30),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 24),
            child: SvgPicture.asset("assets/my_icons/$asset.svg"),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Text(""),
          ),
          title: !RTL
              ? RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "sign_in_with".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                    children: [
                      TextSpan(
                        text: " $option",
                        style:
                            poppinsTextStyle(14, FontWeight.w500, greyColor100),
                      )
                    ],
                  ),
                )
              : RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: " $option",
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
                    children: [
                      TextSpan(
                        text: "sign_in_with".tr,
                        style:
                            poppinsTextStyle(14, FontWeight.w500, greyColor50),
                      )
                    ],
                  ),
                )),
    );
  }
}
