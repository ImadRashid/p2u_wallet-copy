import 'dart:convert';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/services/API/wallet_api_service.dart';
import 'package:p2u_wallet/v2/core/services/deep_link_payment.dart';
import 'package:p2u_wallet/v2/core/services/local_auth.dart';
import 'package:get/get.dart';
import '../../../../locator.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/password_model.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/services/API/user_api_service.dart';
import '../../../core/services/auth_services.dart';
import '../../../core/services/locator_services/password_attempt.dart';
import '../fallback_error/fallback_error_screen.dart';

class MobilePaymentProvider extends BaseViewModal {
  /// [PasswordModel] object to handle:
  /// - [totalAttempts] for password verification
  /// - [passwordController] for password [TextInput] controller
  PasswordModel passwordData = PasswordModel();

  /// [WalletAPIServices] that handles [API] requests related to [User]'s wallet
  WalletAPIServices _walletAPI = WalletAPIServices();

  /// [UserAPIServices] that handles [API] request related to [User]'s account
  UserAPIServices _userAPI = UserAPIServices();

  /// [AuthServices] that handles [User]'s data
  final _auth = locator<AuthServices>();

  /// [BiometricAuthenticationService] that handles [User]'s biometric authentication
  BioMetricAuthenticationServices bioMetricServices =
      locator<BioMetricAuthenticationServices>();

  /// a [boolean] loading flog
  bool loader = false;

  /// a [boolean] authentication flag
  bool isAuthenticated = false;

  TransactionData? paymentData;

  bool noRequestKey = false;

  bool borderRed = false;

  /// [Constructor] that initializes important [data] members
  MobilePaymentProvider() {
    init();
  }

  void init() async {
    await fetchPaymentRequestData();
    isAuthenticated = false;
    loader = false;
    passwordData = PasswordModel();
  }

  /// [Function] that changes loader value based on the provided argument [v]
  changeLoading(v) {
    loader = v;
    notifyListeners();
  }

  /// [Function] that fetches the payment request data from the
  /// server based on request key sent along the deep link
  fetchPaymentRequestData() async {
    changeLoading(true);
    var requestKey;
    if (locator<DeepLinkPayment>().hasDeepLink) {
      requestKey = locator<DeepLinkPayment>().requestKey;
      noRequestKey = false;
    } else {
      noRequestKey = true;
      changeLoading(false);
      return;
    }
    var response =
        await _walletAPI.fetchWalletRequestDataAPI(requestKey: requestKey);

    if (!response['error']) {
      paymentData = TransactionData.fromJson(jsonDecode(response['msg']));
    } else {
      Get.to(() => FallbackErrorScreen(error: 404, msg: response["msg"]));
    }
    changeLoading(false);
  }

  /// [Function] that handles the fingerprint authentication and than in success
  /// case complete transaction request.
  performTransactionWithFingerprint() async {
    changeLoading(true);
    // Authenticate fingerprint
    isAuthenticated = await bioMetricServices.authenticateUser();
    if (isAuthenticated) {
      // Complete transaction request
      return await completeRequest();
    }
    changeLoading(false);
    return {"msg": "fingerprint_failed", "color": dangerColor10};
  }

  performTransactionWithPassword() async {
    changeLoading(true);
    var response;
    List<String> passwordAttempts =
        locator<PasswordAttempt>().getPasswordAttemptsData(0);
    if (passwordAttempts[0] == "false") {
      if (passwordData.totalAttempts > 1) {
        final result = await passwordAuthentication();
        if (result == false) {
          borderRed = true;
          response = {"msg": "wrong_password".tr, "color": dangerColor10};
        } else {
          borderRed = false;
          response = result;
        }
      } else {
        locator<PasswordAttempt>().setPasswordAttemptsData(
            "barcode", true, DateTime.now().toString());
        response = {"msg": "pass_limit_reached".tr, "color": dangerColor10};
      }
    } else {
      passwordData.totalAttempts = 0;
      String timestamp = passwordAttempts[1];
      int diff = DateTime.now().difference(DateTime.parse(timestamp)).inMinutes;
      if (diff < 5) {
        response = {
          "msg": "try_again_msg_1".tr + " ${5 - diff} " + "try_again_msg_2".tr,
          "color": dangerColor10
        };
      } else {
        passwordData.totalAttempts = 10;
        locator<PasswordAttempt>()
            .setPasswordAttemptsData("barcode", false, "null");
      }
    }
    changeLoading(false);

    return response;
  }

  /// [Function] that handles the password verification and than in success
  /// case complete transaction request.
  passwordAuthentication() async {
    changeLoading(true);
    // Verify user password
    isAuthenticated = await _userAPI.validateUser(
        // user email
        email: _auth.myAppUser.email!,
        // user password
        password: passwordData.passwordController.text);
    if (isAuthenticated) {
      // complete transaction request
      return await completeRequest();
    } else {
      passwordData.reduceAttempts();
    }
    changeLoading(false);
    return false;
  }

  /// [Function] that handles the complete request API from wallet
  /// to confirm transaction request
  completeRequest() async {
    changeLoading(true);
    var response = await _walletAPI.completeRequestAPI(
      requestKey: paymentData!.requestPlatform!.requestKey!,
    );
    changeLoading(false);
    if (!response['error']) {
      return {"reroute": "confirmed"};
    }

    return {"reroute": response['msg']['err']};
  }

  refusePayment() {
    Get.back();
  }
}
