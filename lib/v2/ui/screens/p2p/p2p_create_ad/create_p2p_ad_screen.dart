import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/static_values.dart';
import '../../../../core/enums/view_state.dart';
import '../../../widgets/custom_text_input_field.dart';
import '../../../widgets/dialogues/custom_alert_dialog.dart';
import '../../../widgets/divider_widget.dart';
import '../../../widgets/password_snackbar.dart';
import '../p2p_listing/p2p_user_screen.dart';
import '../p2p_listing/p2p_user_screen_provider.dart';
import 'create_p2p_ad_provider.dart';

class CreateP2PAdScreen extends StatefulWidget {
  const CreateP2PAdScreen({Key? key}) : super(key: key);

  @override
  State<CreateP2PAdScreen> createState() => _CreateP2PAdScreenState();
}

class _CreateP2PAdScreenState extends State<CreateP2PAdScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => P2PCreateAdProvider()),
      child: Consumer<P2PCreateAdProvider>(builder: (context, model, child) {
        return Scaffold(
          backgroundColor: greyColor0,
          appBar: AppBar(
            title: Text("create_p2p_ad".tr),
            centerTitle: false,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => cancelCreateAd(model));
              },
            ),
            bottom: PreferredSize(
              child: DividerWidget(),
              preferredSize: Size.fromHeight(1.0),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: model.state == ViewState.busy,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Token".tr, style: TextStyle(color: greyColor)),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 32),
                    child: SizedBox(
                      height: 20,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: tokens.length,
                        itemBuilder: (BuildContext context, index) {
                          return Row(
                            children: [
                              Radio(
                                  value: tokens[index],
                                  activeColor: primaryColor70,
                                  visualDensity: VisualDensity(horizontal: -4),
                                  groupValue: model.currentToken,
                                  onChanged: model.tokenSelectionOnChange),
                              Text(tokens[index],
                                  style: tokens[index] == model.currentToken
                                      ? poppinsTextStyle(
                                          14, FontWeight.w500, greyColor100)
                                      : poppinsTextStyle(
                                          14, FontWeight.w500, greyColor50)),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12))
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Text("listing_type".tr, style: TextStyle(color: greyColor)),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 32),
                    child: SizedBox(
                      height: 20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: transactionType.length,
                        itemBuilder: (BuildContext context, index) {
                          return Row(
                            children: [
                              Radio(
                                  value: transactionType[index],
                                  activeColor: primaryColor70,
                                  visualDensity: VisualDensity(horizontal: -4),
                                  groupValue: model.currentType,
                                  onChanged:
                                      model.listingTypeSelectionOnChange),
                              Text(
                                  transactionType[index] == "Buy"
                                      ? "Buy".tr
                                      : "Sell".tr,
                                  style: transactionType[index] ==
                                          model.currentType
                                      ? poppinsTextStyle(
                                          14, FontWeight.w500, greyColor100)
                                      : poppinsTextStyle(
                                          14, FontWeight.w500, greyColor50)),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12)),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Text("total_amount".tr, style: TextStyle(color: greyColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: CustomTextInputField(
                      controller: model.amountController,
                      hintText: "1.00",
                      onChanged: model.amountValueOnChange,
                      mode: AutovalidateMode.onUserInteraction,
                      validator: model.amountValidation,
                    ),
                  ),
                  Text("Price".tr, style: TextStyle(color: greyColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: CustomTextInputField(
                      controller: model.priceController,
                      hintText: "1.00",
                      onChanged: model.askPriceValueOnChange,
                      mode: AutovalidateMode.onUserInteraction,
                      validator: model.priceValidation,
                      suffix: model.askCurrency,
                    ),
                  ),
                ],
              ),
            ),
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: CustomMaterialButton(
              onPressed: () async {
                var response = await model.createP2PAd();
                if (response["color"] == successColor30) {
                  showDialog(
                      context: context,
                      builder: (context) => createAdSuccessful());
                }
                showCustomSnackBar(
                    "create_p2p_ad", response["msg"], response["color"]);
              },
              title: "create".tr,
              btnColor: model.isEnabled ? primaryColor70 : greyColor10,
              textColor: model.isEnabled ? Colors.white : greyColor40,
            ),
          ),
        );
      }),
    );
  }

  createAdSuccessful() {
    return CustomAlertDialog(
      title: "you_have_created_an_ad".tr,
      message: "you_can_have_a_look_at_your_ad’s_on_your_listings_page".tr,
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<P2pUserScreenProvider>(
              context,
              listen: false,
            ).fetchDataForAllTokens();
            Get.until((route) => Get.currentRoute == '/P2pScreen');
            Get.to(() => P2PUserScreen());
          },
          child: Text(
            "take_me_to_listings".tr,
            style: poppinsTextStyle(14, FontWeight.w500, primaryColor70),
          ),
        )
      ],
    );
  }

  cancelCreateAd(P2PCreateAdProvider model) {
    return CustomAlertDialog(
      title: "cancel_ad_creating".tr,
      message: "if_you_choose_to_cancel".tr,
      actions: [
        TextButton(
          onPressed: () {
            model.clear();
            Get.back();
            Get.back();
          },
          child: Text(
            "yes".tr,
            style: poppinsTextStyle(14, FontWeight.w500, primaryColor70),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "no".tr,
            style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
          ),
        ),
      ],
    );
  }
}
