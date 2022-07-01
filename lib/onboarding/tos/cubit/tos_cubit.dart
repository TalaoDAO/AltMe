import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tos_state.dart';

class TOSCubit extends Cubit<TOSState> {
  TOSCubit() : super(const TOSState());

  void setScrolledIsOver({required bool scrollIsOver}) {
    emit(state.copyWith(scrollIsOver: scrollIsOver));
  }

  void setAgreeTerms({required bool agreeTerms}) {
    emit(state.copyWith(agreeTerms: agreeTerms));
  }

  void setReadTerms({required bool readTerms}) {
    emit(state.copyWith(readTerms: readTerms));
  }

  void setAcceptanceButtonEnabled({required bool acceptanceButtonEnabled}) {
    emit(state.copyWith(acceptanceButtonEnabled: acceptanceButtonEnabled));
  }
}
