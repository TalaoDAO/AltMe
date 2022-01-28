import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<bool> {
  HomeCubit() : super(false);

  void toggle() {
    emit(!state);
  }
}
