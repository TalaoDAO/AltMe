part of 'credential_manifest_pick_cubit.dart';

@JsonSerializable()
class CredentialManifestPickState extends Equatable {
  const CredentialManifestPickState({
    this.message,
    this.selected = const [],
    required this.filteredCredentialList,
    this.presentationDefinition,
    this.isButtonEnabled = false,
  });

  factory CredentialManifestPickState.fromJson(Map<String, dynamic> json) =>
      _$CredentialManifestPickStateFromJson(json);

  final StateMessage? message;
  final List<int> selected;
  final List<CredentialModel> filteredCredentialList;
  final PresentationDefinition? presentationDefinition;
  final bool isButtonEnabled;

  CredentialManifestPickState copyWith({
    List<int>? selected,
    List<CredentialModel>? filteredCredentialList,
    PresentationDefinition? presentationDefinition,
    bool? isButtonEnabled,
    StateMessage? message,
  }) {
    return CredentialManifestPickState(
      selected: selected ?? this.selected,
      filteredCredentialList:
          filteredCredentialList ?? this.filteredCredentialList,
      presentationDefinition:
          presentationDefinition ?? this.presentationDefinition,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      message: message,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialManifestPickStateToJson(this);

  @override
  List<Object?> get props => [
        selected,
        filteredCredentialList,
        presentationDefinition,
        isButtonEnabled,
        message,
      ];
}
