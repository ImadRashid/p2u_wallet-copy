import '../enums/env.dart';

class Config {
  final Env _env;
  final String _devBaseUrl = '';
  final String _stagingBaseUrl = '';
  final String _productionBaseUrl = '';
  late String _baseUrl;

  /// Getters
  Env get env => _env;
  String get baseUrl => _baseUrl;

  /// Constructor
  Config(this._env) {
    _setupBaseUrl();
  }

  _setupBaseUrl() {
    if (_env == Env.production) {
      _baseUrl = _productionBaseUrl;
    } else if (_env == Env.staging) {
      _baseUrl = _stagingBaseUrl;
    } else if (_env == Env.development) {
      _baseUrl = _devBaseUrl;
    }
  }
}


// import 'dart:io';

// class AppConfig {
//   static final String appName = "MSQ Wallet";
//   // static final String packageName = "com.apptester.app";
//   static final String defaultLanguage = "en";
//   static final String defaultTheme = "dark";
//   static const String currency = "\$";
//   static String admobKey = Platform.isAndroid
//       ? 'ca-app-pub-3940256099942544/6300978111'
//       : 'ca-app-pub-3940256099942544/2934735716';
//   static final Map<String, String> languagesSupported = {
//     'en': "English",
//     'ar': "عربى",
//     'pt': "Portugal",
//     'fr': "Français",
//     'id': "Bahasa Indonesia",
//     'es': "Español",
//     'it': "italiano",
//     'tr': "Türk",
//     'sw': "Kiswahili",
//   };

// }