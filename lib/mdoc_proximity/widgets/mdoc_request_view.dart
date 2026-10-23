import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:altme/mdoc_proximity/helpers/proximity_reader.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// What a reader asks for: who asks and whether the trusted list knows it,
/// then document by document, the card of the attestation that answers it
/// with a checkbox per requested data element.
///
/// Each requested document is answered by one of the wallet's [candidates]
/// for its type; the user picks when there are several. Everything requested
/// and held is selected by default; the user unticks what they do not want
/// to share. Elements the chosen attestation does not hold are listed but
/// cannot be selected, and a document with no candidate cannot be shared.
class MdocRequestView extends StatefulWidget {
  /// Creates the view.
  const MdocRequestView({
    super.key,
    required this.documents,
    required this.candidates,
    this.reader = const ProximityReader(),
    required this.onShare,
    required this.onDecline,
  });

  /// The reader's request.
  final List<ProximityDocumentRequest> documents;

  /// docType → the credentials that can answer it.
  final Map<String, List<CredentialModel>> candidates;

  /// Who asks, checked against the trusted list.
  final ProximityReader reader;

  /// Called with one disclosure per document the user shares.
  final void Function(List<ProximityDisclosure> disclosures) onShare;

  /// Called when the user declines.
  final VoidCallback onDecline;

  @override
  State<MdocRequestView> createState() => _MdocRequestViewState();
}

class _MdocRequestViewState extends State<MdocRequestView> {
  /// docType → the candidate chosen to answer it; the first by default.
  late final Map<String, CredentialModel> _chosen = {
    for (final document in widget.documents)
      if (_candidatesOf(document.docType).firstOrNull
          case final CredentialModel credential)
        document.docType: credential,
  };

  /// `docType|nameSpace|element` of every selected element.
  late final Set<String> _selected = {
    for (final document in widget.documents) ..._heldIds(document),
  };

  List<CredentialModel> _candidatesOf(String docType) =>
      widget.candidates[docType] ?? const [];

  /// The attestation answering [document], if any.
  CredentialModel? _credential(ProximityDocumentRequest document) =>
      _chosen[document.docType];

  bool _held(ProximityDocumentRequest document, String ns, String element) =>
      _credential(document)?.mdocValue(ns, element) != null;

  /// The ids of the elements of [document] the chosen attestation holds.
  Iterable<String> _heldIds(ProximityDocumentRequest document) => [
    for (final ns in document.nameSpaces.entries)
      for (final element in ns.value.keys)
        if (_held(document, ns.key, element))
          _id(document.docType, ns.key, element),
  ];

  static String _id(String docType, String ns, String element) =>
      '$docType|$ns|$element';

  void _choose(ProximityDocumentRequest document, CredentialModel credential) =>
      setState(() {
        _chosen[document.docType] = credential;
        _selected
          ..removeWhere((id) => id.startsWith('${document.docType}|'))
          ..addAll(_heldIds(document));
      });

  List<ProximityDisclosure> _disclosures() => [
    for (final document in widget.documents)
      if (_credential(document) case final CredentialModel credential)
        if (_elements(document) case final elements when elements.isNotEmpty)
          ProximityDisclosure(
            mdoc: credential.proximityMdoc,
            elements: elements,
          ),
  ];

  /// name space → the selected elements of [document].
  Map<String, List<String>> _elements(ProximityDocumentRequest document) => {
    for (final ns in document.nameSpaces.entries)
      if ([
            for (final element in ns.value.keys)
              if (_selected.contains(_id(document.docType, ns.key, element)))
                element,
          ]
          case final elements when elements.isNotEmpty)
        ns.key: elements,
  };

  void _toggle(String id, {required bool selected}) => setState(() {
    if (selected) {
      _selected.add(id);
    } else {
      _selected.remove(id);
    }
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final reader = widget.reader;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              Text(l10n.mdocProximityRequestedBy, style: textTheme.bodyMedium),
              Text(
                reader.name ?? l10n.mdocProximityUnknownReader,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TrustBadge(
                isTrusted: reader.isTrusted,
                trustedLabel: l10n.verifiedOrganisationLabel,
                notTrustedLabel: l10n.organisationNotVerifiedLabel,
                notTrustedDescription: reader.isTrusted
                    ? null
                    : l10n.organisationNotVerifiedDescription,
              ),
              const SizedBox(height: 16),
              for (final document in widget.documents)
                _DocumentCard(
                  docType: document.docType,
                  credential: _credential(document),
                  selector: _candidatesOf(document.docType).length > 1
                      ? _CandidateSelector(
                          candidates: _candidatesOf(document.docType),
                          chosen: _credential(document)!,
                          onChanged: (credential) =>
                              _choose(document, credential),
                        )
                      : null,
                  elements: [
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
                              ? (selected) => _toggle(
                                  _id(document.docType, ns.key, element.key),
                                  selected: selected,
                                )
                              : null,
                        ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.onlyInformationShownWillBeShared),
        const SizedBox(height: 8),
        MyElevatedButton(
          text: l10n.shareInformationButtonLabel,
          onPressed: _selected.isEmpty
              ? null
              : () => widget.onShare(_disclosures()),
        ),
        const SizedBox(height: 8),
        MyOutlinedButton(
          text: l10n.dontShareLabel,
          onPressed: widget.onDecline,
        ),
      ],
    );
  }
}

/// Which of several attestations of one type answers the document.
class _CandidateSelector extends StatelessWidget {
  const _CandidateSelector({
    required this.candidates,
    required this.chosen,
    required this.onChanged,
  });

  final List<CredentialModel> candidates;
  final CredentialModel chosen;
  final ValueChanged<CredentialModel> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CredentialModel>(
      initialValue: chosen,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.l10n.mdocProximityChooseAttestation,
      ),
      items: [
        for (final (index, credential) in candidates.indexed)
          DropdownMenuItem(
            value: credential,
            child: Text(
              // Two attestations of one type often share a name.
              '${credential.mdocName} (${index + 1})',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (credential) {
        if (credential != null) onChanged(credential);
      },
    );
  }
}

/// One requested document: the card of the attestation answering it, as on
/// the OIDC4VP presentation screens, and its requested elements; or why no
/// attestation answers it.
class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.docType,
    required this.credential,
    required this.selector,
    required this.elements,
  });

  final String docType;
  final CredentialModel? credential;
  final Widget? selector;
  final List<Widget> elements;

  @override
  Widget build(BuildContext context) {
    final credential = this.credential;
    final picture = credential == null
        ? null
        : SelectiveDisclosure(credential).getPicture;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (credential == null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.block,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(docType),
                subtitle: Text(context.l10n.mdocProximityDocumentUnavailable),
              )
            else if (picture != null)
              PictureDisplay(credentialImage: picture)
            else
              CredentialDisplay(
                credentialModel: credential,
                credDisplayType: CredDisplayType.List,
                profileSetting: context
                    .read<ProfileCubit>()
                    .state
                    .model
                    .profileSetting,
                isDiscover: false,
                showPortrait: true,
              ),
            if (selector != null) ...[const SizedBox(height: 8), selector!],
            const SizedBox(height: 12),
            ...elements,
          ],
        ),
      ),
    );
  }
}

/// A requested element, its value as on the OIDC4VP presentation screens,
/// with the checkbox that shares it. Not selectable when the attestation
/// does not hold it.
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
    final onChanged = this.onChanged;
    final theme = Theme.of(context);
    final color = onChanged == null
        ? theme.disabledColor
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onChanged == null ? null : () => onChanged(!selected),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: selected,
            onChanged: onChanged == null ? null : (v) => onChanged(v ?? false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CredentialField(
                  title: label,
                  value: _display(value),
                  titleColor: color,
                  valueColor: color,
                  showVertically: true,
                ),
                if (intentToRetain)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      context.l10n.mdocProximityWillRetain,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// How [value] reads; a `data:` image URI is shown as the picture.
  static String _display(Object? value) => switch (value) {
    null => '—',
    Map<dynamic, dynamic>() || List<dynamic>() => jsonEncode(value),
    _ => value.toString(),
  };
}
