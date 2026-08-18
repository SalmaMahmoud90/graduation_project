import 'package:a_tareqaak/domain/entity/report/report_entity.dart';
import 'package:a_tareqaak/presentation/cubit/report/create_report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CreateReportCubit extends Cubit<CreateReportCubitState> {
  CreateReportCubit() : super(const CreateReportCubitState(entity: null));

  void updateReport({required int userId, required String type, required String reason, int? ride}) {
    emit(
      state.copyWith(
        entity: CreateReportEntity(
          userId: userId,
          type: type,
          reason: reason,
          ride: ride,
        ),
      ),
    );
  }
}