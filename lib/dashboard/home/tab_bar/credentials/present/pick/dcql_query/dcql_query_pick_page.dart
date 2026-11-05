import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/helper_functions/get_display.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/dcql_query/dcql_helper.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/dcql_query/dcql_mdoc_helper.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:altme/oidc4vc/model/verifier_trust_info.dart';
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
    this.verifierTrustInfo,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final int inputDescriptorIndex;
  final List<CredentialModel> credentialsToBePresented;
  final VerifierTrustInfo? verifierTrustInfo;

  static Route<dynamic> route({
    required Uri uri,
    required CredentialModel credential,
    required Issuer issuer,
    required int inputDescriptorIndex,
    required List<CredentialModel> credentialsToBePresented,
    VerifierTrustInfo? verifierTrustInfo,
  }) {
    final pageRoute = MaterialPageRoute<void>(
      builder: (context) => DcqlQueryOfferPickPage(
        uri: uri,
        credential: credential,
        issuer: issuer,
        inputDescriptorIndex: inputDescriptorIndex,
        credentialsToBePresented: credentialsToBePresented,
        verifierTrustInfo: verifierTrustInfo,
      ),
      settings: const RouteSettings(name: '/DcqlQueryOfferPickPage'),
    );
    return pageRoute;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final profileModel = context.read<ProfileCubit>().state.model;
        final credentialManifestPickCubit = CredentialManifestPickCubit(
          credential: credential,
          credentialList: context
              .read<CredentialsCubit>()
              .state
              .credentials
              .onePerBatch,
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
        return credentialManifestPickCubit;
      },
      // The app-wide scan listener pops the dialog it shows on an error, so
      // this page shows the message itself, like the other pick pages.
      child: BlocListener<ScanCubit, ScanState>(
        listener: (context, scanState) {
          if (scanState.status == ScanStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }
          if (scanState.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: scanState.message!,
            );
          }
        },
        child: DcqlQueryOfferPickView(
          uri: uri,
          credential: credential,
          issuer: issuer,
          inputDescriptorIndex: inputDescriptorIndex,
          credentialsToBePresented: credentialsToBePresented,
          verifierTrustInfo: verifierTrustInfo,
        ),
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
    this.verifierTrustInfo,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final int inputDescriptorIndex;
  final List<CredentialModel> credentialsToBePresented;
  final VerifierTrustInfo? verifierTrustInfo;

  @override
  State<DcqlQueryOfferPickView> createState() => _DcqlQueryOfferPickViewState();
}

class _DcqlQueryOfferPickViewState extends State<DcqlQueryOfferPickView> {
  /// Set once Confirm is pressed: the button is disabled from then on, so a
  /// presentation cannot be sent twice.
  bool _presenting = false;

  /// How many of the transaction types' screens shown before the consent
  /// the user has gone through.
  int _reviewsSeen = 0;

  /// The match the user picked for each credential query, by query id and
  /// index in its list of matches. The first match when absent.
  final _selection = <String, int>{};

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
      // Already checked against the query when the request was scanned.
      const transactionHandlers = Parameters.transactionHandlers;
      final transactionData = transactionHandlers.dataTypes.parse(
        token.payload['transaction_data'],
        credentialQueryIds: {for (final c in query.credentials) c.id},
      );
      // One copy per batch: the user chooses among credentials, not copies.
      final credentials = context
          .read<CredentialsCubit>()
          .state
          .credentials
          .onePerBatch;
      final candidates = <CredentialModel>[];
      final packageFormatCredentials = <DigitalCredential>[];
      for (final e in credentials) {
        try {
          if (e.format == VCFormatType.dcSdJWT.vpValue) {
            packageFormatCredentials.add(
              SdJwtDigitalCredential.fromSdJwt(sdJwtToken: e.jwt!),
            );
            candidates.add(e);
          } else if (e.canPresentInProximity) {
            // an mdoc bound to a platform key, which signs DeviceAuth
            final mdoc = mdocDigitalCredential(e);
            if (mdoc == null) continue;
            packageFormatCredentials.add(mdoc);
            candidates.add(e);
          }
        } catch (_) {
          // skip candidates that fail to parse rather than aborting the
          // whole screen
        }
      }
      final matches = query.query(packageFormatCredentials);

      if (!matches.fulfilled) {
        return _DcqlQueryFailureView(
          missingCredentials: matches.unsatisfiedQueryCredentialSets.toList(),
          credentialModels: candidates,
        );
      }

      // The screens some transaction types show before the consent, such as
      // the documents a QES approval signs, one after the other.
      final reviews = [
        for (final item in transactionData)
          if (transactionHandlers
                  .of(item)
                  .buildReview(
                    context,
                    item,
                    onContinue: () => setState(() => _reviewsSeen++),
                  )
              case final review?)
            review,
      ];
      if (_reviewsSeen < reviews.length) return reviews[_reviewsSeen];

      return BasePage(
        title: l10n.credentialShareTitle,
        titleAlignment: Alignment.topCenter,
        titleTrailing: const WhiteCloseButton(),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in transactionData)
              transactionHandlers.of(item).buildConsent(context, item),
            VerifiableCredentialsColumn(
              result: matches,
              packageFormatCredentials: packageFormatCredentials,
              candidates: candidates,
              selection: _selection,
              onSelected: (queryId, index) =>
                  setState(() => _selection[queryId] = index),
            ),
          ],
        ),
        navigation: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: MyElevatedButton(
              onPressed: _presenting
                  ? null
                  : () async {
                      setState(() => _presenting = true);
                      try {
                        await present(
                          context: context,
                          uri: widget.uri,
                          result: selectMatchPerCredential(matches, _selection),
                          packageFormatCredentials: packageFormatCredentials,
                          candidates: candidates,
                          transactionData: transactionData,
                        );
                      } catch (e) {
                        // Nothing was sent (key, VP token): the user may try
                        // again.
                        if (mounted) {
                          setState(() => _presenting = false);
                          context.read<ScanCubit>().emitError(e);
                        }
                      }
                    },
              text: transactionData.isEmpty
                  ? l10n.share
                  : transactionHandlers
                        .of(transactionData.first)
                        .confirmLabel(l10n),
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
    required List<DigitalCredential> packageFormatCredentials,
    required List<CredentialModel> candidates,
    required List<TransactionDataItem> transactionData,
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

    // An mdoc's DeviceAuth signs over the request: client_id, nonce,
    // response_uri and, when encrypted, the verifier's encryption key.
    final presentsMdoc = result.verifiableCredentials.values.any(
      (matches) => matches.any((c) => c is MdocDigitalCredential),
    );
    final mdocSessionTranscript = presentsMdoc
        ? oid4vpSessionTranscript(
            uri: uri,
            clientMetadata: await getClientMetada(
              client: context.read<ScanCubit>().client,
              uri: uri,
            ),
          )
        : null;

    final vpToken = await buildVpToken(
      result,
      packageFormatCredentials,
      candidates,
      uri,
      jsonDecode(privateKeyString) as Map<String, dynamic>,
      customOidc4vcProfile.proofHeader,
      credentialKeySigner: profileCubit.signerForCredentialKey,
      mdocSessionTranscript: mdocSessionTranscript,
      transactionDataTypes: Parameters.transactionHandlers.dataTypes,
      transactionData: transactionData,
    );

    final presentedCredentials = presentedCandidates(
      result,
      packageFormatCredentials,
      candidates,
    );

    await context.read<ScanCubit>().presentOidc4vpFinal(
      uri: uri,
      credentialModel: widget.credential,
      keyId: SecureStorageKeys.ssiKey,
      vpToken: vpToken,
      issuer: widget.issuer,
      qrCodeScanCubit: context.read<QRCodeScanCubit>(),
      presentedCredentials: presentedCredentials,
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
      final labels = claims.map((claim) {
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
          final translatedTitle = _translatedTitle(
            credentialModel,
            claim.path,
            languageCode,
          );
          return translatedTitle;
        }
        final value = path.isEmpty ? credential.id : path.last;
        final formattedValue = _humanizeClaimName(value);
        return formattedValue;
      });
      return labels;
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
  // No display in the issuer's metadata: the claim's own name, readable.
  final names = path.whereType<String>();
  if (names.isNotEmpty) return _humanizeClaimName(names.last);
  return path.map((item) => item == null ? '*' : item.toString()).join(' > ');
}

/// `family_name` and `familyName` as "Family Name".
String _humanizeClaimName(String name) => name
    .replaceAll(RegExp('([a-z])([A-Z])'), r'$1 $2')
    .replaceAll(RegExp('[_-]+'), ' ')
    .split(' ')
    .map(
      (word) =>
          word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}',
    )
    .join(' ');

class VerifiableCredentialsColumn extends StatelessWidget {
  const VerifiableCredentialsColumn({
    super.key,
    required this.result,
    required this.packageFormatCredentials,
    required this.candidates,
    this.selection = const {},
    this.onSelected,
  });

  final DcqlQueryResult result;
  final List<DigitalCredential> packageFormatCredentials;
  final List<CredentialModel> candidates;

  /// The match picked for each credential query, by query id and index in
  /// its matches. The first match when absent.
  final Map<String, int> selection;

  /// Called with the query id and the index of the match the user taps,
  /// when a query matches several credentials.
  final void Function(String queryId, int index)? onSelected;

  // Label a missing (zero-match) credential-query requirement: the claims
  // it asked for when it specified any, else the credential type it asked
  // for (vct_values), else the raw DCQL id as a last resort.
  static String _missingCredentialLabel(DcqlCredential missing) {
    final claims = missing.claims;
    if (claims != null && claims.isNotEmpty) {
      final claimLabels = claims
          .map(
            (c) =>
                c.path.map((s) => s == null ? '*' : s.toString()).join(' › '),
          )
          .join(', ');
      return claimLabels;
    }
    final vctValues = missing.meta?.vctValues;
    if (vctValues != null && vctValues.isNotEmpty) {
      final joinedVctValues = vctValues.join(', ');
      return joinedVctValues;
    }
    return missing.meta?.doctypeValue ?? missing.id;
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
          for (final (index, credential) in entry.value.indexed)
            _CredentialTile(
              credentialModel:
                  candidates[packageFormatCredentials.indexOf(
                    findOriginal(credential, packageFormatCredentials)!,
                  )],
              credential: credential,
              requestedPaths:
                  result.query.credentials
                      .firstWhere((c) => c.id == entry.key)
                      .claims
                      ?.map((c) => c.path)
                      .toList() ??
                  const [],
              // The user picks among the matches of a query when it has
              // several.
              selected: entry.value.length < 2
                  ? null
                  : (selection[entry.key] ?? 0) == index,
              onSelected: () => onSelected?.call(entry.key, index),
            ),
        ],
      ],
    );
  }
}

/// A credential the verifier asks for: its card, then a folded list of the
/// data the request asks for. Each row shows the label of one claim and
/// unfolds its value on a tap.
class _CredentialTile extends StatelessWidget {
  const _CredentialTile({
    required this.credentialModel,
    required this.credential,
    required this.requestedPaths,
    this.selected,
    this.onSelected,
  });

  final CredentialModel credentialModel;
  final DigitalCredential credential;
  final List<List<dynamic>> requestedPaths;

  /// Whether the user picked this match, when its query has several. `null`
  /// when there is nothing to pick.
  final bool? selected;
  final VoidCallback? onSelected;

  static String _valueLabel(dynamic value) =>
      value is Map || value is List ? jsonEncode(value) : value.toString();

  @override
  Widget build(BuildContext context) {
    final languageCode = context.read<LangCubit>().state.locale.languageCode;
    final textTheme = Theme.of(context).textTheme;

    return CredentialShareCard(
      credentialModel: credentialModel,
      onTap: selected == null ? null : onSelected,
      belowImage: selected == null
          ? null
          : Semantics(
              selected: selected,
              inMutuallyExclusiveGroup: true,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    selected!
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 25,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
      children: [
        Text(context.l10n.dcqlSharedDataLabel, style: textTheme.bodySmall),
        for (final path in requestedPaths)
          _FoldedClaim(
            title: _translatedTitle(credentialModel, path, languageCode),
            value: _valueLabel(credential.getValueByPath(path) ?? '—'),
          ),
      ],
    );
  }
}

/// The label of one shared claim, with its value one tap away.
class _FoldedClaim extends StatelessWidget {
  const _FoldedClaim({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 8),
      dense: true,
      title: Text(title, style: textTheme.titleSmall),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      children: [SelectableText(value, style: textTheme.bodyMedium)],
    );
  }
}
