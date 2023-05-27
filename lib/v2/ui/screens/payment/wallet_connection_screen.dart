import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p2u_wallet/v2/core/enums/view_state.dart';
import 'package:p2u_wallet/v2/ui/screens/payment/wallet_connection_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:get/get.dart';
import '../../../../locator.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';
import '../../../core/services/deep_link_payment.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/dialogues/fingerprint_unlock_dialogue.dart';
import '../../widgets/dialogues/password_validation_dialogue.dart';
import '../../widgets/password_snackbar.dart';
import '../splash_screen.dart';
import '../wallet/successfuly_connected.dart';

class WalletConnectionScreen extends StatefulWidget {
  const WalletConnectionScreen({Key? key}) : super(key: key);

  @override
  State<WalletConnectionScreen> createState() => _WalletConnectionScreenState();
}

class _WalletConnectionScreenState extends State<WalletConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletConnectionProvider(),
      child: Consumer<WalletConnectionProvider>(
        builder: (context, model, child) {
          return Scaffold(
              appBar: customAppBar(
                "wallet_con_req",
                isBottomBorder: true,
                center: true,
              ),
              body: model.state == ViewState.busy
                  ? Center(child: CircularProgressIndicator())
                  : model.noRequestKey
                      ? Center(child: Text("no_req_found".tr))
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: greyColor20),
                            ),
                            elevation: 0,
                            color: Colors.white,
                            child: model.paymentData?.status == "prepared"
                                ? ListView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                          "NatureBook " +
                                              "wallet_con_req_received".tr,
                                          textAlign: TextAlign.center,
                                          style: poppinsTextStyle(
                                              14, FontWeight.w500, greyColor50),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16, bottom: 8),
                                        child: Text(
                                          "User".tr,
                                          style: poppinsTextStyle(
                                              14, FontWeight.w500, greyColor50),
                                        ),
                                      ),
                                      Text(
                                        model.paymentData!.userEmail.toString(),
                                        softWrap: true,
                                        style: poppinsTextStyle(
                                            14, FontWeight.w500, greyColor100),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16, bottom: 8),
                                        child: Text(
                                          "requested_by".tr,
                                          style: poppinsTextStyle(
                                              14, FontWeight.w500, greyColor50),
                                        ),
                                      ),
                                      Text(
                                        model.paymentData!.platformUrl!
                                            .toString(),
                                        style: poppinsTextStyle(
                                            14, FontWeight.w500, greyColor100),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16, bottom: 8),
                                        child: Text(
                                          "platform".tr,
                                          style: poppinsTextStyle(
                                              14, FontWeight.w500, greyColor50),
                                        ),
                                      ),
                                      Text(
                                        model.paymentData!.platformName!
                                            .toString(),
                                        style: poppinsTextStyle(
                                            14, FontWeight.w500, greyColor100),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16, bottom: 24)),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Text(
                                      "NatureBook " + "wallet_con_req_done".tr,
                                      textAlign: TextAlign.center,
                                      style: poppinsTextStyle(
                                          14, FontWeight.w500, greyColor50),
                                    ),
                                  ),
                          ),
                        ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: model.state == ViewState.busy
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: model.paymentData?.status == "prepared"
                          ? Row(
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
                                      Platform.isAndroid
                                          ? SystemChannels.platform
                                              .invokeMethod(
                                                  'SystemNavigator.pop')
                                          : exit(0);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                Expanded(
                                  child: CustomMaterialButton(
                                    title: "accept".tr,
                                    btnColor: primaryColor70,
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      if (model.bioMetricServices
                                          .isBioMetricEnabled) {
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
                            )
                          : CustomMaterialButton(
                              title: "go_back".tr,
                              btnColor: primaryColor70,
                              textColor: Colors.white,
                              onPressed: () {
                                locator<DeepLinkPayment>().reset();
                                Get.offAll(() => SplashScreenV2());
                                Platform.isAndroid
                                    ? SystemChannels.platform
                                        .invokeMethod('SystemNavigator.pop')
                                    : exit(0);
                              },
                            ),
                    ));
        },
      ),
    );
  }
}
