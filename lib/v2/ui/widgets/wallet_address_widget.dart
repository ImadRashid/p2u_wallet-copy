import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../screens/wallet/copy_address.dart';
import 'package:flutter/services.dart';

class WalletWidget extends StatelessWidget {
  const WalletWidget({
    Key? key,
    required this.walletName,
    required this.walletAddress,
  }) : super(key: key);
  final String walletName;
  final String walletAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.qr_code_2_rounded,
                  size: 24,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                Text(
                  walletName,
                  style: poppinsTextStyle(16, FontWeight.w500, Colors.black),
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  Get.to(
                    CopyAddressScreen(
                        address: walletAddress,
                        chain: walletName.split(" ")[0]),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "scan_qr".tr,
                        style: poppinsTextStyle(
                            16, FontWeight.w500, primaryColor70),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: primaryColor70,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 12, top: 6),
          child: Text(
            walletAddress,
            style: poppinsTextStyle(16, FontWeight.w500, greyColor50),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
              side: BorderSide(
                width: 1.0,
                color: greyColor50,
              ),
            ),
            onPressed: () async {
              Clipboard.setData(ClipboardData(text: walletAddress)).then(
                (_) {
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.copy,
                  size: 20,
                  color: greyColor50,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                Text(
                  "copy_address".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
