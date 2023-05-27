import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:p2u_wallet/v2/ui/components/custom_snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

/// A [Screen]/[View] that displays web page in
/// [WebView] in this [application]

class WebViewScreen extends StatefulWidget {
  /// [Constructor] that accepts:
  /// - [url] of type [string] which is link to [WebView]
  /// - [screenTitle] of type [string] which is title to be
  /// shown on screen
  ///
  /// and creates [WebView] based on that.
  const WebViewScreen({Key? key, required this.url, required this.screenTitle})
      : super(key: key);

  /// [String] value to store web page [url]
  final String? url;

  /// [String] value to be shown on screen
  final String? screenTitle;
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  /// Progress Value
  int progress = 0;
  @override
  void initState() {
    super.initState();
    // Enable virtual display if platform is android
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // custom app bar
      // TODO: via customAppBar (not a priority)
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 19, right: 49),
          child: Column(
            children: [
              Text(
                widget.screenTitle!.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${widget.url}",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Web View
          WebView(
            initialUrl: widget.url,
            onProgress: (a) {
              setState(() {
                progress = a;
              });
            },
            onWebResourceError: (error) {
              debugPrint(
                  "${error.description}, ${error.domain}, ${error.errorCode}, ${error.errorType}");
              customSnackBar(
                context,
                "${error.description}",
                duration: Duration(days: 1),
              );
            },
          ),
          // Liner Progress Indicator
          if (progress < 100)
            LinearProgressIndicator(
              minHeight: 5,
              value: progress / 100.0,
              color: primaryColor70,
            ),
        ],
      ),
    );
  }
}
