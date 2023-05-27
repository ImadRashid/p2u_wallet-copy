import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/ui/screens/wallet/successfuly_connected.dart';
import 'package:p2u_wallet/v2/ui/screens/wallet/wallet_req_provider.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_app_bar.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WalletRequestScreen extends StatelessWidget {
  final getPlatform;
  final getKey;

  WalletRequestScreen({this.getPlatform, this.getKey});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletRequestProvider(),
      child: Consumer<WalletRequestProvider>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Color(0xffDFDFDF),
            appBar: customAppBar(
              "Wallet Request",
              backArrow: true,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(20.r),
                      margin: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "$getPlatform requested a wallet connection",
                            style: poppinsTextStyle(
                                16, FontWeight.w500, Colors.black),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Please confirm the following information and push next.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Divider(
                            height: 4,
                            color: greyColor,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "Requested by:",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "$getPlatform.io",
                            style: poppinsTextStyle(
                                14, FontWeight.w500, Colors.black),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Wallet Address",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${model.locateUser.myAppUser.wallet!.onChainAddress}",
                            style: poppinsTextStyle(
                                14, FontWeight.w500, Colors.black),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomMaterialButton(
                              title: "Back",
                              btnColor: Colors.grey,
                              textColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomMaterialButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SuccessFullyConnectedWallet()));
                              },
                              title: "Next",
                              btnColor: bluishColor,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
