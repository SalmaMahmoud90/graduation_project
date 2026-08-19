extension Validation on String {
  /// Validates Syrian mobile numbers.
  ///
  /// The national significant number is `9XXXXXXXX` (9 digits, starts with 9).
  /// Accepts local forms (`09XXXXXXXX`, `9XXXXXXXX`) and international forms
  /// (`+9639XXXXXXXX`, `009639XXXXXXXX`). Spaces and dashes are ignored so
  /// inputs like `0999 123 456` still validate.
  bool get isValidPhone {
    final String sanitized = replaceAll(RegExp(r'[\s-]'), '');
    final RegExp phoneRegex =
     RegExp(r'^(?:00963|\+963|0)?9\d{8}$');
    return phoneRegex.hasMatch(sanitized);
  }

  bool get isValidEmail {
    final RegExp emailRegex =
     RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  bool get isValidPassword {
    return trim().length >= 8;
  }

  bool get isNotEmptyOrNull {
    return trim().isNotEmpty;
  }
}

class AppValidators {
  AppValidators._();

  static const int minPasswordLength = 8;

  static String? validateRequired(String? value, String fieldRequiredMessage) {
    if (value == null || value.trim().isEmpty) {
      return fieldRequiredMessage;
    }
    return null;
  }

  static String? validateEmail(String? value, String fieldRequiredMessage, String invalidEmailMessage) {
    final requiredError = validateRequired(value, fieldRequiredMessage);
    if (requiredError != null) return requiredError;
    if (!value!.isValidEmail) {
      return invalidEmailMessage;
    }
    return null;
  }

  static String? validatePhone(String? value, String fieldRequiredMessage, String invalidPhoneMessage) {
    final requiredError = validateRequired(value, fieldRequiredMessage);
    if (requiredError != null) return requiredError;
    if (!value!.isValidPhone) {
      return invalidPhoneMessage;
    }
    return null;
  }

  static String? validatePassword(String? value, String fieldRequiredMessage, String tooShortMessage) {
    final requiredError = validateRequired(value, fieldRequiredMessage);
    if (requiredError != null) return requiredError;
    if (!value!.isValidPassword) {
      return tooShortMessage;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password, String fieldRequiredMessage, String notMatchMessage) {
    final requiredError = validateRequired(value, fieldRequiredMessage);
    if (requiredError != null) return requiredError;
    if (value != password) {
      return notMatchMessage;
    }
    return null;
  }
}
