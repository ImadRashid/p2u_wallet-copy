import 'package:p2u_wallet/v2/ui/screens/splash_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DeepLinkPayment {
  String? requestKey;
  bool hasDeepLink = false;
  bool isConnection = false;
  DeepLinkPayment() {
    init();
  }

  init() async {
    await initDynamicLinks();
  }

  reset() {
    //Execute this on refusal to a transaction
    hasDeepLink = false;
    isConnection = false;
    requestKey = null;
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    genericFunctionality(initialLink);
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      genericFunctionality(dynamicLinkData);
    }).onError((error) {
      // Handle errors
      debugPrint(error);
    });
  }

  void genericFunctionality(initialLink) {
    if (initialLink != null) {
      if (initialLink.link.hasQuery) {
        Map data = initialLink.link.queryParameters;
        isConnection = data.containsKey("request_id");
        requestKey = isConnection ? data["request_id"] : data["request_key"];
        hasDeepLink = true;
        Get.to(() => SplashScreenV2());
      }
    } else {
      debugPrint("No Initial Deep Link");
    }
  }
}
