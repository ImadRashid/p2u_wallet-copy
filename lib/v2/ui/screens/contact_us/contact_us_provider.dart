import 'package:p2u_wallet/v2/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// A [ViewModel] that transmits data to our [View] which here is [ContactUsScreen].
class ContactUsProvider extends ChangeNotifier {
  /// A [TextEditingController] that controls [error]'s [TextInput]
  TextEditingController? errorController;

  /// A [TextEditingController] that controls [email]'s [TextInput]
  TextEditingController? emailController;

  /// A [TextEditingController] that controls [message]'s [TextInput]
  TextEditingController? messageController;

  /// A [boolean] that determines the color of submit button and whether that
  /// button should work or not.
  bool isEnabled = false;

  /// A [constructor] that initializes all its [data] members
  ContactUsProvider() {
    errorController = TextEditingController();
    emailController = TextEditingController();
    messageController = TextEditingController();
    isEnabled = false;
  }

  /// [Function] that determines whether to enable submit button
  /// or not.
  changeEnabled() {
    if (errorController!.text.isNotEmpty &&
        emailController!.text.isNotEmpty &&
        messageController!.text.isNotEmpty) {
      isEnabled = true;
    } else {
      isEnabled = false;
    }
    notifyListeners();
  }

  /// [Function] that clears all data members data.
  clear() {
    errorController = emailController = messageController = null;
    isEnabled = false;
    notifyListeners();
  }

  /// [Function] that sends [email] of [user]'s response and returns
  /// a [response] in case request is failure or success.
  ///
  /// [Response] consists of two parts:
  /// - [msg] - [String] value that consists of [message] to be displayed
  /// - [color] - [Color] value that consists of [color] in which message is to
  /// be displayed
  sendEmail() async {
    //check validation
    var response = checkValidations();
    bool? emailResponse;
    if (response == true) {
      /*Email email = Email(
          recipients: ["msq.common@gmail.com"],
          cc: [emailController!.text],
          subject: errorController!.text,
          body: messageController!.text);*/
      try {
        //await FlutterEmailSender.send(email);
        emailResponse = true;
      } catch (e) {
        debugPrint(e.toString());
        emailResponse = false;
      }
      if (emailResponse) {
        return {"msg": "contact_us_error_1".tr, "color": successColor30};
      } else {
        return {"msg": "contact_us_error_2".tr, "color": dangerColor10};
      }
    } else {
      return response;
    }
  }

  /// [Function] that checks all the validations and returns true if all
  /// conditions are passed or specific [response] of following parts:
  /// - [msg] - [String] value that consists of [message] to be displayed
  /// - [color] - [Color] value that consists of [color] in which message is to
  /// be displayed
  checkValidations() {
    if (errorController!.text.isEmpty) {
      return {"msg": "contact_us_error_3".tr, "color": dangerColor10};
    } else if (emailController!.text.isEmpty) {
      return {"msg": "contact_us_error_4".tr, "color": dangerColor10};
    } else if (errorController!.text.isEmpty) {
      return {"msg": "contact_us_error_5".tr, "color": dangerColor10};
    } else if (!EmailValidator.validate(emailController!.text)) {
      return {"msg": "contact_us_error_6".tr, "color": dangerColor10};
    }
    return true;
  }
}
