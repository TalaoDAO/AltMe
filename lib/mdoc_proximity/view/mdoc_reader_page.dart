import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/cubit/mdoc_reader_cubit.dart';
import 'package:altme/mdoc_proximity/widgets/proximity_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:permission_handler/permission_handler.dart';

/// Reads an mDL from a holder's QR code, in person (ISO/IEC 18013-5).
class MdocReaderPage extends StatelessWidget {
  /// Creates the page.
  const MdocReaderPage({super.key, required this.qrUri});

  /// The holder's `mdoc:` device engagement.
  final String qrUri;

  /// The route to this page.
  static Route<dynamic> route({required String qrUri}) =>
      MaterialPageRoute<void>(
        builder: (_) => MdocReaderPage(qrUri: qrUri),
        settings: const RouteSettings(name: '/MdocReaderPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MdocReaderCubit(reader: MdocReader(), qrUri: qrUri)..start(),
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

/// What the holder shared, with the outcome of the signature checks.
class MdocReaderResultView extends StatelessWidget {
  /// Creates the view.
  const MdocReaderResultView({super.key, required this.result});

  /// The verified response.
  final ReaderResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final elements = [
      for (final nameSpace in result.nameSpaces.values) ...nameSpace.entries,
    ];
    return ListView(
      children: [
        Text(result.docTypes.join(', '), style: textTheme.titleMedium),
        const SizedBox(height: 8),
        _CheckRow(
          label: l10n.mdocReaderIssuerCheck,
          check: result.issuerAuthentication,
        ),
        _CheckRow(
          label: l10n.mdocReaderDeviceCheck,
          check: result.deviceAuthentication,
        ),
        for (final MapEntry(key: category, value: messages)
            in result.errors.entries)
          Text('$category: ${messages.join('; ')}', style: textTheme.bodySmall),
        const Divider(height: 32),
        if (elements.isEmpty) Text(l10n.mdocReaderNothingShared),
        for (final MapEntry(:key, :value) in elements)
          _ElementRow(identifier: key, value: value),
        const SizedBox(height: 16),
        MyElevatedButton(
          text: l10n.done,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.check});

  final String label;
  final ReaderCheck check;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, color, text) = switch (check) {
      ReaderCheck.valid => (
        Icons.verified_outlined,
        colorScheme.primary,
        l10n.mdocReaderCheckValid,
      ),
      ReaderCheck.invalid => (
        Icons.gpp_bad_outlined,
        colorScheme.error,
        l10n.mdocReaderCheckInvalid,
      ),
      ReaderCheck.unchecked => (
        Icons.help_outline,
        colorScheme.onSurfaceVariant,
        l10n.mdocReaderCheckUnchecked,
      ),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(text, style: TextStyle(color: color)),
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
