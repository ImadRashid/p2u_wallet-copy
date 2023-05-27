import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/services/API/user_api_service.dart';
import 'package:p2u_wallet/v2/core/services/api_services.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:p2u_wallet/v2/ui/widgets/password_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/colors.dart';
import '../../../core/device_type.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/models/user_model.dart';
import '../../components/custom_snackbar.dart';
import 'package:flutter/material.dart';

/// A [ViewModel] that handles data between [Model]s and our [View] which
/// here is [HomeScreen]

class HomeScreenProvider extends BaseViewModal {
  /// [AuthServices] object
  final locateUser = locator<AuthServices>();

  /// [DeviceType] object that handles [Device]'s dimension.
  final locateSize = locator<DeviceType>();

  /// [APIServices] object that handles [API] requests
  final _apiServices = ApiServices();

  /// [MyAppUser] object that handles [User]'s data
  UserModel myAppUser = UserModel();

  /// [Integer] value that changes [Image] Index
  int imageIndex = 0;

  /// [Double] to store total balance
  var availableBalance = 0.00;

  /// value that stores trend values
  var trendValue = 0.00;

  UserAPIServices _userAPI = UserAPIServices();

  IconData trendIcon = Icons.trending_up;
  Color trendColor = successColor30;

  /// [List] of type [string] that helps in handling
  /// password attempts;
  /// - [Index] 0 represents barcode screen
  /// - [Index] 1 represents swap screen
  /// - [Index] 2 represents setting screen
  List<List<String>> passwordAttempts = [];

  /// [Function] that accepts an [argument] of type [integer] and
  /// changes the [Image] index with that [argument]
  changeImageIndex(int x) {
    imageIndex = x;
    notifyListeners();
  }

  /// A [constructor] that calls the [init] function to
  /// initialize the values.
  HomeScreenProvider() {
    init();
  }

  /// [Function] that initialize with:
  /// - [fetchNewBalances]
  /// - [fetchPrices]
  /// - [myAppUser]
  init() async {
    //Stagging and Dev Env Check
    checkEnv();

    setState(ViewState.busy);
    // fetch new balances
    await fetchNewBalances();
    // assign new myAppUser
    myAppUser = locateUser.myAppUser;

    setState(ViewState.idle);
  }

  checkEnv() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // executes after build

      if (EndPoints.baseUrl.contains("dev-p2u-api")) {
        showPersistentSnackBar(
          "dev_env_label".tr,
          "dev_env".tr + "persistent_common_msg".tr,
        );
      } else if (EndPoints.baseUrl.contains("stg-p2u-api")) {
        showPersistentSnackBar(
          "stg_env_label".tr,
          "stg_env".tr + "persistent_common_msg".tr,
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('warning_message');
        if (!prefs.containsKey('warning_message')) {
          showCustomBetaSnackBar();
          prefs.setBool('warning_message', false);
        }
      }
    });
  }

  /// [Function] that fetches the [Token] balances from
  /// the [API]
  fetchNewBalances() async {
    try {
      final userTokens = await _userAPI.fetchCurrentUserTokens();
      final pricesData = await _apiServices.getPricesAPi();
      if (userTokens != false && pricesData != false) {
        await locateUser.myAppUser
            .updateTokenInfo(userTokens, pricesData["tokens"]);
      }
      myAppUser = locateUser.myAppUser;
      notifyListeners();
    } catch (e, stacktrace) {
      log("catch ${e.toString()}");
      debugPrint(stacktrace.toString());
    }
  }

  Stream<void> fetchLiveBalanceAndTrend() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) async {
      await fetchNewBalances();
    }).asyncMap((event) async => await event);
  }

  /// Function that will issue a request to RPA Device
  /// RPA Device will calculate the user cashbacks
  ///
  syncBalanceCallRPA(BuildContext context) async {
    try {
      final result = await _apiServices.refreshBalanceRPA();
      if (result) {
        showToast(message: "balance_sync".tr);
      }
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }
}
