import 'package:geolocator/geolocator.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/settings/setting_provider.dart';
import 'package:p2u_wallet/v2/ui/screens/settings/store_screen.dart';
import 'package:p2u_wallet/v2/ui/screens/wallet/my_wallet.dart';
import 'package:p2u_wallet/v2/ui/screens/wallet_termination/wallet_termination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/style.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/dialogues/password_validation_dialogue.dart';
import '../../widgets/password_snackbar.dart';
import '../../widgets/setting_screen_widgets/setting_screen_widget.dart';
import '../billing/billing_screen.dart';
import '../contact_us/contact_us_screen.dart';
import '../web_view_screen.dart';

/// A [View] that contains the Setting Screen and shows:
/// - Username
/// - User Wallet Addresses
/// - Language Change
/// - Fingerprint Authentication
/// - Privacy Policy
/// - Terms and Conditions
/// - P2U Wallet Termination
/// - Logout

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isOn = true;
  String privacyPolicy = "https://p2u-api.msq.market/privacy-policy";
  String termsAndConditions = "https://p2u-api.msq.market/terms-and-conditions";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => SettingProvider()),
      child: Consumer<SettingProvider>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: customAppBar("settings"),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // UserName
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "user_name".tr,
                              style: poppinsTextStyle(
                                  16, FontWeight.w500, greyColor100),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                        text: model.locateUser.myAppUser.name
                                            .toString()))
                                    .then(
                                  (_) {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "username_copied".tr,
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
                              child: Text(
                                "${model.locateUser.myAppUser.name.toString()}",
                                style: poppinsTextStyle(
                                    16, FontWeight.w500, greyColor50),
                              ),
                            ),
                          ],
                        ),

                        ///Padding of 14
                        Padding(padding: EdgeInsets.symmetric(vertical: 7)),

                        ///My Wallet
                        SettingScreenWidget(
                            onTap: () {
                              Get.to(() => MyWallet());
                            },
                            title: "my_wallet".tr),

                        ///Padding of 4
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),

                        ///Language
                        SettingScreenWidget(
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8))),
                                context: (context),
                                builder: (context) => StatefulBuilder(
                                  builder: (context, setState) =>
                                      model.languageSelectionModalSheet(),
                                ),
                              );
                            },
                            title: "app_language".tr),

                        ///Padding of 4
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),

                        /// Stores
                        SettingScreenWidget(
                            onTap: () async {
                              Get.to(() => StoreScreen());
                            },
                            title: "stores".tr),

                        ///Padding of 4
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        // Language Selection Widget
                        SettingScreenWidget(
                            onTap: () {
                              Get.to(() => BillingScreen());
                            },
                            title: "billing".tr),

                        ///Padding of 4
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Divider(
                          color: greyColor20,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),

                    ///Padding of 22
                    Padding(padding: EdgeInsets.symmetric(vertical: 11)),

                    ///Privacy settings======================================>

                    Text(
                      "privacy_settings".tr,
                      style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                    ),

                    ///Padding of 22
                    Padding(padding: EdgeInsets.symmetric(vertical: 11)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.fingerprint, size: 32, color: greyColor100),

                        ///Padding of 8
                        Padding(padding: EdgeInsets.symmetric(horizontal: 4)),

                        ///Finger Print Authentication
                        Expanded(
                          child: Text(
                            "fingerprint_authentication".tr,
                            style: poppinsTextStyle(
                                16, FontWeight.w500, greyColor100),
                          ),
                        ),
                        CupertinoSwitch(
                          value: model.isBioMetricEnabled,
                          activeColor: primaryColor70,
                          thumbColor: model.isBioMetricEnabled
                              ? Colors.white
                              : greyColor30,
                          onChanged: (value) async {
                            if (model.isBioMetricEnabled) {
                              var response = await model
                                  .performTransactionWithFingerprint();
                              showCustomSnackBar("Fingerprint Authentication",
                                  response["msg"], response["color"]);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    PasswordValidationDialogue(model: model),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        "fingerprint_text".tr,
                        style:
                            poppinsTextStyle(16, FontWeight.w500, greyColor50),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 12)),
                    Container(
                      child: Divider(
                        color: greyColor20,
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 6)),

                    ///
                    /// other =======================================>
                    ///
                    ///

                    Text(
                      "other".tr,
                      style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                    ),

                    SettingScreenWidget(
                        onTap: () {
                          Get.to(
                            () => WebViewScreen(
                              url: privacyPolicy,
                              screenTitle: "privacy_policy",
                            ),
                          );
                        },
                        title: "privacy_policy".tr),
                    SettingScreenWidget(
                        onTap: () {
                          Get.to(() => WalletTermination());
                        },
                        title: "wallet_termination".tr),
                    SettingScreenWidget(
                      onTap: () {
                        Get.to(
                          () => WebViewScreen(
                            url: termsAndConditions,
                            screenTitle: "terms_and_conditions",
                          ),
                        );
                      },
                      title: "terms_and_conditions".tr,
                    ),
                    SettingScreenWidget(
                        onTap: () {
                          Get.to(() => ContactUsScreen());
                        },
                        title: "contact_us".tr),
                    SettingScreenWidget(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Center(
                              child: Text(
                                "logout".tr,
                                style: poppinsTextStyle(
                                    24, FontWeight.w500, greyColor100),
                              ),
                            ),
                            content: Container(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor70),
                              ),
                            ),
                          ),
                        );
                        model.logOut(context);
                      },
                      title: "logout".tr,
                      isLogout: true,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 12),
                      child: Text(
                        "version: 1.0.0:10",
                        style: poppinsTextStyle(
                            10, FontWeight.normal, greyColor50),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
