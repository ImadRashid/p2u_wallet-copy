import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/services/API/order_api_service.dart';
import 'package:flutter/material.dart';
import '../../../../../locator.dart';
import '../../../../core/enums/view_state.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_services.dart';
import 'package:get/get.dart';
import '../../fallback_error/fallback_error_screen.dart';

class P2pUserScreenProvider extends BaseViewModal {
  List<String> tokens = ['MSQP', 'P2UP'];

  final orderApiService = OrderAPIService();
  final locateUser = locator<AuthServices>();
  UserModel myAppUser = UserModel();

  List<OrdersData> myOrdersDataList = [];
  bool myOrdersFetched = false;
  List<bool> tokenOrdersFetched = [false, false];
  List lastKey = [null, null];
  bool isLoading = false;

  P2pUserScreenProvider() {
    reset();
  }
  changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  reset() {
    for (int i = 0; i < tokenOrdersFetched.length; ++i) {
      tokenOrdersFetched[i] = false;
      lastKey[i] = null;
    }
    isLoading = false;
    myOrdersFetched = false;
    myOrdersDataList = [];
    fetchDataForAllTokens();
    notifyListeners();
  }

  fetchDataForAllTokens({bool isLazy = false}) async {
    if (!isLazy) {
      myOrdersDataList = [];
      changeLoading();
      notifyListeners();
    }
    for (int i = 0; i < tokens.length; ++i) {
      if (!tokenOrdersFetched[i]) {
        await fetchMyOrdersData(tokens[i], i);
      }
    }
    int count = 0;
    for (int i = 0; i < tokens.length; ++i) {
      count += tokenOrdersFetched[i] ? 1 : 0;
    }
    myOrdersFetched = count == tokens.length ? true : false;
    if (!isLazy) {
      changeLoading();
      notifyListeners();
    }
  }

  //Fetch My Orders
  Future<void> fetchMyOrdersData(String token, int i) async {
    //Fetch Records
    try {
      var res = await orderApiService.fetchMyOrders(
          currency: token, isCompleted: false, lastKey: lastKey[i]);
      if (res[0] != 200 && res[0] != "1F2E") {
        Get.to(() => FallbackErrorScreen(error: res[0], msg: res[1]));
      } else if (res[0] == 200 && res[1] != []) {
        for (var value in res[1]["data"]) {
          myOrdersDataList.add(OrdersData.fromJson(value));
        }
        if (res[1]["lastKey"] == null) {
          tokenOrdersFetched[i] = true;
        } else {
          lastKey[i] = res[1]["lastKey"];
        }
        //print("Last Key : " + lastKey[i].toString());
        setState(ViewState.idle);
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(ViewState.idle);
    }
    setState(ViewState.idle);
  }

  //Delete My Orders
  void deleteOrderForCurrentUser(context, String orderID) async {
    changeLoading();
    try {
      var res = await orderApiService.deleteMyOrder(orderID: orderID);
      String msg = "order_cannot_be_deleted".tr;
      Color color = Colors.red;
      if (res) {
        reset();
        msg = "order_successfully_deleted".tr;
        color = Colors.green;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: TextStyle(color: color),
          ),
        ),
      );
      changeLoading();
    } catch (e) {
      debugPrint(e.toString());
      changeLoading();
    }
    changeLoading();
  }
}
