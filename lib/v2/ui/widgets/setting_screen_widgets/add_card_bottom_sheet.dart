import 'package:flutter/material.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_text_input_field.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/models/card.dart';
import '../../screens/billing/billing_screen_provider.dart';
import '../password_snackbar.dart';

class AddCardBottomSheet extends StatelessWidget {
  AddCardBottomSheet({Key? key, required this.model}) : super(key: key);
  BillingScreenProvider model;
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "card_company".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: greyColor30)),
                    child: DropdownButton(
                      elevation: 0,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: greyColor50,
                      iconDisabledColor: greyColor50,
                      underline: SizedBox(),
                      borderRadius: BorderRadius.circular(8),
                      style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                      value: model.selectedCompanyName,
                      hint: Text(
                        model.cardCompanies.isEmpty
                            ? "No Companies"
                            : "select_your_card".tr,
                        style:
                            poppinsTextStyle(14, FontWeight.w500, greyColor40),
                      ),
                      items: model.cardCompanies.map(
                        (CardCompany item) {
                          return DropdownMenuItem(
                              value: item.code, child: Text(item.code!));
                        },
                      ).toList(),
                      onChanged: (value) {
                        model.changeSelectedCompanyName(value.toString());
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "login_id".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
                  ),
                ),
                CustomTextInputField(
                  hintText: "enter_login_id".tr,
                  keyboard: TextInputType.text,
                  controller: model.loginIDController,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                Text(
                  "card_password".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomTextInputField(
                    keyboard: TextInputType.text,
                    hintText: "enter_card_password".tr,
                    isObscure: true,
                    controller: model.passwordController,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 12)),
                loader
                    ? Center(child: CircularProgressIndicator())
                    : CustomMaterialButton(
                        onPressed: () async {
                          setState(() {
                            loader = true;
                          });
                          if (model.cardCompanies.isNotEmpty) {
                            final result = await model.registerNewCard();

                            Get.back();

                            showCustomSnackBar("add_payment_method",
                                result["msg"], result["color"]);
                            model.init();
                          } else {
                            Get.back();
                            showCustomSnackBar("add_payment_method",
                                "No Card Companies", dangerColor10);
                          }
                          setState(() {
                            loader = false;
                          });
                        },
                        btnColor: primaryColor70,
                        textColor: Colors.white,
                        title: "add_card".tr,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
