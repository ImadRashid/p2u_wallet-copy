import 'package:p2u_wallet/v2/core/device_type.dart';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/models/notification_model.dart';
import 'package:p2u_wallet/v2/core/services/api_services.dart';
import 'package:flutter/material.dart';
import '../../../../locator.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/models/history.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends BaseViewModal {
  ScrollController scrollController = ScrollController();
  bool isFirstUser = false;

  bool error = false;

  NotificationResponse notificationResponse = NotificationResponse();
  final apiServices = ApiServices();
  final locateSize = locator<DeviceType>();
  bool isLoading = true; //
  List<Transactions> notificationList = [];
  String? lastId;
  bool endOfPage = false;
  NotificationProvider();

  fetchHistory({String? lastPageId, int? count, bool isLazy = false}) async {
    if (!isLazy) {
      setState(ViewState.busy);
    }

    try {
      //TODO implement getNotification
      notificationResponse = await apiServices.getHistory(
        lastPageId: lastPageId,
        count: count,
      );
      if (notificationResponse.lastId == null) {
        endOfPage = true;
      }
      lastId = notificationResponse.lastId;
      //TODO implement this
      // notificationList = [...notificationList, ...notificationResponse.msg!];
      error = false;
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("error");
      error = true;
    }
    setState(ViewState.idle);
    isLoading = false;
  }

  void _scrollListener() {
    if (!endOfPage) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        fetchHistory(lastPageId: lastId, count: 5, isLazy: true);
      }
    }
  }
}
