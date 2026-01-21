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
  final List<SelectedClaimsKeyIds> selectedClaimsKeyIds;
  final List<int> selectedSDIndexInJWT;
  final String? limitDisclosure;
  final Map<String, dynamic>? filters;

  SelectiveDisclosureState copyWith({
    List<SelectedClaimsKeyIds>? selectedClaimsKeyIds,
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

@JsonSerializable()
class SelectedClaimsKeyIds extends Equatable {
  const SelectedClaimsKeyIds({required this.keyId, required this.isSelected});

  factory SelectedClaimsKeyIds.fromJson(Map<String, dynamic> json) =>
      _$SelectedClaimsKeyIdsFromJson(json);

  final String keyId;
  final bool isSelected;

  SelectedClaimsKeyIds copyWith({String? keyId, bool? isSelected}) {
    return SelectedClaimsKeyIds(
      keyId: keyId ?? this.keyId,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() => _$SelectedClaimsKeyIdsToJson(this);

  @override
  List<Object?> get props => [keyId, isSelected];
}
