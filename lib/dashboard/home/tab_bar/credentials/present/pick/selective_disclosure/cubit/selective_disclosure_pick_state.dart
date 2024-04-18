part of 'selective_disclosure_pick_cubit.dart';

@JsonSerializable()
class SelectiveDisclosureState extends Equatable {
  const SelectiveDisclosureState({
    this.message,
    this.selectedClaimsKeyIds = const [],
    this.selectedSDIndexInJWT = const [],
    this.limitDisclosure,
    this.filters,
  });

  factory SelectiveDisclosureState.fromJson(Map<String, dynamic> json) =>
      _$SelectiveDisclosureStateFromJson(json);

  final StateMessage? message;
  final List<String> selectedClaimsKeyIds;
  final List<int> selectedSDIndexInJWT;
  final String? limitDisclosure;
  final Map<String, dynamic>? filters;

  SelectiveDisclosureState copyWith({
    List<String>? selectedClaimsKeyIds,
    List<int>? selectedSDIndexInJWT,
    StateMessage? message,
    String? limitDisclosure,
    Map<String, dynamic>? filters,
  }) {
    return SelectiveDisclosureState(
      selectedClaimsKeyIds: selectedClaimsKeyIds ?? this.selectedClaimsKeyIds,
      selectedSDIndexInJWT: selectedSDIndexInJWT ?? this.selectedSDIndexInJWT,
      limitDisclosure: limitDisclosure ?? this.limitDisclosure,
      filters: filters ?? this.filters,
      message: message,
    );
  }

  Map<String, dynamic> toJson() => _$SelectiveDisclosureStateToJson(this);

  @override
  List<Object?> get props => [
        selectedClaimsKeyIds,
        selectedSDIndexInJWT,
        message,
        limitDisclosure,
        filters,
      ];
}
