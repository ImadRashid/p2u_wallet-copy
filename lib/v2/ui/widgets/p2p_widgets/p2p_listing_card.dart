import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';
import '../../../core/models/order_model.dart';

class P2PListingCard extends StatelessWidget {
  const P2PListingCard({
    Key? key,
    this.timestamp,
    required this.onPressed,
    required this.order,
  }) : super(key: key);

  final timestamp;
  final OrdersData order;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: greyColor20,
        ),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (order.isBuy! ? "Buy".tr : "Sell".tr) + " ${order.currency}",
                  style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(CupertinoIcons.delete_solid,
                      color: greyColor50, size: 24),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 8),
              child: Row(
                children: [
                  Text(
                    "Amount".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "${order.amount} ${order.currency}",
                      style:
                          poppinsTextStyle(14, FontWeight.w500, greyColor100),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Row(
                children: [
                  Text(
                    "Price".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "${order.askPrice} ${order.askCurrency}",
                      style:
                          poppinsTextStyle(14, FontWeight.w500, greyColor100),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                timestamp,
                style: TextStyle(color: greyColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
