import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/dcql_query/dcql_helper.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dcql/dcql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class DcqlQueryOfferPickPage extends StatelessWidget {
  const DcqlQueryOfferPickPage({
    super.key,
    required this.uri,
    required this.credential,
    required this.issuer,
    required this.inputDescriptorIndex,
    required this.credentialsToBePresented,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final int inputDescriptorIndex;
  final List<CredentialModel> credentialsToBePresented;

  static Route<dynamic> route({
    required Uri uri,
    required CredentialModel credential,
    required Issuer issuer,
    required int inputDescriptorIndex,
    required List<CredentialModel> credentialsToBePresented,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => DcqlQueryOfferPickPage(
        uri: uri,
        credential: credential,
        issuer: issuer,
        inputDescriptorIndex: inputDescriptorIndex,
        credentialsToBePresented: credentialsToBePresented,
      ),
      settings: const RouteSettings(name: '/DcqlQueryOfferPickPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final profileModel = context.read<ProfileCubit>().state.model;
        return CredentialManifestPickCubit(
          credential: credential,
          credentialList: context.read<CredentialsCubit>().state.credentials,
          inputDescriptorIndex: inputDescriptorIndex,
          formatsSupported:
              profileModel
                  .profileSetting
                  .selfSovereignIdentityOptions
                  .customOidc4vcProfile
                  .formatsSupported ??
              [],
          profileType: profileModel.profileType,
        );
      },
      child: DcqlQueryOfferPickView(
        uri: uri,
        credential: credential,
        issuer: issuer,
        inputDescriptorIndex: inputDescriptorIndex,
        credentialsToBePresented: credentialsToBePresented,
      ),
    );
  }
}

class DcqlQueryOfferPickView extends StatefulWidget {
  const DcqlQueryOfferPickView({
    super.key,
    required this.uri,
    required this.credential,
    required this.issuer,
    required this.inputDescriptorIndex,
    required this.credentialsToBePresented,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final int inputDescriptorIndex;
  final List<CredentialModel> credentialsToBePresented;

  @override
  State<DcqlQueryOfferPickView> createState() => _DcqlQueryOfferPickViewState();
}

class _DcqlQueryOfferPickViewState extends State<DcqlQueryOfferPickView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    assert(widget.credential.jwt != null, 'Credential must have a JWT');
    final jwt = widget.credential.jwt!;
    final toto = JWT.decode(jwt);
    if (toto.payload['dcql_query'] == null) {
      throw Exception('dcql_query is null');
    }
    final rawQuery = toto.payload['dcql_query'] as Map<String, dynamic>;
    final query = DcqlCredentialQuery.fromJson(rawQuery);
    final credentials = context.read<CredentialsCubit>().state.credentials;
    final candidates = credentials
        .where((e) => e.format == VCFormatType.dcSdJWT.vpValue)
        .toList();
    // create a list of SdJwtDigitalCredential from the credentials that have
    // the format dcSdJwt and the constructor is
    // SdJwtDigitalCredential.fromSdJwt(sdJwtToken: e.jwt!)

    final packageFormatCredentials = candidates
        .map((e) => SdJwtDigitalCredential.fromSdJwt(sdJwtToken: e.jwt!))
        .toList();
    final result = query.query(packageFormatCredentials);

    return BasePage(
      title: l10n.credentialShareTitle,
      titleAlignment: Alignment.topCenter,
      titleTrailing: const WhiteCloseButton(),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      body: VerifiableCredentialsColumn(result: result),
      navigation: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  return MyElevatedButton(
                    onPressed: () {
                      present(
                        context: context,
                        uri: widget.uri,
                        result: result,
                        packageFormatCredentials: packageFormatCredentials,
                        candidates: candidates,
                      );
                    },
                    text: 'buttonText',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> present({
    required BuildContext context,
    required Uri uri,
    required DcqlQueryResult result,
    required List<SdJwtDigitalCredential> packageFormatCredentials,
    required List<CredentialModel> candidates,
  }) async {
    final profileCubit = context.read<ProfileCubit>();
    final customOidc4vcProfile = profileCubit
        .state
        .model
        .profileSetting
        .selfSovereignIdentityOptions
        .customOidc4vcProfile;

    final privateKeyString = await fetchPrivateKey(
      profileCubit: profileCubit,
      didKeyType: customOidc4vcProfile.defaultDid,
    );

    final vpToken = await buildVpToken(
      result,
      packageFormatCredentials,
      candidates,
      uri,
      jsonDecode(privateKeyString) as Map<String, dynamic>,
      customOidc4vcProfile.proofHeader,
    );

    await context.read<ScanCubit>().presentOidc4vpFinal(
      uri: uri,
      credentialModel: widget.credential,
      keyId: SecureStorageKeys.ssiKey,
      vpToken: vpToken,
      issuer: widget.issuer,
      qrCodeScanCubit: context.read<QRCodeScanCubit>(),
    );
  }

  // Future<CredentialModel> presentationJwt(CredentialModel e) async {
  //   // Implementation for generating presentation JWT
  //   final encryptedValues = e.jwt
  //       ?.split('~')
  //       .where((element) => element.isNotEmpty)
  //       .toList();

  //   if (encryptedValues != null) {
  //     var newJwt = '${encryptedValues[0]}~';

  //     for (final index in selectedSDIndexInJWT) {
  //       newJwt = '$newJwt${encryptedValues[index + 1]}~';
  //     }

  //     // Key Binding JWT

  //     final profileCubit = context.read<ProfileCubit>();

  //     final customOidc4vcProfile = profileCubit
  //         .state
  //         .model
  //         .profileSetting
  //         .selfSovereignIdentityOptions
  //         .customOidc4vcProfile;

  //     final didKeyType = customOidc4vcProfile.defaultDid;

  //     final privateKey = await fetchPrivateKey(
  //       profileCubit: profileCubit,
  //       didKeyType: didKeyType,
  //     );

  //     final tokenParameters = TokenParameters(
  //       privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
  //       did: '', // just added as it is required field
  //       mediaType: MediaType.selectiveDisclosure,
  //       clientType:
  //           ClientType.p256JWKThumprint, // just added as it is required field
  //       proofHeaderType: customOidc4vcProfile.proofHeader,
  //       clientId: '', // just added as it is required field
  //     );

  //     final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  //     final sdHash = sh256Hash(newJwt);

  //     final nonce = uri.queryParameters['nonce'] ?? '';
  //     final clientId = uri.queryParameters['client_id'] ?? '';

  //     final payload = {
  //       'nonce': nonce,
  //       'aud': clientId,
  //       'iat': iat,
  //       'sd_hash': sdHash,
  //     };
  //     // In case of OIDC4VP transaction we need to add the hash of each element
  //     // of transactiondata into the payload
  //     final scanCubit = context.read<ScanCubit>();
  //     final transactionData = scanCubit.state.transactionData;

  //     if (transactionData != null) {
  //       await transactionData.execute();
  //       final List<String> blockchainTransactionHashes = [];
  //       if (blockchainTransactionHashes.isNotEmpty) {
  //         payload['blockchain_transaction_hashes'] =
  //             blockchainTransactionHashes;
  //       }

  //       payload['transaction_data_hashes'] =
  //           transactionData.transactionDataHashes;
  //     }

  //     // If there no cnf in the payload, then no need to add signature
  //     if (e.data['cnf'] != null) {
  //       /// sign and get token
  //       final jwtToken = generateToken(
  //         payload: payload,
  //         tokenParameters: tokenParameters,
  //         ignoreProofHeaderType: true,
  //       );

  //       newJwt = '$newJwt$jwtToken';
  //     }

  //     final CredentialModel newModel = e.copyWith(
  //       selectiveDisclosureJwt: newJwt,
  //     );

  //     final credToBePresented = [newModel];

  //     final updatedCredentials = List.of(widget.credentialsToBePresented)
  //       ..addAll(credToBePresented);

  //     if (isOngoingStep) {
  //       await Navigator.of(context).pushReplacement<void, void>(
  //         CredentialManifestOfferPickPage.route(
  //           uri: widget.uri,
  //           credential: widget.credential,
  //           issuer: widget.issuer,
  //           inputDescriptorIndex: widget.inputDescriptorIndex + 1,
  //           credentialsToBePresented: updatedCredentials,
  //         ),
  //       );
  //     } else {
  //       final bool userPINCodeForAuthentication = context
  //           .read<ProfileCubit>()
  //           .state
  //           .model
  //           .profileSetting
  //           .walletSecurityOptions
  //           .secureSecurityAuthenticationWithPinCode;

  //       if (userPINCodeForAuthentication) {
  //         /// Authenticate
  //         bool authenticated = false;
  //         await securityCheck(
  //           context: context,
  //           title: context.l10n.typeYourPINCodeToShareTheData,
  //           localAuthApi: LocalAuthApi(),
  //           onSuccess: () {
  //             authenticated = true;
  //           },
  //         );

  //         if (!authenticated) {
  //           unawaited(
  //             context.read<ScanCubit>().sendErrorToServer(
  //               uri: widget.uri,
  //               data: {'error': 'access_denied'},
  //             ),
  //           );
  //           return;
  //         }
  //       }

  // }}
}

class VerifiableCredentialsColumn extends StatelessWidget {
  final DcqlQueryResult result;

  const VerifiableCredentialsColumn({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final entries = result.verifiableCredentials.entries.toList();

    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No matching credentials.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
            child: Text(
              entry.key, // the DCQL credential query id, e.g. "pid"
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final credential in entry.value)
            _CredentialTile(
              credential: credential,
              requestedPaths: result.query.credentials
                  .firstWhere((c) => c.id == entry.key)
                  .claims!
                  .map((c) => c.path)
                  .toList(),
            ),
        ],
      ],
    );
  }
}

class _CredentialTile extends StatelessWidget {
  final DigitalCredential credential;
  final List<List<dynamic>> requestedPaths;

  const _CredentialTile({
    required this.credential,
    required this.requestedPaths,
  });

  static String _pathLabel(List<dynamic> path) =>
      path.map((s) => s == null ? '*' : s.toString()).join(' › ');

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              credential.format.name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 16),
            for (final path in requestedPaths)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '${_pathLabel(path)}: '
                  '${credential.getValueByPath(path) ?? '—'}',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
