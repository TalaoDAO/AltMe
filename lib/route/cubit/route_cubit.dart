import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class RouteCubit extends Cubit<String?> {
  RouteCubit() : super('');

  final log = getLogger('RouteCubit');

  void setCurrentScreen(String? screenName) {
    /// track screen of user
    Sentry.captureMessage('Screen -> $screenName');
    emit(screenName);
  }
}
