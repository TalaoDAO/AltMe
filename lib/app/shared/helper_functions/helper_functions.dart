import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:convert/convert.dart';
import 'package:credential_manifest/credential_manifest.dart';

import 'package:dartez/dartez.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';

import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:jose/jose.dart';
import 'package:json_path/json_path.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:key_generator/key_generator.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_storage/secure_storage.dart';

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

bool get isAndroid => Platform.isAndroid;

bool get isIOS => Platform.isIOS;

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

String stringToHexPrefixedWith05({required String payload}) {
  final String formattedInput = <String>[
    'Tezos Signed Message:',
    'altme.io',
    DateTime.now().toString(),
    payload,
  ].join(' ');

  final String bytes = char2Bytes(formattedInput);

  const String prefix = '05';
  const String stringIsHex = '0100';
  final String bytesOfByteLength = char2Bytes(bytes.length.toString());

  final payloadBytes = '$prefix$stringIsHex$bytesOfByteLength$bytes';

  return payloadBytes;
}

String char2Bytes(String text) {
  final List<int> encode = utf8.encode(text);
  final String bytes = hex.encode(encode);
  return bytes;
}

Future<bool> isConnected() async {
  final log = getLogger('Check Internet Connection');

  if (!isAndroid) {
    if (!(await DeviceInfoPlugin().iosInfo).isPhysicalDevice) {
      return true;
    }
  }
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  log.e('No Internet Connection');
  return false;
}

String getCredentialName(String constraints) {
  final dynamic constraintsJson = jsonDecode(constraints);
  final fieldsPath = JsonPath(r'$..fields');
  final dynamic credentialField =
      (fieldsPath.read(constraintsJson).first.value as List)
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
      (fieldsPath.read(constraintsJson).first.value as List)
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
      throw Exception();
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

Future<bool> isCredentialPresentable(String credentialName) async {
  final CredentialSubjectType? credentialSubjectType =
      getCredTypeFromName(credentialName);

  if (credentialSubjectType == null) {
    return true;
  }

  final isPresentable = await isCredentialAvaialble(credentialSubjectType);

  return isPresentable;
}

Future<bool> isCredentialAvaialble(
  CredentialSubjectType credentialSubjectType,
) async {
  /// fetching all the credentials
  final CredentialsRepository repository =
      CredentialsRepository(getSecureStorage);

  final List<CredentialModel> allCredentials = await repository.findAll();

  for (final credential in allCredentials) {
    if (credentialSubjectType ==
        credential
            .credentialPreview.credentialSubjectModel.credentialSubjectType) {
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

String getDateTimeWithoutSpace() {
  final dateTime = DateTime.fromMicrosecondsSinceEpoch(
    DateTime.now().microsecondsSinceEpoch,
  ).toString().replaceAll(' ', '-');
  return dateTime;
}

Future<String> web3RpcMainnetInfuraURL() async {
  await dotenv.load();
  final String infuraApiKey = dotenv.get('INFURA_API_KEY');
  const String prefixUrl = Parameters.web3RpcMainnetUrl;
  return '$prefixUrl$infuraApiKey';
}

Future<String> getRandomP256PrivateKey(
  SecureStorageProvider secureStorage,
) async {
  final String? p256PrivateKey = await secureStorage.get(
    SecureStorageKeys.p256PrivateKey,
  );

  if (p256PrivateKey == null) {
    final jwk = JsonWebKey.generate('ES256');

    final json = jwk.toJson();

    // Sort the keys in ascending order and remove alg
    final sortedJwk = Map.fromEntries(
      json.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    )..remove('keyOperations');

    await secureStorage.set(
      SecureStorageKeys.p256PrivateKey,
      jsonEncode(sortedJwk),
    );

    return jsonEncode(sortedJwk);
  } else {
    return p256PrivateKey;
  }
}

Future<String> fetchPrivateKey({
  required OIDC4VC oidc4vc,
  required SecureStorageProvider secureStorage,
  required bool isEBSIV3,
}) async {
  late String privateKey;

  final index = getIndexValue(isEBSIV3: true);

  if (isEBSIV3) {
    privateKey = await getRandomP256PrivateKey(getSecureStorage);
  } else {
    final OIDC4VC oidc4vc = OIDC4VC();
    final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
    privateKey = await oidc4vc.privateKeyFromMnemonic(
      mnemonic: mnemonic!,
      indexValue: index,
    );
  }
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
  required bool isEBSIV3,
  DIDKitProvider? didKitProvider,
}) async {
  late String did;
  late String kid;

  if (isEBSIV3) {
    final private = jsonDecode(privateKey) as Map<String, dynamic>;

    //b'\xd1\xd6\x03' in python
    final List<int> prefixByteList = [0xd1, 0xd6, 0x03];
    final List<int> prefix = prefixByteList.map((byte) => byte).toList();

    final encodedData = sortedPublcJwk(private);
    final encodedAddress = Base58Encode([...prefix, ...encodedData]);

    did = 'did:key:z$encodedAddress';
    final String lastPart = did.split(':')[2];
    kid = '$did#$lastPart';
  } else {
    const didMethod = AltMeStrings.defaultDIDMethod;
    did = didKitProvider!.keyToDID(didMethod, privateKey);
    kid = await didKitProvider.keyToVerificationMethod(didMethod, privateKey);
  }

  return (did, kid);
}

List<int> sortedPublcJwk(Map<String, dynamic> privateKey) {
  final publicJWK = Map.of(privateKey)..removeWhere((key, value) => key == 'd');

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
  return utf8.encode(jsonString);
}

bool isUriAsValueValid(List<String> keys) =>
    keys.contains('response_type') &&
    keys.contains('client_id') &&
    keys.contains('nonce');

bool isPolygonIdUrl(String url) =>
    url.startsWith('{"id":') ||
    url.startsWith('{"body":{"') ||
    url.startsWith('{"from": "did:polygonid:') ||
    url.startsWith('{"to": "did:polygonid:') ||
    url.startsWith('{"thid":') ||
    url.startsWith('{"typ":') ||
    url.startsWith('{"type":');

bool isOIDC4VCIUrl(Uri uri) {
  return uri.toString().startsWith('openid');
}

bool isSIOPV2OROIDC4VPUrl(Uri uri) {
  final isOpenIdUrl = uri.toString().startsWith('openid://?') ||
      uri.toString().startsWith('openid-vc://?') ||
      uri.toString().startsWith('openid-hedera://?');

  final isSiopv2Url = uri.toString().startsWith('siopv2://?');
  final isAuthorizeEndPoint =
      uri.toString().startsWith(Parameters.authorizeEndPoint);

  return isOpenIdUrl || isAuthorizeEndPoint || isSiopv2Url;
}

Future<OIDC4VCType?> getOIDC4VCTypeForIssuance({
  required String url,
  required DioClient client,
}) async {
  final uri = Uri.parse(url);

  final keys = <String>[];
  uri.queryParameters.forEach((key, value) => keys.add(key));

  late String issuer;

  if (keys.contains('issuer')) {
    /// issuance case 1
    issuer = uri.queryParameters['issuer'].toString();
  } else if (keys.contains('credential_offer') ||
      keys.contains('credential_offer_uri')) {
    ///  issuance case 2
    final dynamic credentialOfferJson = await getCredentialOfferJson(
      scannedResponse: uri.toString(),
      dioClient: client,
    );
    if (credentialOfferJson == null) throw Exception();

    issuer = credentialOfferJson['credential_issuer'].toString();
  } else {
    return null;
  }

  final openidConfigurationResponse = await getOpenIdConfig(
    baseUrl: issuer,
    client: client.dio,
  );

  final authorizationServer =
      openidConfigurationResponse['authorization_server'];

  List<dynamic>? subjectSyntaxTypesSupported;

  if (authorizationServer == null) {
    if (openidConfigurationResponse
        .containsKey('subject_syntax_types_supported')) {
      subjectSyntaxTypesSupported =
          openidConfigurationResponse['subject_syntax_types_supported']
              as List<dynamic>;
    }
  } else {
    final openidConfigurationResponse = await getOpenIdConfig(
      baseUrl: authorizationServer.toString(),
      client: client.dio,
    );

    if (openidConfigurationResponse
        .containsKey('subject_syntax_types_supported')) {
      subjectSyntaxTypesSupported =
          openidConfigurationResponse['subject_syntax_types_supported']
              as List<dynamic>;
    }
  }

  if (subjectSyntaxTypesSupported != null &&
      !subjectSyntaxTypesSupported.contains('did:key')) {
    throw Exception('Subject_Syntax_Type_Not_Supported');
  }

  final credentialsSupported =
      openidConfigurationResponse['credentials_supported'] as List<dynamic>;

  final credSupported = credentialsSupported[0] as Map<String, dynamic>;
  for (final oidc4vcType in OIDC4VCType.values) {
    if (oidc4vcType.isEnabled && url.startsWith(oidc4vcType.offerPrefix)) {
      if (oidc4vcType == OIDC4VCType.DEFAULT ||
          oidc4vcType == OIDC4VCType.EBSIV3) {
        if (credSupported['trust_framework'] == null) {
          return OIDC4VCType.DEFAULT;
        }

        if (credSupported['trust_framework']['name'] == 'ebsi') {
          return OIDC4VCType.EBSIV3;
        } else {
          return OIDC4VCType.DEFAULT;
        }
      }
      return oidc4vcType;
    }
  }
  return null;
}

Future<bool> isEBSIV3ForVerifier({
  required Uri uri,
  required DioClient client,
}) async {
  try {
    final String? clientId = uri.queryParameters['client_id'];

    if (clientId == null) return false;

    final isUrl = isURL(clientId);
    if (!isUrl) return false;

    final openidConfigurationResponse = await getOpenIdConfig(
      baseUrl: clientId,
      client: client.dio,
    );

    final bool hasKey = openidConfigurationResponse
        .containsKey('subject_trust_frameworks_supported');

    /// if subject_trust_frameworks_supported is not present => non-ebsi
    if (!hasKey) {
      return false;
    }

    final subjectTrustFrameworksSupported =
        openidConfigurationResponse['subject_trust_frameworks_supported'];

    /// if subject_trust_frameworks_supported is empty => non-ebsi
    if ((subjectTrustFrameworksSupported as List<dynamic>).isEmpty) {
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
    return false;
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
    throw Exception();
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
    final dynamic credentialOfferJson = await getCredentialOfferJson(
      scannedResponse: uri.toString(),
      dioClient: client,
    );
    if (credentialOfferJson == null) throw Exception();

    return Uri.parse(
      credentialOfferJson['credential_issuer'].toString(),
    ).host;
  } else {
    /// verification case

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
      final String? redirectUri = getRedirectUri(uri);
      if (redirectUri == null) return '';
      return Uri.parse(redirectUri).host;
    }
  }
}

Future<(String?, String?)> getIssuerAndPreAuthorizedCode({
  required String scannedResponse,
  required DioClient dioClient,
}) async {
  String? preAuthorizedCode;
  String? issuer;

  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  final keys = <String>[];
  uriFromScannedResponse.queryParameters.forEach((key, value) => keys.add(key));

  if (keys.contains('issuer')) {
    issuer = uriFromScannedResponse.queryParameters['issuer'].toString();
    //preAuthorizedCode can be null
    preAuthorizedCode =
        uriFromScannedResponse.queryParameters['pre-authorized_code'];
  } else if (keys.contains('credential_offer') ||
      keys.contains('credential_offer_uri')) {
    final dynamic credentialOfferJson = await getCredentialOfferJson(
      scannedResponse: scannedResponse,
      dioClient: dioClient,
    );
    if (credentialOfferJson == null) throw Exception();

    final dynamic preAuthorizedCodeGrant = credentialOfferJson['grants']
        ['urn:ietf:params:oauth:grant-type:pre-authorized_code'];

    if (preAuthorizedCodeGrant != null &&
        preAuthorizedCodeGrant is Map &&
        preAuthorizedCodeGrant.containsKey('pre-authorized_code')) {
      preAuthorizedCode =
          preAuthorizedCodeGrant['pre-authorized_code'] as String;
    }

    issuer = credentialOfferJson['credential_issuer'].toString();
  }

  return (preAuthorizedCode, issuer);
}

bool isURL(String input) {
  final Uri? uri = Uri.tryParse(input);
  return uri != null && uri.hasScheme;
}

String? getRedirectUri(Uri uri) {
  final clientId = uri.queryParameters['client_id'];
  final redirectUri = uri.queryParameters['redirect_uri'];

  /// if redirectUri is not provided and client_id is url then
  /// redirectUri = client_id
  if (redirectUri == null) {
    if (clientId == null) return null;
    final isUrl = isURL(clientId);
    if (isUrl) {
      return clientId;
    } else {
      return null;
    }
  } else {
    return redirectUri;
  }
}

int getIndexValue({required bool isEBSIV3}) {
  if (isEBSIV3) {
    return 3;
  } else {
    return 1;
  }
}

(MessageHandler messageHandler, String? erroDescription, String? errorUrl)
    getOIDC4VCError(dynamic e) {
  ResponseString responseString =
      ResponseString.RESPONSE_STRING_thisRequestIsNotSupported;
  MessageHandler messageHandler = ResponseMessage(
    responseString,
  );

  String? erroDescription;
  String? errorUrl;

  if (e is DioException) {
    final error = NetworkException.getDioException(error: e);

    final data = error.data;

    if (data != null && data is Map) {
      if (data.containsKey('error')) {
        switch (data['error']) {
          case 'invalid_request':
          case 'invalid_request_uri':
          case 'invalid_request_object':
            responseString = ResponseString.RESPONSE_STRING_invalidRequest;

          case 'unauthorized_client':
          case 'access_denied':
          case 'invalid_or_missing_proof':
          case 'interaction_required':
            responseString = ResponseString.RESPONSE_STRING_accessDenied;

          case 'unsupported_response_type':
          case 'invalid_scope':
          case 'request_not_supported':
          case 'request_uri_not_supported':
            responseString =
                ResponseString.RESPONSE_STRING_thisRequestIsNotSupported;

          case 'unsupported_credential_type':
            responseString =
                ResponseString.RESPONSE_STRING_unsupportedCredential;
          case 'login_required':
          case 'account_selection_required':
            responseString = ResponseString.RESPONSE_STRING_aloginIsRequired;

          case 'consent_required':
            responseString =
                ResponseString.RESPONSE_STRING_userConsentIsRequired;

          case 'registration_not_supported':
            responseString =
                ResponseString.RESPONSE_STRING_theWalletIsNotRegistered;

          case 'invalid_grant':
          case 'invalid_client':
          case 'invalid_token':
            responseString =
                ResponseString.RESPONSE_STRING_credentialIssuanceDenied;

          case 'unsupported_credential_format':
            responseString = ResponseString
                .RESPONSE_STRING_thisCredentialFormatIsNotSupported;

          default:
            responseString =
                ResponseString.RESPONSE_STRING_thisRequestIsNotSupported;
        }
      }

      ///error
      messageHandler = ResponseMessage(responseString);

      ///error_description
      if (data.containsKey('error_description')) {
        erroDescription = data['error_description'].toString();
      }

      ///error_uri
      if (data.containsKey('error_uri')) {
        errorUrl = data['error_uri'].toString();
      }
    }
  } else if (e is MessageHandler) {
    messageHandler = e;
  }

  return (messageHandler, erroDescription, errorUrl);
}
