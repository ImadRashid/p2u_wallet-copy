import 'package:p2u_wallet/v2/core/enums/view_state.dart';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:p2u_wallet/v2/core/services/deep_link_payment.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/createid/create_id.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../locator.dart';
import '../../payment/mobile_payment.dart';

/// [LoginProvider] acts as a [ViewModel] and transmits data to
/// our [View] which in here is [LoginScreen]
class LoginProvider extends BaseViewModal {
  /// [AuthServices] object to perform different authentication like
  /// [Google], [Apple] and [Facebook].
  final AuthServices _authServices = locator<AuthServices>();

  /// [Function] that deals [SignIn] with [Google]
  signInWithGoogle(BuildContext context) async {
    setState(ViewState.busy);
    // Calls SignInWithGoogle function from AuthServices object.
    final result = await _authServices.signInWithGoogle(context);
    if (result == null) {
      setState(ViewState.idle);
    } else {
      nextStep(result);
    }
    setState(ViewState.idle);
  }

  /// [Function] that deals [SignIn] with [Facebook]
  signInWithFacebook(BuildContext context) async {
    setState(ViewState.busy);
    // Calls SignInWithFacebook function from AuthServices object.
    final result = await _authServices.signInWithFacebook(context);

    if (result == null) {
      setState(ViewState.idle);
    } else {
      nextStep(result);
    }

    setState(ViewState.idle);
  }

  /// [Function] that deals [SignIn] with [Apple]
  signInWithApple(BuildContext context) async {
    debugPrint("Apple Login clicked");
    setState(ViewState.busy);
    // Calls SignInWithApple function from AuthServices object.
    final result = await _authServices.signInWithApple();

    if (result == null) {
      setState(ViewState.idle);
    } else {
      nextStep(result);
    }
    setState(ViewState.idle);
  }

  /// [Function] that is the next part after [SignIn] with
  /// social media logins.
  void nextStep(bool step) {
    if (step) {
      //if successful move to home screen
      if (locator<DeepLinkPayment>().hasDeepLink) {
        Get.offAll(() => MobilePaymentScreen());
      } else {
        Get.offAll(() => BottomNavigation(indexValue: 0));
      }
    } else {
      //to CreateIDScreen otherwise.
      Get.offAll(CreateIdScreen());
      debugPrint("Logged in Failed");
    }
  }
}
