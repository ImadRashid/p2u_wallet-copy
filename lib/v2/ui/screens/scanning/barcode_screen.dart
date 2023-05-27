import 'dart:convert';
import 'dart:developer';
import 'package:p2u_wallet/v2/core/constants/style.dart';
import 'package:p2u_wallet/v2/core/models/scan_data.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../locator.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/services/API/wallet_api_service.dart';
import '../../../core/services/local_auth.dart';
import '../../widgets/barcode_token_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/dialogues/custom_alert_dialog.dart';
import '../../widgets/dialogues/fingerprint_unlock_dialogue.dart';
import '../../widgets/dialogues/password_validation_dialogue.dart';
import '../../widgets/divider_widget.dart';
import '../../widgets/password_snackbar.dart';
import '../wallet/successfuly_connected.dart';
import 'barcode_screen_provider.dart';

/// A [Screen]/[View] made up of [StatefulWidget]
/// that displays QR Scanner to Scan the QR Code

class BarCodeScreen extends StatefulWidget {
  const BarCodeScreen({Key? key}) : super(key: key);

  @override
  State<BarCodeScreen> createState() => _BarCodeScreenState();
}

class _BarCodeScreenState extends State<BarCodeScreen> {
  /// [Barcode] object
  Barcode? result;

  /// [QRViewController] that handles QR Scanning
  //QRViewController? controller;

  /// [GlobalKey] for qrKey
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  /// [WalletAPIService] object that handles [API]s for Wallet
  final walletAPIService = WalletAPIServices();

  /// [AuthServices] object that handles [User] authentications
  final auth = locator<AuthServices>();

  /// [BioMetricAuthenticationService] object that handles [User]
  /// bioMetric services.
  BioMetricAuthenticationServices bioMetricServices =
      locator<BioMetricAuthenticationServices>();

  /// [TextEditingController] to handle password [TextInput]
  TextEditingController passwordController = TextEditingController();

  /// [ScanData] object that stores scanned data
  ScanData? scanData;

  /// [Boolean] flag.
  bool loader = false;

  BarcodeScreenProvider model = BarcodeScreenProvider();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // on pressing back button on device's native
      // navbar QR controller will disposed.
      onWillPop: () async {
        model.controller!.dispose();
        Get.back();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildQrView(context),
            // App Bar
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "scan_qr_code".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  model.controller!.dispose();
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.white,
                ),
              ),
            ),
            loader
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        overlayColor: Color.fromRGBO(0, 0, 0, 0.8),
        borderRadius: 40,
        borderLength: 70,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  /// [Function] that scans the QR Code data and
  /// performs transactions
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      model.controller = controller;
      // resume camera
      controller.resumeCamera();
    });
    try {
      // get QR Code's scanned data
      controller.scannedDataStream.listen(
        (scannedDataResult) async {
          setState(
            () {
              loader = true;
              result = scannedDataResult;
              log("Scanned Data Result ${jsonDecode(scannedDataResult.code!)}");
            },
          );
          pauseCamera();
          // pass the request key from this scanned data to wallet api
          // to request transaction data
          final getResult = await walletAPIService.fetchWalletRequestDataAPI(
            requestKey: jsonDecode(scannedDataResult.code!)["request_key"],
          );
          setState(() {
            loader = false;
          });
          if (getResult['error']) {
            Get.to(() => SuccessFullyConnectedWallet(status: getResult["msg"]));
          } else {
            // decode json data
            final body = json.decode(getResult["msg"]);
            model.transactionData = TransactionData.fromJson(body);
            //pass data to show relevant popup
            newTransactionDialogue(model.transactionData!);
          }
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.toString()),
        ),
      );
    }
  }

  /// [Function] that generates [snackbar] on the basis of permission.
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      showCustomSnackBar("Permission", 'no_permission', greyColor100);
    }
  }

  /// [Function] that resumes camera controller
  resumeCamera() {
    if (model.controller != null) {
      debugPrint("Camera Resumed");
      setState(() {
        model.controller!.resumeCamera();
        loader = false;
      });
    }
  }

  /// [Function] that pauses camera controller
  pauseCamera() {
    if (model.controller != null) {
      debugPrint("Camera Paused");
      setState(() {
        model.controller!.pauseCamera();
      });
    }
  }

  @override
  void dispose() {
    model.controller!.dispose();
    super.dispose();
  }

  /// [Function] that decides which popup to show
  /// based on type of transaction.
  Future newTransactionDialogue(TransactionData data) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Container(
        child: data.requestPlatform!.status == "completed"
            ? transactionAlreadyDoneDialog()
            : data.requestPlatform!.type == "send_transaction"
                ?
                // Alert Popup for transaction of type send_transaction
                AlertDialog(
                    insetPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      "transaction_detail".tr,
                      textAlign: TextAlign.center,
                      style:
                          poppinsTextStyle(15, FontWeight.w500, Colors.black),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "proceed_transaction".tr,
                            textAlign: TextAlign.center,
                            style: poppinsTextStyle(
                                14, FontWeight.w500, greyColor50),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DividerWidget(),
                          Text(
                            "Amount".tr + ":",
                            style: poppinsTextStyle(
                                14, FontWeight.w500, greyColor50),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: data.requestPlatform!.transaction!.tokens!
                                    .name.length *
                                25,
                            width: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.requestPlatform!.transaction!
                                  .tokens!.name.length,
                              itemBuilder: (context, index) {
                                var name = data.requestPlatform!.transaction!
                                    .tokens!.name[index];
                                var amount = data.requestPlatform!.transaction!
                                    .tokens!.amount[index];
                                return BarcodeTokenAmountWidget(
                                    token: name.toString(),
                                    amount: amount.toString());
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "requested_by".tr + ":",
                            style: poppinsTextStyle(
                                14, FontWeight.w500, greyColor50),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${data.requestPlatform!.platformUrl}",
                            style: poppinsTextStyle(
                                14, FontWeight.w500, greyColor100),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "platform".tr,
                            style: poppinsTextStyle(
                                14, FontWeight.w500, greyColor50),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffD6F3F9),
                            ),
                            child: Text(
                              "${data.requestPlatform!.platformName}",
                              style: poppinsTextStyle(
                                  14, FontWeight.w500, greyColor100),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "wallet_address".tr,
                            style: poppinsTextStyle(
                                14, FontWeight.w500, greyColor50),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${data.requestPlatform!.transaction!.to}",
                            style: poppinsTextStyle(
                                14, FontWeight.w500, greyColor100),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DividerWidget(),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    resumeCamera();
                                  },
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: bluishColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                        "refuse".tr,
                                        style: TextStyle(
                                          color: bluishColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    if (bioMetricServices.isBioMetricEnabled) {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              FingerprintUnlockDialogue(
                                                  model: model));
                                      var res = await model
                                          .performTransactionWithFingerprint();
                                      if (!res.containsKey("reroute")) {
                                        showCustomSnackBar(
                                            "fingerprint_authentication",
                                            res["msg"],
                                            res["color"]);
                                      } else {
                                        model.controller!.dispose();
                                        Get.to(() =>
                                            SuccessFullyConnectedWallet(
                                                status: res["reroute"]));
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              PasswordValidationDialogue(
                                                  model: model));
                                    }
                                  },
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: bluishColor,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                      "accept".tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )
                : getSecondAlertDialog(data),
      ),
    );
  }

  /// Popup for Wallet Access
  Widget getSecondAlertDialog(TransactionData data) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        "wallet_request".tr,
        textAlign: TextAlign.center,
        style: poppinsTextStyle(15, FontWeight.w500, Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${data.requestPlatform!.platformName} " +
                  "request_for_address_and_balance".tr,
              textAlign: TextAlign.center,
              style: poppinsTextStyle(14, FontWeight.w500, greyColor50),
            ),
            SizedBox(
              height: 10,
            ),
            DividerWidget(),
            Text(
              "requested_by".tr + ":",
              style: poppinsTextStyle(15, FontWeight.w500, greyColor50),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${data.requestPlatform!.platformUrl}",
              style: poppinsTextStyle(15, FontWeight.w500, greyColor100),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "platform".tr,
              style: poppinsTextStyle(15, FontWeight.w500, greyColor50),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xffD6F3F9),
              ),
              child: Text(
                "${data.requestPlatform!.platformName}",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 16),
      actions: [
        CustomMaterialButton(
          title: "refuse".tr,
          btnColor: greyColor20,
          textColor: greyColor60,
          isQR: true,
          onPressed: () async {
            Get.back();
            resumeCamera();
          },
        ),
        CustomMaterialButton(
          title: "accept".tr,
          isQR: true,
          btnColor: primaryColor70,
          textColor: Colors.white,
          onPressed: () async {
            if (bioMetricServices.isBioMetricEnabled) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      FingerprintUnlockDialogue(model: model));
              var res = await model.performTransactionWithFingerprint();
              if (!res.containsKey("reroute")) {
                showCustomSnackBar(
                    "fingerprint_authentication", res["msg"], res["color"]);
              } else {
                model.controller!.dispose();
                Get.to(
                    () => SuccessFullyConnectedWallet(status: res["reroute"]));
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) =>
                      PasswordValidationDialogue(model: model));
            }
          },
        ),
      ],
    );
  }

  /// Popup for Transaction Done
  transactionAlreadyDoneDialog() {
    return CustomAlertDialog(
      title: "transaction_done",
      message: "",
      align: MainAxisAlignment.center,
      actions: [
        CustomMaterialButton(
          onPressed: () {
            Navigator.pop(context);
            resumeCamera();
          },
          title: "ok",
          textColor: Colors.white,
          btnColor: primaryColor70,
        )
      ],
    );
  }
}
