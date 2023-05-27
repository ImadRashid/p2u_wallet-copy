import 'package:get_it/get_it.dart';
import 'package:p2u_wallet/v2/core/device_type.dart';
import 'package:p2u_wallet/v2/core/services/deep_link_payment.dart';
import 'package:p2u_wallet/v2/core/services/locator_services/internet_connectivity_service.dart';
import 'package:p2u_wallet/v2/core/services/locator_services/password_attempt.dart';
import 'package:flutter/material.dart';
import './v2/core/services/auth_services.dart';
import './v2/core/services/local_auth.dart';

GetIt locator = GetIt.instance;

setupLocator() async {
  debugPrint("locator services calling");
  // locator.registerLazySingleton(() => InternetConnectivityService());
  locator.registerSingleton(InternetConnectivityService());
  locator.registerLazySingleton(() => PasswordAttempt());
  locator.registerSingleton(BioMetricAuthenticationServices());
  locator.registerLazySingleton(() => AuthServices());
  locator.registerSingleton(DeviceType());
  locator.registerSingleton(DeepLinkPayment());
}
