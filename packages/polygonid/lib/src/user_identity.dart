/// user identity with did and privatekey
class UserIdentity {
  ///
  UserIdentity({
    required this.did,
    required this.privateKey,
  });

  /// did
  String did;

  /// privateKey
  String privateKey;
}
