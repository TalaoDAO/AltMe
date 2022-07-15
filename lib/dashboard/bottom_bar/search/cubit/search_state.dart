part of 'search_cubit.dart';

@JsonSerializable()
class SearchState extends Equatable {
  SearchState({
    this.status = AppStatus.init,
    this.message,
    this.searchText = '',
    List<CredentialModel>? credentials,
  }) : credentials = credentials ?? [];

  factory SearchState.fromJson(Map<String, dynamic> json) =>
      _$SearchStateFromJson(json);

  final AppStatus status;
  final List<CredentialModel> credentials;
  final String searchText;
  final StateMessage? message;

  SearchState loading({String? searchText}) {
    return SearchState(
      status: AppStatus.loading,
      credentials: credentials,
      searchText: searchText ?? this.searchText,
    );
  }

  SearchState error({required MessageHandler messageHandler}) {
    return SearchState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
      searchText: searchText,
    );
  }

  SearchState populate({
    List<CredentialModel>? credentials,
  }) {
    return SearchState(
      status: AppStatus.populate,
      credentials: credentials ?? this.credentials,
      searchText: searchText,
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
      searchText: searchText,
    );
  }

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);

  @override
  List<Object?> get props => [status, message, credentials, searchText];
}
