import 'package:flutter_bloc/flutter_bloc.dart';

class TabControllerCubit extends Cubit<int> {
  TabControllerCubit() : super(0);

  void setIndex(int index) {
    emit(index);
  }
}
