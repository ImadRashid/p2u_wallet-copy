import 'package:p2u_wallet/v2/ui/widgets/history_widgets/rich_text_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/functions.dart';
import '../../../core/constants/style.dart';
import '../../../core/models/history.dart';
import '../divider_widget.dart';

/// A [widget] made up of [StatelessWidget] that creates a
/// [Card] widget for [HistoryList] and returns it
class HistoryListCard extends StatelessWidget {
  /// A [constructor] that accepts an object [transaction] of
  /// type [Transactions]
  const HistoryListCard({Key? key, required this.transaction})
      : super(key: key);

  /// A [transactions] object that stores the current [data] in
  /// the [HistoryList] sent as an argument
  final Transactions transaction;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: greyColor20),
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ListTile to show token image, token name and transaction timestamp
            ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 32,
              visualDensity: VisualDensity(horizontal: -4),
              dense: true,
              // Token Image
              leading: Image.asset("assets/v2/p2up.png", scale: 1.2),
              // Token name
              title: Text(
                "${transaction.currency!}",
                style: poppinsTextStyle(16, FontWeight.w500, greyColor100),
              ),
              // Transaction timestamp
              trailing: Text(
                convertOrderTimeStampToTimeFormat(transaction.createDate!),
                style: poppinsTextStyle(12, FontWeight.w500, greyColor50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: DividerWidget(),
            ),
            // Show +/- and color on the basis off transaction type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ((transaction.type! == "in" || transaction.type! == "mint")
                          ? "+"
                          : "-") +
                      transaction.amount!,
                  style: (transaction.type! == "in" ||
                          transaction.type! == "mint")
                      ? poppinsTextStyle(20, FontWeight.w500, successColor30)
                      : poppinsTextStyle(20, FontWeight.w500, dangerColor10),
                ),
                Container(
                  height: 24,
                  width: 60,
                  decoration: BoxDecoration(
                      color: greyColor10,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Text(transaction.txAction!.toUpperCase(),
                          style: poppinsTextStyle(
                              12, FontWeight.w500, greyColor60)),
                    ),
                  ),
                ),
              ],
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 12)),
            //Transaction Hash
            if (transaction.txHash! != "")
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RichTextHistoryWidget(
                    first: "Tx", second: transaction.txHash!),
              ),
            //From wallet and To wallet
            Row(
              children: [
                Expanded(
                    child: RichTextHistoryWidget(
                        first: "from".tr, second: transaction.from!)),
                Expanded(
                    child: RichTextHistoryWidget(
                        first: "to".tr, second: transaction.to!)),
              ],
            ),
            //Transaction type
            if (transaction.type != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  children: [
                    Text(
                      transaction.type! == "out" ? "out".tr : "in".tr,
                      textAlign: TextAlign.left,
                      style:
                          poppinsTextStyle(14, FontWeight.w500, greyColor100),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
