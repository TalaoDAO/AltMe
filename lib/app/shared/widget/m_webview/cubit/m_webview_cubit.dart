import 'package:flutter_bloc/flutter_bloc.dart';

class MWebViewCubit extends Cubit<bool> {
  MWebViewCubit() : super(true);

  void setLoading({required bool isLoading}) {
    emit(isLoading);
  }
}
