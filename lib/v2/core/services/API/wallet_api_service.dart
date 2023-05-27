import 'dart:convert';
import 'dart:io';
import 'package:p2u_wallet/v2/ui/screens/fallback_error/fallback_error_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../locator.dart';
import '../../constants/api_endpoints.dart';
import '../../models/scan_data.dart';
import '../auth_services.dart';

class WalletAPIServices {
  /// common headers variable that do not change that much
  final locateUser = locator<AuthServices>();
  Future fetchWalletRequestDataAPI({required String requestKey}) async {
    var token = await locateUser.getUserToken();
    final localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(
        Uri.parse("${EndPoints.getTransaction}?request_key=$requestKey"),
        headers: localHeaders);
    var statusCode = response.statusCode;

    if (statusCode == 200 || statusCode == 201) {
      return {"error": false, "msg": response.body};
    } else if (statusCode == 500 || statusCode == 502) {
      return Get.to(() => FallbackErrorScreen(
          error: statusCode, msg: jsonDecode(response.body)["err"]));
    } else {
      return {"error": true, "msg": jsonDecode(response.body)["err"]};
    }
  }

  Future completeRequestAPI({final requestKey}) async {
    locateUser.init();
    var token = await locateUser.getUserToken();
    final localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = jsonEncode({
      "request_key": requestKey,
    });
    final http.Response response = await http.post(
      Uri.parse("${EndPoints.sendTransaction}"),
      headers: localHeaders,
      body: body,
    );
    var statusCode = response.statusCode;

    if (statusCode == 200 || statusCode == 201) {
      return {"error": false};
    } else if (statusCode == 404 || statusCode == 500 || statusCode == 502) {
      return Get.to(() =>
          FallbackErrorScreen(error: statusCode, msg: "error_$statusCode"));
    } else {
      return {"error": true, "msg": jsonDecode(response.body)};
    }
  }

  Future fetchConnectionRequestData({required String requestKey}) async {
    locateUser.init();
    var token = await locateUser.getUserToken();
    final localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token',
    };
    var parameters = "request_id=$requestKey";
    final http.Response response = await http.get(
        Uri.parse("${EndPoints.getConnectionRequest}?$parameters"),
        headers: localHeaders);
    var statusCode = response.statusCode;

    if (statusCode == 200 || statusCode == 201) {
      return {
        "error": false,
        "data": jsonDecode(response.body)["request_connection"]
      };
    } else if (statusCode == 404 || statusCode == 500 || statusCode == 502) {
      return Get.to(() =>
          FallbackErrorScreen(error: statusCode, msg: "error_$statusCode"));
    } else {
      return {"error": true, "msg": jsonDecode(response.body)};
    }
  }

  Future completeConnectionRequest({required String requestKey}) async {
    locateUser.init();
    var token = await locateUser.getUserToken();
    final localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = jsonEncode({"request_id": requestKey});
    final http.Response response = await http.post(
        Uri.parse("${EndPoints.completeConnection}"),
        headers: localHeaders,
        body: body);
    var statusCode = response.statusCode;

    if (statusCode == 200 || statusCode == 201) {
      return {"error": false};
    } else if (statusCode == 404 || statusCode == 500 || statusCode == 502) {
      return Get.to(() =>
          FallbackErrorScreen(error: statusCode, msg: "error_$statusCode"));
    } else {
      return {"error": true, "msg": jsonDecode(response.body)["msg"]};
    }
  }
}
