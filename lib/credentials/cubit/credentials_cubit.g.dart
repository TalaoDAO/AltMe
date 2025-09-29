// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialsState _$CredentialsStateFromJson(Map<String, dynamic> json) =>
    CredentialsState(
      status:
          $enumDecodeNullable(_$CredentialsStatusEnumMap, json['status']) ??
          CredentialsStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      credentials:
          (json['credentials'] as List<dynamic>?)
              ?.map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dummyCredentials:
          (json['dummyCredentials'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              $enumDecode(_$CredentialCategoryEnumMap, k),
              (e as List<dynamic>)
                  .map(
                    (e) => DiscoverDummyCredential.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList(),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$CredentialsStateToJson(CredentialsState instance) =>
    <String, dynamic>{
      'status': _$CredentialsStatusEnumMap[instance.status]!,
      'credentials': instance.credentials,
      'dummyCredentials': instance.dummyCredentials.map(
        (k, e) => MapEntry(_$CredentialCategoryEnumMap[k]!, e),
      ),
      'message': instance.message,
    };

const _$CredentialsStatusEnumMap = {
  CredentialsStatus.init: 'init',
  CredentialsStatus.idle: 'idle',
  CredentialsStatus.populate: 'populate',
  CredentialsStatus.loading: 'loading',
  CredentialsStatus.insert: 'insert',
  CredentialsStatus.delete: 'delete',
  CredentialsStatus.update: 'update',
  CredentialsStatus.reset: 'reset',
  CredentialsStatus.error: 'error',
};

const _$CredentialCategoryEnumMap = {
  CredentialCategory.advantagesCards: 'advantagesCards',
  CredentialCategory.identityCards: 'identityCards',
  CredentialCategory.professionalCards: 'professionalCards',
  CredentialCategory.contactInfoCredentials: 'contactInfoCredentials',
  CredentialCategory.educationCards: 'educationCards',
  CredentialCategory.financeCards: 'financeCards',
  CredentialCategory.humanityProofCards: 'humanityProofCards',
  CredentialCategory.socialMediaCards: 'socialMediaCards',
  CredentialCategory.walletIntegrity: 'walletIntegrity',
  CredentialCategory.blockchainAccountsCards: 'blockchainAccountsCards',
  CredentialCategory.othersCards: 'othersCards',
  CredentialCategory.pendingCards: 'pendingCards',
};
