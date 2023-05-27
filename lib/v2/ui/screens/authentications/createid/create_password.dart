import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/ui/components/custom_snackbars.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/createid/create_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/enums/view_state.dart';
import '../../../widgets/create_screen_widget/circular_check_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_input_field.dart';
import '../../../widgets/divider_widget.dart';

///
/// [CreatePasswordScreen] - A [Screen] based on [StatelessWidget] to which the [User] is directed to
/// after [User] has successfully created their [UniqueID] on [CreateIDScreen] on first time [Login].
/// On this [Screen] the [User] is asked to create a strong [Password] that will be used during the
/// course of using this [Application].
///
class CreatePasswordScreen extends StatelessWidget {
  /// A [String] value of [User]'s [UniqueID] created on [CreateIDScreen]
  final getUserId;

  /// Constructor for [CreatePasswordScreen]
  CreatePasswordScreen({
    this.getUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreatePasswordProvider(),
      child: Consumer<CreatePasswordProvider>(
        builder: (context, model, child) {
          return Scaffold(
            //Custom App Bar
            appBar: customAppBar(
              "",
              backArrow: true,
              isBottomBorder: false,
            ),
            body: ModalProgressHUD(
              progressIndicator: CircularProgressIndicator(
                color: primaryColor70,
              ),
              inAsyncCall: model.state == ViewState.busy,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //Create Password Label
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 4),
                              child: Text(
                                "create_pass".tr,
                                style: poppinsTextStyle(
                                    20, FontWeight.w500, greyColor100),
                              ),
                            ),
                            //Please Create Password Label
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4, bottom: 12),
                              child: Text(
                                "pls_create_pass".tr,
                                style: poppinsTextStyle(
                                    14, FontWeight.w500, greyColor50),
                              ),
                            ),
                            //Password TextInput
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 24, bottom: 8),
                              child: CustomTextInputField(
                                keyboard: TextInputType.text,
                                controller: model.userPassword,
                                onChanged: (value) {
                                  model.myOnChangeFun(model.userPassword.text);
                                },
                                hintText: "pass".tr,
                                isObscure: model.isVisiblePassword,
                                suffixIcon: model.isVisiblePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                suffixOnTap: () {
                                  model.visiblePassword();
                                },
                              ),
                            ),
                            //Confirm Password TextInput
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, bottom: 20),
                              child: CustomTextInputField(
                                keyboard: TextInputType.text,
                                controller: model.userConfirmPassword,
                                onChanged: (value) {
                                  model.myOnChangeFun(model.userPassword.text);
                                },
                                hintText: "confirm_pass".tr,
                                isObscure: model.isVisiblePassword,
                                validator: (value) {
                                  if (value != model.userPassword) {
                                    return 'pass_not_match';
                                  }
                                },
                                suffixIcon: model.isVisiblePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                suffixOnTap: () {
                                  model.visiblePassword();
                                },
                              ),
                            ),
                            //Circular Check which is white with green background
                            //when character length is correct and grey with dark grey
                            //background otherwise
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: CircularCheckButton(
                                        iconColor: model.isCharacterLength
                                            ? Colors.white
                                            : greyColor40),
                                  ),
                                  Text(
                                    "8 ~ 20 " + "characters".tr,
                                    style: poppinsTextStyle(
                                        14, FontWeight.w500, greyColor50),
                                  ),
                                ],
                              ),
                            ),
                            //Circular Check which is white with green background
                            //when characters are both upper and lower case in TextInput and grey
                            //with dark grey background otherwise
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: CircularCheckButton(
                                        iconColor: model.isUpperAndLowerCase
                                            ? Colors.white
                                            : greyColor40),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "must_include_upper_lower".tr,
                                      style: poppinsTextStyle(
                                          14, FontWeight.w500, greyColor50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Circular Check which is white with green background
                            //when characters have a special character in TextInput and grey with dark grey
                            //background otherwise
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: CircularCheckButton(
                                        iconColor:
                                            model.isSpecialCharacterAndNumber
                                                ? Colors.white
                                                : greyColor40),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "must_include_special".tr,
                                      maxLines: 3,
                                      style: poppinsTextStyle(
                                          14, FontWeight.w500, greyColor50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Divider Widget
                            DividerWidget(),
                            // Accept password loss agreement statement
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: ListTile(
                                onTap: () {
                                  getPasswordDailgue(context, model);
                                },
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity(
                                    vertical: VisualDensity.minimumDensity),
                                minLeadingWidth: 20,
                                leading: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Transform.scale(
                                    scale: 1.2,
                                    child: Checkbox(
                                      value: model.rememberMe,
                                      onChanged: (value) {
                                        getPasswordDailgue(context, model);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      side: BorderSide(
                                          color: greyColor50, width: 1),
                                      activeColor: bluishColor,
                                    ),
                                  ),
                                ),
                                horizontalTitleGap: 12,
                                title: Text("accept_pass_agreement".tr,
                                    style: poppinsTextStyle(
                                        14, FontWeight.w500, greyColor50)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Set Floating Action Button to center of screen
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomMaterialButton(
                onPressed: () async {
                  if (model.userPassword.text ==
                      model.userConfirmPassword.text) {
                    if (model.isCharacterLength &&
                        model.isSpecialCharacterAndNumber == true &&
                        model.isUpperAndLowerCase == true &&
                        model.rememberMe == true &&
                        model.userPassword.text ==
                            model.userConfirmPassword.text) {
                      await model.createUserId(
                        context,
                        getUserId: getUserId,
                      );
                    } else {
                      debugPrint("sadfasdfasd");
                    }
                  } else {
                    SnackBars.errorSnackBar(
                      'pass_not_match'.tr,
                      "Erorr: ",
                    );
                  }
                },
                textColor: model.isCharacterLength &&
                        model.isSpecialCharacterAndNumber == true &&
                        model.isUpperAndLowerCase == true &&
                        model.rememberMe == true &&
                        model.userPassword.text ==
                            model.userConfirmPassword.text
                    ? Colors.white
                    : Colors.grey,
                btnColor: model.isCharacterLength &&
                        model.isSpecialCharacterAndNumber == true &&
                        model.isUpperAndLowerCase == true &&
                        model.rememberMe == true &&
                        model.userPassword.text ==
                            model.userConfirmPassword.text
                    ? primaryColor70
                    : greyColor10,
                title: "next".tr,
              ),
            ),
          );
        },
      ),
    );
  }

  /// [AlertDialog] for [Password] accepts two [parameters]:
  /// - [BuildContext] that is to be used to [render] elements
  /// - [model] which is [CreatePasswordProvider] object.
  getPasswordDailgue(BuildContext context, final model) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setState) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.all(24),
            title: Text(
              "create_pass_agreement_title".tr,
              style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Text(
                    "create_pass_agreement_label_1".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Text(
                    "create_pass_agreement_label_2".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Text(
                    "create_pass_agreement_label_3".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, dangerColor10),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  model.changeRememberMe(model.rememberMe);
                  Get.back();
                },
                child: Text(
                  "ok".tr,
                  style: poppinsTextStyle(16, FontWeight.w500, primaryColor70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
