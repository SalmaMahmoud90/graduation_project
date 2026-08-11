import 'package:a_tareqaak/core/extension/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatterHelper {
  // ==> 'Thu, 5/23/2013 10:21:47 AM'
  static String formatDateAppointments(DateTime date) {
    return (DateFormat.yMEd().add_jm().format(date)).toString();
  }

  static Color hexToColor(String code) {
    // Remove the '#' prefix if present
    if (code.startsWith('#')) {
      code = code.substring(1);
    }
    // Parse the hexadecimal color code
    return Color(int.parse(code, radix: 16) + 0xFF000000);
  }

  static String timePassed(DateTime datetime, {bool full = true}) {
    DateTime now = DateTime.now();
    DateTime ago = datetime;
    Duration dur = now.difference(ago);
    int days = dur.inDays;
    int years = days ~/ 365;
    int months = (days - (years * 365)) ~/ 30;
    int weeks = (days - (years * 365 + months * 30)) ~/ 7;
    int rDays = days - (years * 365 + months * 30 + weeks * 7).toInt();
    int hours = (dur.inHours % 24).toInt();
    int minutes = (dur.inMinutes % 60).toInt();
    int seconds = (dur.inSeconds % 60).toInt();
    var diff = {
      "d": rDays,
      "w": weeks,
      "m": months,
      "y": years,
      "s": seconds,
      "i": minutes,
      "h": hours,
    };

    // Map str = {
    //   'y': 'year',
    //   'm': 'month',
    //   'w': 'week',
    //   'd': 'day',
    //   'h': 'hour',
    //   'i': 'minute',
    //   's': 'second',
    // };
    Map str = {
      'y': 'سنة',
      'm': 'شهر',
      'w': 'أسبوع',
      'd': 'يوم',
      'h': 'ساعة',
      'i': 'دقيقة',
      's': 'ثانية',
    };

    str.forEach((k, v) {
      if (diff[k]! > 0) {
        // str[k] = '${diff[k]} $v${diff[k]! > 1 ? 's' : ''}';
        str[k] = '${diff[k]} $v${diff[k]! > 1 ? '' : ''}';
      } else {
        str[k] = "";
      }
    });
    str.removeWhere((index, ele) => ele == "");
    List<String> tList = [];
    str.forEach((k, v) {
      tList.add(v);
    });
    if (full) {
      return str.isNotEmpty ? "منذ ${tList.join("، ")}" : "الآن";
    } else {
      return str.isNotEmpty ? "منذ ${tList[0]}" : "الآن";
    }
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static DateTime minimumSelectableDate({int daysFromNow = 3}) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: daysFromNow));
  }

  static DateTime? parseIsoDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return null;
    return DateTime.tryParse(isoDate);
  }

  static String formatDateForDisplay(
    String? isoDate, {
    String pattern = 'MM/dd/yyyy',
    String? locale,
  }) {
    final parsed = parseIsoDate(isoDate);
    return parsed?.formatWithPattern(pattern, locale: locale) ?? '';
  }

  static TimeOfDay parseTimeOfDay(
    String? time, {
    TimeOfDay fallback = const TimeOfDay(hour: 9, minute: 0),
  }) {
    final parsed = _parseTime(time);
    if (parsed == null) return fallback;
    return TimeOfDay.fromDateTime(parsed);
  }

  static String formatTimeForDisplay(
    String? time, {
    String pattern = 'hh:mm a',
    String locale = 'en',
  }) {
    final parsed = _parseTime(time);
    return parsed?.formatWithPattern(pattern, locale: locale) ?? '';
  }

  static String formatDateForStorage(DateTime date) => date.staticAttributesDate;

  static String formatTimeForStorage(
    TimeOfDay time, {
    String pattern = 'HH:mm',
  }) => _timeOfDayToDateTime(time).formatWithPattern(pattern);

  static String? formatDateTimeForStorage(
    String? isoDate,
    String? time, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
  }) {
    final parsedDate = parseIsoDate(isoDate);
    if (parsedDate == null) return null;

    final parsedTime = _parseTime(time);
    if (parsedTime == null) return null;

    final combined = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    return combined.formatWithPattern(pattern);
  }

  static DateTime? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return DateTime(0, 1, 1, hour, minute);
  }

  static DateTime _timeOfDayToDateTime(TimeOfDay time) => DateTime(0, 1, 1, time.hour, time.minute);

  static String getDateString(BuildContext context, DateTime? date) {
    final locale = Localizations.localeOf(context).languageCode;

    if (locale == 'ar' && date != null) {
      return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day}";
    } else if (locale == 'en' && date != null) {
      return "${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } else {
      return '';
    }
  }

  static String formatArabicDate(String rawDate) {
    final parts = rawDate.split('-');
    if (parts.length != 3) return rawDate;

    final year = parts[0];
    final month = parts[1].padLeft(2, '0');
    final day = parts[2].padLeft(2, '0');

    final formattedDate = '$year-$month-$day';
    final date = DateTime.parse(formattedDate);

    return DateFormat('d MMMM y', 'ar').format(date);
  }

  static DateTime? combineDateAndTime(String? dateString, String? timeString) {
    final date = parseIsoDate(dateString);
    final time = parseTimeOfDay(timeString);

    if (date == null) {
      return null;
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  static bool isEndAfterStart(DateTime? start, DateTime? end) {
    if (start == null || end == null) return true;

    // المدة بين التاريخين
    final difference = end.difference(start).inDays;

    // الفرق 0 إلى 3 أيام فقط (على الأكثر 3)
    return difference <= 3 && difference >= 0;
  }

  static Duration? calculateDuration(String? date) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime start = format.parse(date!);
      DateTime now = DateTime.now();

      Duration dur = start.difference(now);

      if (dur.isNegative || dur == Duration.zero) return null;
      return dur;
    } catch (e) {
      print("Date parse error: $e");
      return null;
    }
  }
}
