import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/style.dart';

class HistoryWidget extends StatelessWidget {
  final title, amount, fee, status, date;
  const HistoryWidget({
    Key? key,
    this.title,
    this.fee,
    this.amount,
    this.date,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Color(0xffDCDEE6)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: poppinsTextStyle(15, FontWeight.w500, Colors.black),
              ),
              Text(
                date,
                style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Text(
                "Amount".tr,
                style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                amount,
                style: poppinsTextStyle(15, FontWeight.w500, Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Fee".tr,
                    style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    fee,
                    style: poppinsTextStyle(15, FontWeight.w500, Colors.black),
                  )
                ],
              ),
              Row(
                children: [
                  Image.asset("assets/tick_enabled.png"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    status.tr,
                    style: poppinsTextStyle(15, FontWeight.w500, Colors.black),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
