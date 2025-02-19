import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';

class LdpVc {
  const LdpVc(this.credentialModel);
  final CredentialModel credentialModel;

  String? get getPicture {
    final credentialSubject = credentialModel
        .credentialSupported?['credentialSubject'] as Map<String, dynamic>?;
// check if member of keyList is a key in credentialSubject. If that's the case check if value contains value_type with value in valueTypeList
    for (final key in Parameters.pictureOnCardKeyList) {
      final keyPresent = credentialSubject?.containsKey(key) ?? false;
      if (keyPresent) {
        final value = credentialSubject?[key];
        if (value is Map<String, dynamic>) {
          final valueType = value['value_type'];
          if (Parameters.pictureOnCardValueTypeList.contains(valueType)) {
            return credentialModel.data['credentialSubject'][key] as String?;
          }
        }
      }
    }

    return null;
  }
}
