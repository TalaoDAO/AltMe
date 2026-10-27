import 'dart:typed_data';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/mdoc_proximity/helpers/reader_document_presets.dart';
import 'package:altme/oidc4vc/helper_function/mdoc_credential_data.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// A document a holder showed the reader, as a [CredentialModel], so that the
/// wallet's own credential widgets display it as they display a stored one.
///
/// The model is only displayed: it is never stored. The reader has no issuer
/// metadata, so the card is the default one named after the document, and the
/// claims are listed without labels of their own.
CredentialModel readerCredentialModel(ReaderDocument document) {
  final data = <String, dynamic>{
    'id': 'reader:${document.docType}',
    'type': [document.docType],
    'issuanceDate': '',
    'credentialSubject': {
      'type': document.docType,
      for (final nameSpace in document.nameSpaces.entries)
        nameSpace.key: {
          for (final element in nameSpace.value.entries)
            element.key: readerDisplayValue(element.value),
        },
    },
    'docType': document.docType,
  };
  final name = readerDocumentPresets
      .where((preset) => preset.docType == document.docType)
      .map((preset) => preset.name)
      .firstOrNull;
  return CredentialModel(
    id: data['id'] as String,
    image: null,
    credentialPreview: Credential.fromJson(data),
    shareLink: '',
    data: data,
    format: VCFormatType.mdoc.vcValue,
    display: Display(name: name ?? document.docType),
    // The claim paths let the credential display find the portrait.
    credentialSupported: {
      'claims': [
        for (final nameSpace in document.nameSpaces.entries)
          for (final element in nameSpace.value.keys)
            {
              'path': [nameSpace.key, element],
            },
      ],
    },
  );
}

/// The value of a received data element as the credential display takes it:
/// a JPEG or PNG image (a byte string, a list of ints) as a `data:` URI, any
/// other value as it is.
Object? readerDisplayValue(Object? value) {
  if (value is! List ||
      value.length < 16 ||
      !value.every((byte) => byte is int && byte >= 0 && byte <= 255)) {
    return value;
  }
  return mdocImageDataUri(Uint8List.fromList(value.cast<int>())) ?? value;
}

/// `family_name` → `Family Name`: the label of an element the issuer gave no
/// display name.
String readerElementLabel(String identifier) => identifier
    .split(RegExp('[_-]+'))
    .where((word) => word.isNotEmpty)
    .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
    .join(' ');
