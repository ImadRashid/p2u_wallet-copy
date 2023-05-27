import 'package:p2u_wallet/v2/ui/screens/wallet/my_wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/divider_widget.dart';
import '../../widgets/wallet_address_widget.dart';

class MyWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyWalletProvider(),
      builder: (context, child) {
        return Consumer<MyWalletProvider>(builder: (context, model, child) {
          return Scaffold(
            backgroundColor: greyColor0,
            appBar: customAppBar("my_wallet", backArrow: true),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: greyColor0,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // WalletWidget(
                      //   walletName: "Polygon Chain",
                      //   walletAddress: model.onChainAddress!,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20, bottom: 24),
                      //   child: DividerWidget(),
                      // ),
                      WalletWidget(
                        walletName: "Beacon Chain",
                        walletAddress: model.nonChainAddress!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
