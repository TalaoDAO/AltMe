import 'dart:async';
import 'dart:convert';

import 'package:altme/app/shared/alert_message/alert_message.dart';
import 'package:altme/app/shared/constants/secure_storage_keys.dart';
import 'package:altme/app/shared/helper_functions/helper_functions.dart';
import 'package:altme/app/shared/local_auth/local_auth_api.dart';
import 'package:altme/app/shared/models/state_message/state_message.dart';
import 'package:altme/app/shared/widget/button/my_elevated_button.dart';
import 'package:altme/dashboard/drawer/wallet_security/helper_function/security_check.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/oidc4vp_signature.dart';
import 'package:altme/oidc4vp_transaction/oidc4vp_transaction.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class AcceptButton extends StatelessWidget {
  const AcceptButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MyElevatedButton(
      text: l10n.communicationHostAllow,
      onPressed: () async {
        // todo(hawkbee): Check the balance of the selected account
        // for each transaction

        /// prepare the transactions with the selected account
        final uri = context.read<QRCodeScanCubit>().state.uri!;
        final scanCubit = context.read<ScanCubit>();
        final transactionData = scanCubit.state.transactionData;

        try {
          final cryptoAccountData = context
              .read<WalletCubit>()
              .state
              .currentAccount!;
          final oidc4vpTransaction = Oidc4vpTransaction(
            transactionData: transactionData!,
          );
          await scanCubit.addBlockchainTransaction(
            await oidc4vpTransaction.getBlockchainSignedTransaction(
              cryptoAccountData: cryptoAccountData,
            ),
          );
          final qrCodeScanCubit = context.read<QRCodeScanCubit>();

          final bool userPINCodeForAuthentication = context
              .read<ProfileCubit>()
              .state
              .model
              .profileSetting
              .walletSecurityOptions
              .secureSecurityAuthenticationWithPinCode;

          if (userPINCodeForAuthentication) {
            /// Authenticate
            bool authenticated = false;
            await securityCheck(
              context: context,
              title: context.l10n.typeYourPINCodeToShareTheData,
              localAuthApi: LocalAuthApi(),
              onSuccess: () {
                authenticated = true;
              },
            );

            if (!authenticated) {
              unawaited(
                context.read<ScanCubit>().sendErrorToServer(
                  uri: uri,
                  data: {'error': 'access_denied'},
                ),
              );
              return;
            }
          }

          final scanState = context.read<ScanCubit>().state;
          final credentialsToBePresented = <CredentialModel>[];

          /// add the jwtToken to the selectivedisclosureJwt of each credential
          ///
          final profileCubit = context.read<ProfileCubit>();

          final customOidc4vcProfile = profileCubit
              .state
              .model
              .profileSetting
              .selfSovereignIdentityOptions
              .customOidc4vcProfile;

          final didKeyType = customOidc4vcProfile.defaultDid;

          final privateKey = await fetchPrivateKey(
            profileCubit: profileCubit,
            didKeyType: didKeyType,
          );

          for (final credential in scanState.credentialsToBePresented!) {
            // Key Binding JWT

            final tokenParameters = TokenParameters(
              privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
              did: '', // just added as it is required field
              mediaType: MediaType.selectiveDisclosure,
              clientType: ClientType
                  .p256JWKThumprint, // just added as it is required field
              proofHeaderType: customOidc4vcProfile.proofHeader,
              clientId: '', // just added as it is required field
            );

            final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
            var newJwt = credential.selectiveDisclosureJwt!;
            final sdHash = sh256Hash(newJwt);

            final nonce = uri.queryParameters['nonce'] ?? '';
            final clientId = uri.queryParameters['client_id'] ?? '';

            final payload = {
              'nonce': nonce,
              'aud': clientId,
              'iat': iat,
              'sd_hash': sdHash,
            };
            // In case of OIDC4VP transaction we need to add the hash of each
            // element of transactiondata into the payload
            final scanCubit = context.read<ScanCubit>();
            final transactionData = scanCubit.state.transactionData;

            if (transactionData != null) {
              /// create list of chain ids from transaction data
              final List<int> chainIds = [];
              final oidc4vpTransaction = Oidc4vpTransaction(
                transactionData: transactionData,
              );
              final decodedTransactions = oidc4vpTransaction
                  .decodeTransactions();

              for (final tx in decodedTransactions) {
                final decodedMap = tx as Map<String, dynamic>;
                final chainId =
                    int.tryParse(decodedMap['chain_id']?.toString() ?? '1') ??
                    1;
                chainIds.add(chainId);
              }

              final Oidc4vpSignedTransaction oidc4vpSignedTransaction =
                  Oidc4vpSignedTransaction(
                    signedTransaction:
                        scanCubit.state.blockchainTransactionsSignatures!,
                    signedTransactionChainIds: chainIds,
                  );

              payload['blockchain_transaction_hashes'] =
                  oidc4vpSignedTransaction.getSignedTransactionHashes();

              final List<String> transactionDataHashes = [];
              for (final element in transactionData) {
                transactionDataHashes.add(sh256Hash(jsonEncode(element)));
              }
              payload['transaction_data_hashes'] = transactionDataHashes;
            }

            // If there no cnf in the payload, then no need to add signature
            if (credential.data['cnf'] != null) {
              /// sign and get token
              final jwtToken = generateToken(
                payload: payload,
                tokenParameters: tokenParameters,
                ignoreProofHeaderType: true,
              );

              newJwt = '$newJwt$jwtToken';
            }

            final CredentialModel newModel = credential.copyWith(
              selectiveDisclosureJwt: newJwt,
            );

            final credToBePresented = [newModel];

            credentialsToBePresented.addAll(credToBePresented);
          }

          /// present the credentials and run the transactions
          await context.read<ScanCubit>().credentialOfferOrPresent(
            uri: uri,
            credentialModel: scanState.credentialPresentation!,
            keyId: SecureStorageKeys.ssiKey,
            credentialsToBePresented: credentialsToBePresented,
            issuer: scanState.presentationIssuer!,
            qrCodeScanCubit: qrCodeScanCubit,
          );
          Navigator.of(context).pop();
        } catch (e) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: StateMessage(stringMessage: e.toString()),
          );
        }
      },
    );
  }
}
