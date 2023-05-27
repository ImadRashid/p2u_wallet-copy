import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';

/// A [StatelessWidget] that displays credit card information on the [BillingScreen] in
/// a proper format
class CreditCardWidget extends StatelessWidget {
  /// Main [Constructor] that accepts:
  /// - Credit Card Company Name
  /// - Card is Selected or not
  ///
  /// and return the card widget.
  const CreditCardWidget({
    Key? key,
    required this.companyName,
    required this.isSelected,
    required this.email,
    required this.password,
  }) : super(key: key);

  /// [String] variable to store the company name
  final String companyName;
  final String email;
  final String password;

  /// A [boolean] flag to handle whether this card is selected or not.
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    // Card Widget
    return Card(
      // Margin from bottom of 16
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.white,
      // Rounded Corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isSelected ? primaryColor70 : greyColor20),
      ),
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Credit Card Company Icon
        leading: Icon(Icons.credit_card),
        minLeadingWidth: 30,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        // if the credit card is selected show the check
        // otherwise show empty circle
        trailing: isSelected
            ? Icon(Icons.check_circle, color: primaryColor70)
            : Icon(Icons.radio_button_off, color: greyColor20),
        // Credit Card Details
        title: Text("$companyName"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expiry Date Label
            Text(email),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Text(
              "*" * password.length,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            )
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
