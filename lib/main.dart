import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:p2u_wallet/firebase_options.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/constants/static_values.dart';
import 'package:p2u_wallet/v2/ui/components/restart_widget.dart';
import 'package:p2u_wallet/v2/ui/screens/p2p/p2p_listing/p2p_user_screen_provider.dart';
import 'package:p2u_wallet/v2/ui/screens/payment/mobile_payment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import './firebase_options.dart';
import './v2/ui/screens/p2p/p2p_provider.dart';
import './v2/ui/screens/splash_screen.dart';
import 'v2/core/config/app_theme.dart';
import 'locator.dart';
import 'v2/core/localization/languages.dart';
import 'v2/ui/screens/homescreen/homescreen_provider.dart';

/// [GlobalKey] that is used for [snackbar] messages
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

/// [Locale] to handle the [App]'s localization
Locale? locale;

/// [SharedPreferences] that handle [LocalStorage]
SharedPreferences? prefs;

/// [dynamic] variable to that handles the app language
var language;

/// [Function] which is the start point of the [Application]
void main() async {
  // Binding to handle widget tree
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Initialize Firebase App
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // initialize SharedPreferences with an instance
  prefs = await SharedPreferences.getInstance();
  // fetch the app language from local storage
  language = prefs!.getString('lang');
  // if there is no language fetched
  if (language == null) {
    // assign device locale to the app locale
    // i.e. use device's preferred language in
    // your application
    locale = languageCodeMapping[Get.deviceLocale!.languageCode];
    debugPrint("Device Locale : $locale");
  } else {
    debugPrint("App Language is : " + language);
    // assign respective locale from LocaleMap with respect
    // to language
    locale = localeMapping[language];
  }
  // Initialize Locator

  await setupLocator();

  // execute main application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => P2PProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => HomeScreenProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => P2pUserScreenProvider(),
            ),
          ],
          child: RestartWidget(
            child: GetMaterialApp(
              title: "P2U Wallet",
              // assign snack bar
              scaffoldMessengerKey: snackbarKey,
              // set debug banner to false
              debugShowCheckedModeBanner: false,
              // set languages
              translations: Languages(),
              // set application locale
              locale: locale,
              // set callback locale to English
              fallbackLocale: const Locale('en', 'US'),
              // Set app theme
              theme: AppTheme.lightTheme,
              // Set color to Primary Color
              color: primaryColor70,
              // Set home Screen
              home: SplashScreenV2(),
              // Named Routes
              routes: {
                MobilePaymentScreen.id: (context) => MobilePaymentScreen()
              },
            ),
          ),
        );
      },
    );
  }
}
