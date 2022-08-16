part of 'import_talao_community_card_cubit.dart';

@JsonSerializable()
class ImportTalaoCommunityCardState extends Equatable {
  const ImportTalaoCommunityCardState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isPrivateKeyValid = false,
  });

  factory ImportTalaoCommunityCardState.fromJson(Map<String, dynamic> json) =>
      _$ImportTalaoCommunityCardStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isPrivateKeyValid;

  ImportTalaoCommunityCardState loading() {
    return ImportTalaoCommunityCardState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isPrivateKeyValid: isPrivateKeyValid,
    );
  }

  ImportTalaoCommunityCardState error({
    required MessageHandler messageHandler,
  }) {
    return ImportTalaoCommunityCardState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isPrivateKeyValid: isPrivateKeyValid,
    );
  }

  ImportTalaoCommunityCardState populating({
    bool? isTextFieldEdited,
    bool? isPrivateKeyValid,
    int? recoveredCredentialLength,
  }) {
    return ImportTalaoCommunityCardState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isPrivateKeyValid: isPrivateKeyValid ?? this.isPrivateKeyValid,
    );
  }

  ImportTalaoCommunityCardState success({
    MessageHandler? messageHandler,
    int? recoveredCredentialLength,
  }) {
    return ImportTalaoCommunityCardState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isPrivateKeyValid: isPrivateKeyValid,
    );
  }

  Map<String, dynamic> toJson() => _$ImportTalaoCommunityCardStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isPrivateKeyValid,
        isTextFieldEdited,
        message,
      ];
}
