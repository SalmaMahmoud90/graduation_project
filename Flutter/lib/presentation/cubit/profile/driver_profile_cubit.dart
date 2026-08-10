import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/helper/media_picker_helper.dart';
import 'driver_profile_state.dart';

// كيوبيت إدارة بروفايل السائق
class DriverProfileCubit extends Cubit<DriverProfileState> {
  DriverProfileCubit() : super(DriverProfileInitialState());

  final MediaPickerHelper _mediaPickerHelper = MediaPickerHelper();

  String driverName = 'أحمد علي';
  String phone = '0999 123 456';
  String carName = 'Kia Rio';
  String carColor = 'أبيض';
  String carPlate = '12-34567';
  String carId = '123456';
  String manufacturingYear = '2020';

  // القيمة الافتراضية تكون false للسائق الجديد
  bool isProfileComplete = false;

  String? profileImagePath;
  String? carCoverImagePath;

  // اختيار صورة البروفايل الشخصية
  Future<void> pickProfileImage(dynamic context) async {
    final imagePath = await _mediaPickerHelper.pickImage(context);
    if (imagePath != null) {
      profileImagePath = imagePath;
      emit(DriverProfileImagePickedState(
        profileImagePath: profileImagePath,
        carCoverImagePath: carCoverImagePath,
      ));
    }
  }

  // اختيار صورة غلاف السيارة
  Future<void> pickCarCoverImage(dynamic context) async {
    final imagePath = await _mediaPickerHelper.pickImage(context);
    if (imagePath != null) {
      carCoverImagePath = imagePath;
      emit(DriverProfileImagePickedState(
        profileImagePath: profileImagePath,
        carCoverImagePath: carCoverImagePath,
      ));
    }
  }

  // دالة تحديث بيانات بروفايل السائق والسيارة
  Future<void> updateProfile({
    required String name,
    required String phoneNum,
    required String car,
    required String color,
    required String plate,
  }) async {
    emit(DriverProfileLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      driverName = name;
      phone = phoneNum;
      carName = car;
      carColor = color;
      carPlate = plate;
      isProfileComplete = true; // اكتمل البروفايل بنجاح
      emit(DriverProfileSuccessState());
    } catch (e) {
      emit(DriverProfileErrorState(e.toString()));
    }
  }
}