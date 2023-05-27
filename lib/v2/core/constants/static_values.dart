import 'dart:ui';

const tokens = ["MSQP", "P2UP"];
const transactionType = ["Buy", "Sell"];

/// An object of type [MAP] that maps the languages to their
/// abbreviations
Map languageMapping = {
  "en": "English",
  "zh": "Chinese",
  "ko": "Korean",
  "ja": "Japanese"
};

/// An object of type [MAP] that maps the languages to their
/// locales
Map localeMapping = {
  "English": Locale("en", "US"),
  "Chinese": Locale("zh", "CH"),
  "Korean": Locale("ko", "KR"),
  "Japanese": Locale("ja", "JP")
};

/// An object of type [MAP] that maps the languages to their
/// locales
Map languageCodeMapping = {
  "en": Locale("en", "US"),
  "zh": Locale("zh", "CH"),
  "ko": Locale("ko", "KR"),
  "ja": Locale("ja", "JP")
};
