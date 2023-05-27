import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import '../../../ui/widgets/password_snackbar.dart';
import 'package:flutter/material.dart';

/// An Independent Service that checks Internet Connection on:
/// - Fresh App Start
/// - Constantly After 5 secs during app lfe
class InternetConnectivityService extends ChangeNotifier {
  /// [Dynamic] variable to store the Internet Connectivity Response.
  var _result;

  /// [ConnectivityResult] variable to store the Internet Connection Result
  var connectivity = ConnectivityResult.none;

  /// [Boolean] flag to let know if the app is starting first time
  bool firstTime = true;

  /// [Boolean] flag to let know if there is internet connection or not
  bool noInternetConnection = false;

  /// [Boolean] flag to handle Fresh App Start Time Internet Connection
  bool firstTimeInternetConnection = false;

  /// [Boolean] flag to handle Fresh App Start Time Internet Connection
  bool noInternetSnackbarShown = false;

  /// [Constructor] that initializes the service functions
  InternetConnectivityService() {
    // initialization function
    init();
  }

  /// [Function] that starts internet connection services
  void init() async {
    // listen to network change
    await checkInternet();
    // check if the connected network is working or not.
    await checkInternetWorks();
  }

  /// [Function] in which we listen to network change, show top snackbar if there is no
  /// internet
  /// This function only checks if the mobile is connected to a network such as WiFi, Data etc.
  /// This does not guarantee that the internet from Wifi or Datasource will work
  ///
  Future<void> checkInternet() async {
    // Listens to network change
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // store connectivity result
      connectivity = result;
      // check if it is not fresh Start than show top snackbar
      if (!firstTime) {
        showInternetConnectionSnackBar(
          isOnline: result != ConnectivityResult.none,
        );
      }
      firstTime = false;
      if (result != ConnectivityResult.none) {}
    });
  }

  /// [Function] in which we listen to check whether the network is working or
  /// not.
  Future<void> checkInternetWorks() async {
    // infinite loop that run every 5 seconds
    while (true) {
      // check is there is no connectivity and app is is running
      if (connectivity == ConnectivityResult.none && !firstTime) {
        // set there is no internet connection
        noInternetConnection = true;
        // serviceLookFailedSnackBarShown = false;
        // show top snack bar with offline mode
        if (!noInternetSnackbarShown) {
          showInternetConnectionSnackBar(isOnline: false);
          noInternetSnackbarShown = true;
        }
      } else {
        try {
          // look up Google address to check if the network connection is working
          _result = await InternetAddress.lookup("www.google.com");
          // set there is internet connection
          noInternetConnection = false;
          noInternetSnackbarShown = false;
        } catch (e) {
          // if there is an error it means the lookup failed
          // and set no internet to true
          noInternetConnection = true;
          if (!firstTimeInternetConnection && !noInternetSnackbarShown) {
            // and if not fresh start show offline snackbar

            showInternetConnectionSnackBar(isOnline: false);
            noInternetSnackbarShown = true;
            // firstTimeInternetConnection = true;
          }
        }
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  /// [Function] that helps us to check if the internet is working or not
  /// for the fresh start
  Future<bool> checkConnection() async {
    // check if connected to internet
    bool hasInternet =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;
    // check if connected to internet
    if (hasInternet) {
      // if connected to internet check if connection is
      // stable.
      try {
        _result = await InternetAddress.lookup("www.google.com");
        // if internet is working set hasInternet to true
        hasInternet = true;
      } catch (e) {
        // if not set hasInternet to false
        hasInternet = false;
      }
    }
    // set firstTime Connection
    firstTimeInternetConnection = !hasInternet;
    // return status
    return !hasInternet;
  }
}
