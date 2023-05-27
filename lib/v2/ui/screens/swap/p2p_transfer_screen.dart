import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/swap/swaping.dart';
import 'package:p2u_wallet/v2/ui/screens/swap/token_transfer_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import '../../../core/constants/style.dart';
import '../../widgets/swap_screen_widgets/topup_widget.dart';

class P2PTransferScreen extends StatefulWidget {
  const P2PTransferScreen(
      {Key? key, required this.balance, required this.token})
      : super(key: key);
  final double balance;
  final String token;
  @override
  State<P2PTransferScreen> createState() => _P2PTransferScreenState();
}

class _P2PTransferScreenState extends State<P2PTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor0,
      appBar: customAppBar(
        widget.token,
        backArrow: true,
        isBottomBorder: true,
        center: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          DottedBorder(
            borderType: BorderType.RRect,
            color: primaryColor60,
            dashPattern: [6, 3],
            radius: Radius.circular(8),
            strokeWidth: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                  color: primaryColor10,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Available Balance Label
                  Text(
                    "available_balances".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
                  ),
                  // Available Balance Value
                  Text(
                    "${widget.balance}",
                    style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
                  )
                ],
              ),
            ),
          ),
          /* // Swap Token Expansion Tile
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: greyColor20)),
              title: Text(
                "swap_token".tr,
                style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
              ),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
          // Topup Credit Expansion Tile
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: greyColor20),
              color: Colors.white,
            ),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  "topup_credit".tr,
                  style: poppinsTextStyle(
                    14,
                    FontWeight.w500,
                    greyColor100,
                  ),
                ),
                textColor: greyColor100,
                iconColor: greyColor50,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TopUpWidget(title: "Flata Exchange", image: "flata"),
                        TopUpWidget(title: "Polygon Scan", image: "polygon"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListTile(
              onTap: () {
                Get.to(() => TokenTransferScreen());
              },
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: greyColor20)),
              title: Text(
                "transfer_credit".tr,
                style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
              ),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
