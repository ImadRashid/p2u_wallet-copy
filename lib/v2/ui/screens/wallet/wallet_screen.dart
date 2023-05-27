import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/enums/view_state.dart';
import 'package:p2u_wallet/v2/ui/screens/wallet/wallet_provider.dart';
import 'package:p2u_wallet/v2/ui/widgets/home_screen_widgets/crypto_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../locator.dart';
import '../../../core/constants/style.dart';
import '../../../core/device_type.dart';

/// A [Screen]/[View] that displays:
/// - Total Number of Tokens Owned by the [User]
/// - Total Value of All Tokens Owned by the [User]
/// - Number of each Token owned by the [User].
class WalletScreen extends StatelessWidget {
  final locateSize = locator<DeviceType>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // declare Provider to be used in this screen
      create: ((context) => WalletScreenProvider()),
      child: Consumer<WalletScreenProvider>(builder: ((context, model, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Color(0xff64A4FA), Color(0xff6739D2)])),
                  height: 292,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 36, 20, 0),
                          child: Text(
                            "wallet".tr,
                            style: poppinsTextStyle(
                                20, FontWeight.w600, Colors.white),
                          ),
                        ),
                      ),
                      Divider(thickness: 1, color: primaryColor40),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Available Balance Text
                            Text(
                              "available_balances".tr,
                              style: poppinsTextStyle(
                                  14, FontWeight.w400, primaryColor10),
                            ),

                            // Available balance value
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 4),
                              child: Text(
                                model.availableBalance.toStringAsFixed(2),
                                style: poppinsTextStyle(
                                    32, FontWeight.w600, Colors.white),
                              ),
                            ),

                            // Available balance value in KRW
                            Text(
                              "₩ " +
                                  model.availableBalanceInKRW
                                      .toStringAsFixed(2),
                              style: poppinsTextStyle(
                                  16, FontWeight.w500, Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 255,
                  right: 20,
                  left: 20,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 310,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        // P2U token
                        CryptoWidget(
                          isHome: false,
                          token: "P2UP",
                          onTap: () {},
                          tokenBalance: model.state == ViewState.busy
                              ? "..."
                              : model.locateUser.myAppUser.wallet!.tokens![0],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      })),
    );
  }
}
