part of 'search_cubit.dart';

@JsonSerializable()
class SearchState extends Equatable {
  SearchState({
    this.status = AppStatus.init,
    this.message,
    List<CredentialModel>? credentials,
  }) : credentials = credentials ?? [];

  factory SearchState.fromJson(Map<String, dynamic> json) =>
      _$SearchStateFromJson(json);

  final AppStatus status;
  final List<CredentialModel> credentials;
  final StateMessage? message;

  SearchState loading() {
    return SearchState(status: AppStatus.loading, credentials: credentials);
  }

  SearchState error({required MessageHandler messageHandler}) {
    return SearchState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
    );
  }

  SearchState populate({
    List<CredentialModel>? credentials,
  }) {
    return SearchState(
      status: AppStatus.idle,
      credentials: credentials ?? this.credentials,
    );
  }

  SearchState success({
    required AppStatus status,
    MessageHandler? messageHandler,
    List<CredentialModel>? credentials,
  }) {
    return SearchState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      credentials: credentials ?? this.credentials,
    );
  }

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);

  @override
  List<Object?> get props => [status, message, credentials];
}
