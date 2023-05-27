import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';
import '../../../core/models/order_model.dart';

class P2PScreenOrderWidget extends StatelessWidget {
  const P2PScreenOrderWidget({Key? key, this.onPressed, required this.order})
      : super(key: key);
  final OrdersData order;
  final onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: greyColor20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: primaryColor70,
                      child: Text(order.createdBy![0],
                          style: interTextStyle(
                              12, FontWeight.w700, Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      order.createdBy!,
                      style:
                          poppinsTextStyle(14, FontWeight.w500, greyColor100),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Amount".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                Text("${order.amount} ${order.currency}",
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor100)),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            Row(
              children: [
                Text(
                  "Price".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                Text("${order.askPrice} ${order.askCurrency}",
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor100)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("|",
                          style: poppinsTextStyle(
                              16, FontWeight.w500, primaryColor70)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                      Text(
                        "p2p_trade".tr,
                        style:
                            poppinsTextStyle(14, FontWeight.w500, greyColor50),
                      ),
                    ],
                  ),
                  MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                    color: !order.isBuy! ? successColor30 : Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onPressed: onPressed,
                    child: Text(!order.isBuy! ? "Buy".tr : "Sell".tr,
                        style:
                            interTextStyle(14, FontWeight.w600, Colors.white)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
