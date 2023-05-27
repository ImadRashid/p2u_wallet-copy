import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:p2u_wallet/v2/core/config/app_theme.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/core/localization/languages.dart';
import 'package:p2u_wallet/v2/ui/components/restart_widget.dart';
import 'package:p2u_wallet/v2/ui/screens/homescreen/homescreen_provider.dart';
import 'package:p2u_wallet/v2/ui/screens/p2p/p2p_listing/p2p_user_screen_provider.dart';
import 'package:p2u_wallet/v2/ui/screens/p2p/p2p_provider.dart';
import 'package:p2u_wallet/v2/ui/screens/payment/mobile_payment.dart';
import 'package:p2u_wallet/v2/ui/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class LoadMyApp extends StatelessWidget {
  LoadMyApp({required this.widgetChild});
  final Widget widgetChild;
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

              // set debug banner to false
              debugShowCheckedModeBanner: false,
              // set languages
              translations: Languages(),
              // set application locale
              locale: Locale('en', 'US'),
              // set callback locale to English
              fallbackLocale: const Locale('en', 'US'),
              // Set app theme
              theme: AppTheme.lightTheme,
              // Set color to Primary Color
              color: primaryColor70,
              // Set home Screen
              home: widgetChild,
            ),
          ),
        );
      },
    );
  }
}
