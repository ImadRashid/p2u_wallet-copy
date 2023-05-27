import 'package:flutter/material.dart';
import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/services/API/transaction_api_service.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:p2u_wallet/v2/core/services/locator_services/password_attempt.dart';
import '../../../core/constants/colors.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/models/password_model.dart';
import '../../../core/models/user_model.dart';
import 'package:get/get.dart';
import '../../../core/services/API/user_api_service.dart';
import '../../../core/services/local_auth.dart';

class TokenTransferProvider extends BaseViewModal {
  UserModel user = locator<AuthServices>().myAppUser;
  TextEditingController mailController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TransactionAPIServices _transactionAPI = TransactionAPIServices();
  bool isEnabled = false;
  bool loader = false;
  bool isAuthenticated = false;
  bool borderRed = false;
  PasswordModel passwordData = PasswordModel();

  /// [BiometricAuthenticationServices] variable that handles biometric authentications
  BioMetricAuthenticationServices _bioMetricServices =
      locator<BioMetricAuthenticationServices>();
  TokenTransferProvider();
  String? mailValidation(String? value) {
    if (value!.length == 0) {
      return "null_value".tr;
    } else {
      return null;
    }
  }

  /// [Function] to check if biometric services are enabled.
  bool isBioMetricEnabled() {
    return _bioMetricServices.isBioMetricEnabled;
  }

  String? amountValidation(String? value) {
    String? output;

    if (value!.isEmpty) {
      isEnabled = false;
      output = "null_value".tr;
    } else {
      if (RegExp(r'^(\d+(?:[\.])\d+?)$').hasMatch(value) ||
          RegExp(r'^(\d+)$').hasMatch(value)) {
        if (double.parse(value) >
            double.parse(user.wallet!.tokens!
                .firstWhere((element) => element.name == "P2UPB")
                .balance
                .toString())) {
          isEnabled = false;
          output = "not_enough_balance".tr;
        } else {
          isEnabled = mailController.text.isNotEmpty && true;
        }
      } else {
        output = "only_decimal_value".tr;
      }
    }

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    return output;
  }

  setMax() {
    amountController.text = user.wallet!.tokens!
        .firstWhere((element) => element.name == "P2UPB")
        .balance
        .toString();
    isEnabled = mailController.text.isNotEmpty;
    notifyListeners();
  }

  setReset() {
    isEnabled = false;
    clear();
    notifyListeners();
  }

  clear() {
    mailController.clear();
    amountController.clear();
  }

  changeLoading(v) {
    loader = v;
    notifyListeners();
  }

  Future tokenTransfer() async {
    String msg = "token_transferred";
    Color color = successColor30;
    var response = await _transactionAPI.tokenTransfer(
        token: "P2UPB",
        amount: double.parse(amountController.text),
        email: mailController.text);
    print(response);
    if (response["error"]) {
      msg = "token_not_transferred";
      color = dangerColor10;
    }
    return {
      "msg": msg,
      "color": color,
      "tokenTransfer": color == successColor30
    };
  }

  performTransactionWithFingerprint() async {
    changeLoading(true);
    setState(ViewState.busy);
    String msg = "fingerprint_failed";
    Color msgColor = dangerColor10;
    isAuthenticated = await _bioMetricServices.authenticateUser();
    if (isAuthenticated) {
      Get.back();
      var res = await tokenTransfer();
      msg = res["msg"];
      msgColor = res["color"];
    }
    changeLoading(false);
    setState(ViewState.idle);
    return {
      "msg": msg,
      "color": msgColor,
      "tokenTransfer": msgColor == successColor30
    };
  }

  Future<bool> validateUser() async {
    return await UserAPIServices().validateUser(
        email: user.email!, password: passwordData.passwordController.text);
  }

  performTransactionWithPassword() async {
    changeLoading(true);
    var response;
    var passwordAttempts =
        locator<PasswordAttempt>().getPasswordAttemptsData(1);
    if (passwordAttempts[0] == "false") {
      if (passwordData.totalAttempts > 1) {
        bool isAuthenticated = await validateUser();
        borderRed = !isAuthenticated;
        if (isAuthenticated) {
          response = await tokenTransfer();
          passwordData.passwordController.clear();
          passwordData.totalAttempts = 10;
        } else {
          passwordData.reduceAttempts();
          response = {"msg": "wrong_password".tr, "color": dangerColor10};
        }
      } else {
        locator<PasswordAttempt>()
            .setPasswordAttemptsData("swap", true, DateTime.now().toString());
        response = {"msg": "pass_limit_reached".tr, "color": dangerColor10};
      }
    } else {
      passwordData.totalAttempts = 0;
      int diff = DateTime.now()
          .difference(DateTime.parse(passwordAttempts[1]))
          .inMinutes;
      if (diff < 5) {
        response = {
          "msg": "try_again_msg_1".tr + "${5 - diff}" + "try_again_msg_2".tr,
          "color": dangerColor10
        };
      } else {
        passwordData.totalAttempts = 10;
        locator<PasswordAttempt>()
            .setPasswordAttemptsData("swap", false, "null");
        response = {"msg": "pass_limit_reset", "color": successColor30};
      }
    }
    changeLoading(false);
    return response;
  }
}
