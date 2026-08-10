// lib/presentation/cubit/customer_service/customer_service_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'customer_service_state.dart';

class CustomerServiceCubit extends Cubit<CustomerServiceState> {
  CustomerServiceCubit() : super(CustomerServiceInitialState());

  Future<void> submitReport(String text) async {
    if (text.trim().isEmpty) return;
    emit(CustomerServiceLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(CustomerServiceSuccessState());
    } catch (e) {
      emit(CustomerServiceErrorState(e.toString()));
    }
  }
}