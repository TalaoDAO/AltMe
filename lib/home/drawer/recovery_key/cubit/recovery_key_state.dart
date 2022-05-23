part of 'recovery_key_cubit.dart';

@JsonSerializable()
class RecoveryKeyState extends Equatable {
  const RecoveryKeyState({this.status = AppStatus.init, this.mnemonic});

  factory RecoveryKeyState.fromJson(Map<String, dynamic> json) =>
      _$RecoveryKeyStateFromJson(json);

  final AppStatus status;
  final List<String>? mnemonic;

  RecoveryKeyState loading() {
    return RecoveryKeyState(
      status: AppStatus.loading,
      mnemonic: mnemonic,
    );
  }

  RecoveryKeyState success({List<String>? mnemonic}) {
    return RecoveryKeyState(
      status: AppStatus.success,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  Map<String, dynamic> toJson() => _$RecoveryKeyStateToJson(this);

  @override
  List<Object?> get props => [status, mnemonic];
}
