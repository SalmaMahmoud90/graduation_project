extension Validation on String {
  bool get isValidPhone {
    final RegExp phoneRegex = RegExp(r'^(009665|9665|\\+9665|05|5)([503649187])([0-9]{7})$');
    return phoneRegex.hasMatch(this);
  }

  bool get isValidEmail {
    final RegExp emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }
}
