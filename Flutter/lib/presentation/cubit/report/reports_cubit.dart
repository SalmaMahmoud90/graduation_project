// lib/presentation/cubit/reports/reports_cubit.dart
import 'package:a_tareqaak/data/models/report/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitialState());

  List<ReportModel> reportsList = [
    ReportModel(
      id: '1',
      type: 'مضايقة',
      status: 'معلق',
      description: 'قام المستخدم بمضايقتي أثناء الرحلة وتحدث بطريقة غير لائقة.',
      date: '20 مايو 2024',
      commentsCount: 0,
      relatedRide: 'عمان -> الزرقاء',
      adminNotes: 'تم استلام البلاغ وجارٍ مراجعته من قبل فريق الدعم.',
      adminNoteDate: '02:15 - 21 مايو 2024',
    ),
    ReportModel(
      id: '2',
      type: 'سبام',
      status: 'تمت المراجعة',
      description: 'يرسل رسائل ترويجية غير مرغوب فيها بشكل متكرر.',
      date: '18 مايو 2024',
      commentsCount: 2,
    ),
    ReportModel(
      id: '3',
      type: 'مزيف',
      status: 'تمت المراجعة',
      description: 'الملف الشخصي يحتوي على معلومات مزيفة وصور غير حقيقية.',
      date: '15 مايو 2024',
      commentsCount: 1,
    ),
    ReportModel(
      id: '4',
      type: 'محتوى غير لائق',
      status: 'معلق',
      description: 'نشر محتوى غير لائق ومخالف للآداب العامة.',
      date: '10 مايو 2024',
      commentsCount: 0,
    ),
  ];

  void fetchReports() {
    emit(ReportsLoadedState(List.from(reportsList)));
  }

  // إرسال بلاغ جديد
  Future<void> sendReport({
    required String type,
    required String description,
    String? relatedRide,
  }) async {
    emit(ReportsLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final newReport = ReportModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        status: 'معلق',
        description: description,
        date: '21 مايو 2024',
        relatedRide: relatedRide ?? 'عمان -> الزرقاء',
        commentsCount: 0,
        adminNotes: 'تم استلام البلاغ وجارٍ مراجعته من قبل فريق الدعم.',
        adminNoteDate: '02:15 - 21 مايو 2024',
      );
      reportsList.insert(0, newReport);
      emit(SendReportSuccessState());
      fetchReports();
    } catch (e) {
      emit(ReportsErrorState(e.toString()));
    }
  }
}