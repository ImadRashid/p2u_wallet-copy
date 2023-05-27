import 'package:p2u_wallet/v2/core/device_type.dart';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/services/API/transaction_api_service.dart';
import 'package:p2u_wallet/v2/core/services/api_services.dart';
import 'package:flutter/material.dart';
import '../../../../locator.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/models/history.dart';
import 'package:flutter/material.dart';

/// A [ViewModel] that transmits data to our [View] which here is
/// [HistoryScreen].
class HistoryProvider extends BaseViewModal {
  /// A [ScrollController] that controls the [History] List
  ScrollController scrollController = ScrollController();

  /// A [boolean] that checks whether its [User]'s first time
  /// visiting this page or not;
  bool isFirstUser = false;

  /// A [HistoryResponse] object that handles the response generated from
  /// specific [API]
  HistoryResponse historyResponse = HistoryResponse();

  /// A [APIServices] object that handles any kind of API request for time being
  final apiServices = ApiServices();
  TransactionAPIServices _transactionAPI = TransactionAPIServices();

  /// A [DeviceType] locator object that gives the dimension of the screen
  final locateSize = locator<DeviceType>();

  /// A [boolean] that acts as flag to let us know whether we are in any kind of
  /// [function] that is in the process fetching [data] and processing. if [true] than
  /// show appropriate [View] which in our case is [CircularProgressIndicator]
  bool isLoading = true;

  /// A [Transaction]'s [List] that stores the [History] which are fetched from the [API]
  List<Transactions> historyList = [];

  /// A [String] that stores the lastKey we received during the previous [data] fetch so
  /// next we can use this key to fetch next [data] chunk as we are handling [lazyLoading].
  String? lastId;

  /// A [boolean] value that check if we have any records remaining in the [database].
  bool endOfPage = false;

  /// A [constructor] that initializes:
  /// - the [ScrollController] with a listener
  /// - fetch [HistoryData] up to 5 records.
  HistoryProvider() {
    scrollController.addListener(_scrollListener);
    fetchHistory(count: 10);
  }

  /// [Function] that accepts:
  /// - [lastPageId] a nullable [String] which is the lastKey of the previous fetch records.
  /// - [count] a nullable [Integer] which is the count of records to be fetch
  ///
  /// and saves the records in [historyList] variable.
  fetchHistory({String? lastPageId, int? count, bool isLazy = false}) async {
    if (!isLazy) {
      setState(ViewState.busy);
    }

    try {
      var response = await _transactionAPI.fetchTransactionHistory(
        lastPageId: lastPageId,
        count: count,
      );

      if (response != false) {
        historyResponse = response as HistoryResponse;
        if (historyResponse.lastId == null) {
          endOfPage = true;
        }
        lastId = historyResponse.lastId;
        historyList = [...historyList, ...historyResponse.transactions!];
      } else {
        historyList = [];
      }
    } catch (e, stackTrace) {
      debugPrint("Error");
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
    }
    setState(ViewState.idle);
  }

  /// A [ScrollController] listener that checks if the we have not reached
  /// [endOfPage] than check if we are at the end of [Scroll] than fetch new
  /// [records]
  void _scrollListener() {
    //check if there is no lastKey
    if (!endOfPage) {
      //check if we are at the end of scroll
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        //fetch next five records.
        fetchHistory(lastPageId: lastId, count: 5, isLazy: true);
      }
    }
  }
}
