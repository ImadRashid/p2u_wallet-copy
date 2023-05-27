import 'dart:io';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/payment/wallet_connection_screen.dart';
import 'package:p2u_wallet/v2/ui/screens/splash_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/barcode_token_widget.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../locator.dart';
import '../../../core/constants/style.dart';
import '../../../core/services/deep_link_payment.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/dialogues/custom_alert_dialog.dart';
import '../../widgets/dialogues/fingerprint_unlock_dialogue.dart';
import '../../widgets/dialogues/password_validation_dialogue.dart';
import '../../widgets/password_snackbar.dart';
import '../wallet/successfuly_connected.dart';
import 'mobile_payment_provider.dart';
import 'package:p2u_wallet/v2/core/services/deep_link_payment.dart';

class MobilePaymentScreen extends StatefulWidget {
  static String id = "MobilePaymentScreen";
  const MobilePaymentScreen({Key? key}) : super(key: key);

  @override
  State<MobilePaymentScreen> createState() => _MobilePaymentScreenState();
}

class _MobilePaymentScreenState extends State<MobilePaymentScreen> {
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return locator<DeepLinkPayment>().isConnection
        ? WalletConnectionScreen()
        : ChangeNotifierProvider(
            create: (context) => MobilePaymentProvider(),
            lazy: false,
            child: Consumer<MobilePaymentProvider>(
              builder: (context, model, child) => WillPopScope(
                onWillPop: () async {
                  Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                  return false;
                },
                child: Scaffold(
                  appBar: customAppBar(
                    "mobile_pay",
                    isBottomBorder: true,
                    center: true,
                  ),
                  body: (model.loader)
                      ? Center(child: CircularProgressIndicator())
                      : model.noRequestKey
                          ? Center(child: Text("no_req_found".tr))
                          : model.paymentData!.requestPlatform!.status ==
                                  "completed"
                              ? completedTransaction(context)
                              : model.paymentData!.requestPlatform!.type ==
                                      "send_transaction"
                                  ? sendTransaction(context, model)
                                  : walletAccessTransaction(context, model),
                  backgroundColor: greyColor0,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: ((model.loader || model.noRequestKey)
                              ? "completed"
                              : model.paymentData!.requestPlatform!.status) ==
                          "completed"
                      ? null
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: CustomMaterialButton(
                                  title: "refuse".tr,
                                  btnColor: Colors.white,
                                  textColor: primaryColor70,
                                  borderColor: primaryColor70,
                                  onPressed: () {
                                    locator<DeepLinkPayment>().reset();
                                    Get.offAll(() => SplashScreenV2());
                                    // Get.offAll(() => BottomNavigation(indexValue: 0));
                                    Platform.isAndroid
                                        ? SystemChannels.platform
                                            .invokeMethod('SystemNavigator.pop')
                                        : exit(0);
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              Expanded(
                                child: CustomMaterialButton(
                                  title: "accept".tr,
                                  btnColor: primaryColor70,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (model
                                        .bioMetricServices.isBioMetricEnabled) {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              FingerprintUnlockDialogue(
                                                  model: model));
                                      var res = await model
                                          .performTransactionWithFingerprint();
                                      if (!res.containsKey("reroute")) {
                                        showCustomSnackBar(
                                            "fingerprint_authentication",
                                            res["msg"],
                                            res["color"]);
                                      } else {
                                        Get.to(() =>
                                            SuccessFullyConnectedWallet(
                                                status: res["reroute"]));
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            PasswordValidationDialogue(
                                                model: model),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          );
  }

  sendTransaction(context, MobilePaymentProvider model) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: greyColor20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      elevation: 0,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text(
              "transaction_detail".tr,
              textAlign: TextAlign.center,
              style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "proceed_transaction".tr,
              textAlign: TextAlign.center,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
          ),
          //DividerWidget(),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "Amount".tr,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
          ),
          Container(
            height: model.paymentData!.requestPlatform!.transaction!.tokens!
                    .name.length *
                25,
            width: 100,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: model.paymentData!.requestPlatform!.transaction!
                  .tokens!.name.length,
              itemBuilder: (context, index) {
                var name = model.paymentData!.requestPlatform!.transaction!
                    .tokens!.name[index];
                var amount = model.paymentData!.requestPlatform!.transaction!
                    .tokens!.amount[index];
                return BarcodeTokenAmountWidget(
                    token: name.toString(), amount: amount.toString());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "requested_by".tr,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
          ),
          Text(
            model.paymentData!.requestPlatform!.platformUrl!.toString(),
            style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "platform".tr,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
          ),
          Text(
            model.paymentData!.requestPlatform!.platformName!.toString(),
            style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "wallet_address".tr,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
          ),
          Text(
            model.paymentData!.requestPlatform!.transaction!.to.toString(),
            style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
          ),
          Padding(padding: const EdgeInsets.only(top: 16, bottom: 24)),
        ],
      ),
    );
  }

  completedTransaction(context) {
    return CustomAlertDialog(
      title: "transaction_done",
      message: "",
      align: MainAxisAlignment.center,
      actions: [
        CustomMaterialButton(
          onPressed: () {
            locator<DeepLinkPayment>().reset();
            Get.offAll(SplashScreenV2());
            Platform.isAndroid
                ? SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                : exit(0);

            // if (Platform.isAndroid) SystemNavigator.pop();
          },
          title: "ok".tr,
          textColor: Colors.white,
          btnColor: primaryColor70,
        )
      ],
    );
  }

  walletAccessTransaction(context, MobilePaymentProvider model) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: greyColor20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      elevation: 0,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text(
              "wallet_request".tr,
              textAlign: TextAlign.center,
              style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "${model.paymentData!.requestPlatform!.platformName} " +
                  "request_for_address_and_balance".tr,
              textAlign: TextAlign.center,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "requested_by".tr,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
          ),
          Text(
            model.paymentData!.requestPlatform!.platformUrl!.toString(),
            style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "platform".tr,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
          ),
          Text(
            model.paymentData!.requestPlatform!.platformName!.toString(),
            style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
          ),
          Padding(padding: const EdgeInsets.only(top: 16, bottom: 24)),
        ],
      ),
    );
  }
}
