import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../widgets/p2p_widgets/custom_circular_indicator.dart';
import '../p2p_create_ad/create_p2p_ad_screen.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/functions.dart';
import '../../../widgets/p2p_widgets/p2p_listing_card.dart';
import 'p2p_user_screen_provider.dart';

class P2PUserScreen extends StatefulWidget {
  const P2PUserScreen({Key? key}) : super(key: key);

  @override
  State<P2PUserScreen> createState() => _P2PUserScreenState();
}

class _P2PUserScreenState extends State<P2PUserScreen> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => P2pUserScreenProvider(),
      child: Consumer<P2pUserScreenProvider>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("p2p_listings".tr),
            bottom: PreferredSize(
              child: Divider(
                color: greyColor20,
                height: 1,
                thickness: 1,
              ),
              preferredSize: Size.fromHeight(1.0),
            ),
          ),
          body: model.isLoading
              ? Center(child: CircularProgressIndicator())
              : model.myOrdersDataList.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/v2/empty.svg"),
                          Text("p2p_listings_empty".tr)
                        ],
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 18),
                      color: greyColor0,
                      child: ListView.builder(
                          controller: controller
                            ..addListener(() {
                              if (controller.position.pixels ==
                                  controller.position.maxScrollExtent) {
                                if (!model.myOrdersFetched) {
                                  model.fetchDataForAllTokens(isLazy: true);
                                }
                              }
                            }),
                          itemCount: model.myOrdersDataList.length + 1,
                          itemBuilder: (context, index) {
                            if (index < model.myOrdersDataList.length) {
                              var value = model.myOrdersDataList[index];
                              return P2PListingCard(
                                order: value,
                                onPressed: () {
                                  confirmationDialogue(
                                      context, model, value.id!);
                                },
                                timestamp: convertOrderTimeStampToTimeFormat(
                                    value.createdAt!),
                              );
                            } else if (index >= model.myOrdersDataList.length &&
                                !model.myOrdersFetched) {
                              return CustomCircularIndicator();
                            } else {
                              return Text("");
                            }
                          }),
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(
                () => CreateP2PAdScreen(),
              );
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: primaryColor70,
            elevation: 0,
            child: Icon(Icons.add, size: 24),
          ),
        );
      }),
    );
  }

  confirmationDialogue(BuildContext context, model, id) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setState) => AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "you_sure".tr,
                style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
              ),
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
              Text("really_sure".tr,
                  style: poppinsTextStyle(14, FontWeight.w500, greyColor50)),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            MaterialButton(
              minWidth: 130.h,
              height: 50,
              shape:
                  RoundedRectangleBorder(side: BorderSide(color: bluishColor)),
              onPressed: () {
                Get.back();
              },
              color: Colors.white,
              child: Text(
                "cancel".tr,
                style: TextStyle(color: bluishColor),
              ),
            ),
            MaterialButton(
              minWidth: 130.h,
              height: 50,
              onPressed: () {
                model.deleteOrderForCurrentUser(context, id);
                Get.back();
              },
              child: Text(
                "i_sure".tr,
                style: TextStyle(color: Colors.white),
              ),
              color: bluishColor,
            )
          ],
        ),
      ),
    );
  }
}
