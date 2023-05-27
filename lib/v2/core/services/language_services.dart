import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageServices {
  Locale? locale;

  SharedPreferences? prefs;
  var language;

  LanguageServices() {
    initLanguages();
  }

  initLanguages() async {
    prefs = await SharedPreferences.getInstance();

    language = prefs!.getString('lang');

    if (language == null) {
      debugPrint("Language is null");
    } else {
      debugPrint("LANGUEAGE IS:" + language);
      locale = language == "Chinese"
          ? Locale('zh', 'CH')
          : language == "Korean"
              ? Locale('ko', "KR")
              : language == "Japanese"
                  ? Locale('ja', "JP")
                  : Locale("en", "US");
    }
  }
}
