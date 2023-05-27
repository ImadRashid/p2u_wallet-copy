import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/p2p/p2p_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BuyAndSellWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<P2PProvider>(
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
              color: greyColor10,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: greyColor20)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: InkWell(
                    onTap: () {
                      model.changeBtnStatus("Buy");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: model.btnStatus == "Buy"
                              ? primaryColor70
                              : greyColor10,
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Text(
                          "Buy".tr,
                          style: TextStyle(
                            color: model.btnStatus == "Buy"
                                ? Colors.white
                                : greyColor50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: InkWell(
                    onTap: () {
                      model.changeBtnStatus("Sell");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: model.btnStatus == "Sell"
                              ? primaryColor70
                              : greyColor10,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          "Sell".tr,
                          style: TextStyle(
                            color: model.btnStatus == "Sell"
                                ? Colors.white
                                : greyColor50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
