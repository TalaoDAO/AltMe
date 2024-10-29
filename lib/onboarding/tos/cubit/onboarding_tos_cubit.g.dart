// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_tos_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnBoardingTosState _$OnBoardingTosStateFromJson(Map<String, dynamic> json) =>
    OnBoardingTosState(
      agreeTerms: json['agreeTerms'] as bool? ?? false,
      scrollIsOver: json['scrollIsOver'] as bool? ?? false,
      readTerms: json['readTerms'] as bool? ?? false,
      acceptanceButtonEnabled:
          json['acceptanceButtonEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$OnBoardingTosStateToJson(OnBoardingTosState instance) =>
    <String, dynamic>{
      'scrollIsOver': instance.scrollIsOver,
      'agreeTerms': instance.agreeTerms,
      'readTerms': instance.readTerms,
      'acceptanceButtonEnabled': instance.acceptanceButtonEnabled,
    };
