import 'package:flutter/cupertino.dart';
import '../../../../locator.dart';
import '../../../core/enums/view_state.dart';
import '../../../core/models/base_view_model.dart';
import '../../../core/services/API/user_api_service.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_services.dart';

/// A [ViewModel]/[ScreenProvider] that fetches data from [API]s and [Model]
/// and transmits data to [View]  which here is [WalletTermination]

class WalletTerminationProvider extends BaseViewModal {
  /// [UserAPIService] object that handles [User] related [API]s
  final _userAPIService = UserAPIServices();

  /// [AuthServices] object that handles [User]authentications.
  final locateUser = locator<AuthServices>();

  /// [Boolean] flag whether to show [password] or not.
  bool? isObscure;

  /// [Boolean] flag whether to enable [OK] button or not.
  bool? isEnabled;

  /// [TextEditingController] variable controls [password]
  TextEditingController? passwordController;

  /// [Function] that [Show] or [Hide] the password.
  showHidePassword() {
    isObscure = !isObscure!;
    notifyListeners();
  }

  /// [Function] that changes [isEnabled]
  changeEnabled(bool value) {
    isEnabled = value;
    notifyListeners();
  }

  /// [Constructor] that initializes some of the [Data] members.
  WalletTerminationProvider() {
    isObscure = true;
    isEnabled = false;
    passwordController = TextEditingController();
  }

  /// [Function] that and validates [user] and than deletes that wallet.
  deleteCurrentUser() async {
    setState(ViewState.busy);
    // validate user
    final validUser = await _userAPIService.validateUser(
        email: locateUser.firebaseUser!.email!,
        password: passwordController!.text);
    // check if user is valid
    if (validUser) {
      // delete user
      final response = await _userAPIService.deleteUser();
      // check if successfully deleted
      if (response) {
        // show Successful response in snack bar
        Get.snackbar(
            "wallet_termination_screen".tr, "wallet_successfully_terminated".tr,
            snackPosition: SnackPosition.BOTTOM);
        // and logout the user from the app.
        locateUser.logout();
      } else {
        // if not successful than show failed response
        Get.snackbar(
            "wallet_termination_screen".tr, "wallet_termination_failed".tr,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      // if validation failed show invalid password.
      Get.snackbar("wallet_termination_screen".tr, "invalid_password".tr,
          snackPosition: SnackPosition.BOTTOM);
    }
    setState(ViewState.idle);
  }

  /// [Function] that disposes of all initialized values.
  disposeData() {
    isObscure = null;
    isEnabled = null;
    passwordController = null;
  }
}
