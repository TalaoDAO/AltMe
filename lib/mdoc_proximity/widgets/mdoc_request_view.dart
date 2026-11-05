import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:altme/mdoc_proximity/helpers/proximity_reader.dart';
import 'package:flutter/material.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// What a reader asks for: who asks and whether the trusted list knows it,
/// then, as on the OIDC4VP share screen, the card of each attestation that
/// can answer a requested document with its requested data elements folded.
///
/// Each requested document is answered by one of the wallet's [candidates]
/// for its type; the user picks with the radio under the cards, or a tap on
/// a card, when there are several. Every requested element the chosen
/// attestation holds is shared; one it does not hold reads "—". A document
/// with no candidate cannot be shared.
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

  List<CredentialModel> _candidatesOf(String docType) =>
      widget.candidates[docType] ?? const [];

  /// One disclosure per document an attestation answers: every requested
  /// element the chosen attestation holds.
  List<ProximityDisclosure> _disclosures() => [
    for (final document in widget.documents)
      if (_chosen[document.docType] case final CredentialModel credential)
        if (_heldElements(document, credential) case final elements
            when elements.isNotEmpty)
          ProximityDisclosure(
            mdoc: credential.proximityMdoc,
            elements: elements,
          ),
  ];

  /// name space → the elements of [document] that [credential] holds.
  static Map<String, List<String>> _heldElements(
    ProximityDocumentRequest document,
    CredentialModel credential,
  ) => {
    for (final ns in document.nameSpaces.entries)
      if ([
            for (final element in ns.value.keys)
              if (credential.mdocValue(ns.key, element) != null) element,
          ]
          case final elements when elements.isNotEmpty)
        ns.key: elements,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final reader = widget.reader;
    final disclosures = _disclosures();

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
                if (_candidatesOf(document.docType).isEmpty)
                  _UnavailableDocument(docType: document.docType)
                else
                  for (final candidate in _candidatesOf(document.docType))
                    _CandidateCard(
                      document: document,
                      credential: candidate,
                      // The user picks among the candidates of a document
                      // when it has several.
                      selected: _candidatesOf(document.docType).length < 2
                          ? null
                          : _chosen[document.docType]?.id == candidate.id,
                      onSelected: () => setState(
                        () => _chosen[document.docType] = candidate,
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.onlyInformationShownWillBeShared),
        const SizedBox(height: 8),
        MyElevatedButton(
          text: l10n.shareInformationButtonLabel,
          onPressed: disclosures.isEmpty
              ? null
              : () => widget.onShare(disclosures),
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

/// An attestation that can answer a requested document, as on the OIDC4VP
/// share screen: its card, then a folded row per requested element. With
/// several candidates, a radio under the card, and a tap on the card picks
/// it.
class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.document,
    required this.credential,
    required this.selected,
    required this.onSelected,
  });

  final ProximityDocumentRequest document;
  final CredentialModel credential;

  /// Whether the user picked this candidate, when its document has several.
  /// `null` when there is nothing to pick.
  final bool? selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;
    final selected = this.selected;

    return CredentialShareCard(
      credentialModel: credential,
      onTap: selected == null ? null : onSelected,
      belowImage: selected == null
          ? null
          : CredentialSelectionMark(selected: selected),
      children: [
        Text(
          l10n.dcqlSharedDataLabel,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        for (final ns in document.nameSpaces.entries)
          for (final element in ns.value.entries)
            FoldedClaim(
              title: credential.mdocLabel(ns.key, element.key, languageCode),
              value: _display(credential.mdocValue(ns.key, element.key)),
              note: element.value ? l10n.mdocProximityWillRetain : null,
            ),
      ],
    );
  }

  /// How [value] reads; a `data:` image URI is shown as the picture.
  static String _display(Object? value) => switch (value) {
    null => '—',
    Map<dynamic, dynamic>() || List<dynamic>() => jsonEncode(value),
    _ => value.toString(),
  };
}

/// A requested document the wallet holds no attestation for.
class _UnavailableDocument extends StatelessWidget {
  const _UnavailableDocument({required this.docType});

  final String docType;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.block,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(docType),
          subtitle: Text(context.l10n.mdocProximityDocumentUnavailable),
        ),
      ),
    );
  }
}
