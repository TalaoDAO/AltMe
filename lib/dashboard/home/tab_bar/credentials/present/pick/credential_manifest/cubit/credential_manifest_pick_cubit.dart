import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/credential_manifest/helpers/apply_submission_requirements.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_manifest_pick_state.dart';

part 'credential_manifest_pick_cubit.g.dart';

/// This Cubit provide list of Credentials as required by issuer
class CredentialManifestPickCubit extends Cubit<CredentialManifestPickState> {
  CredentialManifestPickCubit({
    required List<CredentialModel> credentialList,
    required CredentialModel credential,
    required int inputDescriptorIndex,
  }) : super(const CredentialManifestPickState(filteredCredentialList: [])) {
    filterList(
      credentialList: credentialList,
      credential: credential,
      inputDescriptorIndex: inputDescriptorIndex,
    );
  }

  void filterList({
    required List<CredentialModel> credentialList,
    required CredentialModel credential,
    required int inputDescriptorIndex,
  }) {
    var presentationDefinition =
        credential.credentialManifest!.presentationDefinition!;

    presentationDefinition =
        applySubmissionRequirements(presentationDefinition);

    /// Get instruction to filter credentials of the wallet
    final filteredCredentialList = getCredentialsFromPresentationDefinition(
      presentationDefinition: presentationDefinition,
      credentialList: List.from(credentialList),
      inputDescriptorIndex: inputDescriptorIndex,
    );

    emit(
      state.copyWith(
        filteredCredentialList: filteredCredentialList,
        presentationDefinition: presentationDefinition,
      ),
    );
  }

  void toggle({
    required int index,
    required InputDescriptor inputDescriptor,
    required bool isVcSdJWT,
  }) {
    final bool isSelected = state.selected.contains(index);

    late List<int> selected;

    if (isSelected) {
      /// deSelecting the credential
      selected = List<int>.from(state.selected)
        ..removeWhere((element) => element == index);
    } else {
      if (isVcSdJWT) {
        /// selecting one credential
        selected = [index];
      } else {
        /// selecting multiple credential
        selected = [
          ...state.selected,
          ...[index],
        ];
      }
    }

    bool isButtonEnabled = selected.isNotEmpty;

    if (state.presentationDefinition!.submissionRequirements != null) {
      final requirement = state.presentationDefinition!.submissionRequirements!
          .where((element) => element.from == inputDescriptor.group?[0])
          .firstOrNull;

      if (requirement != null) {
        final count = requirement.count;
        final atLeast = requirement.min;
        if (count != null) {
          if (!isSelected) {
            /// selecting the credential

            if (state.selected.length >= count) {
              /// show message that limit is (count)
              emit(
                state.copyWith(
                  message: StateMessage.info(
                    messageHandler: ResponseMessage(
                      message: ResponseString
                          .RESPONSE_STRING_youcanSelectOnlyXCredential,
                    ),
                    injectedMessage: count.toString(),
                  ),
                ),
              );
              return;
            }
          }

          isButtonEnabled = selected.length == count;
        } else if (atLeast != null) {
          isButtonEnabled = selected.length >= atLeast;
        } else {
          throw Exception();
        }
      } else {
        throw Exception();
      }
    } else {
      /// normal case
      isButtonEnabled = selected.isNotEmpty;
    }

    emit(
      state.copyWith(
        selected: selected,
        isButtonEnabled: isButtonEnabled,
      ),
    );
  }
}
