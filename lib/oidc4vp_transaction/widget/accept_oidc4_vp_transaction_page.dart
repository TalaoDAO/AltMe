import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/helper_functions/helper_functions.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/drawer/blockchain_settings/blockchain_settings.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/selective_disclosure/cubit/selective_disclosure_pick_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/widget/attestation_list.dart';
import 'package:altme/oidc4vp_transaction/widget/navigation_buttons.dart';
import 'package:altme/oidc4vp_transaction/widget/select_crypto_account.dart';
import 'package:altme/oidc4vp_transaction/widget/transaction_presentation.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:altme/trusted_list/widget/trusted_entity_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptOidc4VpTransactionPage extends StatelessWidget {
  const AcceptOidc4VpTransactionPage({
    super.key,
    required this.trustedListEnabled,
    required this.trustedEntity,
    required this.uri,
    required this.showPrompt,
    required this.client,
  });
  final bool trustedListEnabled;
  final TrustedEntity? trustedEntity;
  final Uri uri;
  final bool showPrompt;
  final DioClient client;

  static Route<dynamic> route({
    required bool trustedListEnabled,
    required TrustedEntity? trustedEntity,
    required Uri uri,
    required bool showPrompt,
    required DioClient client,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/AcceptOidc4VpTransactionPage'),
      builder: (_) => AcceptOidc4VpTransactionPage(
        trustedListEnabled: trustedListEnabled,
        trustedEntity: trustedEntity,
        uri: uri,
        showPrompt: showPrompt,
        client: client,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      navigation: const NavigationButtons(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: BlocProvider(
              create: (context) => ManageAccountsCubit(
                credentialsCubit: context.read<CredentialsCubit>(),
                manageNetworkCubit: context.read<ManageNetworkCubit>(),
              ),

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: BackgroundCard(
                      child: DisplayEntity(
                        trustedListEnabled: trustedListEnabled,
                        trustedEntity: trustedEntity,
                        notTrustedText: l10n.notTrustedEntity,
                        uri: uri,
                        client: client,
                      ),
                    ),
                  ),

                  // TransactionPresentation widget displays decoded
                  // transactions
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: BackgroundCard(
                      child: Column(
                        children: [
                          const TransactionPresentation(),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: const SelectCryptoAccount(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: BlocProvider(
                      create: (context) => SelectiveDisclosureCubit(),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 600),
                        child: AttestationList(uri: uri),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DisplayEntity extends StatelessWidget {
  const DisplayEntity({
    super.key,
    required this.trustedEntity,
    required this.notTrustedText,
    required this.trustedListEnabled,
    required this.uri,
    required this.client,
  });

  final TrustedEntity? trustedEntity;
  final String notTrustedText;
  final bool trustedListEnabled;
  final Uri uri;
  final DioClient client;

  @override
  Widget build(BuildContext context) {
    if (!trustedListEnabled) {
      final l10n = context.l10n;
      return FutureBuilder<String>(
        future: host,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Column(
              children: [Text(l10n.scanPromptHost), Text(snapshot.data!)],
            );
          }
          return const LinearProgressIndicator();
        },
      );
    }
    if (trustedEntity != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: TrustedEntityDetails(trustedEntity: trustedEntity!),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(notTrustedText),
      );
    }
  }

  Future<String> get host async {
    return getHost(uri: uri, client: client);
  }
}
