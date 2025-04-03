import 'package:altme/app/app.dart';
import 'package:altme/app/shared/helper_functions/value_type_if_null.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:json_path/json_path.dart';

class LdpVc {
  const LdpVc(this.credentialModel);
  final CredentialModel credentialModel;

  String? get getPicture {
    final credentialSubject =
        (credentialModel.credentialSupported?['credentialSubject'] ??
            credentialModel.credentialSupported?['credential_definition']
                ['credentialSubject']) as Map<String, dynamic>?;

    if (credentialSubject == null) return null;

    // check if member of keyList is a key in credentialSubject.
    // If that's the case check if value contains value_type with value
    // in valueTypeList
    for (final key in Parameters.pictureOnCardKeyList) {
      // Use JsonPath to check if the key exists anywhere in the structure
      final jsonPath = JsonPath(r'$..' + key);
      final matches = jsonPath.read(credentialSubject);

      // keyPresent is true if the key is found at any level in the structure
      final keyPresent = matches.isNotEmpty;

      if (keyPresent) {
        final value = matches.first.value;
        if (value is Map<String, dynamic>) {
          final valueType = value['value_type'] ?? valueTypeIfNull(value);
          if (Parameters.pictureOnCardValueTypeList.contains(valueType)) {
            return credentialModel.data['credentialSubject'][key] as String?;
          }
        }
      }
    }

    return null;
  }
}
