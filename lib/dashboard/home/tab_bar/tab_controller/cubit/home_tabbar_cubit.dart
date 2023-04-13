import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabbarCubit extends Cubit<int> {
  HomeTabbarCubit() : super(0);

  void setIndex(int index) {
    emit(index);
  }
}
