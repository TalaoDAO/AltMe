import 'package:trusted_list/trusted_list.dart';

/// The PEM root certificates of the [trustedList] issuers of any of
/// [docTypes]: the IACAs a reader accepts documents of those types from.
List<String> readerTrustedRoots(
  TrustedList? trustedList,
  Iterable<String> docTypes,
) => {
  for (final entity in trustedList?.entities ?? const <TrustedEntity>[])
    if (entity.type == TrustedEntityType.issuer &&
        (entity.vcTypes ?? const <String>[]).any(docTypes.contains))
      for (final certificate in entity.rootCertificates ?? const <String>[])
        _pem(certificate),
}.toList();

/// [certificate] as PEM; the trusted list carries base64 DER.
String _pem(String certificate) {
  final body = certificate.trim();
  if (body.startsWith('-----BEGIN')) return body;
  final lines = [
    for (var i = 0; i < body.length; i += 64)
      body.substring(i, i + 64 > body.length ? body.length : i + 64),
  ];
  return [
    '-----BEGIN CERTIFICATE-----',
    ...lines,
    '-----END CERTIFICATE-----',
  ].join('\n');
}
