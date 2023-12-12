part of 'credentials_cubit.dart';

///helper function to generate Tezos/Ethereum AssociatedAddressCredential
Future<CredentialModel?> generateAssociatedWalletCredential({
  required CryptoAccountData cryptoAccountData,
  required DIDKitProvider didKitProvider,
  required DIDCubit didCubit,
  String? oldId,
  required BlockchainType blockchainType,
  required KeyGenerator keyGenerator,
}) async {
  final log =
      getLogger('CredentialsCubit - generateAssociatedWalletCredential');
  log.i(blockchainType);
  try {
    late String didMethod;

    switch (blockchainType) {
      case BlockchainType.tezos:
        didMethod = AltMeStrings.cryptoTezosDIDMethod;

      case BlockchainType.ethereum:
      case BlockchainType.fantom:
      case BlockchainType.polygon:
      case BlockchainType.binance:
        didMethod = AltMeStrings.cryptoEVMDIDMethod;
    }

    final String jwkKey = await keyGenerator.jwkFromSecretKey(
      secretKey: cryptoAccountData.secretKey,
      accountType: blockchainType.accountType,
    );

    final issuer = didKitProvider.keyToDID(didMethod, jwkKey);
    log.i('didMethod - $didMethod');
    log.i('jwkKey - $jwkKey');
    log.i('didKitProvider.keyToDID - $issuer');

    //Issue: https://github.com/spruceid/didkit/issues/329
    // final verificationMethod =
    //     await didKitProvider.keyToVerificationMethod(didMethod, jwkKey);
    //log.i('didKitProvider.keyToVerificationMethod - $verificationMethod');

    late String verificationMethod;

    switch (blockchainType) {
      case BlockchainType.tezos:
        verificationMethod = '$issuer#blockchainAccountId';

      case BlockchainType.ethereum:
      case BlockchainType.fantom:
      case BlockchainType.polygon:
      case BlockchainType.binance:
        verificationMethod = '$issuer#Recovery2020';
    }
    log.i('hardcoded verificationMethod - $verificationMethod');

    final didSsi = didCubit.state.did!;

    final options = {
      'proofPurpose': 'assertionMethod',
      'verificationMethod': verificationMethod,
    };

    final verifyOptions = {'proofPurpose': 'assertionMethod'};
    final id = 'urn:uuid:${const Uuid().v4()}';
    final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    final issuanceDate = '${formatter.format(DateTime.now())}Z';

    late dynamic associatedAddressCredential;

    switch (blockchainType) {
      case BlockchainType.tezos:
        associatedAddressCredential = TezosAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: TezosAssociatedAddressModel(
            id: didSsi,
            accountName: cryptoAccountData.name,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'TezosAssociatedAddress',
            issuedBy: const Author('My wallet'),
          ),
        );

      case BlockchainType.ethereum:
        associatedAddressCredential = EthereumAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: EthereumAssociatedAddressModel(
            id: didSsi,
            accountName: cryptoAccountData.name,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'EthereumAssociatedAddress',
            issuedBy: const Author('My wallet'),
          ),
        );

      case BlockchainType.fantom:
        associatedAddressCredential = FantomAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: FantomAssociatedAddressModel(
            id: didSsi,
            accountName: cryptoAccountData.name,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'FantomAssociatedAddress',
            issuedBy: const Author('My wallet'),
          ),
        );

      case BlockchainType.polygon:
        associatedAddressCredential = PolygonAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: PolygonAssociatedAddressModel(
            id: didSsi,
            accountName: cryptoAccountData.name,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'PolygonAssociatedAddress',
            issuedBy: const Author('My wallet'),
          ),
        );

      case BlockchainType.binance:
        associatedAddressCredential = BinanceAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: BinanceAssociatedAddressModel(
            id: didSsi,
            accountName: cryptoAccountData.name,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'BinanceAssociatedAddress',
            issuedBy: const Author('My wallet'),
          ),
        );
    }

    log.i(jsonEncode(associatedAddressCredential.toJson()));
    final String vc = await didKitProvider.issueCredential(
      jsonEncode(associatedAddressCredential.toJson()),
      jsonEncode(options),
      jwkKey,
    );

    log.i('didKitProvider.issueCredential - $vc');

    final result =
        await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions));
    log.i('didKitProvider.verifyCredential - $result');
    final jsonVerification = jsonDecode(result) as Map<String, dynamic>;

    if ((jsonVerification['warnings'] as List<dynamic>).isNotEmpty) {
      log.w(
        'credential verification return warnings',
        error: jsonVerification['warnings'],
      );
    }

    final credentialManifest = blockchainType.credentialManifest;

    if ((jsonVerification['errors'] as List<dynamic>).isNotEmpty) {
      log.e('failed to verify credential, ${jsonVerification['errors']}');
      if (jsonVerification['errors'][0] != 'No applicable proof') {
        throw ResponseMessage(
          message: ResponseString
              .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL,
        );
      } else {
        return _createCredential(vc, oldId, credentialManifest);
      }
    } else {
      return _createCredential(vc, oldId, credentialManifest);
    }
  } catch (e, s) {
    log.e(
      'something went wrong e: $e, stackTrace: $s',
      error: e,
      stackTrace: s,
    );
    return null;
  }
}

Future<CredentialModel> _createCredential(
  String vc,
  String? oldId,
  CredentialManifest credentialManifest,
) async {
  final jsonCredential = jsonDecode(vc) as Map<String, dynamic>;
  final id = oldId ?? 'urn:uuid:${const Uuid().v4()}';
  return CredentialModel(
    id: id,
    image: 'image',
    data: jsonCredential,
    shareLink: '',
    credentialPreview: Credential.fromJson(jsonCredential),
    credentialManifest: credentialManifest,
    activities: [Activity(acquisitionAt: DateTime.now())],
  );
}
