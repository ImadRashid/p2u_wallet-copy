import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/ui/screens/contact_us/contact_us_provider.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_app_bar.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../widgets/custom_text_input_field.dart';

/// A [Screen] or [View] made up of [StatelessWidget] which enables
/// [User] to report the issues that they are receiving during usage
/// of the [application]
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => ContactUsProvider()),
      child: Consumer<ContactUsProvider>(builder: (context, model, child) {
        return Scaffold(
          backgroundColor: greyColor0,
          //Custom App Bar
          appBar: customAppBar("contact_us".tr, backArrow: true, center: true),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Help Label
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 12),
                    child: Text("contact_us_title".tr,
                        style: poppinsTextStyle(
                            16, FontWeight.w500, greyColor100)),
                  ),
                  //Get in touch label
                  Text(
                    "contact_us_msg".tr,
                    textAlign: TextAlign.center,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                  ),
                  // Error title TextInputFiled
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: CustomTextInputField(
                      hintText: "error".tr,
                      keyboard: TextInputType.text,
                      controller: model.errorController,
                      onChanged: (v) {
                        if (v.isNotEmpty) {
                          model.changeEnabled();
                        } else if (v.isEmpty) {
                          model.changeEnabled();
                        }
                      },
                    ),
                  ),
                  // Email title TextInputFiled
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: CustomTextInputField(
                      hintText: "email".tr,
                      keyboard: TextInputType.emailAddress,
                      onChanged: (v) {
                        if (v.isNotEmpty) {
                          model.changeEnabled();
                        } else if (v.isEmpty) {
                          model.changeEnabled();
                        }
                      },
                      controller: model.emailController,
                    ),
                  ),
                  // Message title TextInputFiled
                  CustomTextInputField(
                    maxLines: 7,
                    controller: model.messageController,
                    keyboard: TextInputType.text,
                    hintText: "message".tr,
                    onChanged: (v) {
                      if (v.isNotEmpty) {
                        model.changeEnabled();
                      } else if (v.isEmpty) {
                        model.changeEnabled();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // FAB center location
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          resizeToAvoidBottomInset: false,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomMaterialButton(
              title: "send".tr,
              textColor: model.isEnabled ? Colors.white : greyColor50,
              btnColor: model.isEnabled ? primaryColor70 : greyColor20,
              onPressed: () async {
                //if button is enabled than perform action
                if (model.isEnabled) {
                  var response = await model.sendEmail();
                  //Get.back();
                  Get.snackbar(
                    "",
                    response["msg"],
                    colorText: response["color"],
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.white,
                  );
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
