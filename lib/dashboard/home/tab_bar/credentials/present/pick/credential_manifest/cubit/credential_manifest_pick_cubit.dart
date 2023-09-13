import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/dashboard.dart';
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

    if (presentationDefinition.submissionRequirements != null) {
      /// https://identity.foundation/presentation-exchange/#presentation-definition-extensions
      final inputDescriptors = List.of(presentationDefinition.inputDescriptors);

      final newInputDescriptor = <InputDescriptor>[];

      /// grouping
      while (inputDescriptors.isNotEmpty) {
        final currentFirst = inputDescriptors.removeAt(0);
        final group = currentFirst.group.toString();

        final descriptorsWithSameGroup = inputDescriptors
            .where((descriptor) => descriptor.group.toString() == group)
            .toList();

        if (descriptorsWithSameGroup.isNotEmpty) {
          final mergedDescriptor = InputDescriptor(
            id: '${currentFirst.id},${descriptorsWithSameGroup.map((e) => e.id).join(",")}', // ignore: lines_longer_than_80_chars
            name: [
              currentFirst.name,
              ...descriptorsWithSameGroup.map((e) => e.name),
            ].where((e) => e != null).join(','),
            constraints: Constraints([
              ...?currentFirst.constraints?.fields,
              for (final descriptor in descriptorsWithSameGroup)
                ...?descriptor.constraints?.fields,
            ]),
            group: currentFirst.group,
            purpose: [
              currentFirst.purpose,
              ...descriptorsWithSameGroup.map((e) => e.purpose),
            ].where((e) => e != null).join(','),
          );
          newInputDescriptor.add(mergedDescriptor);
          inputDescriptors.removeWhere(
            (descriptor) => descriptor.group.toString() == group,
          );
        } else {
          newInputDescriptor.add(currentFirst);
        }
      }

      presentationDefinition = PresentationDefinition.copyWithData(
        oldPresentationDefinition: presentationDefinition,
        inputDescriptors: newInputDescriptor,
      );
    }

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
  }) {
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
                      ResponseString
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
