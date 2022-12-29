import 'package:altme/dashboard/dashboard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_manifest_pick_state.dart';

part 'credential_manifest_pick_cubit.g.dart';

/// This Cubit provide list of Credentials as required by issuer
class CredentialManifestPickCubit extends Cubit<CredentialManifestPickState> {
  CredentialManifestPickCubit({
    List<CredentialModel> credentialList = const <CredentialModel>[],
    Map<String, dynamic> presentationDefinition = const <String, dynamic>{},
    required int inputDescriptorIndex,
  }) : super(const CredentialManifestPickState(filteredCredentialList: [])) {
    filterList(
      credentialList: credentialList,
      presentationDefinition: presentationDefinition,
      inputDescriptorIndex: inputDescriptorIndex,
    );
  }

  void filterList({
    required List<CredentialModel> credentialList,
    required Map<String, dynamic> presentationDefinition,
    required int inputDescriptorIndex,
  }) {
    /// Get instruction to filter credentials of the wallet
    final filteredCredentialList = getCredentialsFromPresentationDefinition(
      presentationDefinition: presentationDefinition,
      credentialList: List.from(credentialList),
      inputDescriptorIndex: inputDescriptorIndex,
    );

    emit(state.copyWith(filteredCredentialList: filteredCredentialList));
  }

  void toggle(int index) {
    if (state.selected.contains(index)) {
      emit(
        state.copyWith(
          selected: List<int>.from(state.selected)
            ..removeWhere((element) => element == index),
        ),
      );
    } else {
      emit(
        state.copyWith(
          selected: [
            ...state.selected,
            ...[index]
          ],
        ),
      );
    }
  }
}
