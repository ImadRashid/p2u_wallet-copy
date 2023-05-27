import 'package:flutter/material.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/core/enums/view_state.dart';
import 'package:p2u_wallet/v2/ui/screens/swap/token_transfer_provider.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_app_bar.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_text_input_field.dart';
import 'package:p2u_wallet/v2/ui/widgets/password_snackbar.dart';
import 'package:p2u_wallet/v2/ui/widgets/swap_screen_widgets/small_button.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/dialogues/fingerprint_unlock_dialogue.dart';
import '../../widgets/dialogues/password_validation_dialogue.dart';
import '../wallet/successfuly_connected.dart';

class TokenTransferScreen extends StatefulWidget {
  const TokenTransferScreen({Key? key}) : super(key: key);

  @override
  State<TokenTransferScreen> createState() => _TokenTransferScreenState();
}

class _TokenTransferScreenState extends State<TokenTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TokenTransferProvider(),
      child: Consumer<TokenTransferProvider>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: greyColor0,
            appBar: customAppBar(
              "transfer".tr,
              center: true,
              isBottomBorder: true,
              backArrow: true,
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                Text(
                  "email".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 4)),
                CustomTextInputField(
                  hintText: "enter_recipient_mail".tr,
                  controller: model.mailController,
                  keyboard: TextInputType.text,
                  mode: AutovalidateMode.onUserInteraction,
                  validator: model.mailValidation,
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 12)),
                Text(
                  "Amount".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 4)),
                CustomTextInputField(
                  hintText: "enter_your_amount".tr,
                  controller: model.amountController,
                  suffix: "P2UPB",
                  mode: AutovalidateMode.onUserInteraction,
                  validator: model.amountValidation,
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SwapScreenSmallButton(
                        onPressed: model.setReset,
                        text: "reset".tr,
                        color: Colors.black),
                    SizedBox(
                      width: 12,
                    ),
                    SwapScreenSmallButton(
                        onPressed: model.setMax,
                        text: "max".tr,
                        color: primaryColor70),
                  ],
                ),
              ],
            ),
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: model.state == ViewState.busy
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomMaterialButton(
                      title: "send".tr,
                      onPressed: () async {
                        if (model.isEnabled) {
                          if (model.isBioMetricEnabled()) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  FingerprintUnlockDialogue(model: model),
                            );
                            var response =
                                await model.performTransactionWithFingerprint();
                            if (response.containsKey("tokenTransfer") &&
                                response["tokenTransfer"]) {
                              Get.to(
                                () => SuccessFullyConnectedWallet(
                                    status: "confirmed"),
                              );
                            } else {
                              print(response);
                              showCustomSnackBar("transfer_credit",
                                  response["msg"], response["color"]);
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  PasswordValidationDialogue(model: model),
                            );
                          }
                        } else {
                          showCustomSnackBar("transfer_credit",
                              "resolve_errors", dangerColor10);
                        }
                      },
                      btnColor: model.isEnabled ? primaryColor70 : greyColor20,
                      textColor: model.isEnabled ? Colors.white : greyColor50,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
