import 'package:p2u_wallet/v2/core/enums/view_state.dart';
import 'package:p2u_wallet/v2/core/models/base_view_model.dart';
import 'package:p2u_wallet/v2/core/services/api_services.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../locator.dart';
import '../../../../core/models/user_model.dart';
import '../registration_complete.dart';

/// [CreatePasswordProvider] is a class that acts as a [ViewModel] and transmits
/// data to [View] which here in our case is [CreatePasswordScreen]

class CreatePasswordProvider extends BaseViewModal {
  /// A [boolean] which acts as [Flag] to know if [TextInput] length is
  /// according to defined [rule].
  bool isCharacterLength = false;

  /// A [boolean] which acts as [Flag] to know if the [FirstCharacter] in [TextInput]
  /// is [LowerCase] letter.
  bool isFirstLetterLower = false;

  /// A [boolean] which acts as [Flag] to know if the [TextInput] consists of
  /// [UpperCase] and [lowerCase] letters.
  bool isUpperAndLowerCase = false;

  /// A [boolean] which acts as [Flag] to know if the [TextInput] consists of
  /// any [SpecialCharacter].
  bool isSpecialCharacterAndNumber = false;

  /// A [string] that stores [firstLetter] of the [TextInput]
  String firstLetter = "";

  /// A [boolean] to set [remember] flag.
  bool rememberMe = false;

  /// A [boolean] to set [passwordVisible] flag.
  bool isVisiblePassword = true;

  /// [TextEditingController] for [userPassword]
  TextEditingController userPassword = TextEditingController();

  /// [TextEditingController] for [userConfirmPassword]
  TextEditingController userConfirmPassword = TextEditingController();

  /// [ApiServices] object that calls different [APIs]
  final _apiServices = ApiServices();

  /// [AuthServices] object that consists of [User]'s data
  final locateUser = locator<AuthServices>();

  /// Determines following statements:
  /// - Contains upper and lowercase letters
  /// - Contains special characters
  /// - First Letter is Lower case
  /// - [TextInput] is greater than 8
  myOnChangeFun(var getValue) {
    // Upper and Lower Regex
    RegExp regexUpperAndLower = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])');

    // Special Character Regex
    RegExp regex = RegExp(r'^(?=.*?[0-9])(?=.*?[!@#\$&*~])');

    // Check if there is Special Character than set
    // isSpecialCharacter to true and false otherwise
    if (regex.hasMatch(getValue)) {
      isSpecialCharacterAndNumber = true;
    } else {
      isSpecialCharacterAndNumber = false;
    }
    // Check if there are upper and lower case letter than set
    // isUpperAndLowerCase to true and false otherwise
    if (regexUpperAndLower.hasMatch(getValue)) {
      isUpperAndLowerCase = true;
    } else {
      isUpperAndLowerCase = false;
    }
    // Check if there character length is greater than 4,  set
    // isCharacterLength to true and false otherwise
    if (getValue.length > 8) {
      isCharacterLength = true;
    } else {
      isCharacterLength = false;
    }

    if (getValue.isEmpty || getValue == null) {
      isFirstLetterLower = false;
    } else {
      firstLetter = getValue.trimLeft().substring(0, 1);
      if (firstLetter.toLowerCase() == getValue.substring(0, 1)) {
        isFirstLetterLower = true;
      } else {
        isFirstLetterLower = false;
      }
    }

    notifyListeners();
  }

  /// Set [rememberMe] to input value
  changeRememberMe(var getValue) {
    rememberMe = !getValue;
    notifyListeners();
  }

  /// Determines whether to [show] or [hide] the [password] in [TextInputField]
  visiblePassword() {
    isVisiblePassword = !isVisiblePassword;
    notifyListeners();
  }

  /// A async [Function] that accepts two values:
  /// - [context] of type [BuildContext]
  /// - [getUserID] of type [String]
  ///
  /// The following operations are done in this function:
  /// - Create [SignUp] for the Wallet
  /// - Create account with [Username], [Password] and [Email]
  ///
  /// if all the conditions are fulfilled [fetchUser] successful
  /// than navigate to [RegistrationScreen]

  createUserId(context, {final getUserId}) async {
    //Set Current State to busy
    setState(ViewState.busy);

    try {
      //Create Signup by using display name and email.
      await _apiServices.signUp(
        locateUser.firebaseUser!.displayName ?? locateUser.appleDisplayName!,
        locateUser.firebaseUser!.email!,
      );
      //Create Username by using userID, userPassword and userEmail
      await _apiServices.createUserName(
        getUserId,
        userPassword.text,
        locateUser.firebaseUser!.email!,
      );
      //Fetch User
      var result = await ApiServices().fetchUser();

      if (result == false) {
      } else {
        //Store the results of fetchedUser
        locateUser.myAppUser = UserModel.fromJson(result);
        //Navigate to RegistrationComplete screen.
        Get.offAll(() => RegistrationComplete());
      }
    } catch (e) {
      // If any exception occurs,
      // print it out in Scaffold snack-bar
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
    //Set State to idle as all operation are done
    setState(ViewState.idle);
  }
}
