import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// A [StatelessWidget] that displays [Container] widget when
/// the [User] tokens on the main are being loaded instead of
/// circular progress indicator
class ShimmerBalanceWidget extends StatelessWidget {
  const ShimmerBalanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 30,
      color: greyColor20,
    );
  }
}
