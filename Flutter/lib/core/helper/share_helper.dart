import 'dart:developer';
import 'package:share_plus/share_plus.dart';

// مساعد مشاركة المحتوى النصي باستخدام مكتبة share_plus
class ShareHelper {
  static Future<void> shareText(String text, {String? subject}) async {
    try {
      await SharePlus.instance.share(
        ShareParams(text: text, subject: subject),
      );
    } catch (e) {
      log('****************Could not share content: $e');
    }
  }
}
