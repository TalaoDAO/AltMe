part of 'wallet_ready_cubit.dart';

@JsonSerializable()
class WalletReadyState extends Equatable {
  const WalletReadyState({this.isAgreeWithTerms = false});

  factory WalletReadyState.fromJson(Map<String, dynamic> json) =>
      _$WalletReadyStateFromJson(json);

  final bool isAgreeWithTerms;

  Map<String, dynamic> toJson() => _$WalletReadyStateToJson(this);

  WalletReadyState copyWith({bool? isAgreeWithTerms}) {
    return WalletReadyState(
      isAgreeWithTerms: isAgreeWithTerms ?? this.isAgreeWithTerms,
    );
  }

  @override
  List<Object?> get props => [isAgreeWithTerms];
}
