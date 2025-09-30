// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_wallet_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetWalletState _$ResetWalletStateFromJson(Map<String, dynamic> json) =>
    ResetWalletState(
      isRecoveryPhraseWritten:
          json['isRecoveryPhraseWritten'] as bool? ?? false,
      isBackupCredentialSaved:
          json['isBackupCredentialSaved'] as bool? ?? false,
    );

Map<String, dynamic> _$ResetWalletStateToJson(ResetWalletState instance) =>
    <String, dynamic>{
      'isRecoveryPhraseWritten': instance.isRecoveryPhraseWritten,
      'isBackupCredentialSaved': instance.isBackupCredentialSaved,
    };
