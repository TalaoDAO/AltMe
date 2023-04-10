part of 'wallet_security_cubit.dart';


@JsonSerializable()
class WalletSecurityState extends Equatable {
  const WalletSecurityState({this.isBiometricsEnabled = false});

  factory WalletSecurityState.fromJson(Map<String, dynamic> json) =>
      _$WalletSecurityStateFromJson(json);

  final bool isBiometricsEnabled;

  WalletSecurityState copyWith({bool? isBiometricsEnabled}) {
    return WalletSecurityState(
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
    );
  }

  Map<String, dynamic> toJson() => _$WalletSecurityStateToJson(this);

  @override
  List<Object?> get props => [isBiometricsEnabled];
}
