part of 'query_by_example_credentials_pick_cubit.dart';

@JsonSerializable()
class QueryByExampleCredentialPickState extends Equatable {
  QueryByExampleCredentialPickState({
    List<int>? selection,
  }) : selection = selection ?? <int>[];

  factory QueryByExampleCredentialPickState.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$QueryByExampleCredentialPickStateFromJson(json);

  final List<int> selection;

  QueryByExampleCredentialPickState copyWith({List<int>? selection}) {
    return QueryByExampleCredentialPickState(
      selection: selection ?? this.selection,
    );
  }

  Map<String, dynamic> toJson() =>
      _$QueryByExampleCredentialPickStateToJson(this);

  @override
  List<Object?> get props => [selection];
}
