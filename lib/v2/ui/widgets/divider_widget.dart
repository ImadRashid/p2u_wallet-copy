import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:flutter/material.dart';

/// A [widget] which create a [Divider] widget of [thickness] 1, [height] 1
/// and [color] greyColor20. Instead of repeating [Divider] again, we made a
/// generic [Divider].
class DividerWidget extends StatelessWidget {
  const DividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: greyColor20,
      height: 1,
      thickness: 1,
    );
  }
}
