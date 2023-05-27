import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/enums/view_state.dart';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/models/order_model.dart';
import 'package:p2u_wallet/v2/core/services/api_services.dart';
import 'package:p2u_wallet/v2/core/services/API/order_api_service.dart';
import 'package:p2u_wallet/v2/ui/screens/fallback_error/fallback_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/device_type.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_services.dart';
import 'package:flutter/material.dart';

class P2PProvider extends BaseViewModal {
  String btnStatus = "Buy";
  int currentTab = 0;
  List<String> tokens = ['MSQP', 'P2UP'];

  final apiServices = ApiServices();
  final orderApiService = OrderAPIService();
  final locateUser = locator<AuthServices>();
  UserModel myAppUser = UserModel();

  List<OrdersData> myOrdersDataList = [];

  List<OrdersData> buyTokenOrdersDataList = [];
  List<OrdersData> sellTokenOrdersDataList = [];

  ScrollController buyController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false);
  ScrollController sellController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false);

  List<bool> allOrdersFetched = [false, false];
  bool myOrdersFetched = false;
  var lastKey;

  final locateSize = locator<DeviceType>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String? p2uAmount;

  changeTab(int x) async {
    currentTab = x;
    lastKey = null;
    await reset();
    await fetchAllOrdersData();
    notifyListeners();
  }

  P2PProvider();
  initScrollControllers() {
    buyController =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false)
          ..addListener(() {
            if (buyController.position.pixels ==
                buyController.position.maxScrollExtent) {
              if (!allOrdersFetched[currentTab]) {
                fetchAllOrdersData(isLazy: true);
              }
            }
          });
    sellController =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false)
          ..addListener(() {
            if (sellController.position.pixels ==
                sellController.position.maxScrollExtent) {
              if (!allOrdersFetched[currentTab]) {
                fetchAllOrdersData(isLazy: true);
              }
            }
          });
    notifyListeners();
  }

  changeScrollControllers() {
    if (buyController.hasClients) {
      buyController.jumpTo(0.0);
    }
    if (sellController.hasClients) {
      sellController.jumpTo(0.0);
    }
  }

  init() {
    currentTab = 0;
    lastKey = null;
    sellTokenOrdersDataList = [];
    buyTokenOrdersDataList = [];
    for (var i = 0; i < allOrdersFetched.length; ++i) {
      allOrdersFetched[i] = false;
    }
    notifyListeners();
  }

  reset() async {
    lastKey = null;
    sellTokenOrdersDataList = [];
    buyTokenOrdersDataList = [];
    for (var i = 0; i < allOrdersFetched.length; ++i) {
      allOrdersFetched[i] = false;
    }
    //notifyListeners();
  }

  //Fetch All Orders other the current user
  fetchAllOrdersData({bool isLazy = false}) async {
    if (!isLazy) {
      buyTokenOrdersDataList = [];
      sellTokenOrdersDataList = [];
      setState(ViewState.busy);
    }
    try {
      var res = await orderApiService.fetchAllOrders(
          currency: tokens[currentTab], isCompleted: false, lastKey: lastKey);
      //print(res);
      if (res[0] != 200 && res[0] != "1F2E") {
        Get.to(() => FallbackErrorScreen(error: res[0], msg: res[1]));
      } else if (res[0] == 200 && res[1] != []) {
        for (var value in res[1]["data"]) {
          if (value['isBuy']) {
            sellTokenOrdersDataList.add(OrdersData.fromJson(value));
          } else {
            buyTokenOrdersDataList.add(OrdersData.fromJson(value));
          }
        }
        if (res[1]["lastKey"] == null) {
          allOrdersFetched[currentTab] = true;
          lastKey = null;
        } else {
          lastKey = res[1]["lastKey"];
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(ViewState.idle);
    }
    setState(ViewState.idle);
  }

  showSuccessfulSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "order_completed".tr,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  getAmounts(var x) {
    p2uAmount = x;
    notifyListeners();
  }

  changeBtnStatus(var getStatus) {
    //print(getStatus);
    changeScrollControllers();
    btnStatus = getStatus;
    notifyListeners();
  }
}
