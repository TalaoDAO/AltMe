part of 'token_select_box_cubit.dart';

@JsonSerializable()
class TokenSelectBoxState extends Equatable {
  const TokenSelectBoxState({this.isLoading = false});

  factory TokenSelectBoxState.fromJson(Map<String, dynamic> json) =>
      _$TokenSelectBoxStateFromJson(json);

  final bool isLoading;

  TokenSelectBoxState copyWith({TokenModel? selectedToken, bool? isLoading}) {
    final state = TokenSelectBoxState(isLoading: isLoading ?? this.isLoading);
    return state;
  }

  Map<String, dynamic> toJson() => _$TokenSelectBoxStateToJson(this);

  @override
  List<Object?> get props => [isLoading];
}
