part of 'advance_settings_cubit.dart';

@JsonSerializable()
class AdvanceSettingsState extends Equatable {
  const AdvanceSettingsState({
    required this.isGamingEnabled,
    required this.isIdentityEnabled,
    required this.isPaymentEnabled,
    required this.isSocialMediaEnabled,
    required this.isCommunityEnabled,
    required this.isOtherEnabled,
  });

  factory AdvanceSettingsState.fromJson(Map<String, dynamic> json) =>
      _$AdvanceSettingsStateFromJson(json);

  final bool isGamingEnabled;
  final bool isIdentityEnabled;
  final bool isPaymentEnabled;
  final bool isSocialMediaEnabled;
  final bool isCommunityEnabled;
  final bool isOtherEnabled;

  Map<String, dynamic> toJson() => _$AdvanceSettingsStateToJson(this);

  AdvanceSettingsState copyWith({
    bool? isGamingEnabled,
    bool? isIdentityEnabled,
    bool? isPaymentEnabled,
    bool? isSocialMediaEnabled,
    bool? isCommunityEnabled,
    bool? isOtherEnabled,
  }) {
    return AdvanceSettingsState(
      isGamingEnabled: isGamingEnabled ?? this.isGamingEnabled,
      isIdentityEnabled: isIdentityEnabled ?? this.isIdentityEnabled,
      isPaymentEnabled: isPaymentEnabled ?? this.isPaymentEnabled,
      isSocialMediaEnabled: isSocialMediaEnabled ?? this.isSocialMediaEnabled,
      isCommunityEnabled: isCommunityEnabled ?? this.isCommunityEnabled,
      isOtherEnabled: isOtherEnabled ?? this.isOtherEnabled,
    );
  }

  @override
  List<Object?> get props => [
        isGamingEnabled,
        isIdentityEnabled,
        isPaymentEnabled,
        isSocialMediaEnabled,
        isCommunityEnabled,
        isOtherEnabled,
      ];
}
