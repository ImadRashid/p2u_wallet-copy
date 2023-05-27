import 'dart:io';
import 'package:p2u_wallet/main.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/screens/authentications/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/keys_for_testing.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/enums/view_state.dart';
import '../../../widgets/custom_login_button.dart';

/// [LoginScreen] - A screen made with [StatefulWidget] that acts the first screen
/// for [Application] on startup.
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// [Stores] the value of [LanguageSelection]
  String dropDownValue = 'ENG';

  /// [SharedPreferences] object to retrieve stored data.
  final Future<SharedPreferences> myprefs = SharedPreferences.getInstance();

  /// [Function] accepts a value of [string] and in turn updates
  /// currently used [Language] and stores in local storage
  /// using [SharedPreferences].
  void onLanguageChanged(v) async {
    SharedPreferences prefs = await myprefs;
    String? lang;
    Locale? changeLocale;
    // Using Switch Case Instead of If-Else for Easy maintenance
    // Here, the changed Value is checked and according to its value
    // App language is changed.
    switch (v) {
      case 'CHN':
        lang = "Chinese";
        changeLocale = Locale('zh', 'CH');
        break;
      case 'JPN':
        lang = "Japanese";
        changeLocale = Locale('ja', 'JP');
        break;
      case 'KOR':
        lang = "Korean";
        changeLocale = Locale('ko', 'KR');
        break;
      default:
        lang = "English";
        changeLocale = Locale('en', 'US');
    }

    //Local Preferences are changed on the bases of language selection
    prefs.setString('lang', lang);

    //Current DropDown value and App language is changed on the basis of switch-case
    setState(() {
      dropDownValue = v!;
      Get.updateLocale(changeLocale!);
    });
  }

  /// [Function] that retrieves the [Language] stored in the local storage
  /// and on its basis assigns the drop down value to it.
  void languageSelection() async {
    SharedPreferences prefs = await myprefs;
    //retrieves stored language if there is any
    String deviceLocale = Get.deviceLocale!.languageCode;
    String tempLang = prefs.containsKey('lang') ? prefs.getString('lang')! : "";
    switch (tempLang) {
      case 'Chinese':
        tempLang = 'CHN';
        break;
      case 'Japanese':
        tempLang = 'JPN';
        break;
      case 'Korean':
        tempLang = 'KOR';
        break;
      case 'English':
        tempLang = 'ENG';
        break;
      default:
        if (deviceLocale == "en") tempLang = 'ENG';
        if (deviceLocale == "zh") tempLang = 'CHN';
        if (deviceLocale == "ja") tempLang = 'JPN';
        if (deviceLocale == "ko") tempLang = 'KOR';
    }
    setState(() {
      dropDownValue = tempLang;
    });
  }

  @override
  void initState() {
    super.initState();
    // language Selection Function
    languageSelection();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => LoginProvider()),
      child: Consumer<LoginProvider>(
        builder: (context, model, child) {
          return Scaffold(
            body: ModalProgressHUD(
              progressIndicator: CircularProgressIndicator(
                color: primaryColor70,
              ),
              inAsyncCall: model.state == ViewState.busy,
              child: Stack(
                children: [
                  // Language Selection Drop Down
                  Positioned(
                    right: 10,
                    top: 10,
                    child: SafeArea(
                      child: Container(
                        key: WidgetKey.languageChangeLoginScreen,
                        height: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: greyColor30)),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: DropdownButton<String>(
                            isDense: true,
                            icon: Icon(null),
                            //Remove Drop Arrow from the widget
                            iconSize: 0,
                            //After removing Icon, set size to zero to not reflect empty size on the UI.
                            underline: Container(child: null),
                            value: dropDownValue,
                            items: <String>['ENG', 'CHN', 'JPN', 'KOR']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgPicture.asset('assets/flags/$value.svg'),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(value,
                                          style: poppinsTextStyle(14,
                                              FontWeight.w500, greyColor100)),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: onLanguageChanged,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Login options Google, Facebook and Apple (in case of iOS)
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: SizedBox()),
                        Image.asset("assets/v2/logo.png", scale: 12.2),
                        Expanded(child: SizedBox()),

                        // Login with google button
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: LoginButton(
                            key: WidgetKey.googleLoginButton,
                            asset: "gsvg",
                            option: "Google",
                            onTap: () {
                              model.signInWithGoogle(context);
                            },
                            RTL: dropDownValue == "KOR" ? true : false,
                          ),
                        ),

                        // Login with facebook button
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: LoginButton(
                            asset: "fbsvg",
                            option: "Facebook",
                            onTap: () {
                              model.signInWithFacebook(context);
                            },
                            RTL: dropDownValue == "KOR" ? true : false,
                          ),
                        ),

                        // Login with apple button
                        Platform.isAndroid
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: LoginButton(
                                  asset: "applesvg",
                                  option: "Apple",
                                  onTap: () {
                                    model.signInWithApple(context);
                                  },
                                  RTL: dropDownValue == "KOR" ? true : false,
                                ),
                              ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
