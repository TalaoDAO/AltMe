import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';

/// The copies of batch issuances (OpenID4VCI 1.0 §12.2.4) in a list of
/// credentials. Copies of one batch share a [CredentialModel.batchId], are
/// shown as one credential and are presented one at a time.
extension CredentialBatches on List<CredentialModel> {
  /// The credentials with one copy per batch: the first copy of each batch
  /// stands for the others, in the place of that copy.
  List<CredentialModel> get onePerBatch {
    final seen = <String>{};
    return [
      for (final credential in this)
        if (credential.batchId == null || seen.add(credential.batchId!))
          credential,
    ];
  }

  /// Every copy of [credential]'s batch, [credential] included, or just
  /// [credential] when it was issued alone.
  List<CredentialModel> copiesOf(CredentialModel credential) {
    final batchId = credential.batchId;
    if (batchId == null) return [credential];
    return [
      for (final copy in this)
        if (copy.batchId == batchId) copy,
    ];
  }
}
