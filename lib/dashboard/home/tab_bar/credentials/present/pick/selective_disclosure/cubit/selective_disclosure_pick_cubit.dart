import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

part 'selective_disclosure_pick_state.dart';
part 'selective_disclosure_pick_cubit.g.dart';

class SelectiveDisclosureCubit extends Cubit<SelectiveDisclosureState> {
  SelectiveDisclosureCubit({
    required this.oidc4vc,
  }) : super(const SelectiveDisclosureState());

  final OIDC4VC oidc4vc;

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
    String? claimsKey,
    required CredentialModel credentialModel,
    String? threeDotValue,
  }) {
    final selectiveDisclosure = SelectiveDisclosure(credentialModel);

    int? index;

    if (threeDotValue != null) {
      for (final element
          in selectiveDisclosure.disclosureToContent.entries.toList()) {
        final sh256Hash = oidc4vc.sh256HashOfContent(element.value.toString());
        if (sh256Hash == threeDotValue) {
          final disclosure = element.key.replaceAll('=', '');

          index = selectiveDisclosure.disclosureFromJWT
              .indexWhere((element) => element == disclosure);
        }
      }
    } else if (claimsKey != null) {
      index = selectiveDisclosure.extractedValuesFromJwt.entries
          .toList()
          .indexWhere((entry) => entry.key == claimsKey);
    }

    if (index == null) {
      throw Exception();
    }

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
