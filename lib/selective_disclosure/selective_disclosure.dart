
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/dc_selective_disclosure.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/selective_disclosure/vc_selective_disclosure.dart';
import 'package:oidc4vc/oidc4vc.dart';

export 'helper_functions/selective_disclosure_display_map.dart';
export 'model/model.dart';



// --- SelectiveDisclosure delegator ---
class SelectiveDisclosure {

  SelectiveDisclosure(this.credentialModel) {
    final format = credentialModel.format.toString();
    if (format == VCFormatType.dcSdJWT.vcValue) {
      _delegate = DcSelectiveDisclosure(credentialModel);
    } else {
      _delegate = VcSelectiveDisclosure(credentialModel);
    }
  }
  late final VcSelectiveDisclosure _delegate;
  final CredentialModel credentialModel;

  Map<String, dynamic> get payload => _delegate.payload;
  Map<String, dynamic> get claims => _delegate.claims;
  Map<String, dynamic> get extractedValuesFromJwt =>
      _delegate.extractedValuesFromJwt;
  Map<String, dynamic> get extractedValuesFromJwtWithSd =>
      _delegate.extractedValuesFromJwtWithSd;
  List<String> get disclosureFromJWT => _delegate.disclosureFromJWT;
  Map<String, dynamic> get disclosureListToContent =>
      _delegate.disclosureListToContent;
  Map<String, dynamic> get sh256HashToContent => _delegate.sh256HashToContent;
  List<String> get contents => _delegate.contents;
  String? get getPicture => _delegate.getPicture;
  (List<ClaimsData>, String?) getClaimsData(
          {required String key, required String? parentKeyId}) =>
      _delegate.getClaimsData(key: key, parentKeyId: parentKeyId);
  String disclosureToContent(String element) =>
      _delegate.disclosureToContent(element);
  Map<String, dynamic> replaceSdValues(Map<String, dynamic> extractedValues) =>
      _delegate.replaceSdValues(extractedValues);
  Map<String, dynamic> getMapFromList(List<dynamic> lisString) =>
      _delegate.getMapFromList(lisString);
  String? sdForNested({required String searchedKey, String? parentKeyId}) =>
      _delegate.sdForNested(searchedKey: searchedKey, parentKeyId: parentKeyId);
  String? gestSdFromDigestList(
          String key, String parentKeyId, dynamic value, String searchedKey) =>
      _delegate.gestSdFromDigestList(key, parentKeyId, value, searchedKey);
  Map<String, dynamic> contentOfSh256Hash(String element) =>
      _delegate.contentOfSh256Hash(element);
}
