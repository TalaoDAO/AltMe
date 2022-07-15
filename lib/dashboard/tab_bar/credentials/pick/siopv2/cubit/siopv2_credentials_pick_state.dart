part of 'siopv2_credentials_pick_cubit.dart';

@JsonSerializable()
class SIOPV2CredentialPickState extends Equatable {
  const SIOPV2CredentialPickState({
    this.index = 0,
    this.status = AppStatus.init,
  });

  factory SIOPV2CredentialPickState.fromJson(Map<String, dynamic> json) =>
      _$SIOPV2CredentialPickStateFromJson(json);

  final int index;
  final AppStatus status;

  SIOPV2CredentialPickState copyWith({int? index, AppStatus? status}) {
    return SIOPV2CredentialPickState(
      index: index ?? this.index,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => _$SIOPV2CredentialPickStateToJson(this);

  @override
  List<Object?> get props => [index, status];
}
