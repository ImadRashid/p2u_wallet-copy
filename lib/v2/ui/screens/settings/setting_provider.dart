import 'package:p2u_wallet/v2/core/services/API/user_api_service.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:p2u_wallet/v2/core/services/local_auth.dart';
import 'package:p2u_wallet/v2/core/services/locator_services/password_attempt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../locator.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/static_values.dart';
import '../../../core/device_type.dart';
import '../../../core/models/password_model.dart';
import '../../../core/models/user_model.dart';

/// [ViewModel] that fetches [data] from [Model] and transmit
/// [data] to [View] which here is [SettingScreen]

class SettingProvider extends ChangeNotifier {
  /// [SharedPreferences] object to handle local storage
  final Future<SharedPreferences> myprefs = SharedPreferences.getInstance();

  /// [language] to show on Settings Screen
  var language = languageMapping[Get.locale?.languageCode];

  /// [AuthServices] object to handle [user] authentication service
  final locateUser = locator<AuthServices>();

  /// [DeviceType] object that handles Device Dimensions.
  final locateSize = locator<DeviceType>();

  /// [BioMetricServices] object that handles [bioMetric] of phone.
  BioMetricAuthenticationServices bioMetricServices =
      locator<BioMetricAuthenticationServices>();

  /// [MyAppUser] object that handles [User] data
  UserModel myAppUser = UserModel();

  /// Checks if bioMetric Enabled
  bool isBioMetricEnabled = false;
  // final apiServices = ApiServices();

  /// [String] value to store [passwordData]
  var getPassword = " ";

  /// [Integer] to store number of password attempts
  int totalAttempts = 10;

  /// A [constructor] that initializes some data variables
  SettingProvider() {
    // initialize myAppUser
    myAppUser = locateUser.myAppUser;
    // initialize whether bioMetricEnabled
    isBioMetricEnabled = bioMetricServices.isBioMetricEnabled;
    // refresh token
    refreshToken();
  }

  /// [String] value that stores [User]'s token
  String? userToken;

  UserAPIServices _userAPI = UserAPIServices();
  PasswordModel passwordData = PasswordModel();
  bool loader = false;
  bool borderRed = false;
  changeLoading(v) {
    loader = v;
    notifyListeners();
  }

  /// [Function] that refreshes the [User]'s [Firebase]
  /// [authentication] token.
  refreshToken({BuildContext? context}) async {
    // return firebase token
    final x = await locateUser.firebaseAuth.currentUser!.getIdToken();
    // if token is returned
    if (context != null) {
      // if existing token is same as current token.
      if (x == userToken) {
        ScaffoldMessenger.of(context).clearSnackBars();
        // show snack bar that says token is same.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Token is the same as previous",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
          ),
        );
      }
    }
    // store fetched token in [userToken]
    userToken = x;
    notifyListeners();
  }

  /// [Function] that changes [bioMetric]
  /// services for the [User].
  changeBioMetricValue(bool value) async {
    // Enable biometric services
    final xx = await bioMetricServices.authenticateUser();

    // if User has registered of authenticated himself
    // using biometrics then, set the prefrences value.
    if (xx) {
      await bioMetricServices.setBiometricAuthPref(value);
      isBioMetricEnabled = bioMetricServices.isBioMetricEnabled;
      notifyListeners();
    } else {}
  }

  /// [Function] that logouts the [User]
  logOut(BuildContext context) async {
    await locateUser.logout();
  }

  /// [Function] that checks the [User] credentials
  checkCredential(var x) {
    debugPrint(x.toString());
  }

  /// [Widget] that displays the bottom sheet
  languageSelectionModalSheet() {
    return Wrap(
      children: [
        RadioListTile(
          value: "English",
          selected: language == "English",
          activeColor: primaryColor70,
          groupValue: language,
          onChanged: languageOnChange,
          title: Text("English"),
        ),
        RadioListTile(
          value: "Chinese",
          selected: language == "Chinese",
          activeColor: primaryColor70,
          groupValue: language,
          onChanged: languageOnChange,
          title: Text("Chinese"),
        ),
        RadioListTile(
          value: "Japanese",
          selected: language == "Japanese",
          activeColor: primaryColor70,
          groupValue: language,
          onChanged: languageOnChange,
          title: Text("Japanese"),
        ),
        RadioListTile(
          value: "Korean",
          selected: language == "Korean",
          activeColor: primaryColor70,
          groupValue: language,
          onChanged: languageOnChange,
          title: Text("Korean"),
        ),
      ],
    );
  }

  languageOnChange(v) async {
    String? lang;
    Locale? locale;
    switch (v) {
      case "Chinese":
        lang = "Chinese";
        locale = Locale('zh', 'CH');
        break;
      case "Japanese":
        lang = "Japanese";
        locale = Locale('ja', 'JP');
        break;
      case "Korean":
        lang = "Korean";
        locale = Locale('ko', 'KR');
        break;
      case "English":
        lang = "English";
        locale = Locale('en', 'US');
        break;
    }
    SharedPreferences prefs = await myprefs;
    prefs.setString("lang", lang!);
    language = v;
    Get.updateLocale(locale!);
    Get.back();
    notifyListeners();
  }

  /// [Function] that handles the fingerprint authentication and than in success
  /// case complete transaction request.
  performTransactionWithFingerprint() async {
    changeLoading(true);
    var response = {
      "msg": "Fingerprint Disable Failed",
      "color": dangerColor10
    };
    // Authenticate fingerprint
    var isAuthenticated = await bioMetricServices.authenticateUser();
    if (isAuthenticated) {
      isBioMetricEnabled = false;
      response = {
        "msg": "Fingerprint Disable Successful",
        "color": successColor30
      };
      await bioMetricServices.setBiometricAuthPref(false);
    }
    changeLoading(false);
    return response;
  }

  /// [Function] that handles the password verification and than in success
  /// case complete transaction request.
  performTransactionWithPassword() async {
    changeLoading(true);
    var response;
    var passwordAttempts =
        locator<PasswordAttempt>().getPasswordAttemptsData(2);
    if (passwordAttempts[0] == "false") {
      if (passwordData.totalAttempts > 1) {
        bool isAuthenticated = await _userAPI.validateUser(
            email: locateUser.myAppUser.email!,
            password: passwordData.passwordController.text);
        if (isAuthenticated) {
          isBioMetricEnabled = await bioMetricServices.authenticateUser();
          await bioMetricServices.setBiometricAuthPref(isBioMetricEnabled);
          response = isBioMetricEnabled
              ? {
                  "msg": "Password Authenticated and Fingerprint Enabled",
                  "color": successColor30
                }
              : {
                  "msg": "Password Authenticated But Fingerprint Not Enabled",
                  "color": dangerColor10
                };
          getPassword = "";
          passwordData.totalAttempts = 10;
        } else {
          passwordData.reduceAttempts();
          response = {"msg": "wrong_password".tr, "color": dangerColor10};
        }
      } else {
        locator<PasswordAttempt>().setPasswordAttemptsData(
            "setting", true, DateTime.now().toString());
        response = {"msg": "pass_limit_reached".tr, "color": dangerColor10};
      }
    } else {
      passwordData.totalAttempts = 0;
      int diff = DateTime.now()
          .difference(DateTime.parse(passwordAttempts[1]))
          .inMinutes;
      //Get.back();
      if (diff < 5) {
        response = {
          "msg": "try_again_msg_1".tr + "${5 - diff}" + "try_again_msg_2".tr,
          "color": dangerColor10
        };
      } else {
        passwordData.totalAttempts = 10;
        locator<PasswordAttempt>()
            .setPasswordAttemptsData("setting", false, "null");
        response = {"msg": "Password Limit Reset", "color": successColor30};
      }
    }
    changeLoading(false);
    return response;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
