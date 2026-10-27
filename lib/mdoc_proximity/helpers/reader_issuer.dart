import 'dart:convert';

import 'package:mdoc/mdoc.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:trusted_list/trusted_list.dart';

/// Fetches the OpenID4VCI metadata of the credential issuer at [issuerUrl].
typedef IssuerMetadataFetcher =
    Future<OpenIdConfiguration> Function(String issuerUrl);

/// The trusted-list entry that vouches for the issuer of [document], or
/// `null`.
///
/// The rules of OIDC4VCI issuance: an issuer entry, registered for the
/// document type, one of whose root certificates signed the document signer's
/// certificate. Only the signer's certificate is offered to the roots: its
/// key is the one the MSO signature was checked with, and a root appended to
/// the `x5chain` must not vouch for a signer it did not sign.
///
/// Unlike the ISO/IEC 18013-5 certificate profile the reader also checks, this
/// does not judge the certificate extensions (CRL distribution point, EKU,
/// issuer alternative name), on which test issuers often fail.
TrustedEntity? readerTrustedIssuer({
  required TrustedList? trustedList,
  required ReaderDocument document,
}) {
  final signer = document.issuerCertificateChain.firstOrNull;
  if (trustedList == null || signer == null) return null;
  return trustedList.firstMatching(
    const TrustedEntityCriterion.ofType(TrustedEntityType.issuer) &
        TrustedEntityCriterion.signedByRootIn([base64.encode(signer)]) &
        TrustedEntityCriterion.offersAllVcTypes([document.docType]),
  );
}

/// Where the metadata of the issuer of [document] may be served, most
/// specific first: the `https` URIs and the DNS names of the document signer
/// certificate's subject and issuer alternative names, then the
/// [trustedIssuer] entry's identifier.
List<String> readerIssuerUrls({
  required ReaderDocument document,
  TrustedEntity? trustedIssuer,
}) {
  final urls = <String>{};
  final signer = document.issuerCertificateChain.firstOrNull;
  if (signer != null) {
    try {
      final certificate = X509Certificate.fromDer(signer);
      for (final oid in const ['2.5.29.17', '2.5.29.18']) {
        final names = certificate.extension(oid);
        if (names == null) continue;
        urls
          ..addAll(names.uniformResourceIdentifiers.where(_isHttps))
          ..addAll(names.dnsNames.map((name) => 'https://$name'));
      }
    } on FormatException {
      // No names to read: the trusted-list entry may still say.
    }
  }
  if (trustedIssuer != null && _isHttps(trustedIssuer.id)) {
    urls.add(trustedIssuer.id);
  }
  return [for (final url in urls) _withoutTrailingSlash(url)];
}

bool _isHttps(String url) => Uri.tryParse(url)?.scheme == 'https';

/// `https://issuer.example/` → `https://issuer.example`: the metadata path
/// is appended to it.
String _withoutTrailingSlash(String url) =>
    url.endsWith('/') ? url.substring(0, url.length - 1) : url;
