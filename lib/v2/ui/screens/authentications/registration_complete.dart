import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/registration_provider.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/base_screen.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widgets/create_screen_widget/registration_wallet_widget.dart';

/// A [Screen] of type [View] made up of [StatelessWidget] on which
/// user is direction when ID and Password Creation is successful. It
/// shows following:
/// - [Polygon] Chain [wallet] address
/// - [Beacon] Chain [wallet] address
class RegistrationComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => RegistrationProvider()),
      child: Consumer<RegistrationProvider>(
        builder: (context, model, child) {
          return Scaffold(
            body: Container(
              //left and right margins
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // A green check with circular green background
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: CircleAvatar(
                        backgroundColor: successColor30,
                        radius: 32,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    //Registration Complete Label
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        "request_confirmation".tr,
                        style:
                            poppinsTextStyle(24, FontWeight.w500, greyColor100),
                      ),
                    ),
                    //Registration Complete message
                    Padding(
                      padding: const EdgeInsets.only(bottom: 56),
                      child: Text(
                        "request_confirmation_msg".tr,
                        style:
                            poppinsTextStyle(14, FontWeight.w500, greyColor50),
                      ),
                    ),
                    //Polygon Chain (onChain) Wallet Address
                    /*RegistrationWalletWidget(
                        chain: "Polygon",
                        address: model.myAppUser.wallet!.onChainAddress!),*/
                    //Beacon Chain (nonChain) Wallet Address
                    RegistrationWalletWidget(
                        chain: "Beacon",
                        address: model.myAppUser.wallet!.offChainAddress!),
                  ],
                ),
              ),
            ),
            // Floating action button set to center
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomMaterialButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigation(
                        indexValue: 0,
                      ),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                btnColor: primaryColor70,
                textColor: Colors.white,
                title: "ok".tr,
              ),
            ),
          );
        },
      ),
    );
  }
}
