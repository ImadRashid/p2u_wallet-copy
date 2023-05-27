import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/core/enums/token_type.dart';
import 'package:p2u_wallet/v2/ui/screens/swap/swapping_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/enums/view_state.dart';
import '../../widgets/custom_button.dart';
import 'package:get/get.dart';
import '../../widgets/custom_text_input_field.dart';
import '../../widgets/dialogues/fingerprint_unlock_dialogue.dart';
import '../../widgets/dialogues/password_validation_dialogue.dart';
import '../../widgets/password_snackbar.dart';
import '../../widgets/swap_screen_widgets/small_button.dart';

/// A [Screen]/[View] which shows the User Interface for [Token] Swapping.
class SwappingScreen extends StatefulWidget {
  /// [Constructor] that accepts the type of token that
  /// we are going to perform transaction for

  SwappingScreen({required this.type});

  /// [TokenType] variable that stores the token type for
  /// which we are going to perform transaction for
  final TokenType type;

  @override
  State<SwappingScreen> createState() => _SwappingScreenState();
}

class _SwappingScreenState extends State<SwappingScreen> {
  @override
  Widget build(BuildContext context) {
    // ChangeNotifier to let the app know which provider we are using and
    // is declared.
    return ChangeNotifierProvider(
      // Assign Provider to be used in this screen.
      create: (context) => SwapProvider(this.widget.type),
      child: Consumer<SwapProvider>(
        builder: (context, model, child) => Scaffold(
          // assign background color
          backgroundColor: greyColor0,
          appBar: AppBar(
            // Swap title bar with language localizations
            title: Text("swap".tr,
                style: poppinsTextStyle(20, FontWeight.w500, greyColor100)),
          ),
          // Gesture detector to loose focus from other parts to body
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DottedBorder(
                    borderType: BorderType.RRect,
                    color: greyColor20,
                    dashPattern: [6, 3],
                    radius: Radius.circular(8),
                    strokeWidth: 1,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Available Balance Text
                              Text(
                                "available_balances".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),

                              ///Available Balance Icon
                              Image.asset(
                                "assets/v2/dollar.png",
                                scale: 3.5,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ///Available Balance value
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  model.state == ViewState.busy
                                      ? "..."
                                      : "${model.reversed ? model.convertToAmount : model.convertFromAmount} ${tokenTypes[model.fromTokenType.index]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text("₩ 0.0"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  ///MSQ textfield
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 0),
                    child: CustomTextInputField(
                      controller: model.convertFromController,
                      mode: AutovalidateMode.onUserInteraction,
                      //   validator: model.convertFromValidator,

                      // onChanged: model.convertFromOnChanged,
                      //TODO:Send validator to ViewModel
                      validator: (value) {
                        model.convertFromValidator(value);
                      },
                      //TODO:Send onChanged to ViewModel
                      onChanged: (v) {
                        model.convertFromOnChanged(v);
                      },
                      suffix: model.fromHintField,
                    ),
                  ),

                  ///Swap Button
                  Center(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      iconSize: 40,
                      icon: CircleAvatar(
                        backgroundColor: primaryColor70,
                        radius: 20,
                        child: CircleAvatar(
                          radius: 19,
                          backgroundColor: primaryColor70,
                          child: Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      onPressed: () {
                        model.swapValues();
                      },
                    ),
                  ),

                  ///MSQP textfield
                  CustomTextInputField(
                    controller: model.convertToController,
                    onChanged: model.convertToOnChanged,
                    suffix: model.toHintField,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ///Reset Button
                        SwapScreenSmallButton(
                          onPressed: () {
                            model.resetValues();
                          },
                          text: "reset".tr,
                          color: Colors.black,
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 6)),

                        ///Max Button
                        SwapScreenSmallButton(
                          onPressed: () {
                            model.setMax();
                          },
                          text: "max".tr,
                          color: bluishColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: model.state == ViewState.busy
                ? CircularProgressIndicator()
                : CustomMaterialButton(
                    onPressed: () async {
                      if (model.enableNext) {
                        if (model.isBioMetricEnabled()) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                FingerprintUnlockDialogue(model: model),
                          );
                          var response =
                              await model.performTransactionWithFingerprint();
                          showCustomSnackBar("fingerprint_authentication",
                              response["msg"], response["color"]);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                PasswordValidationDialogue(model: model),
                          );
                        }
                      }
                    },
                    title: "next".tr,
                    btnColor: model.enableNext ? primaryColor70 : greyColor20,
                    textColor: model.enableNext ? Colors.white : greyColor50,
                  ),
          ),
        ),
      ),
    );
  }
}
