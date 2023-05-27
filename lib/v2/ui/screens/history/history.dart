import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/enums/view_state.dart';
import 'package:p2u_wallet/v2/ui/screens/history/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/history_widgets/history_list_card.dart';
import '../../widgets/p2p_widgets/custom_circular_indicator.dart';

/// A [View] or [Screen] made up of [StatefulWidget] that displays the
/// all [transactions] and [order] like [buy], [sell], [swap] and [QRCode].
class HistoryScreen extends StatefulWidget {
  /// Displays all the [transaction] and [order] like [buy], [sell], [swap] and [QRCode].
  const HistoryScreen();

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryProvider(),
      child: Consumer<HistoryProvider>(
        builder: (context, model, child) {
          return Scaffold(
            //custom app bar
            appBar: customAppBar("transaction_history",
                elevation: 0, isBottomBorder: true),
            body: ModalProgressHUD(
              progressIndicator: CircularProgressIndicator(
                color: primaryColor70,
              ),
              inAsyncCall: model.state == ViewState.busy,
              child: model.historyList.length == 0
                  ? firstUserWidget(model)
                  : //Show History data list
                  Container(
                      color: greyColor10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          historyList(model),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  /// [Function] that an shows a [EmptyHistory] widget if it
  /// is [User]'s first time visiting the [HistoryScreen]
  Widget firstUserWidget(model) {
    return Container(
      color: greyColor10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: SizedBox()),
          //Empty History List Image
          Center(child: Image.asset("assets/my_icons/emptyhistory.png")),
          //Empty History Message label
          Center(child: Text("history_list_empty".tr)),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  /// [Function] that accepts an argument [model] of type
  /// [HistoryProvider] and returns [ListView] widget with [History]
  /// data
  Widget historyList(HistoryProvider model) {
    return Expanded(
      child: Container(
        // padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ListView.builder(
          controller: model.scrollController,
          itemCount: model.historyList.length + 1,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            // check if historyList current index is
            // less than current list length than render
            // or show circular progress indicator otherwise
            if (index < model.historyList.length) {
              var value = model.historyList[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: HistoryListCard(transaction: value),
              );
            } else if (index > 4 && !model.endOfPage) {
              return CustomCircularIndicator();
            } else {
              return Text("");
            }
          },
        ),
      ),
    );
  }
}
