import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';
import '../custom_text_input_field.dart';

/// A [Widget] that shows [wallet] address for the specified
/// [chain] in a approved [MobileUI]
class RegistrationWalletWidget extends StatelessWidget {
  /// A constructor that accepts [chain] name and [wallet] address
  const RegistrationWalletWidget(
      {Key? key, required this.chain, required this.address})
      : super(key: key);

  /// [String] value to store [chain] name
  final String chain;

  /// [String] value to store [wallet] address
  final String address;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Chain name Label(left aligned)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text("$chain Chain",
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor50)),
            ),
            // Chain Wallet Address (readOnly) with copy option
            CustomTextInputField(
              readOnly: true,
              controller: TextEditingController()..text = address,
              suffixIcon: Icons.copy,
              suffixOnTap: () {
                //copy wallet address to clipboard
                Clipboard.setData(ClipboardData(text: address)).then(
                  (_) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "wallet_id_copied".tr,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.black,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
