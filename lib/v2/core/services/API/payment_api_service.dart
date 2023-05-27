import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import '../../../../locator.dart';
import '../../../ui/screens/fallback_error/fallback_error_screen.dart';
import '../../constants/api_endpoints.dart';
import '../auth_services.dart';
import 'package:http/http.dart' as http;

class PaymentAPIService {
  /// [AuthServices] that handles the user authentications
  final _locateUser = locator<AuthServices>();

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
  Future fetchCardCompanies() async {
    // retrieve user's FirebaseUserToken
    _token = await _locateUser.getUserToken();

    // assign headers
    _localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $_token'
    };

    // assign the FetchUser API
    _url = Uri.parse("${EndPoints.getCardCompanies}");

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

  Future fetchUserCards() async {
    // retrieve user's FirebaseUserToken
    _token = await _locateUser.getUserToken();

    // assign headers
    _localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $_token'
    };

    // assign the FetchUser API
    _url = Uri.parse("${EndPoints.getCards}");

    // send HttpRequest and store its response.
    _response = await http.get(_url!, headers: _localHeaders);
    // if status code of HttpResponse is 200
    if (_response.statusCode == 200 || _response.statusCode == 201) {
      // return the Data;
      return jsonDecode(_response.body);
    }

    // if status code of HttpResponse is 500,503
    else if (
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

  Future createUserCard(
      {required String company,
      required String loginID,
      required String password}) async {
    // retrieve user's FirebaseUserToken
    _token = await _locateUser.getUserToken();

    // assign headers
    _localHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $_token'
    };
    // register card data
    _body = jsonEncode(
        {"id": loginID, "password": password, "companyCode": company});
    // assign the FetchUser API
    _url = Uri.parse("${EndPoints.addCard}");

    // send HttpRequest and store its response.
    _response = await http.post(_url!, headers: _localHeaders, body: _body);
    // if status code of HttpResponse is 200
    if (_response.statusCode == 200 || _response.statusCode == 201) {
      // return the Data;
      return true;
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
}
