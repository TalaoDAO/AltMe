import 'package:altme/dashboard/home/tab_bar/credentials/models/credential/credential.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';

const DID = 'did:key:test';

final CREDENTIAL_DATA = {
  'id': 'urn:uuid:test_credential_id',
  'type': ['VerifiableCredential'],
  'issuer': {'id': 'did:key:test_issuer'},
  'credentialSubject': {'id': DID, 'name': 'Test Subject'},
};

// create credential preview for testing
final CREDENTIAL_PREVIEW = Credential.dummy();

final TEST_CREDENTIAL = CredentialModel(
  id: 'test_credential_id',
  data: CREDENTIAL_DATA,
  credentialPreview: CREDENTIAL_PREVIEW,
  shareLink: '',
  image: '',
  selectiveDisclosureJwt: 'test_sd_jwt',
);
