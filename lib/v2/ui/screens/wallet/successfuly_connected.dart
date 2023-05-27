import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p2u_wallet/v2/core/services/deep_link_payment.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_app_bar.dart';
import '../../../core/constants/colors.dart';
import '../homescreen/base_screen.dart';

class SuccessFullyConnectedWallet extends StatefulWidget {
  final status;
  SuccessFullyConnectedWallet({this.status});

  @override
  State<SuccessFullyConnectedWallet> createState() =>
      _SuccessFullyConnectedWalletState();
}

class _SuccessFullyConnectedWalletState
    extends State<SuccessFullyConnectedWallet> {
  int time = 3;
  @override
  void initState() {
    if (locator<DeepLinkPayment>().hasDeepLink) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (--time == 0) {
          timer.cancel();
          Platform.isAndroid
              ? SystemChannels.platform.invokeMethod('SystemNavigator.pop')
              : exit(0);
          locator<DeepLinkPayment>().reset();
        }
        setState(() {});
      });
    } else {
      time = 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F7F9),
      appBar: customAppBar(
          (locator<DeepLinkPayment>().isConnection
                  ? "wallet_con_req"
                  : "transaction_request")
              .tr,
          center: true,
          isBottomBorder: true),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Expanded(child: SizedBox()),
                  widget.status == "confirmed"
                      ? Image.asset(
                          "assets/v2/success.png",
                        )
                      : Image.asset(
                          "assets/v2/failed.png",
                        ),
                  SizedBox(
                    height: 25,
                  ),
                  widget.status == "confirmed"
                      ? Text(
                          (locator<DeepLinkPayment>().isConnection
                                  ? "con_success"
                                  : "transaction_confirmed")
                              .tr,
                          textAlign: TextAlign.center,
                          style: poppinsTextStyle(
                              20, FontWeight.w500, Colors.black),
                        )
                      : Text(
                          (locator<DeepLinkPayment>().isConnection
                                  ? "con_fail"
                                  : "transaction_failed")
                              .tr,
                          textAlign: TextAlign.center,
                          style: poppinsTextStyle(
                              20, FontWeight.w500, Colors.black),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  widget.status == "confirmed"
                      ? Text(
                          (locator<DeepLinkPayment>().isConnection
                                  ? "wallet_con_success"
                                  : "transaction_confirm_msg")
                              .tr,
                          textAlign: TextAlign.center,
                          style: poppinsTextStyle(
                              14, FontWeight.w500, greyColor50),
                        )
                      : Text(
                          "${widget.status.tr}",
                          textAlign: TextAlign.center,
                          style: poppinsTextStyle(
                              14, FontWeight.w500, greyColor50),
                        ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      Get.offAll(() => BottomNavigation(indexValue: 0));
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: bluishColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        "back_to_home".tr,
                        style: TextStyle(
                            color: bluishColor, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  time > 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            "redirect_text".tr + " in 0$time secs",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        )
                      : SizedBox(),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
