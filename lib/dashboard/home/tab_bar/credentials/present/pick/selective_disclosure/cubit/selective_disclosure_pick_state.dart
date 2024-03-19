part of 'selective_disclosure_pick_cubit.dart';

@JsonSerializable()
class SelectiveDisclosureState extends Equatable {
  const SelectiveDisclosureState({
    this.message,
    this.selected = const [],
  });

  factory SelectiveDisclosureState.fromJson(Map<String, dynamic> json) =>
      _$SelectiveDisclosureStateFromJson(json);

  final StateMessage? message;
  final List<int> selected;

  SelectiveDisclosureState copyWith({
    List<int>? selected,
    StateMessage? message,
  }) {
    return SelectiveDisclosureState(
      selected: selected ?? this.selected,
      message: message,
    );
  }

  Map<String, dynamic> toJson() => _$SelectiveDisclosureStateToJson(this);

  @override
  List<Object?> get props => [
        selected,
        message,
      ];
}
