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
  }) : super(const CredentialManifestPickState(filteredCredentialList: [])) {
    /// Get instruction to filter credentials of the wallet
    final filteredCredentialList = getCredentialsFromPresentationDefinition(
      presentationDefinition,
      List.from(credentialList),
    );

    emit(state.copyWith(filteredCredentialList: filteredCredentialList));
  }

  void toggle(int index) {
    emit(state.copyWith(selected: index));
  }
}
