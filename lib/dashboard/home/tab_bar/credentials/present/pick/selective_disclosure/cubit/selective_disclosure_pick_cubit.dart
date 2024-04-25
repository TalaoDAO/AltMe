import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:credential_manifest/credential_manifest.dart';
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
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Issue with the dislosuer of jwt.',
        },
      );
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

  void disclosureAction({
    required String claimKeyId,
    required CredentialModel credentialModel,
    String? threeDotValue,
    String? claimsKey,
  }) {
    toggle(claimKeyId);
    saveIndexOfSDJWT(
      claimsKey: claimsKey,
      credentialModel: credentialModel,
      threeDotValue: threeDotValue,
    );
  }
}
