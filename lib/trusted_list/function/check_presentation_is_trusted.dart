import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

bool checkPresentationIsTrusted({
  required TrustedEntity trustedEntity,
  required String encodedPresentation,
}) {
  // Decode the encoded presentation and retrieve payload.
  final jwt = JWT.decode(encodedPresentation);
  // ignore: lines_longer_than_80_chars
  // Check in jwt.payload['presentation_definition']['input_descriptors']['constraints']['fields']
  // that an element has path = ["$.vct"] and filter['const'] = one of
  // the vcTypes in the trustedEntity.
  final inputDescriptors = jwt.payload['presentation_definition']
      ['input_descriptors'] as List<dynamic>?;
  if (inputDescriptors == null) {
    throw Exception(
        'No input descriptors found in the presentation definition');
  }
  for (final inputDescriptor in inputDescriptors) {
    final constraints = inputDescriptor['constraints'];
    if (constraints != null) {
      final fields = constraints['fields'] as List<dynamic>?;
      if (fields != null) {
        for (final field in fields) {
          final path = field['path'] as List<dynamic>?;
          final filter = field['filter'];
          if (path != null &&
              path.isNotEmpty &&
              path.first == r'$.vct' &&
              filter != null &&
              filter['const'] != null) {
            final vct = filter['const'];
            if (trustedEntity.vcTypes?.contains(vct) ?? false) {
              return true;
            }
          }
        }
      }
    }
  }
  // If no matching vcType is found, throw an exception.

  throw Exception(
      // ignore: lines_longer_than_80_chars
      'No matching vcType found in the presentation definition for the trusted entity',);
}
