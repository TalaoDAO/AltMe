import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selective_disclosure_pick_state.dart';
part 'selective_disclosure_pick_cubit.g.dart';

class SelectiveDisclosureCubit extends Cubit<SelectiveDisclosureState> {
  SelectiveDisclosureCubit() : super(const SelectiveDisclosureState());

  void toggle(String claimKeyId) {
    final List<String> selectedClaimsKeys = List.of(state.selectedClaimsKeyIds);

    late List<String> id;

    if (selectedClaimsKeys.contains(claimKeyId)) {
      /// deSelecting the credential
      id = List<String>.from(state.selectedClaimsKeyIds)
        ..removeWhere((element) => element == claimKeyId);
    } else {
      /// selecting the credential
      id = [
        ...state.selectedClaimsKeyIds,
        ...[claimKeyId],
      ];
    }
    emit(state.copyWith(selectedClaimsKeyIds: id));
  }

  void saveIndexOfSDJWT({
    required String claimsKey,
    required CredentialModel credentialModel,
  }) {
    final selectiveDisclosure = SelectiveDisclosure(credentialModel);
    final sdIndexInJWT = selectiveDisclosure.extractedValuesFromJwt.entries
        .toList()
        .indexWhere((entry) => entry.key == claimsKey);

    final bool isSelected = state.selectedSDIndexInJWT.contains(sdIndexInJWT);

    late List<int> selected;

    if (isSelected) {
      /// deSelecting the credential
      selected = List<int>.from(state.selectedSDIndexInJWT)
        ..removeWhere((element) => element == sdIndexInJWT);
    } else {
      /// selecting the credential
      selected = [
        ...state.selectedSDIndexInJWT,
        ...[sdIndexInJWT],
      ];
    }
    emit(state.copyWith(selectedSDIndexInJWT: selected));
  }
}
