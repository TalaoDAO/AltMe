import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/cubit/custom_reader_requests_cubit.dart';
import 'package:altme/mdoc_proximity/view/mdoc_reader_page.dart';
import 'package:altme/mdoc_proximity/view/mdoc_reader_request_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// What the wallet, as a reader, can ask a holder for: the profile's requests,
/// then the ones the user defined, which the user can add, change and delete.
/// Picking a request opens the camera on the holder's QR code, then reads it
/// in person.
class MdocReaderRequestsView extends StatelessWidget {
  /// Creates the view.
  const MdocReaderRequestsView({
    super.key,
    required this.requests,
    this.scan = _scanWithCamera,
  });

  /// The profile's reader requests.
  final List<ReaderRequest> requests;

  /// Scans a QR code; `null` when the user went back.
  final Future<String?> Function(BuildContext context) scan;

  static Future<String?> _scanWithCamera(BuildContext context) =>
      Navigator.of(context).push<String?>(QrScannerPage.route());

  Future<void> _read(BuildContext context, ReaderRequest request) async {
    final qrUri = await scan(context);
    if (qrUri == null || !context.mounted) return;
    if (!qrUri.toLowerCase().startsWith('mdoc:')) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: StateMessage.error(
          stringMessage: context.l10n.mdocReaderNotHolderQrCode,
          showDialog: false,
        ),
      );
      return;
    }
    await Navigator.of(
      context,
    ).push(MdocReaderPage.route(qrUri: qrUri, query: request.query));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<CustomReaderRequestsCubit, CustomReaderRequestsState>(
      builder: (context, state) => ListView(
        children: [
          Text(l10n.mdocReaderRequestsSubtitle, style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          for (final request in requests)
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: Text(request.name),
              subtitle: Text(request.docTypes.join(', ')),
              trailing: const Icon(Icons.qr_code_scanner),
              onTap: () => _read(context, request),
            ),
          const SizedBox(height: 16),
          Text(l10n.mdocReaderMyRequests, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final request in state.requests)
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: Text(request.name),
              subtitle: Text(
                '${request.docTypes.join(', ')} · '
                '${l10n.mdocReaderRequestClaimCount(_claimCount(request))}',
              ),
              trailing: PopupMenuButton<_RequestAction>(
                onSelected: (action) => switch (action) {
                  _RequestAction.edit => Navigator.of(
                    context,
                  ).push(MdocReaderRequestEditorPage.route(request: request)),
                  _RequestAction.delete => confirmDeleteReaderRequest(
                    context,
                    request,
                  ),
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _RequestAction.edit,
                    child: Text(l10n.edit),
                  ),
                  PopupMenuItem(
                    value: _RequestAction.delete,
                    child: Text(l10n.delete),
                  ),
                ],
              ),
              onTap: () => _read(context, request),
            ),
          const SizedBox(height: 8),
          MyOutlinedButton(
            text: l10n.mdocReaderAddRequest,
            onPressed: () =>
                Navigator.of(context).push(MdocReaderRequestEditorPage.route()),
          ),
        ],
      ),
    );
  }

  static int _claimCount(ReaderRequest request) => request.query.values
      .expand((nameSpaces) => nameSpaces.values)
      .fold(0, (count, elements) => count + elements.length);
}

enum _RequestAction { edit, delete }
