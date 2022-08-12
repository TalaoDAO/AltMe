part of 'token_select_box_cubit.dart';

@JsonSerializable()
class TokenSelectBoxState extends Equatable {
  const TokenSelectBoxState({
    this.isLoading = false,
  });

  factory TokenSelectBoxState.fromJson(Map<String, dynamic> json) =>
      _$TokenSelectBoxStateFromJson(json);

  final bool isLoading;

  TokenSelectBoxState copyWith({
    TokenModel? selectedToken,
    bool? isLoading,
  }) {
    return TokenSelectBoxState(
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toJson() => _$TokenSelectBoxStateToJson(this);

  @override
  List<Object?> get props => [isLoading];
}
