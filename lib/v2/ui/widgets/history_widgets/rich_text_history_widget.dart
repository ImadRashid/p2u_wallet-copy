import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/style.dart';

/// A [widget] made up of [StatelessWidget] to create a row of
/// [walletType] (from/to) and [walletAddress] in hash and return it.
class RichTextHistoryWidget extends StatelessWidget {
  /// A [constructor] which have two arguments:
  /// - [first] which is a [String]
  /// - [second] which is also a [String]
  const RichTextHistoryWidget(
      {Key? key, required this.first, required this.second})
      : super(key: key);

  /// A [String] variable that stores [walletType] which are [from] and [to]
  final String first;

  /// A [String] variable that stores [hashValue] of [walletAddress]
  final String second;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Wallet Type
        Text(
          first,
          style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
        ),
        SizedBox(
          width: 10,
        ),
        // Wallet Address
        Flexible(
          child: Text(
            second,
            overflow: TextOverflow.ellipsis,
            style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
          ),
        ),
      ],
    );
  }
}
