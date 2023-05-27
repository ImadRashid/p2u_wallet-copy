import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A [widget] of type [StatelessWidget] that displays
/// [CryptoToken]'s values like [name],[balance],[valueOfToken],
/// [valueOfBalance] in a specific UI Format.

class CryptoWidget extends StatelessWidget {
  /// A [constructor] that accepts:
  /// - [token] of type [String]
  /// - [tokenBalance] of type [dynamic]
  /// - [valueOfToken] of type [dynamic]
  /// - [valueOfBalance] of type [dynamic]
  /// - [onTap] of type [Function]
  /// - [isHome] of type [boolean]
  ///
  /// and returns a [ListTile] widget in a specific
  /// format.
  const CryptoWidget(
      {Key? key,
      required this.token,
      required this.onTap,
      this.valueOfToken,
      this.valueOfBalance,
      this.tokenBalance,
      this.isHome = true})
      : super(key: key);

  /// [String] value that stores token name
  final String token;

  /// [Function] value that stores [onTap] function
  final void Function() onTap;

  /// [dynamic] value that stores balance of token
  final tokenBalance;

  /// [dynamic] value that stores value of token
  final valueOfToken;

  /// [dynamic] value that stores value of balance
  final valueOfBalance;

  /// [boolean] flag that tells whether the screen is [HomeScreen]
  /// or [WalletScreen] as this [widget] is used on both screens.
  final isHome;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHome ? 8 : 6),
      child: Material(
        color: Colors.transparent,
        // ListTile
        child: ListTile(
          dense: isHome,
          contentPadding: EdgeInsets.symmetric(horizontal: isHome ? 16 : 12),
          visualDensity: VisualDensity(horizontal: -3),
          onTap: onTap,
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: greyColor20)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Token Name
              Text(
                token,
                style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
              ),
              // Token Balance
              Text(
                tokenBalance != "..." ? tokenBalance.toStringAsFixed(1) : "...",
                style: isHome
                    ? poppinsTextStyle(16, FontWeight.w500, greyColor100)
                    : poppinsTextStyle(16, FontWeight.w500, greyColor50),
              ),
            ],
          ),
          subtitle: !isHome
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Value of token
                    Text(
                      valueOfToken,
                      style: poppinsTextStyle(12, FontWeight.w500, greyColor50),
                    ),
                    // Balance of token
                    Text(
                      valueOfBalance,
                      style: poppinsTextStyle(12, FontWeight.w500, greyColor50),
                    ),
                  ],
                ),
          leading: token == "MATIC"
              ? Image.asset(
                  "assets/v2/${token.toLowerCase()}.png",
                  height: 40,
                  width: 40,
                )
              : SvgPicture.asset(
                  "assets/v2/P2UP.svg",
                  height: 40,
                  width: 40,
                ),
        ),
      ),
    );
  }
}
