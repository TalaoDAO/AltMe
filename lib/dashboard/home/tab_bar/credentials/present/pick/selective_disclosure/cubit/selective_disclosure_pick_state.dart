part of 'selective_disclosure_pick_cubit.dart';

@JsonSerializable()
class SelectiveDisclosureState extends Equatable {
  const SelectiveDisclosureState({
    this.message,
    this.selected = const [],
    this.selectedSDIndexInJWT = const [],
  });

  factory SelectiveDisclosureState.fromJson(Map<String, dynamic> json) =>
      _$SelectiveDisclosureStateFromJson(json);

  final StateMessage? message;
  final List<int> selected;
  final List<int> selectedSDIndexInJWT;

  SelectiveDisclosureState copyWith({
    List<int>? selected,
    List<int>? selectedSDIndexInJWT,
    StateMessage? message,
  }) {
    return SelectiveDisclosureState(
      selected: selected ?? this.selected,
      selectedSDIndexInJWT: selectedSDIndexInJWT ?? this.selectedSDIndexInJWT,
      message: message,
    );
  }

  Map<String, dynamic> toJson() => _$SelectiveDisclosureStateToJson(this);

  @override
  List<Object?> get props => [
        selected,
        selectedSDIndexInJWT,
        message,
      ];
}
