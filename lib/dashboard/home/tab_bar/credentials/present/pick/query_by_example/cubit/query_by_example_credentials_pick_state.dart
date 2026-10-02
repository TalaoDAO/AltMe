part of 'query_by_example_credentials_pick_cubit.dart';

@JsonSerializable()
class QueryByExampleCredentialPickState extends Equatable {
  const QueryByExampleCredentialPickState({
    this.selected,
    required this.filteredCredentialList,
  });

  factory QueryByExampleCredentialPickState.fromJson(
    Map<String, dynamic> json,
  ) => _$QueryByExampleCredentialPickStateFromJson(json);

  final int? selected;
  final List<CredentialModel> filteredCredentialList;

  QueryByExampleCredentialPickState copyWith({
    int? selected,
    List<CredentialModel>? filteredCredentialList,
  }) {
    final newState = QueryByExampleCredentialPickState(
      selected: selected ?? this.selected,
      filteredCredentialList:
          filteredCredentialList ?? this.filteredCredentialList,
    );
    return newState;
  }

  Map<String, dynamic> toJson() =>
      _$QueryByExampleCredentialPickStateToJson(this);

  @override
  List<Object?> get props => [selected, filteredCredentialList];
}
