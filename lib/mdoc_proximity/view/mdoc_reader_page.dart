import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/cubit/mdoc_reader_cubit.dart';
import 'package:altme/mdoc_proximity/helpers/reader_trusted_roots.dart';
import 'package:altme/mdoc_proximity/widgets/proximity_message.dart';
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
      child: const MdocReaderView(),
    );
  }
}

/// The reader session, one screen per state.
class MdocReaderView extends StatelessWidget {
  /// Creates the view.
  const MdocReaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.mdocReaderTitle,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      secureScreen: true,
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
  const MdocReaderResultView({super.key, required this.result});

  /// The verified response.
  final ReaderResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return ListView(
      children: [
        if (result.documents.isEmpty && !result.hasErrors)
          Text(l10n.mdocReaderNothingShared),
        for (final document in result.documents) ...[
          Row(
            children: [
              Icon(Icons.verified_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(document.docType, style: textTheme.titleMedium),
              ),
            ],
          ),
          Text(l10n.mdocReaderDocumentVerified, style: textTheme.bodySmall),
          for (final nameSpace in document.nameSpaces.values)
            for (final MapEntry(:key, :value) in nameSpace.entries)
              _ElementRow(identifier: key, value: value),
          const Divider(height: 32),
        ],
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

class _ElementRow extends StatelessWidget {
  const _ElementRow({required this.identifier, required this.value});

  final String identifier;
  final dynamic value;

  /// `family_name` → `Family name`.
  String get _label {
    final words = identifier.replaceAll('_', ' ');
    return words.isEmpty ? words : words[0].toUpperCase() + words.substring(1);
  }

  /// Byte strings (e.g. `portrait`) arrive as lists of ints.
  Uint8List? get _bytes {
    final value = this.value;
    if (value is! List || value.length < 16) return null;
    if (!value.every((byte) => byte is int && byte >= 0 && byte <= 255)) {
      return null;
    }
    return Uint8List.fromList(value.cast<int>());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final bytes = _bytes;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_label, style: textTheme.bodySmall),
          const SizedBox(height: 2),
          if (bytes != null)
            Image.memory(
              bytes,
              height: 160,
              alignment: Alignment.centerLeft,
              errorBuilder: (_, _, _) => Text('${bytes.length} bytes'),
            )
          else
            SelectableText(switch (value) {
              true => l10n.yes,
              false => l10n.no,
              Map<dynamic, dynamic>() || List<dynamic>() =>
                const JsonEncoder.withIndent('  ').convert(value),
              _ => '$value',
            }),
        ],
      ),
    );
  }
}
