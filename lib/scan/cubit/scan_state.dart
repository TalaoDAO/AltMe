part of 'scan_cubit.dart';

class ScanState extends Equatable {
  const ScanState({
    this.status = ScanStatus.init,
    this.message,
    this.uri,
    this.keyId,
    this.challenge,
    this.domain,
    this.done,
    this.transactionData,
    this.blockchainTransactionsSignatures,
    this.localDocumentSignature,
    this.credentialPresentation,
    this.presentationIssuer,
    this.credentialsToBePresented,
  });

  final ScanStatus status;
  final StateMessage? message;
  final Uri? uri;
  final String? keyId;
  final String? challenge;
  final String? domain;
  final List<dynamic>? transactionData;
  final List<Uint8List>? blockchainTransactionsSignatures;
  final Map<String, dynamic>? localDocumentSignature;
  final CredentialModel? credentialPresentation;
  final Issuer? presentationIssuer;
  final List<CredentialModel>? credentialsToBePresented;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final dynamic Function(String)? done;

  ScanState loading() {
    return copyWith(
      status: ScanStatus.loading,
      uri: uri,
      keyId: keyId,
      challenge: challenge,
      domain: domain,
      done: done,
    );
  }

  ScanState scanPermission({
    required Uri uri,
    required String keyId,
    String? challenge,
    String? domain,
    required dynamic Function(String) done,
  }) {
    return copyWith(
      status: ScanStatus.askPermissionDidAuth,
      uri: uri,
      keyId: keyId,
      challenge: challenge,
      domain: domain,
      done: done,
    );
  }

  ScanState warning({required MessageHandler messageHandler}) {
    return copyWith(
      status: ScanStatus.warning,
      message: StateMessage.warning(messageHandler: messageHandler),
    );
  }

  ScanState error({required StateMessage message}) {
    return copyWith(status: ScanStatus.error, message: message);
  }

  ScanState copyWith({
    ScanStatus? status,
    StateMessage? message,
    Uri? uri,
    String? keyId,
    String? challenge,
    String? domain,
    dynamic Function(String)? done,
    List<dynamic>? transactionData,
    List<Uint8List>? blockchainTransactionsSignatures,
    Map<String, dynamic>? localDocumentSignature,
    CredentialModel? credentialPresentation,
    Issuer? presentationIssuer,
    List<CredentialModel>? credentialsToBePresented,
  }) {
    // when status is successfull we need to reset transactionData and
    // blockchainTransactionsSignatures to null if they are not provided
    var newTransactionData = transactionData ?? this.transactionData;
    var newBlockchainTransactionsSignatures =
        blockchainTransactionsSignatures ??
        this.blockchainTransactionsSignatures;
    var newLocalDocumentSignature =
        localDocumentSignature ?? this.localDocumentSignature;
    var newCredentialPresentation =
        credentialPresentation ?? this.credentialPresentation;
    var newPresentationIssuer = presentationIssuer ?? this.presentationIssuer;
    var newCredentialsToBePresented =
        credentialsToBePresented ?? this.credentialsToBePresented;

    if (status == ScanStatus.success || status == ScanStatus.error) {
      newTransactionData = null;
      newBlockchainTransactionsSignatures = null;
      newLocalDocumentSignature = null;
      newCredentialsToBePresented = null;
      newPresentationIssuer = null;
      newCredentialPresentation = null;
    }

    return ScanState(
      status: status ?? this.status,
      message: message ?? this.message,
      uri: uri ?? this.uri,
      keyId: keyId ?? this.keyId,
      challenge: challenge ?? this.challenge,
      domain: domain ?? this.domain,
      done: done ?? this.done,
      transactionData: newTransactionData,
      blockchainTransactionsSignatures: newBlockchainTransactionsSignatures,
      localDocumentSignature: newLocalDocumentSignature,
      credentialPresentation: newCredentialPresentation,
      presentationIssuer: newPresentationIssuer,
      credentialsToBePresented: newCredentialsToBePresented,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    uri,
    keyId,
    challenge,
    domain,
    done,
    transactionData,
    blockchainTransactionsSignatures,
    localDocumentSignature,
    credentialPresentation,
    presentationIssuer,
    credentialsToBePresented,
  ];
}
