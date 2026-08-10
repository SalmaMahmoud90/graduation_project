extension UrlExtensions on String {
  String? extractIdFromUrl() {
    if (!contains('/ad/')) {
      return null;
    }

    // النمط لاستخراج الرقم بعد "/ad/"
    final pattern = RegExp(r'/ad/(\d+)');
    final match = pattern.firstMatch(this);

    if (match != null && match.groupCount > 0) {
      return match.group(1);
    }

    return null;
  }
}
