part of 'get_linkedin_info_cubit.dart';

@JsonSerializable()
class GetLinkedinInfoState extends Equatable {
  const GetLinkedinInfoState({
    this.isTextFieldEdited = false,
    this.isLinkedUrlValid = false,
  });

  factory GetLinkedinInfoState.fromJson(Map<String, dynamic> json) =>
      _$GetLinkedinInfoStateFromJson(json);

  final bool isTextFieldEdited;
  final bool isLinkedUrlValid;

  GetLinkedinInfoState copyWith({
    bool? isTextFieldEdited,
    bool? isLinkedUrlValid,
  }) {
    return GetLinkedinInfoState(
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isLinkedUrlValid: isLinkedUrlValid ?? this.isLinkedUrlValid,
    );
  }

  Map<String, dynamic> toJson() => _$GetLinkedinInfoStateToJson(this);

  @override
  List<Object?> get props => [
        isLinkedUrlValid,
        isTextFieldEdited,
      ];
}
