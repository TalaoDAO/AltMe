part of 'nft_details_cubit.dart';

@JsonSerializable()
class NftDetailsState extends Equatable {
  const NftDetailsState({
    this.status = AppStatus.init,
  });

  factory NftDetailsState.fromJson(Map<String, dynamic> json) =>
      _$NftDetailsStateFromJson(json);

  final AppStatus status;

  NftDetailsState copyWith({
    AppStatus? status,
  }) {
    return NftDetailsState(
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => _$NftDetailsStateToJson(this);

  @override
  List<Object?> get props => [
        status,
      ];
}
