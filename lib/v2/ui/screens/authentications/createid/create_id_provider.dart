import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../locator.dart';

/// This [CreateIDProvided] is class, which acts as a [ViewModel] and transmits
/// data to [View] which in our case is [CreateIDScreen]

class CreateIdProvider extends ChangeNotifier {
  /// Handles authentication services
  final auth = locator<AuthServices>();

  /// Determines whether the number of characters are greater than 4
  /// and less than 10
  bool isCharacterLength = false;

  /// Determines whether the first letter is lower or not
  bool isFirstLettterLower = false;
  String firstLetter = "";

  /// [TextEditingController] for userID [TextInput]

  TextEditingController userId = TextEditingController();

  /// [TextEditingController] for fullName [TextInput]
  TextEditingController fullName = TextEditingController();

  /// [Function] that checks:
  /// * if value has characters greater than 4.
  /// * if first letter is lower case.
  myOnChangeFun(var getValue) {
    if (getValue.length > 4) {
      isCharacterLength = true;
    } else {
      isCharacterLength = false;
    }

    if (getValue.isEmpty || getValue == null) {
      isFirstLettterLower = false;
    } else {
      //checks if first letter is lower case.
      firstLetter = getValue.trimLeft().substring(0, 1);
      if (firstLetter.toLowerCase() == getValue.substring(0, 1)) {
        isFirstLettterLower = true;
      } else {
        isFirstLettterLower = false;
      }
    }

    notifyListeners();
  }

  /// [Function] that logouts the [User] from its current account.
  logoutUser() async {
    await auth.logout();
  }
}
