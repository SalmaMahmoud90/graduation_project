// حالات قائمة الرحلات المتاحة للتعديل
import 'package:a_tareqaak/data/models/ride/ride_model.dart';

abstract class EditRideListState {}

class EditRideListInitialState extends EditRideListState {}

class EditRideListLoadedState extends EditRideListState {
  final List<RideModel> rides;

  EditRideListLoadedState(this.rides);
}