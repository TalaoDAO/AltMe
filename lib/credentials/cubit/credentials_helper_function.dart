part of 'credentials_cubit.dart';

///helper function to generate Tezos/Ethereum AssociatedAddressCredential
Future<CredentialModel?> generateCryptoAccountOwnershipProof({
  required CryptoAccountData cryptoAccountData,
  required DIDKitProvider didKitProvider,
  required KeyGenerator keyGenerator,
  required String did,
  required CustomOidc4VcProfile customOidc4vcProfile,
  required OIDC4VC oidc4vc,
  required Map<String, dynamic> privateKey,
  required ProfileType profileType,
  required VCFormatType vcFormatType,
  String? oldId,
}) async {
  final log = getLogger(
    'CredentialsCubit - generateAssociatedWalletCredential',
  );
  final blockchainType = cryptoAccountData.blockchainType;
  log.i(blockchainType);
  try {
    final didMethod = getDidMethod(blockchainType);

    log.i('didMethod - $didMethod');

    final String jwkKey = await keyGenerator.jwkFromSecretKey(
      secretKey: cryptoAccountData.secretKey,
      accountType: blockchainType.accountType,
    );

    final String issuer = didKitProvider.keyToDID(didMethod, jwkKey);

    log.i('jwkKey - $jwkKey');
    log.i('didKitProvider.keyToDID - $issuer');

    late String verificationMethod;

    switch (blockchainType) {
      case BlockchainType.tezos:
        verificationMethod = '$issuer#blockchainAccountId';

      case BlockchainType.ethereum:
      case BlockchainType.fantom:
      case BlockchainType.polygon:
      case BlockchainType.binance:
      case BlockchainType.etherlink:
        //verificationMethod = '$issuer#Recovery2020';
        verificationMethod = await didKitProvider.keyToVerificationMethod(
          didMethod,
          jwkKey,
        );
    }

    log.i('verificationMethod - $verificationMethod');

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
            id: did,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'TezosAssociatedAddress',
          ),
        );

      case BlockchainType.ethereum:
        associatedAddressCredential = EthereumAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: EthereumAssociatedAddressModel(
            id: did,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'EthereumAssociatedAddress',
          ),
        );

      case BlockchainType.fantom:
        associatedAddressCredential = FantomAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: FantomAssociatedAddressModel(
            id: did,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'FantomAssociatedAddress',
          ),
        );

      case BlockchainType.polygon:
        associatedAddressCredential = PolygonAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: PolygonAssociatedAddressModel(
            id: did,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'PolygonAssociatedAddress',
          ),
        );

      case BlockchainType.binance:
        associatedAddressCredential = BinanceAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: BinanceAssociatedAddressModel(
            id: did,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'BinanceAssociatedAddress',
          ),
        );

      case BlockchainType.etherlink:
        associatedAddressCredential = EtherlinkAssociatedAddressCredential(
          id: id,
          issuer: issuer,
          issuanceDate: issuanceDate,
          credentialSubjectModel: EtherlinkAssociatedAddressModel(
            id: did,
            associatedAddress: cryptoAccountData.walletAddress,
            type: 'EtherlinkAssociatedAddress',
          ),
        );
    }

    log.i(jsonEncode(associatedAddressCredential.toJson()));
    late String vc;
    switch (vcFormatType) {
      case VCFormatType.vcSdJWT:
      case VCFormatType.dcSdJWT:
        final String jwkKey = await keyGenerator.jwkFromSecretKey(
          secretKey: cryptoAccountData.secretKey,
          accountType: blockchainType.accountType,
          alg: Alg.ES256K,
        );

        final cryptoAccountPrivateKey = jwkKey;

        const didMethod = AltMeStrings.defaultDIDMethod;
        final cryptoAccountDid = didKitProvider.keyToDID(
          didMethod,
          cryptoAccountPrivateKey,
        );
        final cryptoAccountKid = await didKitProvider.keyToVerificationMethod(
          didMethod,
          cryptoAccountPrivateKey,
        );

        final DateTime dateTime = DateTime.now();

        final iat = (dateTime.millisecondsSinceEpoch / 1000).round();
        const vct =
            'https://vc-registry.com/vct/registry/publish/2ab5fa6078eb308aedae7ee438c5bd1807bea3f8a77c014f69f4143da91f077e';
        const vctIntegrity =
            'sha256-1UrQWdTJDYXTB3pzikDEX6ocWm7HV5I8QqNPrw+HeWQ=';

        final publicJWKString = sortedPublicJwk(jsonEncode(privateKey));
        final publicJWK = jsonDecode(publicJWKString) as Map<String, dynamic>;

        final payload = {
          'iat': iat,
          'vct': vct,
          'vct#integrity': vctIntegrity,
          'blockchain_network': cryptoAccountData.blockchainType.name,
          'wallet_address': cryptoAccountData.walletAddress,
          'cnf': {
            'jwk': {...publicJWK},
          },
        };

        final cryptoAccountTokenParameters = TokenParameters(
          privateKey: jsonDecode(jwkKey) as Map<String, dynamic>,
          did: cryptoAccountDid,
          kid: cryptoAccountKid,
          mediaType: vcFormatType == VCFormatType.dcSdJWT
              ? MediaType.dcSdJWT
              : MediaType.vcSdJWT,
          clientType: customOidc4vcProfile.clientType,
          // Mismatch between the cnf of the crypto card and the wallet
          // identity identifier #3392
          // proofHeaderType: customOidc4vcProfile.proofHeader,
          proofHeaderType: ProofHeaderType.jwk,
          clientId: customOidc4vcProfile.clientId ?? '',
        );

        /// sign and get token
        final jwt =
            // ignore: lines_longer_than_80_chars
            '${generateToken(payload: payload, tokenParameters: cryptoAccountTokenParameters)}~';
        log.i('jwt - $jwt');
        final data = getCredentialDataFromJson(
          data: jwt,
          format: vcFormatType.vcValue,
          jwtDecode: JWTDecode(),
          credentialType:
              'https://vc-registry.com/vct/registry/publish/2ab5fa6078eb308aedae7ee438c5bd1807bea3f8a77c014f69f4143da91f077e',
        );

        final credential = CredentialModel(
          id: id,
          image: 'image',
          shareLink: '',
          jwt: jwt,
          format: vcFormatType.vcValue,
          activities: [Activity(acquisitionAt: dateTime)],
          profileLinkedId: profileType.getVCId,
          data: data,
          // Just metadata to get correct card and category
          credentialPreview: Credential.fromJson(
            associatedAddressCredential.toJson() as Map<String, dynamic>,
          ),
        );
        return credential;
      case VCFormatType.ldpVc:
        vc = await didKitProvider.issueCredential(
          jsonEncode(associatedAddressCredential.toJson()),
          jsonEncode(options),
          jwkKey,
        );
        log.i('didKitProvider.issueCredential - $vc');

        final result = await didKitProvider.verifyCredential(
          vc,
          jsonEncode(verifyOptions),
        );
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
          }
        }
        return _createCredential(
          vc: vc,
          oldId: oldId,
          credentialManifest: credentialManifest,
          customOidc4vcProfile: customOidc4vcProfile,
          oidc4vc: oidc4vc,
          privateKey: privateKey,
          kid: verificationMethod,
          did: did,
          profileType: profileType,
          vcFormatType: vcFormatType,
        );
      case VCFormatType.jwtVc:
        // TODO: Handle this case.
        throw UnimplementedError();
      case VCFormatType.jwtVcJson:
        // TODO: Handle this case.
        throw UnimplementedError();
      case VCFormatType.jwtVcJsonLd:
        // TODO: Handle this case.
        throw UnimplementedError();
      case VCFormatType.auto:
        // TODO: Handle this case.
        throw UnimplementedError();
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

Future<CredentialModel> _createCredential({
  required String vc,
  required CredentialManifest credentialManifest,
  required CustomOidc4VcProfile customOidc4vcProfile,
  required OIDC4VC oidc4vc,
  required Map<String, dynamic> privateKey,
  required String did,
  required String kid,
  required ProfileType profileType,
  required VCFormatType vcFormatType,
  String? oldId,
}) async {
  final jsonLd = jsonDecode(vc) as Map<String, dynamic>;

  String? jwt;
  DateTime dateTime = DateTime.now();

  if (vcFormatType == VCFormatType.dcSdJWT) {
    /// id -> jti (optional)
    /// issuer -> iss (compulsary)
    /// issuanceDate -> iat (optional)
    /// expirationDate -> exp (optional)

    try {
      dateTime = DateTime.parse(jsonLd['issuanceDate'].toString());
    } catch (e) {
      dateTime = DateTime.now();
    }

    final iat = (dateTime.millisecondsSinceEpoch / 1000).round();

    final jsonContent = <String, dynamic>{
      'iat': iat,
      'exp': iat + 1000,
      'iss': jsonLd['issuer'],
      'jti': jsonLd['id'] ?? 'urn:uuid:${const Uuid().v4()}',
      'sub': did,
      'vc': jsonLd,
    };

    final tokenParameters = TokenParameters(
      privateKey: privateKey,
      did: did,
      kid: kid,
      mediaType: MediaType.basic,
      clientType: customOidc4vcProfile.clientType,
      proofHeaderType: customOidc4vcProfile.proofHeader,
      clientId: customOidc4vcProfile.clientId ?? '',
    );

    /// sign and get token
    jwt = generateToken(payload: jsonContent, tokenParameters: tokenParameters);
  }

  final id = oldId ?? 'urn:uuid:${const Uuid().v4()}';
  return CredentialModel(
    id: id,
    image: 'image',
    data: jsonLd,
    shareLink: '',
    jwt: jwt,
    format: vcFormatType.vcValue,
    credentialPreview: Credential.fromJson(jsonLd),
    credentialManifest: credentialManifest,
    activities: [Activity(acquisitionAt: dateTime)],
    profileLinkedId: profileType.getVCId,
  );
}
