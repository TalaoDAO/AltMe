import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:asn1lib/asn1lib.dart' as asn1lib;
import 'package:convert/convert.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:dartez/dartez.dart';
import 'package:dio/dio.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:jose_plus/jose.dart';
import 'package:json_path/json_path.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:key_generator/key_generator.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:x509/x509.dart' as x509;
import 'package:x509/x509.dart';

export 'is_connected_to_internet.dart';
export 'test_platform.dart';

String generateDefaultAccountName(
  int accountIndex,
  List<String> accountNameList,
) {
  final defaultAccountName = 'My account ${accountIndex + 1}';
  final containSameName = accountNameList.contains(defaultAccountName);
  if (containSameName) {
    return generateDefaultAccountName(accountIndex + 1, accountNameList);
  } else {
    return defaultAccountName;
  }
}

String getIssuerDid({required Uri uriToCheck}) {
  String did = '';
  uriToCheck.queryParameters.forEach((key, value) {
    if (key == 'issuer') {
      did = value;
    }
  });
  return did;
}

bool isValidPrivateKey(String value) {
  bool isEthereumPrivateKey = false;
  if (RegExp(r'^(0x)?[0-9a-f]{64}$', caseSensitive: false).hasMatch(value)) {
    isEthereumPrivateKey = true;
  }

  return value.startsWith('edsk') ||
      value.startsWith('spsk') ||
      value.startsWith('p2sk') ||
      value.startsWith('0x') ||
      isEthereumPrivateKey;
}

KeyStoreModel getKeysFromSecretKey({required String secretKey}) {
  final List<String> sourceKeystore = Dartez.getKeysFromSecretKey(secretKey);

  return KeyStoreModel(
    secretKey: sourceKeystore[0],
    publicKey: sourceKeystore[1],
    publicKeyHash: sourceKeystore[2],
  );
}

String stringToHexPrefixedWith05({
  required String payload,
  DateTime? dateTime,
}) {
  dateTime ??= DateTime.now();
  final String formattedInput = <String>[
    'Tezos Signed Message:',
    'altme.io',
    dateTime.toString(),
    payload,
  ].join(' ');

  final String bytes = formattedInput.char2Bytes;

  const String prefix = '05';
  const String stringIsHex = '0100';
  final String bytesOfByteLength = bytes.length.toString().char2Bytes;

  final payloadBytes = '$prefix$stringIsHex$bytesOfByteLength$bytes';

  return payloadBytes;
}

String getCredentialName(String constraints) {
  final dynamic constraintsJson = jsonDecode(constraints);
  final fieldsPath = JsonPath(r'$..fields');
  final dynamic credentialField =
      (fieldsPath.read(constraintsJson).first.value! as List)
          .where(
            (dynamic e) =>
                e['path'].toString() == r'[$.credentialSubject.type]',
          )
          .toList()
          .first;
  return credentialField['filter']['pattern'] as String;
}

String getIssuersName(String constraints) {
  final dynamic constraintsJson = jsonDecode(constraints);
  final fieldsPath = JsonPath(r'$..fields');
  final dynamic issuerField =
      (fieldsPath.read(constraintsJson).first.value! as List)
          .where(
            (dynamic e) => e['path'].toString() == r'[$.issuer]',
          )
          .toList()
          .first;
  return issuerField['filter']['pattern'] as String;
}

BlockchainType getBlockchainType(AccountType accountType) {
  switch (accountType) {
    case AccountType.ssi:
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Invalid request.',
        },
      );
    case AccountType.tezos:
      return BlockchainType.tezos;
    case AccountType.ethereum:
      return BlockchainType.ethereum;
    case AccountType.fantom:
      return BlockchainType.fantom;
    case AccountType.polygon:
      return BlockchainType.polygon;
    case AccountType.binance:
      return BlockchainType.binance;
    case AccountType.etherlink:
      return BlockchainType.etherlink;
  }
}

CredentialSubjectType? getCredTypeFromName(String credentialName) {
  for (final element in CredentialSubjectType.values) {
    if (credentialName == element.name) {
      return element;
    }
  }
  return null;
}

Future<bool> isCredentialPresentable({
  required CredentialSubjectType? credentialSubjectType,
  required List<VCFormatType> formatsSupported,
}) async {
  if (credentialSubjectType == null) {
    return true;
  }

  final isPresentable = await isCredentialAvaialble(
    credentialSubjectType: credentialSubjectType,
    formatsSupported: formatsSupported,
  );

  return isPresentable;
}

Future<bool> isCredentialAvaialble({
  required CredentialSubjectType credentialSubjectType,
  required List<VCFormatType> formatsSupported,
}) async {
  /// fetching all the credentials
  final CredentialsRepository repository =
      CredentialsRepository(getSecureStorage);

  final List<CredentialModel> allCredentials = await repository.findAll();

  for (final credential in allCredentials) {
    final matchSubjectType = credentialSubjectType ==
        credential
            .credentialPreview.credentialSubjectModel.credentialSubjectType;
    final formatsSupportedStrings =
        formatsSupported.map((e) => e.vcValue).toList();
    final matchFormat =
        formatsSupportedStrings.contains(credential.getFormat) ||
            credential.getFormat == 'auto';
    if (matchSubjectType && matchFormat) {
      return true;
    }
  }

  return false;
}

String timeFormatter({required int timeInSecond}) {
  final int sec = timeInSecond % 60;
  final int min = (timeInSecond / 60).floor();
  final String minute = min.toString().length <= 1 ? '0$min' : '$min';
  final String second = sec.toString().length <= 1 ? '0$sec' : '$sec';
  return '$minute : $second';
}

Future<List<String>> getssiMnemonicsInList(
  SecureStorageProvider secureStorageProvider,
) async {
  final phrase = await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);
  return phrase!.split(' ');
}

Future<bool> getStoragePermission() async {
  if (isAndroid) {
    return true;
  }
  if (await Permission.storage.request().isGranted) {
    return true;
  } else if (await Permission.storage.request().isPermanentlyDenied) {
    await openAppSettings();
  } else if (await Permission.storage.request().isDenied) {
    return false;
  }
  return false;
}

String getDateTimeWithoutSpace({DateTime? dateTime}) {
  dateTime ??= DateTime.now();

  final dateTimeString = DateTime.fromMicrosecondsSinceEpoch(
    dateTime.microsecondsSinceEpoch,
  ).toString().replaceAll(' ', '-');
  return dateTimeString;
}

int getIndexValue({
  required bool isEBSI,
  required DidKeyType didKeyType,
}) {
  switch (didKeyType) {
    case DidKeyType.secp256k1:
      if (isEBSI) {
        return 3;
      } else {
        return 1;
      }
    case DidKeyType.p256:
      return 4;
    case DidKeyType.ebsiv3:
      return 5;
    case DidKeyType.jwkP256:
      return 6;
    case DidKeyType.ebsiv4:
      return 7;
    case DidKeyType.edDSA:
    case DidKeyType.jwtClientAttestation:
      return 0; // it is not needed, just assigned
  }
}

Future<String> getPrivateKey({
  required ProfileCubit profileCubit,
  required DidKeyType didKeyType,
}) async {
  final customOidc4vcProfile = profileCubit.state.model.profileSetting
      .selfSovereignIdentityOptions.customOidc4vcProfile;

  if (customOidc4vcProfile.clientType == ClientType.p256JWKThumprint) {
    final privateKey =
        await getP256KeyToGetAndPresentVC(profileCubit.secureStorageProvider);

    return privateKey;
  }

  final mnemonic = await profileCubit.secureStorageProvider
      .get(SecureStorageKeys.ssiMnemonic);

  switch (didKeyType) {
    case DidKeyType.edDSA:
      final ssiKey = await profileCubit.secureStorageProvider
          .get(SecureStorageKeys.ssiKey);
      return ssiKey.toString();

    case DidKeyType.secp256k1:
      final index = getIndexValue(
        isEBSI: true,
        didKeyType: didKeyType,
      );
      final key = privateKeyFromMnemonic(
        mnemonic: mnemonic!,
        indexValue: index,
      );
      return key;

    case DidKeyType.p256:
    case DidKeyType.ebsiv3:
    case DidKeyType.ebsiv4:
    case DidKeyType.jwkP256:
      final indexValue = getIndexValue(
        isEBSI: false,
        didKeyType: didKeyType,
      );

      final key = p256PrivateKeyFromMnemonics(
        mnemonic: mnemonic!,
        indexValue: indexValue,
      );

      return key;

    case DidKeyType.jwtClientAttestation:
      if (profileCubit.state.model.walletType != WalletType.enterprise) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'Please switch to enterprise account',
          },
        );
      }

      final walletAttestationData = await profileCubit.secureStorageProvider
          .get(SecureStorageKeys.walletAttestationData);

      if (walletAttestationData == null) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The wallet attestation data has some issue.',
          },
        );
      }

      final p256KeyForWallet =
          await getP256KeyToGetAndPresentVC(profileCubit.secureStorageProvider);

      return p256KeyForWallet;
  }
}

Future<String> getWalletAttestationP256Key(
  SecureStorageProvider secureStorage,
) async {
  const storageKey = SecureStorageKeys.p256PrivateKeyForWallet;

  /// return key if it is already created
  final String? p256PrivateKey = await secureStorage.get(storageKey);
  if (p256PrivateKey != null) return p256PrivateKey.replaceAll('=', '');

  /// create key if it is not created
  final newKey = generateRandomP256Key();

  await secureStorage.set(storageKey, newKey);

  return newKey;
}

Future<String> getP256KeyToGetAndPresentVC(
  SecureStorageProvider secureStorage,
) async {
  const storageKey = SecureStorageKeys.p256PrivateKeyToGetAndPresentVC;

  /// return key if it is already created
  final String? p256PrivateKey = await secureStorage.get(storageKey);
  if (p256PrivateKey != null) return p256PrivateKey.replaceAll('=', '');

  /// create key if it is not created
  final newKey = generateRandomP256Key();

  await secureStorage.set(storageKey, newKey);

  return newKey;
}

String generateRandomP256Key() {
  /// create key if it is not created
  final jwk = JsonWebKey.generate('ES256');

  final json = jwk.toJson();

  // Sort the keys in ascending order and remove alg
  final sortedJwk = Map.fromEntries(
    json.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
  )..remove('keyOperations');

  final newKey = jsonEncode(sortedJwk).replaceAll('=', '');

  return newKey;
}

DidKeyType? getDidKeyFromString(String? didKeyTypeString) {
  if (didKeyTypeString == null) return null;
  for (final name in DidKeyType.values) {
    if (name.toString() == didKeyTypeString) {
      return name;
    }
  }
  return null;
}

Future<String> fetchPrivateKey({
  required ProfileCubit profileCubit,
  required DidKeyType didKeyType,
  bool? isEBSI,
}) async {
  if (isEBSI != null && isEBSI) {
    final privateKey = await getPrivateKey(
      profileCubit: profileCubit,
      didKeyType: DidKeyType.ebsiv3,
    );

    return privateKey;
  }

  final privateKey = await getPrivateKey(
    profileCubit: profileCubit,
    didKeyType: didKeyType,
  );

  return privateKey;
}

Map<String, dynamic> decodePayload({
  required JWTDecode jwtDecode,
  required String token,
}) {
  final log = getLogger('QRCodeScanCubit - jwtDecode');
  late final Map<String, dynamic> data;

  try {
    final payload = jwtDecode.parseJwt(token);
    data = payload;
  } catch (e, s) {
    log.e('An error occurred while decoding.', error: e, stackTrace: s);
  }
  return data;
}

Map<String, dynamic> decodeHeader({
  required JWTDecode jwtDecode,
  required String token,
}) {
  final log = getLogger('QRCodeScanCubit - jwtDecode');
  late final Map<String, dynamic> data;

  try {
    final header = jwtDecode.parseJwtHeader(token);
    data = header;
  } catch (e, s) {
    log.e('An error occurred while decoding.', error: e, stackTrace: s);
  }
  return data;
}

String birthDateFormater(int birthData) {
  final String birthdate = birthData.toString();

  // Parse the input string
  final DateTime parsedBirthdate = DateTime.parse(
    '${birthdate.substring(0, 4)}-${birthdate.substring(4, 6)}-${birthdate.substring(6, 8)}', // ignore: lines_longer_than_80_chars
  );

  // Format the parsed date
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formattedBirthdate = formatter.format(parsedBirthdate);

  return formattedBirthdate;
}

String chatTimeFormatter(int birthData) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(birthData);
  final formattedDate = DateFormat('dd.MM.yyyy').format(dateTime);
  return formattedDate;
}

String getSignatureType(String circuitId) {
  if (circuitId == 'credentialAtomicQuerySigV2' ||
      circuitId == 'credentialAtomicQuerySigV2OnChain') {
    return 'BJJ Signature';
  } else if (circuitId == 'credentialAtomicQueryMTPV2' ||
      circuitId == 'credentialAtomicQueryMTPV2OnChain') {
    return 'SMT Signature';
  }

  return '';
}

String splitUppercase(String input) {
  final regex = RegExp('(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])');
  return input.split(regex).join(' ');
}

List<String> generateUriList(String url) {
  final uri = Uri.parse(url);

  final finalList = <String>[];

  final uriList = uri.queryParametersAll['uri_list'];
  if (uriList != null) {
    for (final uriString in uriList) {
      final Uri uriItem = Uri.parse(Uri.decodeComponent(uriString));
      finalList.add(uriItem.toString());
    }
  }

  return uriList ?? [];
}

String getUtf8Message(String maybeHex) {
  if (maybeHex.startsWith('0x')) {
    final List<int> decoded = hex.decode(
      maybeHex.substring(2),
    );
    return utf8.decode(decoded);
  }

  return maybeHex;
}

Future<(String, String)> getDidAndKid({
  required String privateKey,
  required ProfileCubit profileCubit,
  required DidKeyType didKeyType,
}) async {
  late String did;
  late String kid;

  switch (didKeyType) {
    case DidKeyType.ebsiv3:
    case DidKeyType.ebsiv4:

      //b'\xd1\xd6\x03' in python
      final List<int> prefixByteList = [0xd1, 0xd6, 0x03];
      final List<int> prefix = prefixByteList.map((byte) => byte).toList();

      final encodedData = utf8.encode(sortedPublcJwk(privateKey));
      final encodedAddress = Base58Encode([...prefix, ...encodedData]);

      did = 'did:key:z$encodedAddress';
      final String lastPart = did.split(':')[2];
      kid = '$did#$lastPart';
    case DidKeyType.jwkP256:
      final encodedData = utf8.encode(sortedPublcJwk(privateKey));

      final base64EncodedJWK = base64UrlEncode(encodedData).replaceAll('=', '');
      did = 'did:jwk:$base64EncodedJWK';

      kid = '$did#0';
    case DidKeyType.p256:
    case DidKeyType.secp256k1:
    case DidKeyType.edDSA:
      const didMethod = AltMeStrings.defaultDIDMethod;
      did = profileCubit.didKitProvider.keyToDID(didMethod, privateKey);
      kid = await profileCubit.didKitProvider
          .keyToVerificationMethod(didMethod, privateKey);
    case DidKeyType.jwtClientAttestation:
      if (profileCubit.state.model.walletType != WalletType.enterprise) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'Please switch to enterprise account',
          },
        );
      }

      final walletAttestationData = await profileCubit.secureStorageProvider
          .get(SecureStorageKeys.walletAttestationData);

      if (walletAttestationData == null) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The wallet attestation data has some issue.',
          },
        );
      }

      final walletAttestationDataPayload =
          profileCubit.jwtDecode.parseJwt(walletAttestationData);

      did = walletAttestationDataPayload['cnf']['jwk']['kid'].toString();
      kid = did;
  }

  return (did, kid);
}

Future<(String, String)> fetchDidAndKid({
  required String privateKey,
  bool? isEBSI,
  required ProfileCubit profileCubit,
  required DidKeyType didKeyType,
}) async {
  if (isEBSI != null && isEBSI) {
    final (did, kid) = await getDidAndKid(
      didKeyType: DidKeyType.ebsiv3,
      privateKey: privateKey,
      profileCubit: profileCubit,
    );

    return (did, kid);
  }

  final (did, kid) = await getDidAndKid(
    didKeyType: didKeyType,
    privateKey: privateKey,
    profileCubit: profileCubit,
  );

  return (did, kid);
}

String sortedPublcJwk(String privateKey) {
  final private = jsonDecode(privateKey) as Map<String, dynamic>;
  final publicJWK = Map.of(private)..removeWhere((key, value) => key == 'd');

  /// we use crv P-256K in the rest of the package to ensure compatibility
  /// with jose dart package. In fact our crv is secp256k1 wich change the
  /// fingerprint

  final sortedJwk = Map.fromEntries(
    publicJWK.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
  )
    ..removeWhere((key, value) => key == 'use')
    ..removeWhere((key, value) => key == 'alg');

  /// this test is to be crv agnostic and respect https://www.rfc-editor.org/rfc/rfc7638
  if (sortedJwk['crv'] == 'P-256K') {
    sortedJwk['crv'] = 'secp256k1';
  }

  final jsonString = jsonEncode(sortedJwk).replaceAll(' ', '');
  return jsonString;
}

String sortedPrivateJwk(String privateKey) {
  final private = jsonDecode(privateKey) as Map<String, dynamic>;

  /// we use crv P-256K in the rest of the package to ensure compatibility
  /// with jose dart package. In fact our crv is secp256k1 wich change the
  /// fingerprint

  final sortedJwk = Map.fromEntries(
    private.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
  )
    ..removeWhere((key, value) => key == 'use')
    ..removeWhere((key, value) => key == 'alg');

  /// this test is to be crv agnostic and respect https://www.rfc-editor.org/rfc/rfc7638
  if (sortedJwk['crv'] == 'P-256K') {
    sortedJwk['crv'] = 'secp256k1';
  }

  final jsonString = jsonEncode(sortedJwk).replaceAll(' ', '');
  return jsonString;
}

bool isPolygonIdUrl(String url) =>
    url.startsWith('{"id":') ||
    url.startsWith('{"body":{"') ||
    url.startsWith('{"from": "did:polygonid:') ||
    url.startsWith('{"to": "did:polygonid:') ||
    url.startsWith('{"thid":') ||
    url.startsWith('{"typ":') ||
    url.startsWith('{"type":');

bool isOIDC4VCIUrl(Uri uri) {
  return uri.toString().startsWith('openid') ||
      uri.toString().startsWith('haip') ||
      uri.toString().startsWith(Parameters.walletOfferDeepLink);
}

bool isSIOPV2OROIDC4VPUrl(Uri uri) {
  final isOpenIdUrl = uri.toString().startsWith('openid://?') ||
      uri.toString().startsWith('openid-vc://?') ||
      uri.toString().startsWith(Parameters.walletPresentationDeepLink) ||
      uri.toString().startsWith('openid-hedera://?') ||
      uri.toString().startsWith('haip://?') &&
          (uri.queryParameters['request_uri'] != null ||
              uri.queryParameters['request'] != null);

  final isSiopv2Url = uri.toString().startsWith('siopv2://?');
  final isAuthorizeEndPoint =
      uri.toString().startsWith(Parameters.authorizeEndPoint) ||
          uri.toString().startsWith('haip://authorize?');

  return isOpenIdUrl || isAuthorizeEndPoint || isSiopv2Url;
}

Future<void> handleErrorForOID4VCI({
  required Oidc4vcParameters oidc4vcParameters,
}) async {
  List<dynamic>? subjectSyntaxTypesSupported =
      oidc4vcParameters.issuerOpenIdConfiguration.subjectSyntaxTypesSupported;

  if (oidc4vcParameters
          .authorizationServerOpenIdConfiguration.subjectSyntaxTypesSupported !=
      null) {
    subjectSyntaxTypesSupported = oidc4vcParameters
        .authorizationServerOpenIdConfiguration.subjectSyntaxTypesSupported;
  }

  if (oidc4vcParameters.tokenEndpoint == '') {
    throw ResponseMessage(
      data: {
        'error': 'invalid_issuer_metadata',
        'error_description': 'The token_endpoint is missing.',
      },
    );
  }

  if (oidc4vcParameters.issuerOpenIdConfiguration.credentialEndpoint == null) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_issuer_metadata',
        'error_description': 'The issuer configuration is invalid. '
            'The credential_endpoint is missing.',
      },
    );
  }

  if (oidc4vcParameters.issuerOpenIdConfiguration.credentialIssuer == null) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_issuer_metadata',
        'error_description': 'The issuer configuration is invalid. '
            'The credential_issuer is missing.',
      },
    );
  }

  if (oidc4vcParameters.issuerOpenIdConfiguration.credentialsSupported ==
          null &&
      oidc4vcParameters
              .issuerOpenIdConfiguration.credentialConfigurationsSupported ==
          null) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_issuer_metadata',
        'error_description': 'The issuer configuration is invalid. '
            'The credentials_supported is missing.',
      },
    );
  }

  if (subjectSyntaxTypesSupported != null &&
      !subjectSyntaxTypesSupported.contains('did:key')) {
    throw ResponseMessage(
      data: {
        'error': 'subject_syntax_type_not_supported',
        'error_description': 'The subject syntax type is not supported.',
      },
    );
  }
}

Future<Map<String, dynamic>?> getPresentationDefinition({
  required Uri uri,
  required DioClient client,
}) async {
  try {
    final keys = <String>[];
    uri.queryParameters.forEach((key, value) => keys.add(key));

    if (keys.contains('presentation_definition')) {
      final String presentationDefinitionValue =
          uri.queryParameters['presentation_definition'] ?? '';

      final json = jsonDecode(presentationDefinitionValue.replaceAll("'", '"'))
          as Map<String, dynamic>;

      return json;
    } else if (keys.contains('presentation_definition_uri')) {
      final presentationDefinitionUri =
          uri.queryParameters['presentation_definition_uri'].toString();
      final dynamic response = await client.get(presentationDefinitionUri);

      final Map<String, dynamic> data = response == String
          ? jsonDecode(response.toString()) as Map<String, dynamic>
          : response as Map<String, dynamic>;

      return data;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<Map<String, dynamic>?> getClientMetada({
  required Uri uri,
  required DioClient client,
}) async {
  try {
    final keys = <String>[];
    uri.queryParameters.forEach((key, value) => keys.add(key));

    if (keys.contains('client_metadata')) {
      final String clientMetaDataValue =
          uri.queryParameters['client_metadata'] ?? '';

      final json = jsonDecode(clientMetaDataValue.replaceAll("'", '"'))
          as Map<String, dynamic>;

      return json;
    } else if (keys.contains('client_metadata_uri')) {
      final clientMetaDataUri =
          uri.queryParameters['client_metadata_uri'].toString();
      final dynamic response = await client.get(clientMetaDataUri);

      final Map<String, dynamic> data = response == String
          ? jsonDecode(response.toString()) as Map<String, dynamic>
          : response as Map<String, dynamic>;

      return data;
    } else {
      return null;
    }
  } catch (e) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_request',
        'error_description': 'Client metaData is invalid',
      },
    );
  }
}

Future<bool?> isEBSIForVerifiers({
  required Uri uri,
  required OIDC4VC oidc4vc,
  required OIDC4VCIDraftType oidc4vciDraftType,
}) async {
  try {
    final String? clientId = uri.queryParameters['client_id'];

    if (clientId == null) return false;

    final isUrl = isURL(clientId);
    if (!isUrl) return false;

    final openIdConfiguration = await oidc4vc.getIssuerMetaData(
      baseUrl: clientId,
      dio: Dio(),
    );

    final subjectTrustFrameworksSupported =
        openIdConfiguration.subjectTrustFrameworksSupported;

    /// if subject_trust_frameworks_supported is not present => non-ebsi
    if (subjectTrustFrameworksSupported == null) {
      return false;
    }

    /// if subject_trust_frameworks_supported is empty => non-ebsi
    if (subjectTrustFrameworksSupported.isEmpty) {
      return false;
    }

    final profileType = subjectTrustFrameworksSupported[0].toString();

    if (profileType == 'ebsi') {
      /// if ebsi is available => ebsi
      return true;
    } else {
      /// if ebsi is not-available => non-ebsi
      return false;
    }
  } catch (e) {
    return null;
  }
}

String getCredentialData(dynamic credential) {
  late String cred;

  if (credential is String) {
    cred = credential;
  } else if (credential is Map<String, dynamic>) {
    final credentialSupported = (credential['types'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    cred = credentialSupported.last;
  } else {
    throw ResponseMessage(
      data: {
        'error': 'invalid_request',
        'error_description':
            'The format of credentail should be either String or Map.',
      },
    );
  }

  return cred;
}

Future<String> getHost({
  required Uri uri,
  required DioClient client,
}) async {
  final keys = <String>[];
  uri.queryParameters.forEach((key, value) => keys.add(key));

  if (keys.contains('issuer')) {
    /// issuance case 1
    return Uri.parse(
      uri.queryParameters['issuer'].toString(),
    ).host;
  } else if (keys.contains('credential_offer') ||
      keys.contains('credential_offer_uri')) {
    ///  issuance case 2
    final dynamic credentialOfferJson = await getCredentialOffer(
      scannedResponse: uri.toString(),
      dioClient: client,
    );
    if (credentialOfferJson == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'The credential offer is required.',
        },
      );
    }

    return Uri.parse(
      credentialOfferJson['credential_issuer'].toString(),
    ).host;
  } else {
    /// verification case

    final clientId = getClientIdForPresentation(
      uri.queryParameters['client_id'],
    );

    if (clientId != null) {
      return clientId;
    }

    final String? requestUri = uri.queryParameters['request_uri'];

    /// check if request uri is provided or not
    if (requestUri != null) {
      final dynamic response = await client.get(requestUri);
      final Map<String, dynamic> decodedResponse = decodePayload(
        jwtDecode: JWTDecode(),
        token: response as String,
      );

      final redirectUri = decodedResponse['redirect_uri'];
      final responseUri = decodedResponse['response_uri'];

      if (redirectUri != null) {
        return Uri.parse(redirectUri.toString()).host;
      } else if (responseUri != null) {
        return Uri.parse(responseUri.toString()).host;
      }

      return '';
    } else {
      return '';
    }
  }
}

bool isURL(String input) {
  final bool uri = Uri.tryParse(input)?.hasAbsolutePath ?? false;
  return uri;
}

MessageHandler getMessageHandler(dynamic e) {
  if (e is MessageHandler) {
    return e;
  } else if (e is DioException) {
    final error = NetworkException.getDioException(error: e);

    return NetworkException(data: error.data);
  } else if (e is FormatException) {
    return ResponseMessage(
      data: {
        'error': 'unsupported_format',
        'error_description': '${e.message}\n\n${e.source}',
      },
    );
  } else if (e is TypeError) {
    return ResponseMessage(
      data: {
        'error': 'unsupported_format',
        'error_description': 'Some issue in the response from the server.',
      },
    );
  } else {
    final stringException = e.toString().replaceAll('Exception: ', '');
    if (stringException.contains('CREDENTIAL_SUPPORT_DATA_ERROR')) {
      return ResponseMessage(
        data: {
          'error': 'unsupported_credential_format',
          'error_description': 'The credential support format has some issues.',
        },
      );
    } else if (stringException.contains('AUTHORIZATION_DETAIL_ERROR')) {
      return ResponseMessage(
        data: {
          'error': 'unsupported_format',
          'error_description': 'Invalid token response format.',
        },
      );
    } else if (stringException.contains('INVALID_TOKEN')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'Failed to extract header from jwt.',
        },
      );
    } else if (stringException.contains('INVALID_PAYLOAD')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'Failed to extract payload from jwt.',
        },
      );
    } else if (stringException.contains('SSI_ISSUE')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'SSI does not support this process.',
        },
      );
    } else if (stringException
        .contains('AUTHORIZATION_SERVER_METADATA_ISSUE')) {
      return ResponseMessage(
        data: {
          'error': 'unsupported_format',
          'error_description': 'Authorization server metadata response issue.',
        },
      );
    } else if (stringException.contains('ISSUER_METADATA_ISSUE')) {
      return ResponseMessage(
        data: {
          'error': 'unsupported_format',
          'error_description': 'Issuer metadata response issue.',
        },
      );
    } else if (stringException.contains('NOT_A_VALID_OPENID_URL')) {
      return ResponseMessage(
        data: {
          'error': 'unsupported_format',
          'error_description': 'Not a valid openid url to initiate issuance.',
        },
      );
    } else if (stringException.contains('JWKS_URI_IS_NULL')) {
      return ResponseMessage(
        data: {
          'error': 'unsupported_format',
          'error_description': 'The jwks_uri is null.',
        },
      );
    } else if (stringException.contains('Issue while getting')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': stringException,
        },
      );
    } else if (stringException.contains('SECURE_STORAGE_ISSUE')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Secure Storage issue with this device',
        },
      );
    } else if (stringException.contains('ISSUE_WHILE_ADDING_IDENTITY')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Issue while adding identity.',
        },
      );
    } else if (stringException.contains('ISSUE_WHILE_GETTING_CLAIMS')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Issue while getting claims.',
        },
      );
    } else if (stringException.contains('ISSUE_WHILE_RESTORING_CLAIMS')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Issue while restoring claims.',
        },
      );
    } else if (stringException.contains('PUBLICKEYJWK_EXTRACTION_ERROR')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Issue while restoring claims.',
        },
      );
    } else if (stringException.contains('KID_DOES_NOT_MATCH_DIDDOCUMENT')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Kid does not match the did document.',
        },
      );
    } else if (stringException.contains('C_NONCE_NOT_AVAILABLE')) {
      return ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'c_nonce is not avaiable.',
        },
      );
    } else {
      return ResponseMessage(
        message:
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
      );
    }
  }
}

ResponseString getErrorResponseString(String errorString) {
  switch (errorString) {
    case 'invalid_request':
    case 'invalid_request_uri':
    case 'invalid_request_object':
      return ResponseString.RESPONSE_STRING_invalidRequest;

    case 'unauthorized_client':
    case 'access_denied':
    case 'invalid_or_missing_proof':
    case 'interaction_required':
      return ResponseString.RESPONSE_STRING_accessDenied;

    case 'unsupported_response_type':
    case 'invalid_scope':
    case 'request_not_supported':
    case 'request_uri_not_supported':
      return ResponseString.RESPONSE_STRING_thisRequestIsNotSupported;

    case 'unsupported_credential_type':
      return ResponseString.RESPONSE_STRING_unsupportedCredential;
    case 'login_required':
    case 'account_selection_required':
      return ResponseString.RESPONSE_STRING_aloginIsRequired;

    case 'consent_required':
      return ResponseString.RESPONSE_STRING_userConsentIsRequired;

    case 'registration_not_supported':
      return ResponseString.RESPONSE_STRING_theWalletIsNotRegistered;

    case 'invalid_grant':
      return ResponseString.RESPONSE_STRING_invalidCode;
    case 'invalid_token':
      return ResponseString.RESPONSE_STRING_credentialIssuanceDenied;

    case 'issuance_pending':
      return ResponseString.RESPONSE_STRING_credentialIssuanceIsStillPending;

    case 'unsupported_credential_format':
      return ResponseString.RESPONSE_STRING_thisCredentialFormatIsNotSupported;

    case 'unsupported_format':
      return ResponseString.RESPONSE_STRING_thisFormatIsNotSupported;

    case 'invalid_issuer_metadata':
      return ResponseString.RESPONSE_STRING_theCredentialOfferIsInvalid;

    case 'server_error':
      return ResponseString.RESPONSE_STRING_theServiceIsNotAvailable;

    case 'invalid_client':
      return ResponseString.RESPONSE_STRING_invalidClientErrorDescription;

    case 'vp_formats_not_supported':
      return ResponseString
          .RESPONSE_STRING_vpFormatsNotSupportedErrorDescription;

    case 'invalid_presentation_definition_uri':
      return ResponseString
          .RESPONSE_STRING_invalidPresentationDefinitionUriErrorDescription;

    default:
      return ResponseString.RESPONSE_STRING_thisRequestIsNotSupported;
  }
}

bool isIDTokenOnly(String responseType) {
  return responseType.contains('id_token') &&
      !responseType.contains('vp_token');
}

bool isVPTokenOnly(String responseType) {
  return responseType.contains('vp_token') &&
      !responseType.contains('id_token');
}

bool isIDTokenAndVPToken(String responseType) {
  return responseType.contains('id_token') && responseType.contains('vp_token');
}

bool hasIDToken(String responseType) {
  return responseType.contains('id_token');
}

bool hasVPToken(String responseType) {
  return responseType.contains('vp_token');
}

bool hasIDTokenOrVPToken(String responseType) {
  return responseType.contains('id_token') || responseType.contains('vp_token');
}

String getFormattedStringOIDC4VCI({
  required String url,
  required Oidc4vcParameters oidc4vcParameters,
}) {
  return '''
<b>SCHEME :</b> ${getSchemeFromUrl(url)}\n
<b>CREDENTIAL OFFER  :</b> 
${const JsonEncoder.withIndent('  ').convert(oidc4vcParameters.credentialOffer)}\n
<b>AUTHORIZATION SERVER CONFIGURATION :</b>
${oidc4vcParameters.authorizationServerOpenIdConfiguration != const OpenIdConfiguration(requirePushedAuthorizationRequests: false) ? const JsonEncoder.withIndent('  ').convert(oidc4vcParameters.authorizationServerOpenIdConfiguration.rawConfiguration) : 'None'}\n
<b>CREDENTIAL ISSUER CONFIGURATION :</b> 
${const JsonEncoder.withIndent('  ').convert(oidc4vcParameters.issuerOpenIdConfiguration.rawConfiguration)}
''';
}

String getFormattedTokenResponse({
  required Map<String, dynamic>? tokenData,
}) {
  return '''
<b>TOKEN RESPONSE :</b> 
${tokenData != null ? const JsonEncoder.withIndent('  ').convert(tokenData) : 'None'}\n
''';
}

String getFormattedCredentialResponse({
  required List<dynamic>? credentialData,
}) {
  return '''
<b>CREDENTIAL RESPONSE :</b>
${credentialData != null ? const JsonEncoder.withIndent('  ').convert(credentialData) : 'None'}\n
''';
}

Future<String> getFormattedStringOIDC4VPSIOPV2({
  required String url,
  required DioClient client,
  required Map<String, dynamic>? response,
}) async {
  final Map<String, dynamic>? presentationDefinition =
      await getPresentationDefinition(
    client: client,
    uri: Uri.parse(url),
  );

  final Map<String, dynamic>? clientMetaData = await getClientMetada(
    client: client,
    uri: Uri.parse(url),
  );

  final data = '''
<b>SCHEME :</b> ${getSchemeFromUrl(url)}\n
<b>AUTHORIZATION REQUEST :</b>
${response != null ? const JsonEncoder.withIndent('  ').convert(response) : Uri.decodeComponent(url)}\n
<b>CLIENT METADATA  :</b>  
${clientMetaData != null ? const JsonEncoder.withIndent('  ').convert(clientMetaData) : 'None'}\n
<b>PRESENTATION DEFINITION  :</b> 
${presentationDefinition != null ? const JsonEncoder.withIndent('  ').convert(presentationDefinition) : 'None'}
''';

  return data;
}

String getSchemeFromUrl(String url) {
  final parts = url.split(':');
  return parts.length > 1 ? '${parts[0]}://' : '';
}

Future<dynamic> fetchRequestUriPayload({
  required String url,
  required DioClient client,
}) async {
  final log = getLogger('QRCodeScanCubit - fetchRequestUriPayload');
  late final dynamic data;

  try {
    final dynamic response = await client.get(url);
    data = response.toString();
  } catch (e, s) {
    log.e(
      'An error occurred while connecting to the server.',
      error: e,
      stackTrace: s,
    );
  }
  return data;
}

String getUpdatedUrlForSIOPV2OIC4VP({
  required Uri uri,
  required Map<String, dynamic> response,
  required String clientId,
}) {
  final responseType = response['response_type'];
  final redirectUri = response['redirect_uri'];
  final scope = response['scope'];
  final responseUri = response['response_uri'];
  final responseMode = response['response_mode'];
  final nonce = response['nonce'];
  final claims = response['claims'];
  final stateValue = response['state'];
  final presentationDefinition = response['presentation_definition'];
  final presentationDefinitionUri = response['presentation_definition_uri'];
  final registration = response['registration'];
  final clientMetadata = response['client_metadata'];
  final clientMetadataUri = response['client_metadata_uri'];

  final queryJson = <String, dynamic>{};

  if (!uri.queryParameters.containsKey('scope') && scope != null) {
    queryJson['scope'] = scope;
  }

  if (!uri.queryParameters.containsKey('client_id')) {
    queryJson['client_id'] = clientId;
  }

  if (!uri.queryParameters.containsKey('redirect_uri') && redirectUri != null) {
    queryJson['redirect_uri'] = redirectUri;
  }

  if (!uri.queryParameters.containsKey('response_uri') && responseUri != null) {
    queryJson['response_uri'] = responseUri;
  }

  if (!uri.queryParameters.containsKey('response_mode') &&
      responseMode != null) {
    queryJson['response_mode'] = responseMode;
  }

  if (!uri.queryParameters.containsKey('nonce') && nonce != null) {
    queryJson['nonce'] = nonce;
  }

  if (!uri.queryParameters.containsKey('state') && stateValue != null) {
    queryJson['state'] = stateValue;
  }

  if (!uri.queryParameters.containsKey('response_type') &&
      responseType != null) {
    queryJson['response_type'] = responseType;
  }

  if (!uri.queryParameters.containsKey('claims') && claims != null) {
    queryJson['claims'] = jsonEncode(claims).replaceAll('"', "'");
  }

  if (!uri.queryParameters.containsKey('presentation_definition') &&
      presentationDefinition != null) {
    queryJson['presentation_definition'] =
        jsonEncode(presentationDefinition).replaceAll('"', "'");
  }

  if (!uri.queryParameters.containsKey('presentation_definition_uri') &&
      presentationDefinitionUri != null) {
    queryJson['presentation_definition_uri'] = presentationDefinitionUri;
  }

  if (!uri.queryParameters.containsKey('registration') &&
      registration != null) {
    queryJson['registration'] =
        registration is Map ? jsonEncode(registration) : registration;
  }

  if (!uri.queryParameters.containsKey('client_metadata') &&
      clientMetadata != null) {
    queryJson['client_metadata'] =
        clientMetadata is Map ? jsonEncode(clientMetadata) : clientMetadata;
  }

  if (!uri.queryParameters.containsKey('client_metadata_uri') &&
      clientMetadataUri != null) {
    queryJson['client_metadata_uri'] = clientMetadataUri;
  }

  final String queryString = Uri(queryParameters: queryJson).query;

  final String newUrl = '$uri&$queryString';
  return newUrl;
}

// clientId,
// clientSecret,
// authorization,
// oAuthClientAttestation,
// oAuthClientAttestationPop
Future<(String?, String?, String?, String?, String?)> getClientDetails({
  required ProfileCubit profileCubit,
  required bool isEBSI,
  required String issuer,
}) async {
  try {
    String? clientId;
    String? clientSecret;
    String? authorization;
    String? oAuthClientAttestation;
    String? oAuthClientAttestationPop;

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    final didKeyType = customOidc4vcProfile.defaultDid;

    final String privateKey = await fetchPrivateKey(
      profileCubit: profileCubit,
      isEBSI: isEBSI,
      didKeyType: didKeyType,
    );

    final (did, _) = await fetchDidAndKid(
      privateKey: privateKey,
      isEBSI: isEBSI,
      profileCubit: profileCubit,
      didKeyType: didKeyType,
    );

    final tokenParameters = TokenParameters(
      privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
      did: '', // just added as it is required field
      mediaType: MediaType.basic, // just added as it is required field
      clientType:
          customOidc4vcProfile.clientType, // just added as it is required field
      proofHeaderType: customOidc4vcProfile.proofHeader,
      clientId: '', // just added as it is required field
    );

    switch (customOidc4vcProfile.clientAuthentication) {
      ///  none
      case ClientAuthentication.none:
        break;

      case ClientAuthentication.clientSecretBasic:
        authorization = base64UrlEncode(utf8.encode('$clientId:$clientSecret'))
            .replaceAll('=', '');

        switch (customOidc4vcProfile.clientType) {
          case ClientType.p256JWKThumprint:
            clientId = tokenParameters.thumbprint;
          case ClientType.did:
            clientId = did;
          case ClientType.confidential:
            clientId = customOidc4vcProfile.clientId;
        }

      ///  only clientId
      case ClientAuthentication.clientId:
        switch (customOidc4vcProfile.clientType) {
          case ClientType.p256JWKThumprint:
            clientId = tokenParameters.thumbprint;
          case ClientType.did:
            clientId = did;
          case ClientType.confidential:
            clientId = customOidc4vcProfile.clientId;
        }

      case ClientAuthentication.clientSecretPost:
        clientId = customOidc4vcProfile.clientId;
        clientSecret = customOidc4vcProfile.clientSecret;

      case ClientAuthentication.clientSecretJwt:
        if (profileCubit.state.model.walletType != WalletType.enterprise) {
          throw ResponseMessage(
            data: {
              'error': 'invalid_request',
              'error_description': 'Please switch to enterprise account',
            },
          );
        }

        final walletAttestationData = await profileCubit.secureStorageProvider
            .get(SecureStorageKeys.walletAttestationData);

        clientId = did;

        final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
        final nbf = iat - 10;

        final payload = {
          'iss': clientId,
          'aud': issuer,
          'nbf': nbf,
          'exp': nbf + 60,
          'jti': const Uuid().v4(),
        };

        final jwtProofOfPossession = generateToken(
          payload: payload,
          tokenParameters: tokenParameters,
          ignoreProofHeaderType: true,
        );

        oAuthClientAttestation = walletAttestationData;
        oAuthClientAttestationPop = jwtProofOfPossession;
    }

    return (
      clientId,
      clientSecret,
      authorization,
      oAuthClientAttestation,
      oAuthClientAttestationPop
    );
  } catch (e) {
    return (null, null, null, null, null);
  }
}

(Display?, dynamic) fetchDisplay({
  required OpenIdConfiguration openIdConfiguration,
  required String credentialType,
  required String languageCode,
}) {
  Display? display;
  dynamic credentialSupported;

  if (openIdConfiguration.credentialsSupported != null) {
    final credentialsSupported = openIdConfiguration.credentialsSupported!;
    final CredentialsSupported? credSupported =
        credentialsSupported.firstWhereOrNull(
      (CredentialsSupported credentialsSupported) =>
          (credentialsSupported.id != null &&
              credentialsSupported.id == credentialType) ||
          (credentialsSupported.types != null &&
              credentialsSupported.types!.contains(credentialType)),
    );

    if (credSupported != null) {
      credentialSupported = credSupported.toJson();

      final credSupportedDisplay = credSupported.display;

      if (credSupportedDisplay != null) {
        display = credSupportedDisplay.firstWhereOrNull(
              (Display display) =>
                  display.locale.toString().contains(languageCode),
            ) ??
            credSupportedDisplay.firstWhereOrNull(
              (Display display) => display.locale.toString().contains('en'),
            ) ??
            credSupportedDisplay.firstWhereOrNull(
              (Display display) => display.locale == null,
            ) ??
            credSupportedDisplay.first; // if local is not provided
      }
    }
  } else if (openIdConfiguration.credentialConfigurationsSupported != null) {
    final credentialsSupported =
        openIdConfiguration.credentialConfigurationsSupported;

    if ((credentialsSupported is Map<String, dynamic>) &&
        credentialsSupported.containsKey(credentialType)) {
      /// credentialSupported
      final credSupported = credentialsSupported[credentialType];

      credentialSupported = credSupported;

      if (credSupported is Map<String, dynamic>) {
        /// display
        if (credSupported.containsKey('display')) {
          final displayData = credSupported['display'];

          if (displayData is List<dynamic>) {
            final displays = displayData
                .map((ele) => Display.fromJson(ele as Map<String, dynamic>))
                .toList();

            display = displays.firstWhereOrNull(
                  (Display display) =>
                      display.locale.toString().contains(languageCode),
                ) ??
                displays.firstWhereOrNull(
                  (Display display) => display.locale.toString().contains('en'),
                ) ??
                displays.firstWhereOrNull(
                  (Display display) => display.locale != null,
                ) ??
                displays.first; // if local is not provided
          }
        }
      }
    }
  }

  if (display == null && openIdConfiguration.display != null) {
    final displays = openIdConfiguration.display!;

    display = displays.firstWhereOrNull(
          (Display display) => display.locale.toString().contains(languageCode),
        ) ??
        displays.firstWhereOrNull(
          (Display display) => display.locale.toString().contains('en'),
        ) ??
        displays.firstWhereOrNull(
          (Display display) => display.locale == null,
        ) ??
        displays.first; // if local is not provided;
  }
  return (display, credentialSupported);
}

List<String> getStringCredentialsForToken({
  required List<CredentialModel> credentialsToBePresented,
  required ProfileCubit profileCubit,
}) {
  final credentialList = credentialsToBePresented.map((item) {
    final isVcSdJWT = item.getFormat == VCFormatType.vcSdJWT.vcValue;

    if (isVcSdJWT) {
      return item.selectiveDisclosureJwt ?? jsonEncode(item.toJson());
    }

    return jsonEncode(item.toJson());
  }).toList();

  return credentialList;
}

//(presentLdpVc, presentJwtVc, presentJwtVcJson, presentVcSdJwt)
List<VCFormatType> getPresentVCDetails({
  required List<VCFormatType> formatsSupported,
  required PresentationDefinition presentationDefinition,
  required Map<String, dynamic>? clientMetaData,
  required List<CredentialModel> credentialsToBePresented,
}) {
  bool presentLdpVc = false;
  bool presentJwtVc = false;
  bool presentJwtVcJson = false;
  bool presentJwtVcJsonLd = false;
  bool presentVcSdJwt = false;

  final supportingFormats = <VCFormatType>[];

  if (presentationDefinition.format != null) {
    final format = presentationDefinition.format;

    /// ldp_vc
    presentLdpVc = format?.ldpVc != null || format?.ldpVp != null;

    /// jwt_vc
    presentJwtVc = format?.jwtVc != null || format?.jwtVp != null;

    /// jwt_vc_json
    presentJwtVcJson = format?.jwtVcJson != null || format?.jwtVpJson != null;

    /// jwt_vc_json_ld
    presentJwtVcJsonLd =
        format?.jwtVcJsonLd != null || format?.jwtVpJson != null;

    /// vc+sd-jwt
    presentVcSdJwt = format?.vcSdJwt != null;
  } else {
    if (clientMetaData == null) {
      /// credential manifest case
      presentLdpVc = true;
      presentJwtVc = true;
      presentJwtVcJson = true;
      presentJwtVcJsonLd = true;
      presentVcSdJwt = true;
    } else {
      final vpFormats = clientMetaData['vp_formats'] as Map<String, dynamic>;

      /// ldp_vc
      presentLdpVc =
          vpFormats.containsKey('ldp_vc') || vpFormats.containsKey('ldp_vp');

      /// jwt_vc
      presentJwtVc =
          vpFormats.containsKey('jwt_vc') || vpFormats.containsKey('jwt_vp');

      /// jwt_vc_json
      presentJwtVcJson = vpFormats.containsKey('jwt_vc_json') ||
          vpFormats.containsKey('jwt_vp_json');

      /// jwt_vc_json-ld
      presentJwtVcJsonLd = vpFormats.containsKey('jwt_vc_json-ld') ||
          vpFormats.containsKey('jwt_vp_json-ld');

      /// vc+sd-jwt
      presentVcSdJwt = vpFormats.containsKey('vc+sd-jwt');
    }
  }

  if (!presentLdpVc &&
      !presentJwtVc &&
      !presentJwtVcJson &&
      !presentJwtVcJsonLd &&
      !presentVcSdJwt) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_request',
        'error_description': 'VC format is missing',
      },
    );
  }

  /// create list of supported formats
  if (presentLdpVc && formatsSupported.contains(VCFormatType.ldpVc)) {
    supportingFormats.add(VCFormatType.ldpVc);
  }
  if (presentJwtVc && formatsSupported.contains(VCFormatType.jwtVc)) {
    supportingFormats.add(VCFormatType.jwtVc);
  }
  if (presentJwtVcJson && formatsSupported.contains(VCFormatType.jwtVcJson)) {
    supportingFormats.add(VCFormatType.jwtVcJson);
  }
  if (presentJwtVcJsonLd &&
      formatsSupported.contains(VCFormatType.jwtVcJsonLd)) {
    supportingFormats.add(VCFormatType.jwtVcJsonLd);
  }
  if (presentVcSdJwt && formatsSupported.contains(VCFormatType.vcSdJWT)) {
    supportingFormats.add(VCFormatType.vcSdJWT);
  }

  return supportingFormats;
}

List<dynamic> collectSdValues(Map<String, dynamic> data) {
  final result = <dynamic>[];

  if (data.containsKey('_sd') && data is List<dynamic>) {
    final sd = data['_sd'];
    if (sd is List<dynamic>) {
      result.addAll(sd);
    }
  }

  data.forEach((key, value) {
    if (key == '_sd') {
      final sd = data['_sd'];
      if (sd is List<dynamic>) {
        result.addAll(sd);
      }
    } else {
      if (value is Map<String, dynamic>) {
        result.addAll(collectSdValues(value));
      } else if (value is List<dynamic>) {
        for (final ele in value) {
          if (ele is Map) {
            final threeDotValue = ele['...'];

            if (threeDotValue != null) {
              result.add(threeDotValue);
            }
          }
        }
      }
    }
  });

  return result;
}

Map<String, dynamic> createJsonByDecryptingSDValues({
  required Map<String, dynamic> encryptedJson,
  required SelectiveDisclosure selectiveDisclosure,
}) {
  final json = <String, dynamic>{};

  final sh256HashToContent = selectiveDisclosure.sh256HashToContent;

  encryptedJson.forEach((key, value) {
    if (key == '_sd') {
      final sd = encryptedJson['_sd'];

      if (sd is List<dynamic>) {
        for (final sdValue in sd) {
          if (sh256HashToContent.containsKey(sdValue)) {
            final content = sh256HashToContent[sdValue];
            if (content is Map) {
              content.forEach((key, value) {
                if (value is Map<String, dynamic>) {
                  if (value.containsKey('_sd')) {
                    final nestedJson = createJsonByDecryptingSDValues(
                      selectiveDisclosure: selectiveDisclosure,
                      encryptedJson: value,
                    );
                    json[key.toString()] = nestedJson;
                  } else {
                    json[key.toString()] = value;
                  }
                } else {
                  json[key.toString()] = value;
                }
              });
            }
          }
        }
      }
    } else {
      if (value is Map<String, dynamic>) {
        final nestedJson = createJsonByDecryptingSDValues(
          selectiveDisclosure: selectiveDisclosure,
          encryptedJson: value,
        );
        json[key] = nestedJson;
      } else if (value is List<dynamic>) {
        final list = <String>[];

        for (final ele in value) {
          if (ele is Map) {
            final threeDotValue = ele['...'];
            if (sh256HashToContent.containsKey(threeDotValue)) {
              final content = sh256HashToContent[threeDotValue];
              if (content is Map) {
                content.forEach((key, value) {
                  list.add(value.toString());
                });
              }
            }
          } else {
            list.add(ele.toString());
          }
        }

        json[key] = list;
      } else {
        json[key] = value;
      }
    }
  });

  return json;
}

Future<Map<String, dynamic>?> checkX509({
  required String encodedData,
  required Map<String, dynamic> header,
  required String clientId,
}) async {
  final x5c = header['x5c'];

  if (x5c != null) {
    if (x5c is! List) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'x509_san_dns scheme error',
        },
      );
    }

    //array x5c[0], it is a certificat in DER format (binary)
    final certificate = x5c.firstOrNull;

    if (certificate == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'x509_san_dns scheme error',
        },
      );
    }

    final decoded = base64Decode(certificate.toString());
    final seq = asn1lib.ASN1Sequence.fromBytes(decoded);
    final cert = x509.X509Certificate.fromAsn1(seq);

    final extensions = cert.tbsCertificate.extensions;

    if (extensions == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'x509_san_dns scheme error',
        },
      );
    }

    final extension = extensions
        .where((Extension element) => element.extnId.name == 'subjectAltName')
        .firstOrNull;

    if (extension == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'x509_san_dns scheme error',
        },
      );
    }

    final extnValue = extension.extnValue.toString();

    if (!extnValue.contains(clientId)) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description': 'x509_san_dns scheme error',
        },
      );
    }

    final publicKey = cert.publicKey;
    if (publicKey is x509.RsaPublicKey) {
      final BigInt modulus = BigInt.parse(publicKey.modulus.toString());
      final n = base64Encode(modulus.toBytes);
      final publicKeyJwk = {
        'e': 'AQAB',
        'kty': 'RSA',
        'n': n.replaceAll('=', ''),
      };
      return publicKeyJwk;
    } else if (publicKey is x509.EcPublicKey) {
      final BigInt xModulus = BigInt.parse(publicKey.xCoordinate.toString());
      final BigInt yModulus = BigInt.parse(publicKey.yCoordinate.toString());
      final x = base64Encode(xModulus.toBytes);
      final y = base64Encode(yModulus.toBytes);
      final publicKeyJwk = {
        'kty': 'EC',
        'crv': 'P-256',
        'x': x.replaceAll('=', ''),
        'y': y.replaceAll('=', ''),
      };
      return publicKeyJwk;
    }
  }
  return null;
}

Future<Map<String, dynamic>?> checkVerifierAttestation({
  required String clientId,
  required Map<String, dynamic> header,
  required JWTDecode jwtDecode,
}) async {
  final jwt = header['jwt'];

  if (jwt == null) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description': 'verifier_attestation scheme error',
      },
    );
  }

  final payload = jwtDecode.parseJwt(jwt.toString());

  final sub = payload['sub'];
  final cnf = payload['cnf'];

  if (sub == null ||
      sub != clientId ||
      cnf == null ||
      cnf is! Map<String, dynamic> ||
      !cnf.containsKey('jwk') ||
      cnf['jwk'] is! Map<String, dynamic>) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description': 'verifier_attestation scheme error',
      },
    );
  }

  return cnf['jwk'] as Map<String, dynamic>;
}

/// walletaddress and blockchain type
(String?, BlockchainType?) getWalletAddress(
  CredentialSubjectModel credentialSubjectModel,
) {
  if (credentialSubjectModel is TezosAssociatedAddressModel) {
    return (
      credentialSubjectModel.associatedAddress,
      BlockchainType.tezos,
    );
  } else if (credentialSubjectModel is EthereumAssociatedAddressModel) {
    return (
      credentialSubjectModel.associatedAddress,
      BlockchainType.ethereum,
    );
  } else if (credentialSubjectModel is PolygonAssociatedAddressModel) {
    return (
      credentialSubjectModel.associatedAddress,
      BlockchainType.polygon,
    );
  } else if (credentialSubjectModel is BinanceAssociatedAddressModel) {
    return (
      credentialSubjectModel.associatedAddress,
      BlockchainType.binance,
    );
  } else if (credentialSubjectModel is FantomAssociatedAddressModel) {
    return (
      credentialSubjectModel.associatedAddress,
      BlockchainType.fantom,
    );
  } else if (credentialSubjectModel is EtherlinkAssociatedAddressModel) {
    return (
      credentialSubjectModel.associatedAddress,
      BlockchainType.etherlink,
    );
  }
  return (null, null);
}

Future<String> fetchRpcUrl({
  required BlockchainNetwork blockchainNetwork,
  required DotEnv dotEnv,
}) async {
  String rpcUrl = '';

  if (blockchainNetwork is BinanceNetwork ||
      blockchainNetwork is FantomNetwork ||
      blockchainNetwork is EtherlinkNetwork) {
    rpcUrl = blockchainNetwork.rpcNodeUrl as String;
  } else {
    if (blockchainNetwork.networkname == 'Mainnet') {
      await dotEnv.load();
      final String infuraApiKey = dotEnv.get('INFURA_API_KEY');

      late String prefixUrl;

      if (blockchainNetwork is PolygonNetwork) {
        prefixUrl = Parameters.POLYGON_INFURA_URL;
      } else {
        prefixUrl = Parameters.web3RpcMainnetUrl;
      }

      return '$prefixUrl$infuraApiKey';
    } else {
      rpcUrl = blockchainNetwork.rpcNodeUrl as String;
    }
  }

  return rpcUrl;
}

String getDidMethod(BlockchainType blockchainType) {
  late String didMethod;

  switch (blockchainType) {
    case BlockchainType.tezos:
      didMethod = AltMeStrings.cryptoTezosDIDMethod;

    case BlockchainType.ethereum:
    case BlockchainType.fantom:
    case BlockchainType.polygon:
    case BlockchainType.binance:
    case BlockchainType.etherlink:
      didMethod = AltMeStrings.cryptoEVMDIDMethod;
  }

  return didMethod;
}

bool useOauthServerAuthEndPoint(ProfileModel profileModel) {
  final profileSetting = profileModel.profileSetting;
  final customOidc4vcProfile =
      profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile;

  final bool notEligible = profileModel.profileType == ProfileType.ebsiV3 ||
      profileModel.profileType == ProfileType.ebsiV4;

  if (notEligible) return false;

  final bool greaterThanDraft13 =
      customOidc4vcProfile.oidc4vciDraft != OIDC4VCIDraftType.draft11;

  if (greaterThanDraft13) return true;

  return false;
}

Future<String> getDPopJwt({
  required String url,
  required String publicKey,
  String? accessToken,
  String? nonce,
}) async {
  final tokenParameters = TokenParameters(
    privateKey: jsonDecode(publicKey) as Map<String, dynamic>,
    mediaType: MediaType.dPop,
    did: '', // just added as it is required field
    clientType:
        ClientType.p256JWKThumprint, // just added as it is required field
    proofHeaderType: ProofHeaderType.jwk,
    clientId: '', // just added as it is required field
  );

  final jti = const Uuid().v4();
  final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();

  final payload = {
    'jti': jti,
    'htm': 'POST',
    'htu': url,
    'iat': iat,
  };

  if (accessToken != null) {
    final hash = sh256Hash(accessToken);
    payload['ath'] = hash;
  }

  // if (nonce != null) payload['nonce'] = nonce;

  final jwtToken = generateToken(
    payload: payload,
    tokenParameters: tokenParameters,
    ignoreProofHeaderType: false,
  );
  return jwtToken;
}

String generateP256KeyForDPop() {
  final randomKey = generateRandomP256Key();
  final publicKeyForDPop = sortedPrivateJwk(randomKey);

  return publicKeyForDPop;
}

Map<String, dynamic> getCredentialDataFromJson({
  required String data,
  required String format,
  required JWTDecode jwtDecode,
  required String credentialType,
}) {
  late Map<String, dynamic> credential;

  final jsonContent = jwtDecode.parseJwt(data);
  if (format == VCFormatType.vcSdJWT.vcValue) {
    final sdAlg = jsonContent['_sd_alg'] ?? 'sha-256';

    if (sdAlg != 'sha-256') {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Only sha-256 is supported.',
        },
      );
    }

    credential = jsonContent;
  } else {
    credential = jsonContent['vc'] as Map<String, dynamic>;
  }

  if (format == VCFormatType.vcSdJWT.vcValue) {
    /// type
    if (!credential.containsKey('type')) {
      credential['type'] = [credentialType];
    }

    ///credentialSubject
    if (!credential.containsKey('credentialSubject')) {
      credential['credentialSubject'] = {'type': credentialType};
    }
  }

  /// id -> jti
  if (!credential.containsKey('id')) {
    if (jsonContent.containsKey('jti')) {
      credential['id'] = jsonContent['jti'];
    } else {
      credential['id'] = 'urn:uuid:${const Uuid().v4()}';
    }
  }

  /// issuer -> iss
  if (!credential.containsKey('issuer')) {
    if (jsonContent.containsKey('iss')) {
      credential['issuer'] = jsonContent['iss'];
    } else {
      throw ResponseMessage(
        data: {
          'error': 'unsupported_format',
          'error_description': 'Issuer is missing',
        },
      );
    }
  }

  /// issuanceDate -> iat
  if (!credential.containsKey('issuanceDate')) {
    if (jsonContent.containsKey('iat')) {
      credential['issuanceDate'] = jsonContent['iat'].toString();
    } else if (jsonContent.containsKey('issuanceDate')) {
      credential['issuanceDate'] = jsonContent['issuanceDate'].toString();
    }
  }

  /// expirationDate -> exp
  if (!credential.containsKey('expirationDate')) {
    if (jsonContent.containsKey('exp')) {
      credential['expirationDate'] = jsonContent['exp'].toString();
    } else if (jsonContent.containsKey('expirationDate')) {
      credential['expirationDate'] = jsonContent['expirationDate'].toString();
    }
  }

  /// cred,tailSubject.id -> sub

  // if (newCredential['id'] == null) {
  //   newCredential['id'] = 'urn:uuid:${const Uuid().v4()}';
  // }

  // if (newCredential['credentialPreview']['id'] == null) {
  //   newCredential['credentialPreview']['id'] =
  //       'urn:uuid:${const Uuid().v4()}';
  // }

  credential['jwt'] = data;

  return credential;
}

bool isContract(String reciever) {
  // check if it smart contract or not
  // smart contarct address start with KT1
  if (reciever.startsWith('tz')) return false;
  if (reciever.startsWith('KT1')) return true;
  return false;
}

String? getClientIdForPresentation(String? clientId) {
  if (clientId == null) return '';
  if (clientId.contains(':')) {
    final parts = clientId.split(':');
    if (parts.length == 2) {
      return parts[1];
    } else {
      return clientId;
    }
  } else {
    return clientId;
  }
}
