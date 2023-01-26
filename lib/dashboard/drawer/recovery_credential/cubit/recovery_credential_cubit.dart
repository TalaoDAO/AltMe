import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'recovery_credential_cubit.g.dart';
part 'recovery_credential_state.dart';

class RecoveryCredentialCubit extends Cubit<RecoveryCredentialState> {
  RecoveryCredentialCubit({
    required this.walletCubit,
    required this.cryptoKeys,
    required this.secureStorageProvider,
  }) : super(const RecoveryCredentialState());

  final WalletCubit walletCubit;
  final CryptocurrencyKeys cryptoKeys;
  final SecureStorageProvider secureStorageProvider;

  void isMnemonicsValid(String value) {
    emit(
      state.populating(
        isTextFieldEdited: value.isNotEmpty,
        isMnemonicValid: bip39.validateMnemonic(value) && value.isNotEmpty,
      ),
    );
  }

  void setFilePath({String? filePath}) {
    emit(state.copyWith(backupFilePath: filePath));
  }

  Future<void> recoverWallet() async {
    if (state.backupFilePath == null) return;
    emit(state.loading());

    final String? mnemonics = await secureStorageProvider
        .get(SecureStorageKeys.recoverCredentialMnemonics);

    if (mnemonics == null) throw Exception();

    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final file = File(state.backupFilePath!);
      final text = await file.readAsString();
      final json = jsonDecode(text) as Map<String, dynamic>;
      if (!json.containsKey('cipherText') ||
          !json.containsKey('authenticationTag') ||
          json['cipherText'] is! String ||
          json['authenticationTag'] is! String) {
        throw ResponseMessage(
          ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE,
        );
      }
      final encryption = Encryption(
        cipherText: json['cipherText'] as String,
        authenticationTag: json['authenticationTag'] as String,
      );
      final decryptedText = await cryptoKeys.decrypt(mnemonics, encryption);
      final decryptedJson = jsonDecode(decryptedText) as Map<String, dynamic>;
      if (!decryptedJson.containsKey('date') ||
          !decryptedJson.containsKey('credentials') ||
          decryptedJson['date'] is! String) {
        throw ResponseMessage(
          ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE,
        );
      }
      final List<dynamic> credentialJson =
          decryptedJson['credentials'] as List<dynamic>;
      final credentials = credentialJson.map(
        (dynamic credential) =>
            CredentialModel.fromJson(credential as Map<String, dynamic>),
      );

      await walletCubit.recoverWallet(credentials.toList());
      emit(
        state.success(recoveredCredentialLength: credentials.length),
      );
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else if (e.toString().startsWith('Auth message')) {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE,
            ),
          ),
        );
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE,
            ),
          ),
        );
      }
    }
  }
}
