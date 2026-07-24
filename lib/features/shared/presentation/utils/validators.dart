import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateInput(String? input, String message) {
    if (input == null || input.isEmpty) {
      return message;
    }
    return null;
  }

  static String? validateEmail(String? input) {
    if (EmailValidator.validate(input ?? '') == false) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? input) {
    if ((input ?? '').length < 6) {
      return 'Enter a password more than 5 letters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? input, String password) {
    if (input == password) {
      return 'Confirm password does not match!';
    }
    return null;
  }
}
