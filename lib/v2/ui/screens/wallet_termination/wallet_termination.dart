import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/ui/screens/wallet_termination/wallet_termination_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/enums/view_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_input_field.dart';

/// A [Screen]/[View] that displays the [TextInput] for password
/// verification in order to terminate [User]'s wallet.

class WalletTermination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletTerminationProvider(),
      builder: (context, child) {
        return Consumer<WalletTerminationProvider>(
            builder: (context, model, child) {
          return Scaffold(
            backgroundColor: greyColor0,
            // custom app bar
            appBar: customAppBar("wallet_termination_screen".tr,
                backArrow: true, center: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Warning Icon
                    Padding(
                      padding: const EdgeInsets.only(top: 52, bottom: 24),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 52,
                        color: dangerColor10,
                      ),
                    ),
                    // Warning Message
                    Text(
                      "proceed_wallet_termination".tr,
                      style:
                          poppinsTextStyle(14, FontWeight.w500, dangerColor10),
                    ),
                    // Password TextInput
                    Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 44),
                      child: CustomTextInputField(
                        keyboard: TextInputType.text,
                        hintText: "pass".tr,
                        isObscure: model.isObscure!,
                        controller: model.passwordController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            model.changeEnabled(true);
                          } else if (value.isEmpty) {
                            model.changeEnabled(false);
                          }
                        },
                        suffixIcon: model.isObscure!
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        suffixOnTap: () {
                          model.showHidePassword();
                        },
                      ),
                    ),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // cancel button
                        Expanded(
                          child: MaterialButton(
                            height: 52,
                            elevation: 0,
                            onPressed: () {
                              model.passwordController!.clear();
                            },
                            child: Text(
                              "cancel".tr,
                              style: poppinsTextStyle(
                                  14, FontWeight.w500, greyColor50),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(68),
                              side: BorderSide(color: greyColor50),
                            ),
                            color: greyColor0,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 16)),
                        // OK Button
                        Expanded(
                          child: MaterialButton(
                            height: 52,
                            elevation: 0,
                            onPressed: () {
                              if (model.isEnabled!) {
                                model.deleteCurrentUser();
                              }
                            },
                            child: model.state == ViewState.busy
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "ok".tr,
                                    style: !model.isEnabled!
                                        ? poppinsTextStyle(
                                            14, FontWeight.w500, greyColor40)
                                        : poppinsTextStyle(
                                            14, FontWeight.w500, Colors.white),
                                  ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(68),
                              side: BorderSide(
                                  color: !model.isEnabled!
                                      ? greyColor20
                                      : primaryColor70),
                            ),
                            color: !model.isEnabled!
                                ? greyColor20
                                : primaryColor70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
