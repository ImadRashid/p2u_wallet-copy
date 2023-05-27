import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/p2p/p2p_provider.dart';
import '../buy&sell_widget.dart';
import 'order_list_widget.dart';

class AssetTokenWidget extends StatefulWidget {
  const AssetTokenWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AssetTokenWidget> createState() => _AssetTokenWidgetState();
}

class _AssetTokenWidgetState extends State<AssetTokenWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<P2PProvider>(
      builder: (context, model, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: BuyAndSellWidget(),
              ),
              model.btnStatus == "Buy"
                  ? OrderListWidget(
                      model: model,
                      orderFetched: model.allOrdersFetched[model.currentTab],
                      orderList: model.buyTokenOrdersDataList,
                      scrollController: model.buyController,
                    )
                  : OrderListWidget(
                      model: model,
                      orderFetched: model.allOrdersFetched[model.currentTab],
                      orderList: model.sellTokenOrdersDataList,
                      scrollController: model.sellController,
                    ),
            ],
          ),
        );
      },
    );
  }
}
