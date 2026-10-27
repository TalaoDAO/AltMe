import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/cubit/mdoc_reader_cubit.dart';
import 'package:altme/mdoc_proximity/cubit/reader_issuer_cubit.dart';
import 'package:altme/mdoc_proximity/helpers/reader_credential_model.dart';
import 'package:altme/mdoc_proximity/helpers/reader_issuer.dart';
import 'package:altme/mdoc_proximity/helpers/reader_trusted_roots.dart';
import 'package:altme/mdoc_proximity/widgets/proximity_message.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:permission_handler/permission_handler.dart';

/// Reads mdocs from a holder's QR code, in person (ISO/IEC 18013-5).
class MdocReaderPage extends StatelessWidget {
  /// Creates the page.
  const MdocReaderPage({
    super.key,
    required this.qrUri,
    this.query = mdlReaderQuery,
  });

  /// The holder's `mdoc:` device engagement.
  final String qrUri;

  /// What is asked for.
  final ReaderQuery query;

  /// The route to this page.
  static Route<dynamic> route({
    required String qrUri,
    ReaderQuery query = mdlReaderQuery,
  }) => MaterialPageRoute<void>(
    builder: (_) => MdocReaderPage(qrUri: qrUri, query: query),
    settings: const RouteSettings(name: '/MdocReaderPage'),
  );

  @override
  Widget build(BuildContext context) {
    final scanCubit = context.read<QRCodeScanCubit>();
    return BlocProvider(
      create: (_) => MdocReaderCubit(
        reader: MdocReader(),
        qrUri: qrUri,
        query: query,
        trustedRoots: readerTrustedRoots(
          context.read<ProfileCubit>().state.model.trustedList,
          query.keys,
        ),
      )..start(),
      child: MdocReaderView(
        fetchIssuerMetadata: (url) => scanCubit.oidc4vc.getIssuerMetaData(
          baseUrl: url,
          dio: scanCubit.client.dio,
        ),
      ),
    );
  }
}

/// The reader session, one screen per state.
class MdocReaderView extends StatelessWidget {
  /// Creates the view.
  const MdocReaderView({super.key, required this.fetchIssuerMetadata});

  /// How the issuers' metadata is fetched, for their name and logo.
  final IssuerMetadataFetcher fetchIssuerMetadata;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.mdocReaderTitle,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      body: BlocBuilder<MdocReaderCubit, ReaderState>(
        builder: (context, state) {
          final cubit = context.read<MdocReaderCubit>();
          return switch (state) {
            ReaderConnecting() => ProximityWaiting(l10n.mdocReaderConnecting),
            ReaderWaitingForResponse() => ProximityWaiting(
              l10n.mdocReaderWaitingForResponse,
            ),
            ReaderBluetoothRequired() => ProximityMessage(
              icon: Icons.bluetooth_disabled,
              text: l10n.mdocReaderBluetoothPermission,
              actions: [
                MyOutlinedButton(
                  text: l10n.mdocProximityOpenSettings,
                  onPressed: openAppSettings,
                ),
                MyElevatedButton(text: l10n.tryAgain, onPressed: cubit.start),
              ],
            ),
            ReaderSuccess(:final result) => MdocReaderResultView(
              result: result,
              fetchIssuerMetadata: fetchIssuerMetadata,
            ),
            ReaderFailure(:final message) => ProximityMessage(
              icon: Icons.error_outline,
              text: l10n.mdocReaderError,
              detail: message,
              actions: [
                MyElevatedButton(text: l10n.tryAgain, onPressed: cubit.start),
                MyOutlinedButton(
                  text: l10n.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}

/// What the holder shared that passed every check, and what did not pass.
class MdocReaderResultView extends StatelessWidget {
  /// Creates the view.
  const MdocReaderResultView({
    super.key,
    required this.result,
    required this.fetchIssuerMetadata,
  });

  /// The verified response.
  final ReaderResult result;

  /// How the issuers' metadata is fetched, for their name and logo.
  final IssuerMetadataFetcher fetchIssuerMetadata;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final languageCode = Localizations.localeOf(context).languageCode;
    return ListView(
      children: [
        if (result.documents.isEmpty && !result.hasErrors)
          Text(l10n.mdocReaderNothingShared),
        for (final document in result.documents)
          BlocProvider(
            create: (context) => ReaderIssuerCubit(
              document: document,
              trustedList: context.read<ProfileCubit>().state.model.trustedList,
              fetchIssuerMetadata: fetchIssuerMetadata,
              languageCode: languageCode,
            )..resolveDisplay(),
            child: _DocumentSection(document: document),
          ),
        if (result.hasErrors) ...[
          Row(
            children: [
              Icon(Icons.gpp_bad_outlined, color: colorScheme.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.mdocReaderNotVerified,
                  style: textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final docType in {
            ...result.failedDocTypes,
            ...result.documentErrors.keys,
          })
            _ErrorRow(
              title: docType,
              messages: result.documentErrors[docType] ?? const [],
            ),
          for (final docType in result.unrequestedDocTypes)
            _ErrorRow(title: docType, messages: [l10n.mdocReaderUnrequested]),
          if (result.responseErrors.isNotEmpty)
            _ErrorRow(
              title: l10n.mdocReaderResponseErrors,
              messages: result.responseErrors,
            ),
          const Divider(height: 32),
        ],
        MyElevatedButton(
          text: l10n.done,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _ErrorRow extends StatelessWidget {
  const _ErrorRow({required this.title, required this.messages});

  final String title;
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.bodyMedium),
          for (final message in messages)
            Text(message, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// A document the holder shared: its issuer, as the issuer-connect dialog
/// shows it (logo, name, trust badge), then the document.
class _DocumentSection extends StatelessWidget {
  const _DocumentSection({required this.document});

  final ReaderDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ReaderIssuerCubit, ReaderIssuerState>(
      builder: (context, issuer) {
        final logoUri = issuer.logoUri;
        final name = issuer.name;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logoUri != null) ...[
              Center(
                child: CachedImageFromNetwork(logoUri, height: 48, width: 48),
              ),
              const SizedBox(height: 8),
            ],
            if (name != null) ...[
              Center(child: Text(name, style: textTheme.titleMedium)),
              const SizedBox(height: 8),
            ],
            // The document is read either way; only the badge differs, as for
            // an OIDC4VP issuer missing from the trusted list.
            TrustBadge(
              isTrusted: issuer.isTrusted,
              trustedLabel: l10n.trustedIssuerLabel,
              notTrustedLabel: l10n.issuerNotVerifiedLabel,
              notTrustedDescription: l10n.issuerNotVerifiedDescription,
            ),
            if (issuer.isTrusted)
              Text(l10n.mdocReaderDocumentVerified, style: textTheme.bodySmall)
            else
              for (final error in document.issuerTrustErrors)
                Text(error, style: textTheme.bodySmall),
            const SizedBox(height: 8),
            _DocumentCard(document: document),
          ],
        );
      },
    );
  }
}

/// A document the holder shared, shown as the OIDC4VP presentation screens
/// show a credential: its card, then its elements.
class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final ReaderDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final credentialModel = readerCredentialModel(document);
    // The card shows the portrait when it can; the field is then not repeated.
    final portraitOnCard =
        SelectiveDisclosure(credentialModel).portrait?.key;

    return CredentialShareCard(
      credentialModel: credentialModel,
      children: [
        for (final nameSpace in document.nameSpaces.entries)
          for (final element in nameSpace.value.entries)
            if (element.key != portraitOnCard)
              CredentialField(
                title: readerElementLabel(element.key),
                value: _valueText(l10n, readerDisplayValue(element.value)),
                titleColor: onSurface,
                valueColor: onSurface,
                showVertically: true,
              ),
      ],
    );
  }
}

/// How a received element reads; a `data:` image URI is shown as the picture.
String _valueText(AppLocalizations l10n, Object? value) => switch (value) {
  true => l10n.yes,
  false => l10n.no,
  // A byte string that is not an image.
  final List<dynamic> bytes
      when bytes.length >= 16 &&
          bytes.every((byte) => byte is int && byte >= 0 && byte <= 255) =>
    '${bytes.length} bytes',
  Map<dynamic, dynamic>() || List<dynamic>() => jsonEncode(value),
  _ => '$value',
};
