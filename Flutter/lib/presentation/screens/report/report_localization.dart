import 'package:a_tareqaak/core/l10n/app_localizations.dart';

// ترجمة نوع البلاغ القادم من الـ API إلى نص مقروء
String localizeReportType(AppLocalizations tr, String? type) {
  switch (type) {
    case 'spam':
      return tr.spam;
    case 'fake':
      return tr.fake;
    case 'harassment':
      return tr.harassment;
    case 'dangerous':
      return tr.dangerous;
    case 'other':
      return tr.inappropriate_content;
    default:
      return type ?? tr.report_type;
  }
}

// ترجمة حالة البلاغ (pending / reviewed)
String localizeReportStatus(AppLocalizations tr, String? status) {
  return status == 'reviewed' ? tr.reviewed_status : tr.pending_status;
}

// تنسيق التاريخ القادم بصيغة ISO إلى صيغة مختصرة
String formatReportDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  final normalized = raw.replaceFirst('T', ' ');
  return normalized.length >= 16 ? normalized.substring(0, 16) : normalized;
}
