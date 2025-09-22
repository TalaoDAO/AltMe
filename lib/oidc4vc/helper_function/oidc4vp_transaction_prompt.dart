import 'dart:async';

import 'package:altme/app/shared/helper_functions/helper_functions.dart';
import 'package:altme/dashboard/crypto_account_switcher/crypto_bottom_sheet/view/crypto_account_switcher.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/oidc4vc/helper_function/get_payload.dart';
import 'package:altme/oidc4vc/helper_function/oidc4vp_prompt.dart';
import 'package:altme/oidc4vp_transaction/oidc4vp_transaction.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Oidc4VpTransactionPrompt extends Oidc4VpPrompt {
  Oidc4VpTransactionPrompt({
    required super.context,
    required super.l10n,
    required super.trustedListEnabled,
    required super.trustedEntity,
    required super.uri,
    required super.client,
    required super.showPrompt,
  });

  @override
  Future<Widget> get promptContent async {
    // get transaction informations
    final String? requestUri = uri.queryParameters['request_uri'];
    final String? request = uri.queryParameters['request'];
    final encodedData = await getPayload(client, requestUri, request);
    final response = decodePayload(
      jwtDecode: JWTDecode(),
      token: encodedData as String,
    );
    final transactionInfo = response['transaction_data'];
    // should be done when processing because we need the crypto account
    unawaited(
      context.read<ScanCubit>().addTransactionData(
        transactionInfo as List<dynamic>,
      ),
    );

    final List<dynamic> decodedTransactions = Oidc4vpTransaction(
      transactionData: transactionInfo,
    ).decodeTransactions();

    // let user select the ethereum account
    // show the transaction informations
    // show the presentation informations
    return Column(
      children: [
        Text(decodedTransactions.toString()),
        // const CryptoAccountSwitcherProvider(),
      ],
    );
  }

  @override
  Future<void> launchProcess() async {
    final qrCodeScanCubit = context.read<QRCodeScanCubit>();
    await qrCodeScanCubit.startSIOPV2OIDC4VPProcess(uri);
  }
}
