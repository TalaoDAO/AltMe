import 'package:altme/home/home.dart';
import 'package:altme/home/tab_bar/credentials/pick/credential_manifest/helpers/get_filtered_credential_list.dart';
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
  }) : super(CredentialManifestPickState(filteredCredentialList: const [])) {
    /// Get instruction to filter credentials of the wallet
    final filteredCredentialList = getFilteredCredentialList(
      presentationDefinition,
      List.from(credentialList),
    );
    emit(
      CredentialManifestPickState(
        filteredCredentialList: filteredCredentialList,
      ),
    );
  }

  void toggle(int index) {
    final List<int> selection;
    if (state.selection.contains(index)) {
      selection = List.of(state.selection)
        ..removeWhere((element) => element == index);
    } else {
      selection = List.of(state.selection)..add(index);
    }
    emit(
      state.copyWith(
        selection: selection,
        filteredCredentialList: state.filteredCredentialList,
      ),
    );
  }
}
