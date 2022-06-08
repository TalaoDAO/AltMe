part of 'credential_manifest_pick_cubit.dart';

@JsonSerializable()
class CredentialManifestPickState extends Equatable {
  CredentialManifestPickState({
    List<int>? selection,
    required List<CredentialModel> filteredCredentialList,
  })  : selection = selection ?? <int>[],
        filteredCredentialList = filteredCredentialList;

  factory CredentialManifestPickState.fromJson(Map<String, dynamic> json) =>
      _$CredentialManifestPickStateFromJson(json);

  final List<int> selection;
  final List<CredentialModel> filteredCredentialList;

  CredentialManifestPickState copyWith(
      {List<int>? selection,
      required List<CredentialModel> filteredCredentialList}) {
    return CredentialManifestPickState(
        selection: selection ?? this.selection,
        filteredCredentialList: filteredCredentialList);
  }

  Map<String, dynamic> toJson() => _$CredentialManifestPickStateToJson(this);

  @override
  List<Object?> get props => [
        selection,
        filteredCredentialList,
      ];
}
