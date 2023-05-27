import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/style.dart';
import '../../../core/models/order_model.dart';
import '../../screens/p2p/p2p_provider.dart';
import '../buttons/custom_cancel_button.dart';
import '../dialogues/custom_alert_dialog.dart';
import '../password_snackbar.dart';
import 'custom_circular_indicator.dart';
import 'empty_listing_widget.dart';
import 'order_widget.dart';

class OrderListWidget extends StatelessWidget {
  const OrderListWidget({
    Key? key,
    this.orderList,
    required this.scrollController,
    required this.orderFetched,
    this.model,
  }) : super(key: key);
  final orderList;
  final ScrollController scrollController;
  final bool orderFetched;
  final model;

  @override
  Widget build(BuildContext context) {
    return orderList.length == 0
        ? EmptyListingWidget()
        : Expanded(
            child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: orderList.length + 1,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index < orderList.length) {
                    return P2PScreenOrderWidget(
                      order: orderList[index],
                      onPressed: () {
                        confirmationDialogue(context, model, orderList[index]);
                      },
                    );
                  } else if ((index >= 2 && index >= orderList.length) &&
                      !orderFetched) {
                    return CustomCircularIndicator();
                  } else {
                    return Text("");
                  }
                }),
          );
  }

  confirmationDialogue(context, P2PProvider model, OrdersData ordersData) {
    bool isFetched = false;
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CustomAlertDialog(
            title: "you_sure",
            message: "really_sure",
            align:
                !isFetched ? MainAxisAlignment.end : MainAxisAlignment.center,
            actions: !isFetched
                ? <Widget>[
                    CustomCancelButton(),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isFetched = !isFetched;
                        });
                        final result = await model.apiServices.completedOrders(
                          orderId: ordersData.id,
                          email: ordersData.createdBy,
                          currency: ordersData.currency,
                          amount: ordersData.amount,
                        );
                        if (result == true) {
                          model.showSuccessfulSnackBar(context);
                          await model.reset();
                          await model.fetchAllOrdersData();
                          Get.back();
                        } else {
                          Get.back();
                          showCustomSnackBar("P2P Buy",
                              jsonDecode(result)["message"], dangerColor10);
                        }

                        setState(() {
                          isFetched = !isFetched;
                        });
                      },
                      child: Text("i_sure".tr,
                          style: poppinsTextStyle(
                              14, FontWeight.w500, primaryColor70)),
                    )
                  ]
                : [CircularProgressIndicator()]),
      ),
    );
  }
}
