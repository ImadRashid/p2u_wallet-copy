import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class BarcodeTokenAmountWidget extends StatelessWidget {
  const BarcodeTokenAmountWidget({
    Key? key,
    required this.amount,
    required this.token,
  }) : super(key: key);
  final String amount;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          token,
          style: TextStyle(
              fontSize: 12, color: greyColor50, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
