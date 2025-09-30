// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_verification_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KycVerificationState _$KycVerificationStateFromJson(
        Map<String, dynamic> json) =>
    KycVerificationState(
      status:
          $enumDecodeNullable(_$KycVerificationStatusEnumMap, json['status']) ??
              KycVerificationStatus.unverified,
    );

Map<String, dynamic> _$KycVerificationStateToJson(
        KycVerificationState instance) =>
    <String, dynamic>{
      'status': _$KycVerificationStatusEnumMap[instance.status]!,
    };

const _$KycVerificationStatusEnumMap = {
  KycVerificationStatus.unverified: 'unverified',
  KycVerificationStatus.pending: 'pending',
  KycVerificationStatus.approved: 'approved',
  KycVerificationStatus.rejected: 'rejected',
  KycVerificationStatus.loading: 'loading',
  KycVerificationStatus.unkown: 'unkown',
};
