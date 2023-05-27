import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:p2u_wallet/v2/ui/screens/fallback_error/fallback_error_screen.dart';
import 'package:http/http.dart' as http;
import '../../../../locator.dart';
import '../../constants/api_endpoints.dart';
import '../auth_services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

///TODO: Try to remove email from functions input arguments and instead use email in locateUser

/// [APIServices] that handles all
/// the [API] calls related to [User].
/// - [fetchCurrentUser] that fetches [User] Data
/// - [validateUser] that validates if the current user
/// is in our system.
/// - [deleteUser] that deletes the current user from the
/// system.

class UserAPIServices {
  /// [Constant] variable that contains fixed [headers]
  final _headers = {HttpHeaders.contentTypeHeader: 'application/json'};

  /// [AuthServices] that handles the user authentications
  //final _locateUser = locator<AuthServices>();

  /*
  * All the variables below are made data members because
  * instead of declaration of these each time in the same
  * and different function we will be using less memory
  * space.
  * */

  /// variable that handles [User] token
  var _token;

  /// variable that handles local headers for each of the [API] functions
  var _localHeaders;

  /// variable that handles body for each of the [API] functions
  var _body;

  /// variable that handles [HttpResponse] received from the
  /// [API] request.
  var _response;

  /// [String] variable that handles [API] url
  Uri? _url;

  /// Async [Function] that fetches [User]'s data and returns
  /// it.
  Future fetchCurrentUser() async {
    final locateUser = locator<AuthServices>();
    // retrieve user's FirebaseUserToken
    _token = await locateUser.getUserToken();

    // assign headers
    _localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $_token'
    };

    // assign the FetchUser API
    _url = Uri.parse("${EndPoints.fetchUser}");

    try {
      // send HttpRequest and store its response.
      _response = await http.get(_url!, headers: _localHeaders);
      // if status code of HttpResponse is 200
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        // return the Data;
        return jsonDecode(_response.body);
      }
      // if status code of HttpResponse is 404,500,503
      else {
        throw "Error: ${_response.statusCode}, \n${_response.body}";
        // show pre-defined FallBackErrorScreen
        // log(_response.body.toString());
        // Get.to(() => FallbackErrorScreen(
        //     error: _response.statusCode, msg: "error_${_response.statusCode}"));
      }
    } catch (error) {
      throw "Error: ${_response.statusCode}, \n${_response.body}";
    }
  }

  Future fetchCurrentUserTokens() async {
    final locateUser = locator<AuthServices>();
    // retrieve user's FirebaseUserToken
    _token = await locateUser.getUserToken();

    // assign headers
    _localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $_token'
    };

    // assign the FetchUser API
    _url = Uri.parse("${EndPoints.fetchUserToken}");

    // send HttpRequest and store its response.
    _response = await http.get(_url!, headers: _localHeaders);
    // if status code of HttpResponse is 200
    if (_response.statusCode == 200 || _response.statusCode == 201) {
      // return the Data;
      return jsonDecode(_response.body);
    }

    // if status code of HttpResponse is 404,500,503
    else if (_response.statusCode == 404 ||
        _response.statusCode == 500 ||
        _response.statusCode == 502) {
      // show pre-defined FallBackErrorScreen
      Get.to(() => FallbackErrorScreen(
          error: _response.statusCode, msg: "error_${_response.statusCode}"));
    } else {
      // return false so that you can show corresponding
      // message in ViewModel
      return false;
    }
  }

  Future validateUser({required String email, required String password}) async {
    final encodePassword = Uri.encodeComponent(password);
    final parameters = "user=$email&plainPassword=$encodePassword";
    final parsedUri = Uri.parse("${EndPoints.validateUser}?$parameters");
    final response = await http.get(parsedUri, headers: _headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["status"];
    } else {
      return false;
    }
  }

  Future deleteUser() async {
    final locateUser = locator<AuthServices>();
    // Store User Auth Token
    _token = await locateUser.getUserToken();

    // local headers which store return data type
    // and Authorization token.
    _localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $_token'
    };
    // assign the FetchUser API
    _url = Uri.parse('${EndPoints.deleteUser}');
    // send HttpRequest and store its response.
    _response = await http.delete(_url!, headers: _localHeaders);
    // if status code of HttpResponse is 200
    if (_response.statusCode == 200) {
      // deleted
      return true;
    }
    //not deleted
    return false;
  }

  Future signup({required String name, required String email}) async {
    final locateUser = locator<AuthServices>();
    _token = await locateUser.getUserToken();
    _body = jsonEncode({"name": name, "email": email});
    _localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $_token'
    };
    _url = Uri.parse('${EndPoints.signUp}');
    _response = await http.post(_url!, headers: _localHeaders, body: _body);
    if (_response.statusCode == 200) {
      return true;
    } else if (_response.statusCode == 404 ||
        _response.statusCode == 500 ||
        _response.statusCode == 502) {
      Get.to(() => FallbackErrorScreen(
          error: _response.statusCode, msg: 'error_${_response.statusCode}'));
    } else {
      return false;
    }
  }

  Future createUserName(
      {required String username,
      required String password,
      required String email}) async {
    _body =
        jsonEncode({"username": username, "password": password, "user": email});
    _url = Uri.parse("${EndPoints.userCredential}");
    _response = await http.post(_url!, headers: _headers, body: _body);
    if (_response.statusCode == 200) {
      return true;
    } else if (_response.statusCode == 404 ||
        _response.statusCode == 500 ||
        _response.statusCode == 502) {
      Get.to(() => FallbackErrorScreen(
          error: _response.statusCode, msg: 'error_${_response.statusCode}'));
    } else {
      return false;
    }
  }

  Future fetchAffiliateStores() async {
    try {
      final locateUser = locator<AuthServices>();
      // retrieve user's FirebaseUserToken
      _token = await locateUser.getUserToken();
      // assign headers
      _localHeaders = {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $_token'
      };

      // assign the FetchUser API
      _url = Uri.parse("${EndPoints.getAffiliates}");

      // send HttpRequest and store its response.
      _response = await http.get(_url!, headers: _localHeaders);
      // if status code of HttpResponse is 200
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        // return the Data;
        return jsonDecode(_response.body);
      } else {
        throw "Error@FetchingAffiliates${_response.statusCode}, ${_response.body}";
      }
      // if status code of HttpResponse is 404,500,503
      // else if (_response.statusCode == 404 ||
      //     _response.statusCode == 500 ||
      //     _response.statusCode == 502) {
      //   // show pre-defined FallBackErrorScreen
      //   // Get.to(() => FallbackErrorScreen(
      //   //     error: _response.statusCode, msg: "error_${_response.statusCode}"));
      // } else {
      //   // return false so that you can show corresponding
      //   // message in ViewModel
      //   return false;
      // }
    } catch (e) {
      debugPrint("Error@FetchingAffiliates=====> $e");
    }
  }
}
