part of 'nft_details_cubit.dart';

@JsonSerializable()
class NftDetailsState extends Equatable {
  const NftDetailsState({this.status = AppStatus.init, this.message});

  factory NftDetailsState.fromJson(Map<String, dynamic> json) =>
      _$NftDetailsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  NftDetailsState copyWith({AppStatus? status, StateMessage? message}) {
    final state = NftDetailsState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
    return state;
  }

  Map<String, dynamic> toJson() => _$NftDetailsStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
