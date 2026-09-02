import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/helper_functions/get_display.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/dcql_query/dcql_helper.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';

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
      body: VerifiableCredentialsColumn(
        result: result,
        packageFormatCredentials: packageFormatCredentials,
        candidates: candidates,
      ),
      navigation: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  return MyElevatedButton(
                    onPressed: result.fulfilled
                        ? () {
                            present(
                              context: context,
                              uri: widget.uri,
                              result: result,
                              packageFormatCredentials:
                                  packageFormatCredentials,
                              candidates: candidates,
                            );
                          }
                        : null,
                    text: l10n.confirm,
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
}

class VerifiableCredentialsColumn extends StatelessWidget {
  const VerifiableCredentialsColumn({
    super.key,
    required this.result,
    required this.packageFormatCredentials,
    required this.candidates,
  });

  final DcqlQueryResult result;
  final List<SdJwtDigitalCredential> packageFormatCredentials;
  final List<CredentialModel> candidates;

  // Label a missing (zero-match) credential-query requirement: the claims
  // it asked for when it specified any, else the credential type it asked
  // for (vct_values), else the raw DCQL id as a last resort.
  static String _missingCredentialLabel(DcqlCredential missing) {
    final claims = missing.claims;
    if (claims != null && claims.isNotEmpty) {
      return claims
          .map(
            (c) =>
                c.path.map((s) => s == null ? '*' : s.toString()).join(' › '),
          )
          .join(', ');
    }
    final vctValues = missing.meta?.vctValues;
    if (vctValues != null && vctValues.isNotEmpty) {
      return vctValues.join(', ');
    }
    return missing.id;
  }

  @override
  Widget build(BuildContext context) {
    final entries = result.verifiableCredentials.entries.toList();
    final missingCredentials = result.unsatisfiedQueryCredentialSets.toList();
    final l10n = context.l10n;

    if (entries.isEmpty && missingCredentials.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No matching credentials.'),
      );
    }

    final profileSetting = context
        .read<ProfileCubit>()
        .state
        .model
        .profileSetting;

    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!result.fulfilled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (missingCredentials.isNotEmpty)
                  for (final missing in missingCredentials)
                    Center(
                      child: Text(
                        '${l10n.youAreMissing}: '
                        '${_missingCredentialLabel(missing)}',
                        style: TextStyle(color: errorColor),
                      ),
                    )
                else
                  Text(
                    l10n.userNotFitErrorMessage,
                    style: TextStyle(color: errorColor),
                  ),
              ],
            ),
          ),
        for (final entry in entries) ...[
          for (final credential in entry.value)
            _CredentialTile(
              credentialModel:
                  candidates[packageFormatCredentials.indexOf(
                    findOriginal(credential, packageFormatCredentials)!,
                  )],
              profileSetting: profileSetting,
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
  const _CredentialTile({
    required this.credentialModel,
    required this.profileSetting,
    required this.credential,
    required this.requestedPaths,
  });

  final CredentialModel credentialModel;
  final ProfileSetting profileSetting;
  final DigitalCredential credential;
  final List<List<dynamic>> requestedPaths;

  // Registered/technical JWT and SD-JWT claims — never shown to the user.
  static const _technicalClaims = {
    'iss', 'sub', 'aud', 'exp', 'nbf', 'iat', 'jti',
    'cnf', 'vct', 'vct#integrity', 'status', '_sd', '_sd_alg', //
  };

  static String _pathLabel(List<dynamic> path) =>
      path.map((s) => s == null ? '*' : s.toString()).join(' › ');

  static String _valueLabel(dynamic value) =>
      value is Map || value is List ? jsonEncode(value) : value.toString();

  static bool _pathEquals(List<dynamic> claimPath, List<dynamic> path) {
    if (claimPath.length != path.length) return false;
    for (var i = 0; i < path.length; i++) {
      if (claimPath[i]?.toString() != path[i]?.toString()) return false;
    }
    return true;
  }

  // Same lookup used to build the titles passed to DisclosureLine: find the
  // claim's display metadata (credential_metadata.claims[].display) and
  // resolve the localized name for the current language, falling back to
  // the raw path when no translation is defined.
  String _translatedTitle(List<dynamic> path, String languageCode) {
    final credentialSupported = credentialModel.credentialSupported;
    final claimsList =
        credentialSupported?['credential_metadata']?['claims'] ??
        credentialSupported?['claims'];
    if (claimsList is List) {
      for (final claim in claimsList) {
        if (claim is Map<String, dynamic> &&
            claim['path'] is List &&
            _pathEquals(claim['path'] as List, path)) {
          final display = getDisplay(claim, languageCode);
          if (display is Map && display['name'] != null) {
            return display['name'].toString();
          }
        }
      }
    }
    return _pathLabel(path);
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.read<LangCubit>().state.locale.languageCode;
    final selectiveDisclosure = SelectiveDisclosure(credentialModel);
    final credentialImage = selectiveDisclosure.getPicture;

    // Top-level keys already covered by the DCQL-disclosed claims below,
    // so they aren't duplicated among the "not in a disclosure" claims.
    final disclosedKeys = requestedPaths
        .map((path) => path.isNotEmpty ? path.first?.toString() : null)
        .whereType<String>()
        .toSet();

    final plainClaims = <MapEntry<String, dynamic>>[];
    selectiveDisclosure.payload.forEach((key, value) {
      if (_technicalClaims.contains(key) || disclosedKeys.contains(key)) {
        return;
      }
      // A Map holding `_sd` is a selective-disclosure group container, not
      // a plain always-visible value.
      if (value is Map && value.containsKey('_sd')) {
        return;
      }
      plainClaims.add(MapEntry(key, value));
    });

    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (credentialImage != null)
              PictureDisplay(credentialImage: credentialImage)
            else
              CredentialDisplay(
                credentialModel: credentialModel,
                credDisplayType: CredDisplayType.List,
                profileSetting: profileSetting,
                isDiscover: false,
              ),
            const SizedBox(height: 20),
            for (final path in requestedPaths)
              CredentialField(
                title: _translatedTitle(path, languageCode),
                value: _valueLabel(credential.getValueByPath(path) ?? '—'),
                titleColor: onSurface,
                valueColor: onSurface,
                showVertically: true,
              ),
            for (final entry in plainClaims)
              CredentialField(
                title: _translatedTitle([entry.key], languageCode),
                value: _valueLabel(entry.value),
                titleColor: onSurface,
                valueColor: onSurface,
                showVertically: true,
              ),
          ],
        ),
      ),
    );
  }
}
