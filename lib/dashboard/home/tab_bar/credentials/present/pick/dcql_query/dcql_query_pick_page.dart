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
    try {
      final jwt = widget.credential.jwt!;
      final token = JWT.decode(jwt);
      if (token.payload['dcql_query'] == null) {
        throw Exception('dcql_query is null');
      }

      final rawQuery = token.payload['dcql_query'];
      if (rawQuery is! Map<String, dynamic>) {
        throw Exception('dcql_query is not a Map<String, dynamic>');
      }
      final query = DcqlCredentialQuery.fromJson(rawQuery);
      final credentials = context.read<CredentialsCubit>().state.credentials;
      final candidates = credentials
          .where((e) => e.format == VCFormatType.dcSdJWT.vpValue)
          .toList();
      final packageFormatCredentials = candidates
          .map((e) => SdJwtDigitalCredential.fromSdJwt(sdJwtToken: e.jwt!))
          .toList();
      final result = query.query(packageFormatCredentials);

      if (!result.fulfilled) {
        return _DcqlQueryFailureView(
          missingCredentials: result.unsatisfiedQueryCredentialSets.toList(),
          credentialModels: candidates,
        );
      }

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
            child: MyElevatedButton(
              onPressed: () {
                present(
                  context: context,
                  uri: widget.uri,
                  result: result,
                  packageFormatCredentials: packageFormatCredentials,
                  candidates: candidates,
                );
              },
              text: l10n.confirm,
            ),
          ),
        ),
      );
    } catch (_) {
      return const _DcqlQueryFailureView();
    }
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

class _DcqlQueryFailureView extends StatelessWidget {
  const _DcqlQueryFailureView({
    this.missingCredentials = const [],
    this.credentialModels = const [],
  });

  final List<DcqlCredential> missingCredentials;
  final List<CredentialModel> credentialModels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final languageCode = context.read<LangCubit>().state.locale.languageCode;
    final labels = missingCredentials
        .expand(
          (credential) =>
              _missingLabels(credential, languageCode, credentialModels),
        )
        .toSet()
        .toList();
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                l10n.dcqlInformationNotAvailable,
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.dcqlInformationNotAvailableDescription,
              style: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              '${l10n.dcqlMissingInformation}:',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (labels.isEmpty)
              Text(l10n.userNotFitErrorMessage, style: textTheme.bodyMedium)
            else
              for (final label in labels)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('\u2022  $label', style: textTheme.bodyMedium),
                ),
            const SizedBox(height: 18),
            Text(l10n.dcqlCannotContinue, style: textTheme.bodyMedium),
          ],
        ),
      ),
      navigation: MyElevatedButton(
        text: l10n.close,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static Iterable<String> _missingLabels(
    DcqlCredential credential,
    String languageCode,
    List<CredentialModel> credentialModels,
  ) {
    final claims = credential.claims;
    if (claims != null && claims.isNotEmpty) {
      return claims.map((claim) {
        final path = claim.path.whereType<String>().toList();
        final credentialModel = credentialModels
            .cast<CredentialModel?>()
            .firstWhere(
              (model) =>
                  model != null &&
                  model.credentialSupported?['credential_metadata']?['claims']
                      is List &&
                  (model.credentialSupported?['credential_metadata']?['claims']
                          as List)
                      .any(
                        (item) =>
                            item is Map<String, dynamic> &&
                            item['path'] is List &&
                            _pathEquals(item['path'] as List, claim.path),
                      ),
              orElse: () => null,
            );
        if (credentialModel != null) {
          return _translatedTitle(credentialModel, claim.path, languageCode);
        }
        final value = path.isEmpty ? credential.id : path.last;
        return value
            .replaceAll(RegExp('([a-z])([A-Z])'), r'$1 $2')
            .replaceAll(RegExp('[_-]+'), ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
      });
    }
    return [credential.meta?.vctValues?.join(', ') ?? credential.id];
  }
}

bool _pathEquals(List<dynamic> first, List<dynamic> second) {
  if (first.length != second.length) return false;
  for (var i = 0; i < first.length; i++) {
    if (first[i]?.toString() != second[i]?.toString()) return false;
  }
  return true;
}

String _translatedTitle(
  CredentialModel credentialModel,
  List<dynamic> path,
  String languageCode,
) {
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
  return path.map((item) => item == null ? '*' : item.toString()).join(' > ');
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

  static String _valueLabel(dynamic value) =>
      value is Map || value is List ? jsonEncode(value) : value.toString();

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
                title: _translatedTitle(credentialModel, path, languageCode),
                value: _valueLabel(credential.getValueByPath(path) ?? '—'),
                titleColor: onSurface,
                valueColor: onSurface,
                showVertically: true,
              ),
            for (final entry in plainClaims)
              CredentialField(
                title: _translatedTitle(credentialModel, [
                  entry.key,
                ], languageCode),
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
