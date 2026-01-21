import 'package:altme/app/shared/alert_message/exception_message.dart';
import 'package:bloc/bloc.dart';

class MessageCubit extends Cubit<ExceptionMessage> {
  MessageCubit() : super(ExceptionMessage(error: '', errorDescription: ''));
  
  void error(ExceptionMessage exception) {
    emit(exception);
  }
}
