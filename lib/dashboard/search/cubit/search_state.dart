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
    final loadingState = SearchState(
      status: AppStatus.loading,
      credentials: credentials,
      searchText: searchText ?? this.searchText,
    );
    return loadingState;
  }

  SearchState error({required MessageHandler messageHandler}) {
    final errorState = SearchState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
      searchText: searchText,
    );
    return errorState;
  }

  SearchState populate({List<CredentialModel>? credentials}) {
    final populatedState = SearchState(
      status: AppStatus.populate,
      credentials: credentials ?? this.credentials,
      searchText: searchText,
    );
    return populatedState;
  }

  SearchState copuWith({
    required AppStatus status,
    MessageHandler? messageHandler,
    List<CredentialModel>? credentials,
  }) {
    final searchState = SearchState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      credentials: credentials ?? this.credentials,
      searchText: searchText,
    );
    return searchState;
  }

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);

  @override
  List<Object?> get props => [status, message, credentials, searchText];
}
