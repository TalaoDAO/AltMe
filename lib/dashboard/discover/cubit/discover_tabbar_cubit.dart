import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverTabbarCubit extends Cubit<int> {
  DiscoverTabbarCubit() : super(0);

  void setIndex(int index) {
    emit(index);
  }
}
