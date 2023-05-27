import 'package:flutter/cupertino.dart';

/// Class that handles the Password Attempts for in-app transactions
class PasswordModel extends ChangeNotifier {
  /// [Integer[ that stores total Attempts
  int? _totalAttempts;

  /// [TextEditingController] that handles [_passwordController]
  TextEditingController? _passwordController;

  /// Main [Constructor]
  PasswordModel() {
    // initializes the total attempts
    _totalAttempts = 10;
    // initializes password Controller
    _passwordController = TextEditingController();
  }

  /// [Function] that reduces total attempts and than notifies
  /// listeners
  void reduceAttempts() {
    _totalAttempts = _totalAttempts! - 1;
    notifyListeners();
  }

  /// [Getter] Function that returns total number of attempts.
  int get totalAttempts => _totalAttempts!;

  /// [Setter] Function that sets the total attempts, its mostly used for
  /// resetting the total attempts.
  set totalAttempts(int value) {
    _totalAttempts = value;
    notifyListeners();
  }

  /// [Getter] function for password controller.
  TextEditingController get passwordController => _passwordController!;
}
