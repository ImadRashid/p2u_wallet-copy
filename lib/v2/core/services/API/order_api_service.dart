import 'dart:convert';
import 'dart:io';
import 'package:p2u_wallet/v2/core/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../../locator.dart';
import '../auth_services.dart';

class OrderAPIService {
  /// common headers variable that do not change that much
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

  /// Number of records to be fetch in a single call
  final recordLimit = 5;

  ///
  /// Get All Orders API
  /// function: This API fetches All Orders except Current User
  ///
  Future fetchAllOrders(
      {required String currency, required bool isCompleted, lastKey}) async {
    /// Initialize User Authorization services to
    /// get user auth token
    final locateUser = locator<AuthServices>();

    /// Store User Auth Token
    var token = await locateUser.getUserToken();

    ///local headers which store return data type
    ///and Authorization token.
    final localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token'
    };

    ///Stores the Json Encoded body parameters which are
    ///needed to get the desired data successfully/
    final body = jsonEncode({
      //encodes object data into JSON Format
      "currency": currency, //currency against which you want data
      "isComplete": isCompleted, //status of orders which are completed or not.
      "limit": recordLimit, // number of records that are to be fetched
      "lastKey": lastKey //lastKey of the last order data
    });

    ///Post Request to send and receive response as a result
    ///The parameters defined in body variable are sent to body
    final response = await http.post(Uri.parse('${EndPoints.getAllOrders}'),
        body: body, headers: localHeaders);
    if (response.statusCode == 200) {
      return [200, jsonDecode(response.body)];
    } else if (response.statusCode == 404) {
      ///Fallback Error 404 Screen Data
      return [404, "error_404"];
    } else if (response.statusCode == 500) {
      ///Fallback Error 500 Screen Data
      debugPrint(response.body);
      return [500, "error_500"];
    } else if (response.statusCode == 502) {
      ///Fallback Error 502 Screen Data
      return [502, "error_502"];
    } else {
      return ["1F2E", "Some Other Error"];
    }
  }

  ///
  /// Get Orders API
  /// function: This API fetches All Orders for Current User
  ///
  Future fetchMyOrders(
      {required String currency, required bool isCompleted, lastKey}) async {
    /// Initialize User Authorization services to
    /// get user auth token
    final locateUser = locator<AuthServices>();

    /// Store User Auth Token
    var token = await locateUser.getUserToken();

    ///local headers which store return data type
    ///and Authorization token.
    final localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token'
    };

    ///Stores the Json Encoded body parameters which are
    ///needed to get the desired data successfully/
    final body = jsonEncode({
      //encodes object data into JSON Format
      "currency": currency, //currency against which you want data
      "isComplete": isCompleted, //status of orders which are completed or not.
      "limit": recordLimit, // number of records that are to be fetched
      "lastKey": lastKey //last key of the last order
    });

    ///Post Request to send and receive response as a result
    ///The parameters defined in body variable are sent to body
    final response = await http.post(Uri.parse('${EndPoints.getMyOrders}'),
        body: body, headers: localHeaders);

    if (response.statusCode == 200) {
      return [200, jsonDecode(response.body)];
    } else if (response.statusCode == 404) {
      ///Fallback Error 404 Screen Data
      return [404, "error_404"];
    } else if (response.statusCode == 500) {
      ///Fallback Error 500 Screen Data
      return [500, "error_500"];
    } else if (response.statusCode == 502) {
      ///Fallback Error 502 Screen Data
      return [502, "error_502"];
    } else {
      return ["1F2E", "Some Other Error"];
    }
  }

  ///
  /// Delete Order
  /// function : This API deletes current user's order
  /// order id is to be provided
  ///

  Future deleteMyOrder({required String orderID}) async {
    final locateUser = locator<AuthServices>();
    var token = await locateUser.getUserToken();
    final localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token'
    };
    final parameters = "order_id=$orderID";
    final response = await http.delete(
        Uri.parse('${EndPoints.deleteOrder}?$parameters'),
        headers: localHeaders);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  ///
  ///Buy Sell Order
  ///function: Place and Sell Order
  ///
  Future buyAndSellOrder(
      {required String currency,
      required double amount,
      required bool isBuy,
      required String askCurrency,
      required double askPrice}) async {
    final locateUser = locator<AuthServices>();
    var token = await locateUser.getUserToken();
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode({
      "currency": currency,
      "amount": amount,
      "isBuy": isBuy,
      "askCurrency": askCurrency,
      "askPrice": askPrice
    });

    var response = await http.post(Uri.parse("${EndPoints.buySellOrders}"),
        headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      debugPrint(response.statusCode.toString());

      //throw Exception('Unexpected error occured!');
    }
    return false;
  }

  Future completeUserOrder({required String orderID}) async {
    var locateUser = locator<AuthServices>();
    var token = await locateUser.getUserToken();
    final localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode({"order_id": orderID});
    final response = await http.post(Uri.parse("${EndPoints.ordersCompleted}"),
        headers: localHeaders, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return response.statusCode;
    }
  }
}
