part of 'selective_disclosure_pick_cubit.dart';

@JsonSerializable()
class SelectiveDisclosureState extends Equatable {
  const SelectiveDisclosureState({
    this.message,
    this.selectedClaimsKeyIds = const [],
    this.selectedSDIndexInJWT = const [],
  });

  factory SelectiveDisclosureState.fromJson(Map<String, dynamic> json) =>
      _$SelectiveDisclosureStateFromJson(json);

  final StateMessage? message;
  final List<String> selectedClaimsKeyIds;
  final List<int> selectedSDIndexInJWT;

  SelectiveDisclosureState copyWith({
    List<String>? selectedClaimsKeyIds,
    List<int>? selectedSDIndexInJWT,
    StateMessage? message,
  }) {
    return SelectiveDisclosureState(
      selectedClaimsKeyIds: selectedClaimsKeyIds ?? this.selectedClaimsKeyIds,
      selectedSDIndexInJWT: selectedSDIndexInJWT ?? this.selectedSDIndexInJWT,
      message: message,
    );
  }

  Map<String, dynamic> toJson() => _$SelectiveDisclosureStateToJson(this);

  @override
  List<Object?> get props => [
        selectedClaimsKeyIds,
        selectedSDIndexInJWT,
        message,
      ];
}
