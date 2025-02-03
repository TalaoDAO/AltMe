// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      walletType: $enumDecode(_$WalletTypeEnumMap, json['walletType']),
      walletProtectionType: $enumDecode(
          _$WalletProtectionTypeEnumMap, json['walletProtectionType']),
      isDeveloperMode: json['isDeveloperMode'] as bool,
      profileType: $enumDecode(_$ProfileTypeEnumMap, json['profileType']),
      profileSetting: ProfileSetting.fromJson(
          json['profileSetting'] as Map<String, dynamic>),
      enterpriseWalletName: json['enterpriseWalletName'] as String?,
      oidc4VCIStack: json['oidc4VCIStack'] == null
          ? null
          : Oidc4VCIStack.fromJson(
              json['oidc4VCIStack'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'walletType': _$WalletTypeEnumMap[instance.walletType]!,
      'walletProtectionType':
          _$WalletProtectionTypeEnumMap[instance.walletProtectionType]!,
      'isDeveloperMode': instance.isDeveloperMode,
      'profileSetting': instance.profileSetting,
      'profileType': _$ProfileTypeEnumMap[instance.profileType]!,
      'enterpriseWalletName': instance.enterpriseWalletName,
      'oidc4VCIStack': instance.oidc4VCIStack,
    };

const _$WalletTypeEnumMap = {
  WalletType.personal: 'personal',
  WalletType.enterprise: 'enterprise',
};

const _$WalletProtectionTypeEnumMap = {
  WalletProtectionType.pinCode: 'pinCode',
  WalletProtectionType.biometrics: 'biometrics',
  WalletProtectionType.FA2: 'FA2',
};

const _$ProfileTypeEnumMap = {
  ProfileType.defaultOne: 'defaultOne',
  ProfileType.ebsiV3: 'ebsiV3',
  ProfileType.ebsiV4: 'ebsiV4',
  ProfileType.diipv3: 'diipv3',
  ProfileType.custom: 'custom',
  ProfileType.enterprise: 'enterprise',
};
