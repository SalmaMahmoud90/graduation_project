import 'package:intl/intl.dart';

extension NumExtension on num {

  String removeTrailingZeros(int digits) {
    return toStringAsFixed(digits)
        .replaceFirst(RegExp(r'\.?0+$'), '');
  }


  String toShortPrice(int digits) {
    if (this >= 1000 && this < 1000000) {
      return '${(this / 1000).ceil()} K';
    }

    if (this >= 1000000) {
      return '${(this / 1000000).ceil()} M';
    }

    return removeTrailingZeros(digits);
  }


  String toCommaSeparated() {
    return NumberFormat('#,###').format(this);
  }
}