import 'package:shared_preferences/shared_preferences.dart';

class PasswordAttempt {
  SharedPreferences? prefs;
  List<List<String>> passwordAttempts = [];

  PasswordAttempt() {
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    await setPasswordAttempts();
    await initializePassAttemptList();
  }

  Future<void> setPasswordAttempts() async {
    // Set up password attempts keys
    if (!prefs!.containsKey("barcode_attempts")) {
      prefs!.setStringList("barcode_attempts", ["false", "null"]);
    }
    if (!prefs!.containsKey("swap_attempts")) {
      prefs!.setStringList("swap_attempts", ["false", "null"]);
    }
    if (!prefs!.containsKey("setting_attempts")) {
      prefs!.setStringList("setting_attempts", ["false", "null"]);
    }
    if (!prefs!.containsKey("mobile_payment_attempts")) {
      prefs!.setStringList("mobile_payment_attempts", ["false", "null"]);
    }
  }

  Future<void> initializePassAttemptList() async {
    passwordAttempts.add(prefs!.getStringList("barcode_attempts")!);
    passwordAttempts.add(prefs!.getStringList("swap_attempts")!);
    passwordAttempts.add(prefs!.getStringList("setting_attempts")!);
    passwordAttempts.add(prefs!.getStringList("mobile_payment_attempts")!);
  }

  void setPasswordAttemptsData(
      String name, bool attempts, String timestamp) async {
    switch (name) {
      case "barcode":
        prefs!.setStringList(
            "barcode_attempts", [attempts.toString(), timestamp]);
        passwordAttempts[0][0] = attempts.toString();
        passwordAttempts[0][1] = timestamp;
        break;
      case "swap":
        prefs!.setStringList("swap_attempts", [attempts.toString(), timestamp]);
        passwordAttempts[1][0] = attempts.toString();
        passwordAttempts[1][1] = timestamp;
        break;
      case "setting":
        prefs!.setStringList(
            "setting_attempts", [attempts.toString(), timestamp]);
        passwordAttempts[2][0] = attempts.toString();
        passwordAttempts[2][1] = timestamp;
        break;
      case "mobile_payment":
        prefs!.setStringList(
            "mobile_payment_attempts", [attempts.toString(), timestamp]);
        passwordAttempts[3][0] = attempts.toString();
        passwordAttempts[3][1] = timestamp;
        break;
    }
  }

  List<String> getPasswordAttemptsData(int index) {
    return passwordAttempts[index];
  }
}
