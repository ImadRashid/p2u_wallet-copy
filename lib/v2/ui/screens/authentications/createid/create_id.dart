import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/createid/create_password.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_app_bar.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/style.dart';
import '../../../widgets/create_screen_widget/circular_check_button.dart';
import '../../../widgets/custom_text_input_field.dart';
import 'create_id_provider.dart';

///
/// [CreateIDScreen] - When the [User] first time [logins] with an [AppleID], [Gmail] or [FacebookID] that
/// previously does not have an account linked then the [User] is directed to this screen to create
/// a [UniqueID] which can then be used to identify this [User]
///
class CreateIdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateIdProvider(),
      child: Consumer<CreateIdProvider>(
        builder: (context, model, child) {
          return Scaffold(
            //Custom App Bar
            appBar: customAppBar(
              "",
              isBottomBorder: false,
              backArrow: true,
              elevation: 0,
              backArrowFunction: () async {
                //Alert Dialog Box to ask whether user wants to logout or not
                // when user taps on back button
                final x = await showOkCancelAlertDialog(
                  context: context,
                  useActionSheetForIOS: true,
                  //logout alert dialog title
                  title: "want_to_logout".tr,
                  //logout alert dialog msg
                  message:
                      "logout_msg".tr + "\n${model.auth.firebaseUser!.email}",
                );
                if (x == OkCancelResult.ok) {
                  //logouts user from its current account.
                  await model.logoutUser();
                }
              },
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Create ID Text
                    Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 4),
                      child: Text(
                        "create_id".tr,
                        style:
                            poppinsTextStyle(20, FontWeight.w500, greyColor100),
                      ),
                    ),

                    // Enter User ID label
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 12),
                      child: Text(
                        "enter_user_id".tr,
                        style:
                            poppinsTextStyle(14, FontWeight.w500, greyColor50),
                      ),
                    ),

                    // Text Input Field for Create ID
                    Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 20),
                      child: CustomTextInputField(
                        controller: model.userId,
                        keyboard: TextInputType.text,
                        hintText: "user_id".tr,
                        onChanged: (value) {
                          model.myOnChangeFun(value);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z]"),
                          ),
                          FilteringTextInputFormatter.deny(
                            RegExp(
                                r'^[0-9A-Z]+'), //users can't type 0-9,A-Z at 1st position
                          ),
                        ],
                      ),
                    ),
                    //if display name is null or providerID is apple than ask
                    //user to enter their full name as well.
                    if (model.auth.firebaseUser!.providerData[0].providerId ==
                            "apple.com" &&
                        model.auth.appleDisplayName == null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: CustomTextInputField(
                          controller: model.fullName,
                          keyboard: TextInputType.text,
                          hintText: "Full Name",
                        ),
                      ),

                    //Check Create ID Characters length
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: CircularCheckButton(
                                iconColor: model.isCharacterLength
                                    ? Colors.white
                                    : greyColor40),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              "4 ~ 10 " + "characters".tr,
                              style: TextStyle(
                                  color: model.isCharacterLength == true
                                      ? greenColor
                                      : greyColor50),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //First Character must be lower case
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: CircularCheckButton(
                                iconColor: model.isFirstLettterLower
                                    ? Colors.white
                                    : greyColor40),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              "first_must_be_lower".tr,
                              style: TextStyle(
                                  color: model.isFirstLettterLower == true
                                      ? greenColor
                                      : greyColor50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Next Button is enabled only when TextField has some input
            // or required checks are completed.
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomMaterialButton(
                onPressed: () {
                  //check Character Length
                  //check First Character is lower
                  if (model.isCharacterLength && model.isFirstLettterLower) {
                    model.auth.appleDisplayName = model.fullName.text;
                    //if both statements are true than navigate user to
                    //CreatePasswordScreen
                    Get.to(() =>
                        CreatePasswordScreen(getUserId: model.userId.text));
                  }
                },
                textColor:
                    model.isCharacterLength && model.isFirstLettterLower == true
                        ? Colors.white
                        : greyColor50,
                btnColor:
                    model.isCharacterLength && model.isFirstLettterLower == true
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
}
