import 'package:intl/intl.dart';

extension FormatDate on DateTime {
  String get formatToTime => DateFormat('kk:mm').format(this);

  String get shortTime => DateFormat('hh:mm a').format(this);

  String get formatMonth => DateFormat('d MMM yyyy').format(this);

  String get staticAttributesDate => DateFormat('yyyy-MM-dd').format(this);

    String formatWithPattern(String pattern, {String? locale}) => DateFormat(pattern, locale).format(this);
}
