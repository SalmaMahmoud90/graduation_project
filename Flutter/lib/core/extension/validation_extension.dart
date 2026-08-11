extension Validation on String {
  /// Validates Syrian mobile numbers.
  ///
  /// The national significant number is `9XXXXXXXX` (9 digits, starts with 9).
  /// Accepts local forms (`09XXXXXXXX`, `9XXXXXXXX`) and international forms
  /// (`+9639XXXXXXXX`, `009639XXXXXXXX`). Spaces and dashes are ignored so
  /// inputs like `0999 123 456` still validate.
  bool get isValidPhone {
    final String sanitized = replaceAll(RegExp(r'[\s-]'), '');
    final RegExp phoneRegex = RegExp(r'^(?:00963|\+963|0)?9\d{8}$');
    return phoneRegex.hasMatch(sanitized);
  }

  bool get isValidEmail {
    final RegExp emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }
}
