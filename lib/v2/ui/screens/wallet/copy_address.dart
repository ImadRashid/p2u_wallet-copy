import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/wallet/my_wallet_provider.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/style.dart';

/// A [Screen]/[View] that displays:
/// - [onChain] wallet address of the [User]
/// - [QRCode] of the [onChain] wallet address of the [User]
/// - [button] to copy tha wallet address
class CopyAddressScreen extends StatelessWidget {
  CopyAddressScreen({Key? key, required this.address, required this.chain})
      : super(key: key);
  final String address;
  final String chain;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => MyWalletProvider()),
      child: Consumer<MyWalletProvider>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  iconSize: 24,
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            backgroundColor: greyColor0,
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(child: SizedBox()),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 35.w,
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.all(
                        15.r,
                      ),
                      // QR Code
                      child: QrImage(
                        data: '$address',
                        version: QrVersions.auto,
                        // size: 250.r,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    // Username
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        "${model.auth.myAppUser.name!}'s" +
                            " $chain " +
                            "wallet_address".tr,
                        textAlign: TextAlign.center,
                        style:
                            poppinsTextStyle(16, FontWeight.w500, Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 38,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 35.w,
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xff9EA2B3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Wallet Address
                      child: Text(
                        "$address",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    // button to copy wallet address.
                    CustomMaterialButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: address)).then(
                          (_) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "wallet_id_copied".tr,
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
                      btnColor: primaryColor70,
                      textColor: Colors.white,
                      title: "copy_address".tr,
                    ),
                    SizedBox(height: 20),
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
