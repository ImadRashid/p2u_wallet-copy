import 'package:p2u_wallet/locator.dart';
import 'package:p2u_wallet/v2/core/services/auth_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/models/user_model.dart';

/// A [ViewModel] which transmits data to our [View] which here is [RegistrationComplete]
class RegistrationProvider extends ChangeNotifier {
  /// An [AuthServices] object
  final locateUser = locator<AuthServices>();

  /// An [AppUser] object that contains [AppUser] data.
  UserModel myAppUser = UserModel();

  /// A [constructor] that initializes [AppUser] with
  /// [LocatorAuthServices]
  RegistrationProvider() {
    myAppUser = locateUser.myAppUser;
  }
}
