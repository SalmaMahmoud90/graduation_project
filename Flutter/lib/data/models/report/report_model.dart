// نموذج بيانات البلاغ
class ReportModel {
  final String id;
  final String type; // نوع البلاغ (تحرش، سبام، مزيف، إلخ)
  final String status; // معلق / تمت المراجعة
  final String description; // نص البلاغ
  final String date; // تاريخ الإبلاغ
  final String? relatedRide; // الرحلة المرتبطة
  final int commentsCount;
  final String? adminNotes;
  final String? adminNoteDate;

  ReportModel({
    required this.id,
    required this.type,
    required this.status,
    required this.description,
    required this.date,
    this.relatedRide,
    this.commentsCount = 0,
    this.adminNotes,
    this.adminNoteDate,
  });
}