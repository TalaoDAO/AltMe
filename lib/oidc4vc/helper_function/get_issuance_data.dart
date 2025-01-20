import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/message_handler/response_message.dart';
import 'package:altme/oidc4vc/helper_function/get_credential_offer_json.dart';
import 'package:dio/dio.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// OIDC4VCType?, OpenIdConfiguration?, OpenIdConfiguration?,
/// credentialOfferJson, issuer, pre-authorizedCode
Future<Oidc4vcParameters> getIssuanceData({
  required String url,
  required DioClient client,
  required OIDC4VC oidc4vc,
  required OIDC4VCIDraftType oidc4vciDraftType,
  required bool useOAuthAuthorizationServerLink,
}) async {
  final uri = Uri.parse(url);

  final keys = <String>[];
  uri.queryParameters.forEach((key, value) => keys.add(key));

  late Map<String, dynamic> credentialOfferJson;
  String? issuer;
  String? preAuthorizedCode;
  bool userPinRequired = false;
  TxCode? txCode;
  String? issuerState;

  if (keys.contains('credential_offer') ||
      keys.contains('credential_offer_uri')) {
    ///  issuance case 2
    credentialOfferJson = await getCredentialOffer(
      scannedResponse: uri.toString(),
      dioClient: client,
    );
    issuer = credentialOfferJson['credential_issuer'].toString();

    final grants = credentialOfferJson['grants'];

    if (grants != null && grants is Map) {
      final dynamic preAuthorizedCodeGrant =
          grants['urn:ietf:params:oauth:grant-type:pre-authorized_code'];
      if (preAuthorizedCodeGrant != null && preAuthorizedCodeGrant is Map) {
        if (preAuthorizedCodeGrant.containsKey('pre-authorized_code')) {
          preAuthorizedCode =
              preAuthorizedCodeGrant['pre-authorized_code'] as String;
        }
        if (preAuthorizedCodeGrant.containsKey('user_pin_required')) {
          userPinRequired = preAuthorizedCodeGrant['user_pin_required'] as bool;
        } else if (preAuthorizedCodeGrant.containsKey('tx_code')) {
          /// draft 13
          final txCodeMap = preAuthorizedCodeGrant['tx_code'];

          if (txCodeMap is Map<String, dynamic>) {
            txCode = TxCode.fromJson(txCodeMap);
            userPinRequired = true;
          }
        }
      }
      final dynamic authorizedCode = grants['authorization_code'];
      if (authorizedCode != null &&
          authorizedCode is Map &&
          authorizedCode.containsKey('issuer_state')) {
        issuerState = authorizedCode['issuer_state'] as String;
      }
    }
  } else {
    throw ResponseMessage(
      data: {
        'error': 'invalid_request',
        'error_description': 'The credential offer is missing.',
      },
    );
  }

  if (keys.contains('issuer')) {
    /// issuance case 1
    issuer = uri.queryParameters['issuer'].toString();

    /// preAuthorizedCode can be null
    preAuthorizedCode = uri.queryParameters['pre-authorized_code'];
  }

  if (issuer == '') {
    return Oidc4vcParameters(
      oidc4vciDraftType: oidc4vciDraftType,
      useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
      initialUri: uri,
      userPinRequired: userPinRequired,
      issuerState: issuerState,
    );
  }

  final issuerOpenIdConfiguration = await oidc4vc.getIssuerMetaData(
    baseUrl: issuer,
    dio: client.dio,
  );

  if (preAuthorizedCode == null) {
    final grantTypesSupported = issuerOpenIdConfiguration.grantTypesSupported;
    if (grantTypesSupported != null && grantTypesSupported.isNotEmpty) {
      if (!grantTypesSupported.contains('authorization_code')) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'No grant specified.',
          },
        );
      }
    }
  }

  final Oidc4vcParameters oidc4vcParametersfromIssuer = Oidc4vcParameters(
    oidc4vciDraftType: oidc4vciDraftType,
    useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
    initialUri: uri,
    classIssuerOpenIdConfiguration: issuerOpenIdConfiguration,
    classCredentialOffer: credentialOfferJson,
    preAuthorizedCode: preAuthorizedCode,
    classIssuer: issuer,
    userPinRequired: userPinRequired,
    txCode: txCode,
    issuerState: '',
  );
  final Oidc4vcParameters oidc4vcParameters =
      await oidc4vc.authorizationParameters(
    oidc4vcParameters: oidc4vcParametersfromIssuer,
    dio: Dio(),
  );
  final credentialsSupported = issuerOpenIdConfiguration.credentialsSupported;
  final credentialConfigurationsSupported =
      issuerOpenIdConfiguration.credentialConfigurationsSupported;

  if (credentialsSupported == null &&
      credentialConfigurationsSupported == null) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_request',
        'error_description': 'The credential supported is missing.',
      },
    );
  }

  CredentialsSupported? credSupported;

  if (credentialsSupported != null) {
    credSupported = credentialsSupported[0];
  }
  for (final oidc4vcType in OIDC4VCType.values) {
    if (oidc4vcType.isEnabled && url.startsWith(oidc4vcType.offerPrefix)) {
      if (oidc4vcType == OIDC4VCType.DEFAULT ||
          oidc4vcType == OIDC4VCType.WALLET ||
          oidc4vcType == OIDC4VCType.EBSI) {
        if (credSupported?.trustFramework != null &&
            credSupported == credSupported?.trustFramework) {
          return oidc4vcParameters.copyWith(
            oidc4vcType: OIDC4VCType.DEFAULT,
          );
        }

        if (credSupported?.trustFramework?.name != null &&
            credSupported?.trustFramework?.name == 'ebsi') {
          return oidc4vcParameters.copyWith(
            oidc4vcType: OIDC4VCType.EBSI,
          );
        } else {
          return oidc4vcParameters.copyWith(
            oidc4vcType: OIDC4VCType.DEFAULT,
          );
        }
      }
      return oidc4vcParameters.copyWith(
        oidc4vcType: oidc4vcType,
      );
    }
  }

  return oidc4vcParameters;
}
