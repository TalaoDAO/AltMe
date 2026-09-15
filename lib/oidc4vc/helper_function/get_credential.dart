import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:dio/dio.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// Retreive credential_type from url
// encodedCredentialOrFutureTokens,deferredCredentialEndpoint,
// format
Future<(List<dynamic>?, String?, String?)?> getCredential({
  required Oidc4vcParameters oidc4vcParameters,
  required dynamic credential,
  required ProfileCubit profileCubit,
  required bool cryptoHolderBinding,
  required DidKeyType didKeyType,
  required String? clientId,
  required String accessToken,
  required List<dynamic>? authorizationDetails,
  required QRCodeScanCubit qrCodeScanCubit,
  required String publicKeyForDPop,
  required String? cnonce,
}) async {
  final privateKey = await fetchPrivateKey(
    isEBSI: oidc4vcParameters.oidc4vcType == OIDC4VCType.EBSI,
    didKeyType: didKeyType,
    profileCubit: profileCubit,
  );

  final (did, kid) = await fetchDidAndKid(
    isEBSI: oidc4vcParameters.oidc4vcType == OIDC4VCType.EBSI,
    privateKey: privateKey,
    didKeyType: didKeyType,
    profileCubit: profileCubit,
  );

  final customOidc4vcProfile = profileCubit
      .state
      .model
      .profileSetting
      .selfSovereignIdentityOptions
      .customOidc4vcProfile;

  var nonce = cnonce;
  print('nonce: $nonce');

  final (
    credentialType,
    types,
    credentialDefinition,
    vct,
    format,
  ) = await profileCubit.oidc4vc.getCredentialData(
    openIdConfiguration: oidc4vcParameters.issuerOpenIdConfiguration,
    credential: credential,
  );

  final credentialResponseData = <dynamic>[];

  final issuerTokenParameters = IssuerTokenParameters(
    privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
    did: did,
    kid: kid,
    issuer: oidc4vcParameters.issuer,
    mediaType: MediaType.proofOfOwnership,
    clientType: customOidc4vcProfile.clientType,
    proofHeaderType: customOidc4vcProfile.proofHeader,
    clientId: clientId ?? '',
  );

  /// Builds the Credential Request for a single credential_identifier (or
  /// none, when the Token Response did not return any for this credential)
  /// and sends it. Returns false when the developer-mode preview was
  /// cancelled, meaning the whole flow should stop.
  Future<bool> sendCredentialRequest({
    required String? credentialIdentifier,
  }) async {
    final credentialData = await profileCubit.oidc4vc.buildCredentialData(
      nonce: nonce,
      issuerTokenParameters: issuerTokenParameters,
      credentialType: credentialType,
      types: types,
      format: format,
      credentialIdentifier: credentialIdentifier,
      cryptoHolderBinding: cryptoHolderBinding,
      credentialDefinition: credentialDefinition,
      clientAuthentication: customOidc4vcProfile.clientAuthentication,
      vct: vct,
      proofType: customOidc4vcProfile.proofType,
      did: did,
      kid: kid,
      privateKey: privateKey,
      formatsSupported: customOidc4vcProfile.formatsSupported ?? [],
      oidc4vcParameters: oidc4vcParameters,
      clientId: clientId,
    );

    if (profileCubit.state.model.isDeveloperMode) {
      final value = await qrCodeScanCubit.showDataBeforeSending(
        title: 'CREDENTIAL REQUEST',
        data: credentialData,
      );

      if (value) {
        qrCodeScanCubit.completer = null;
      } else {
        qrCodeScanCubit.completer = null;
        qrCodeScanCubit.resetNonceAndAccessTokenAndAuthorizationDetails();
        qrCodeScanCubit.goBack();
        return false;
      }
    }

    final credentialResponseDataValue = await getSingleCredentialData(
      profileCubit: profileCubit,
      openIdConfiguration: oidc4vcParameters.issuerOpenIdConfiguration,
      accessToken: accessToken,
      dio: Dio(),
      credentialData: credentialData,
      publicKeyForDPop: publicKeyForDPop,
    );

    /// update nonce value
    if (credentialResponseDataValue is Map<String, dynamic>) {
      if (credentialResponseDataValue.containsKey('c_nonce')) {
        nonce = credentialResponseDataValue['c_nonce'].toString();
      }
    }
  print('nonce_update: $nonce');

    credentialResponseData.add(credentialResponseDataValue);
    return true;
  }

  if (authorizationDetails != null) {
    final dynamic authDetailForCredential = authorizationDetails
        .where(
          (dynamic ele) =>
              ele is Map<String, dynamic> &&
              ((ele.containsKey('credential_configuration_id') &&
                      ele['credential_configuration_id'] == credentialType) ||
                  (ele.containsKey('types') &&
                      (ele['types'] as List).contains(credentialType)) ||
                  (ele.containsKey('credential_definition') &&
                      (ele['credential_definition']['type'] as List).contains(
                        credentialType,
                      ))),
        )
        .firstOrNull;

    if (authDetailForCredential == null) {
      throw Exception('AUTHORIZATION_DETAIL_ERROR');
    }

    /// credential_identifiers is OPTIONAL in the Token Response: when it is
    /// absent, the wallet falls back to a single Credential Request using
    /// credential_configuration_id, same as when authorization_details is
    /// absent entirely.
    final rawCredentialIdentifiers =
        authDetailForCredential['credential_identifiers'];

    final credentialIdentifiers = rawCredentialIdentifiers is List
        ? rawCredentialIdentifiers
              .map((dynamic element) => element.toString())
              .toList()
        : <String>[];

    if (credentialIdentifiers.isEmpty) {
      if (!await sendCredentialRequest(credentialIdentifier: null)) {
        return null;
      }
    } else {
      for (final credentialIdentifier in credentialIdentifiers) {
        if (!await sendCredentialRequest(
          credentialIdentifier: credentialIdentifier,
        )) {
          return null;
        }
      }
    }
  } else {
    if (!await sendCredentialRequest(credentialIdentifier: null)) {
      return null;
    }
  }

  final deferredCredentialEndpoint = profileCubit.oidc4vc
      .getDeferredCredentialEndpoint(
        oidc4vcParameters.issuerOpenIdConfiguration,
      );

  return (credentialResponseData, deferredCredentialEndpoint, format);
}

int count = 0;

Future<dynamic> getSingleCredentialData({
  required ProfileCubit profileCubit,
  required OpenIdConfiguration openIdConfiguration,
  required String accessToken,
  required Dio dio,
  required Map<String, dynamic> credentialData,
  required String publicKeyForDPop,
}) async {
  final credentialEndpoint = profileCubit.oidc4vc.readCredentialEndpoint(
    openIdConfiguration,
  );

  final customOidc4vcProfile = profileCubit
      .state
      .model
      .profileSetting
      .selfSovereignIdentityOptions
      .customOidc4vcProfile;
  try {
    String? dPop;

    if (customOidc4vcProfile.dpopSupport) {
      dPop = await getDPopJwt(
        url: credentialEndpoint,
        accessToken: accessToken,
        publicKey: publicKeyForDPop,
      );
    }

    final credentialResponseDataValue = await profileCubit.oidc4vc
        .getSingleCredential(
          accessToken: accessToken,
          dio: Dio(),
          credentialData: credentialData,
          credentialEndpoint: credentialEndpoint,
          dPop: dPop,
        );

    return credentialResponseDataValue;
  } catch (e) {
    rethrow;
  }
}
