import 'package:bloc/bloc.dart';

class DeepLinkCubit extends Cubit<String> {
  DeepLinkCubit() : super('');

  void addDeepLink(String url) {
    emit(url);
  }

  void resetDeepLink() {
    emit('');
  }
}
