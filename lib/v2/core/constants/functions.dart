import 'package:intl/intl.dart';

/// [Function] that converts any timestamp to
/// our desired output as the timestamp is in
/// another format.
String convertTimeStampToTimeFormat(String date) {
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm');
  return outputFormat.format(DateTime.parse(
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date).toString()));
}

/// [Function] that converts the [Order] timestamp to
/// our desired output as the [Order] timestamp is in
/// another format.
String convertOrderTimeStampToTimeFormat(String date) {
  var outputFormat = DateFormat('MMM-dd-yyyy hh:mm:ss a');
  return outputFormat.format(DateTime.parse(
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date).toString()));
}
