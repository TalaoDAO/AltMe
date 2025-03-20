import 'dart:convert';

import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selective_disclosure_pick_state.dart';
part 'selective_disclosure_pick_cubit.g.dart';

class SelectiveDisclosureCubit extends Cubit<SelectiveDisclosureState> {
  SelectiveDisclosureCubit() : super(const SelectiveDisclosureState());

  void dataFromPresentation({
    required CredentialModel credentialModel,
    required PresentationDefinition? presentationDefinition,
  }) {
    String? limitDisclosure;
    final json = <String, dynamic>{};

    if (presentationDefinition != null) {
      final selectiveDisclosure = SelectiveDisclosure(credentialModel);

      final credentialData = createJsonByDecryptingSDValues(
        encryptedJson: credentialModel.data,
        selectiveDisclosure: selectiveDisclosure,
      );

      for (final inputDescriptor in presentationDefinition.inputDescriptors) {
        final filterList = inputDescriptor.constraints?.fields ?? <Field>[];

        limitDisclosure = inputDescriptor.constraints?.limitDisclosure;

        for (final field in filterList) {
          for (final path in field.path) {
            final searchList = getTextsFromCredential(path, credentialData);
            for (final element in searchList) {
              final key = path.split('.').toList().last;
              json[key] = element;
            }
          }
        }
      }

      emit(state.copyWith(limitDisclosure: limitDisclosure, filters: json));
    }
  }

  void toggle(String claimKeyId, String? sd) {
    final List<SelectedClaimsKeyIds> selectedClaimsKeys =
        List.of(state.selectedClaimsKeyIds);

    late List<SelectedClaimsKeyIds> ids;

    final selectedKey = selectedClaimsKeys
        .firstWhereOrNull((ele) => ele.keyId == '$claimKeyId#$sd');

    if (selectedKey != null) {
      ids = List<SelectedClaimsKeyIds>.from(state.selectedClaimsKeyIds)
        ..removeWhere((element) => element.keyId == '$claimKeyId#$sd')
        ..add(
          SelectedClaimsKeyIds(
            keyId: '$claimKeyId#$sd',
            isSelected: !selectedKey.isSelected,
          ),
        );
    } else {
      /// adding
      ids = [
        ...state.selectedClaimsKeyIds,
        ...[
          SelectedClaimsKeyIds(keyId: '$claimKeyId#$sd', isSelected: true),
        ],
      ];
    }
    emit(state.copyWith(selectedClaimsKeyIds: ids));
  }

  void saveIndexOfSDJWT({
    String? claimsKey,
    required CredentialModel credentialModel,
    String? threeDotValue,
    String? sd,
  }) {
    final selectiveDisclosure = SelectiveDisclosure(credentialModel);

    int? index;

    if (sd != null) {
      index = selectiveDisclosure.disclosureFromJWT
          .indexWhere((entry) => entry == sd);
    } else if (threeDotValue != null) {
      index = selectiveDisclosure.disclosureFromJWT
          .indexWhere((entry) => entry == threeDotValue);
    } else if (claimsKey != null) {
      index = selectiveDisclosure.disclosureListToContent.entries
          .toList()
          .indexWhere(
            (entry) =>
                selectiveDisclosure
                    .getMapFromList(
                      jsonDecode(entry.value.toString()) as List,
                    )
                    .keys
                    .first ==
                claimsKey,
          );
    }

    if (!(index == null || index == -1)) {
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

  void disclosureAction({
    required String claimKeyId,
    required CredentialModel credentialModel,
    String? threeDotValue,
    String? claimsKey,
    String? sd,
  }) {
    final selectiveDisclosure = SelectiveDisclosure(credentialModel);
    toggle(claimKeyId, sd);
    saveIndexOfSDJWT(
      claimsKey: claimsKey,
      credentialModel: credentialModel,
      threeDotValue: threeDotValue,
      sd: sd,
    );
  }
}
