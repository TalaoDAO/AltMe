part of 'query_by_example_credentials_pick_cubit.dart';

@JsonSerializable()
class QueryByExampleCredentialPickState extends Equatable {
  QueryByExampleCredentialPickState({
    List<int>? selection,
    required this.filteredCredentialList,
  }) : selection = selection ?? <int>[];

  factory QueryByExampleCredentialPickState.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$QueryByExampleCredentialPickStateFromJson(json);

  final List<int> selection;
  final List<CredentialModel> filteredCredentialList;

  QueryByExampleCredentialPickState copyWith({
    List<int>? selection,
    required List<CredentialModel> filteredCredentialList,
  }) {
    return QueryByExampleCredentialPickState(
      selection: selection ?? this.selection,
      filteredCredentialList: filteredCredentialList,
    );
  }

  Map<String, dynamic> toJson() =>
      _$QueryByExampleCredentialPickStateToJson(this);

  @override
  List<Object?> get props => [
        selection,
        filteredCredentialList,
      ];
}
