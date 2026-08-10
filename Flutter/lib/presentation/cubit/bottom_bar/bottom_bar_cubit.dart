import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBarCubit extends Cubit<bool> {
  BottomBarCubit() : super(true);

  void toggleBottomBar() => emit(state ? false : true);

  void setBottomBarVisibility(bool v) => emit(v);
}
