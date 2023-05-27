import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';

class ShimmerCreditCardWidget extends StatelessWidget {
  const ShimmerCreditCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Card Widget
    return Container(
      // Margin from bottom of 16
      margin: EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        // Border Radius Set to 8
        borderRadius: BorderRadius.circular(8),
        // Border Color Set to greyColor20
        border: Border.all(color: greyColor20),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Credit Card Company Icon
        leading: Container(
          color: greyColor20,
          width: 30,
          height: 30,
        ),
        minLeadingWidth: 30,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        // if the credit card is selected show the check
        // otherwise show empty circle
        trailing: CircleAvatar(radius: 12, backgroundColor: greyColor20),
        // Credit Card Details
        title: Container(
          color: greyColor20,
          width: 50,
          height: 20,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expiry Date Label
            Container(
              color: greyColor20,
              width: 150,
              height: 20,
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              color: greyColor20,
              width: 100,
              height: 20,
            )
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
