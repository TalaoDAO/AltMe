import 'dart:convert';

import 'package:altme/app/shared/helper_functions/x509_subject_fields.dart';
import 'package:equatable/equatable.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:trusted_list/trusted_list.dart';

/// Who reads the wallet's documents, as the request screen shows it.
class ProximityReader extends Equatable {
  /// Creates a reader.
  const ProximityReader({this.name, this.isTrusted = false});

  /// The reader of [documents], checked against [trustedList] (`null` when
  /// the profile does not use one).
  ///
  /// The reader is trusted when it signed every document request and, for
  /// each certificate chain it signed with, a verifier of [trustedList] has
  /// a root that issued the chain and is registered for the docTypes asked
  /// under it, the way an OIDC4VP verifier is checked. Its name is the
  /// organizationName of its certificate, else the trusted list entry's.
  factory ProximityReader.of(
    List<ProximityDocumentRequest> documents,
    TrustedList? trustedList,
  ) {
    final chains = <String, (List<String>, List<String>)>{};
    var signed = documents.isNotEmpty;
    for (final document in documents) {
      final chain = document.readerCertificateChain;
      if (chain == null || chain.isEmpty) {
        signed = false;
        continue;
      }
      final x5c = chain.map(base64Encode).toList();
      chains.putIfAbsent(x5c.join(), () => (x5c, [])).$2.add(document.docType);
    }

    final entities = [
      if (trustedList != null)
        for (final (x5c, docTypes) in chains.values)
          trustedList.firstMatching(
            const TrustedEntityCriterion.ofType(TrustedEntityType.verifier) &
                TrustedEntityCriterion.signedByRootIn(x5c) &
                TrustedEntityCriterion.offersAllVcTypes(docTypes),
          ),
    ];
    final leaf = chains.values.firstOrNull?.$1.first;
    final organisation = leaf == null
        ? null
        : x509SubjectField(leaf, oidName: 'organizationName');

    return ProximityReader(
      name: organisation ?? entities.nonNulls.firstOrNull?.name,
      isTrusted:
          signed &&
          entities.length == chains.length &&
          entities.every((entity) => entity != null),
    );
  }

  /// The organisation, from the reader certificate or the trusted list;
  /// `null` when the reader did not sign its request.
  final String? name;

  /// Whether the trusted list lists the reader for the requested documents.
  final bool isTrusted;

  @override
  List<Object?> get props => [name, isTrusted];
}
