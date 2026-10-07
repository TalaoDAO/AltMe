import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:flutter/material.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// What a reader asks for, with a checkbox per data element the wallet holds.
///
/// Everything requested and held is selected by default; the user unticks
/// what they do not want to share. Elements the mdoc does not hold are
/// listed but cannot be selected.
class MdocRequestView extends StatefulWidget {
  /// Creates the view.
  const MdocRequestView({
    super.key,
    required this.credentialModel,
    required this.documents,
    required this.onShare,
    required this.onCancel,
  });

  /// The mdoc being presented.
  final CredentialModel credentialModel;

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

  bool _held(ProximityDocumentRequest document, String ns, String element) =>
      document.docType == widget.credentialModel.mdocDocType &&
      widget.credentialModel.mdocValue(ns, element) != null;

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
              for (final document in widget.documents)
                for (final ns in document.nameSpaces.entries)
                  for (final element in ns.value.entries)
                    _ElementTile(
                      label: widget.credentialModel.mdocLabel(
                        ns.key,
                        element.key,
                        languageCode,
                      ),
                      value: widget.credentialModel.mdocValue(
                        ns.key,
                        element.key,
                      ),
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
