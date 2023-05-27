import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/core/enums/view_state.dart';
import 'package:p2u_wallet/v2/ui/screens/p2p/p2p_provider.dart';
import 'package:p2u_wallet/v2/ui/widgets/custom_button.dart';

import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class P2PBuyScreen extends StatelessWidget {
  final getTitle;
  final getIndexTitle;
  P2PBuyScreen({this.getTitle, this.getIndexTitle});
  @override
  Widget build(BuildContext context) {
    return Consumer<P2PProvider>(builder: (context, model, child) {
      return Scaffold(
        key: model.scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            '$getTitle' + ' $getIndexTitle',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            color: Colors.blue,
          ),
          inAsyncCall: model.state == ViewState.busy,
          child: Container(
            color: greyBackgroundColor,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My balance"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "00000",
                  style: poppinsTextStyle(15, FontWeight.w500, Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Amount",
                  style: poppinsTextStyle(15, FontWeight.w500, Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text("$getIndexTitle"),
                      Expanded(
                        child: Container(
                          height: 50,
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            onChanged: (value) {
                              model.p2uAmount = value;
                              model.getAmounts(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: SizedBox()),
                CustomMaterialButton(
                  onPressed: () {
                    if (model.p2uAmount == null || model.p2uAmount == "") {
                    } else {
                      confirmationDailgue(context, model);
                    }
                  },
                  title: "Next",
                  btnColor: model.p2uAmount == null || model.p2uAmount == ""
                      ? Color(0xffDCDEE6)
                      : bluishColor,
                  textColor: Colors.white,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  confirmationDailgue(BuildContext context, P2PProvider model) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "are_you_sure".tr,
                style: poppinsTextStyle(14, FontWeight.w500, greyColor100),
              ),
              SizedBox(
                height: 30,
              ),
              Text("are_you_sure_you_want_to_proceed_with_the_transaction".tr),
              SizedBox(
                height: 20,
              ),
              Divider(
                height: 4,
                color: Colors.grey,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("close".tr)),
                    InkWell(
                      onTap: () async {
                        /*await model.buyP2U(
                          context,
                          getTitle == "Buy" ? true : false,
                          getIndexTitle,
                        );*/
                        Get.until(
                            (route) => Get.currentRoute == '/P2PUserScreen');
                      },
                      child: Text(
                        "yes_i_am_sure".tr,
                        style: TextStyle(color: bluishColor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
