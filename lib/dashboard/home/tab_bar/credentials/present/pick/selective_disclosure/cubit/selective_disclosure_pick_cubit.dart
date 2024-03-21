import 'package:altme/app/shared/shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selective_disclosure_pick_state.dart';
part 'selective_disclosure_pick_cubit.g.dart';

class SelectiveDisclosureCubit extends Cubit<SelectiveDisclosureState> {
  SelectiveDisclosureCubit() : super(const SelectiveDisclosureState());

  void toggle(int index) {
    final bool isSelected = state.selected.contains(index);

    late List<int> selected;

    if (isSelected) {
      /// deSelecting the credential
      selected = List<int>.from(state.selected)
        ..removeWhere((element) => element == index);
    } else {
      /// selecting the credential
      selected = [
        ...state.selected,
        ...[index],
      ];
    }
    emit(state.copyWith(selected: selected));
  }

  void saveIndexOfSDJWT(int index) {
    final bool isSelected = state.selectedSDIndexInJWT.contains(index);

    late List<int> selected;

    if (isSelected) {
      /// deSelecting the credential
      selected = List<int>.from(state.selectedSDIndexInJWT)
        ..removeWhere((element) => element == index);
    } else {
      /// selecting the credential
      selected = [
        ...state.selectedSDIndexInJWT,
        ...[index],
      ];
    }
    emit(state.copyWith(selectedSDIndexInJWT: selected));
  }
}
