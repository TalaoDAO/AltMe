import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:flutter/material.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// What a reader asks for, document by document, with a checkbox per data
/// element of the attestation that answers it.
///
/// Everything requested and held is selected by default; the user unticks
/// what they do not want to share. Elements no attestation holds are listed
/// but cannot be selected.
class MdocRequestView extends StatefulWidget {
  /// Creates the view.
  const MdocRequestView({
    super.key,
    required this.credentials,
    required this.documents,
    required this.onShare,
    required this.onCancel,
  });

  /// The mdocs of the session, found by [ProximityDocumentRequest.mdocId].
  final List<CredentialModel> credentials;

  /// The reader's request.
  final List<ProximityDocumentRequest> documents;

  /// Called with docType → name space → element identifiers.
  final void Function(Map<String, Map<String, List<String>>> elements) onShare;

  /// Called when the user declines.
  final VoidCallback onCancel;

  @override
  State<MdocRequestView> createState() => _MdocRequestViewState();
}

class _MdocRequestViewState extends State<MdocRequestView> {
  /// `docType|nameSpace|element` of every selected element.
  late final Set<String> _selected = {
    for (final document in widget.documents)
      for (final ns in document.nameSpaces.entries)
        for (final element in ns.value.keys)
          if (_held(document, ns.key, element))
            _id(document.docType, ns.key, element),
  };

  /// The attestation answering [document], if any.
  CredentialModel? _credential(ProximityDocumentRequest document) => widget
      .credentials
      .where((credential) => credential.id == document.mdocId)
      .firstOrNull;

  bool _held(ProximityDocumentRequest document, String ns, String element) =>
      _credential(document)?.mdocValue(ns, element) != null;

  static String _id(String docType, String ns, String element) =>
      '$docType|$ns|$element';

  Map<String, Map<String, List<String>>> _selection() {
    final selection = <String, Map<String, List<String>>>{};
    for (final id in _selected) {
      final [docType, ns, element] = id.split('|');
      selection
          .putIfAbsent(docType, () => {})
          .putIfAbsent(ns, () => [])
          .add(element);
    }
    return selection;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.mdocProximityRequestTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.mdocProximityUnverifiedReader)),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [
              for (final document in widget.documents) ...[
                _DocumentHeader(
                  docType: document.docType,
                  credential: _credential(document),
                ),
                for (final ns in document.nameSpaces.entries)
                  for (final element in ns.value.entries)
                    _ElementTile(
                      label:
                          _credential(
                            document,
                          )?.mdocLabel(ns.key, element.key, languageCode) ??
                          element.key,
                      value: _credential(
                        document,
                      )?.mdocValue(ns.key, element.key),
                      intentToRetain: element.value,
                      selected: _selected.contains(
                        _id(document.docType, ns.key, element.key),
                      ),
                      onChanged: _held(document, ns.key, element.key)
                          ? (value) => setState(() {
                              final id = _id(
                                document.docType,
                                ns.key,
                                element.key,
                              );
                              if (value) {
                                _selected.add(id);
                              } else {
                                _selected.remove(id);
                              }
                            })
                          : null,
                    ),
              ],
            ],
          ),
        ),
        Text(l10n.onlyInformationShownWillBeShared),
        const SizedBox(height: 8),
        MyElevatedButton(
          text: l10n.shareInformationButtonLabel,
          onPressed: _selected.isEmpty
              ? null
              : () => widget.onShare(_selection()),
        ),
        const SizedBox(height: 8),
        MyOutlinedButton(text: l10n.dontShareLabel, onPressed: widget.onCancel),
      ],
    );
  }
}

/// The attestation answering a requested document, or why none does.
class _DocumentHeader extends StatelessWidget {
  const _DocumentHeader({required this.docType, required this.credential});

  final String docType;
  final CredentialModel? credential;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final credential = this.credential;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        credential != null ? Icons.badge_outlined : Icons.block,
        color: credential != null ? null : theme.colorScheme.error,
      ),
      title: Text(credential?.mdocName ?? docType),
      subtitle: Text(
        credential != null
            ? docType
            : context.l10n.mdocProximityDocumentUnavailable,
      ),
    );
  }
}

class _ElementTile extends StatelessWidget {
  const _ElementTile({
    required this.label,
    required this.value,
    required this.intentToRetain,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final Object? value;
  final bool intentToRetain;
  final bool selected;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subtitle = [
      if (value != null) _display(value!),
      if (intentToRetain) l10n.mdocProximityWillRetain,
    ].join(' · ');

    return CheckboxListTile(
      value: selected,
      onChanged: onChanged == null ? null : (v) => onChanged!(v ?? false),
      title: Text(label),
      subtitle: subtitle.isEmpty ? null : Text(subtitle, maxLines: 2),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  static String _display(Object value) {
    final text = value.toString();
    // Images (portrait) are long base64 strings: do not print them.
    return text.length > 64 ? '${text.substring(0, 61)}…' : text;
  }
}
