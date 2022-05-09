part of 'siopv2_credentials_pick_cubit.dart';

@JsonSerializable()
class SIOPV2CredentialPickState extends Equatable {
  const SIOPV2CredentialPickState({this.index = 0, this.loading = false});

  factory SIOPV2CredentialPickState.fromJson(Map<String, dynamic> json) =>
      _$SIOPV2CredentialPickStateFromJson(json);

  final int index;
  final bool loading;

  SIOPV2CredentialPickState copyWith({int? index, bool? loading}) {
    return SIOPV2CredentialPickState(
      index: index ?? this.index,
      loading: loading ?? this.loading,
    );
  }

  Map<String, dynamic> toJson() => _$SIOPV2CredentialPickStateToJson(this);

  @override
  List<Object?> get props => [index, loading];
}

@JsonSerializable()
class SIOPV2CredentialPresentState extends SIOPV2CredentialPickState {
  const SIOPV2CredentialPresentState({this.index = 0, this.loading = false});

  factory SIOPV2CredentialPresentState.fromJson(Map<String, dynamic> json) =>
      _$SIOPV2CredentialPresentStateFromJson(json);

  @override
  final int index;
  @override
  final bool loading;

  @override
  SIOPV2CredentialPresentState copyWith({int? index, bool? loading}) {
    return SIOPV2CredentialPresentState(
      index: index ?? this.index,
      loading: loading ?? this.loading,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$SIOPV2CredentialPresentStateToJson(this);

  @override
  List<Object?> get props => [index, loading];
}
