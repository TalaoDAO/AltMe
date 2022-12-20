import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';

class RouteCubit extends Cubit<String?> {
  RouteCubit() : super('');

  final log = getLogger('RouteCubit');

  void setCurrentScreen(String? screenName) {
    /// track screen of user
    log.i('Screen -> $screenName');
    emit(screenName);
  }
}
