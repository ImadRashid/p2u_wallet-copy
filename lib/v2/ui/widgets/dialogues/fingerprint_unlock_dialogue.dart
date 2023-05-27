import 'package:flutter/services.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/widgets/dialogues/dialogue_single_button.dart';
import 'package:p2u_wallet/v2/ui/widgets/dialogues/password_validation_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../locator.dart';
import '../../../core/constants/style.dart';
import '../../../core/services/deep_link_payment.dart';
import '../../../core/services/local_auth.dart';
import '../../screens/wallet/successfuly_connected.dart';
import '../divider_widget.dart';
import '../password_snackbar.dart';
import 'dart:io';

class FingerprintUnlockDialogue extends StatefulWidget {
  FingerprintUnlockDialogue({Key? key, required this.model}) : super(key: key);
  var model;

  @override
  State<FingerprintUnlockDialogue> createState() =>
      _FingerprintUnlockDialogueState();
}

class _FingerprintUnlockDialogueState extends State<FingerprintUnlockDialogue> {
  BioMetricAuthenticationServices bioMetricServices =
      locator<BioMetricAuthenticationServices>();
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        titlePadding: EdgeInsets.fromLTRB(20, 24, 20, 8),
        actionsPadding: EdgeInsets.fromLTRB(20, 16, 20, 24),
        title: Text(
          "unlock_wallet".tr,
          textAlign: TextAlign.center,
          style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "scan_finger_to_connect".tr,
              textAlign: TextAlign.center,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
            IconButton(
              iconSize: 50,
              onPressed: () async {
                setState(() {
                  loader = true;
                });
                var response =
                    await widget.model.performTransactionWithFingerprint();
                setState(() {
                  loader = false;
                });
                if (response.containsKey("tokenTransfer") &&
                    response["tokenTransfer"]) {
                  Get.to(
                      () => SuccessFullyConnectedWallet(status: "confirmed"));
                } else if (response.containsKey("reroute")) {
                  widget.model.controller!.dispose();
                  Get.back();
                  Get.to(() =>
                      SuccessFullyConnectedWallet(status: response["reroute"]));
                }
                showCustomSnackBar("fingerprint_authentication",
                    response["msg"], response["color"]);
              },
              icon: loader
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.fingerprint,
                      size: 50,
                      color: primaryColor70,
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 20),
              child: Text(
                "scan_finger".tr,
                style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DividerWidget(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "or".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                  ),
                ),
                Expanded(
                  child: DividerWidget(),
                ),
              ],
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          DialogSingleMaterialButton(
            onPressed: () {
              Get.back();
              showDialog(
                context: context,
                builder: (context) =>
                    PasswordValidationDialogue(model: widget.model),
              );
            },
            passwordVerified: false,
            buttonTitle: "use_password".tr,
          ),
        ],
      ),
    );
  }
}
