import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/home/home.dart';
import 'package:altme/issuer_websites_page/issuer_websites.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logging/logging.dart';

part 'qr_code_scan_cubit.g.dart';
part 'qr_code_scan_state.dart';

class QRCodeScanCubit extends Cubit<QRCodeScanState> {
  QRCodeScanCubit({
    required this.client,
    required this.requestClient,
    required this.scanCubit,
    required this.profileCubit,
    required this.walletCubit,
    required this.queryByExampleCubit,
    required this.deepLinkCubit,
    required this.jwtDecode,
  }) : super(const QRCodeScanState());

  final DioClient client;
  final DioClient requestClient;
  final ScanCubit scanCubit;
  final ProfileCubit profileCubit;
  final WalletCubit walletCubit;
  final QueryByExampleCubit queryByExampleCubit;
  final DeepLinkCubit deepLinkCubit;
  final JWTDecode jwtDecode;

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  Future<void> host({required String? url}) async {
    emit(state.loading(isDeepLink: false));
    try {
      if (url == null || url.isEmpty) {
        throw ResponseMessage(
          ResponseString
              .RESPONSE_STRING_THIS_QR_CODE_DOSE_NOT_CONTAIN_A_VALID_MESSAGE, // ignore: lines_longer_than_80_chars
        );
      } else {
        final uri = Uri.parse(url);
        await verify(uri: uri);
      }
    } on FormatException {
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString
                .RESPONSE_STRING_THIS_QR_CODE_DOSE_NOT_CONTAIN_A_VALID_MESSAGE, // ignore: lines_longer_than_80_chars
          ),
        ),
      );
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
            ),
          ),
        );
      }
    }
  }

  Future<void> deepLink() async {
    emit(state.loading(isDeepLink: true));
    final deepLinkUrl = deepLinkCubit.state;
    if (deepLinkUrl != '') {
      deepLinkCubit.resetDeepLink();
      try {
        final uri = Uri.parse(deepLinkUrl);
        await verify(uri: uri);
      } on FormatException {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_THIS_QR_CODE_DOSE_NOT_CONTAIN_A_VALID_MESSAGE, // ignore: lines_longer_than_80_chars
            ),
          ),
        );
      }
    }
  }

  Future<void> verify({required Uri? uri}) async {
    try {
      ///Check if SIOPV2 request
      if (uri?.queryParameters['scope'] == 'openid') {
        ///restrict non-enterprise user
        if (!profileCubit.state.model.isEnterprise) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE,
          );
        }

        ///credential should not be empty since we have to present
        if (walletCubit.state.credentials.isEmpty) {
          emit(
            state.error(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR,
              ),
            ),
          );
          emit(state.success(route: IssuerWebsitesPage.route('')));

          return;
        }

        ///request attribute check
        if (requestAttributeExists()) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
        }

        ///request_uri attribute check
        if (!requestUriAttributeExists()) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
        }

        final sIOPV2Param = await getSIOPV2Parameters();

        ///check if claims exists
        if (sIOPV2Param.claims == null) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
        }

        final openIdCredential = getCredential(sIOPV2Param.claims!);
        final openIdIssuer = getIssuer(sIOPV2Param.claims!);

        ///check if credential and issuer both are not present
        if (openIdCredential == '' && openIdIssuer == '') {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
        }

        final selectedCredentials = <CredentialModel>[];
        for (final credentialModel in walletCubit.state.credentials) {
          final credentialTypeList = credentialModel.credentialPreview.type;
          final issuer = credentialModel.credentialPreview.issuer;

          ///credential and issuer provided in claims
          if (openIdCredential != '' && openIdIssuer != '') {
            if (credentialTypeList.contains(openIdCredential) &&
                openIdIssuer == issuer) {}
          }

          ///credential provided in claims
          if (openIdCredential != '' && openIdIssuer == '') {
            if (credentialTypeList.contains(openIdCredential)) {
              selectedCredentials.add(credentialModel);
            }
          }

          ///issuer provided in claims
          if (openIdCredential == '' && openIdIssuer != '') {
            if (openIdIssuer == issuer) {
              selectedCredentials.add(credentialModel);
            }
          }
        }

        if (selectedCredentials.isEmpty) {
          emit(
            state.success(route: IssuerWebsitesPage.route(openIdCredential)),
          );
          return;
        }

        emit(
          state.success(
            route: SIOPV2CredentialPickPage.route(
              credentials: selectedCredentials,
              sIOPV2Param: sIOPV2Param,
            ),
          ),
        );
      } else {
        emit(state.acceptHost(uri: uri!));
      }
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
            ),
          ),
        );
      }
    }
  }

  Future<void> accept({required Uri uri}) async {
    emit(state.loading());
    final log = Logger('altme-wallet/qrcode/accept');

    late final dynamic data;

    try {
      final dynamic response = await client.get(uri.toString());
      data = response is String ? jsonDecode(response) : response;

      switch (data['type']) {
        case 'CredentialOffer':
          log.info('Credential Offer');
          emit(
            state.success(
              route: CredentialsReceivePage.route(
                uri: uri,
                preview: data as Map<String, dynamic>,
              ),
            ),
          );
          break;

        case 'VerifiablePresentationRequest':
          if (data['query'] != null) {
            queryByExampleCubit.setQueryByExampleCubit(
              (data['query']).first as Map<String, dynamic>,
            );
            if (data['query'].first['type'] == 'DIDAuth') {
              log.info('DIDAuth');
              await scanCubit.askPermissionDIDAuthCHAPI(
                keyId: 'key',
                done: (done) {
                  debugPrint('done');
                },
                uri: uri,
                challenge: data['challenge'] as String,
                domain: data['domain'] as String,
              );
            } else if (data['query'].first['type'] == 'QueryByExample') {
              log.info('QueryByExample');
              emit(
                state.success(
                  route: CredentialsPresentPage.route(
                    uri: uri,
                    preview: data as Map<String, dynamic>,
                  ),
                ),
              );
            } else {
              throw ResponseMessage(
                ResponseString.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE,
              );
            }
          } else {
            emit(
              state.success(
                route: CredentialsPresentPage.route(
                  uri: uri,
                  preview: data as Map<String, dynamic>,
                ),
              ),
            );
          }
          break;

        default:
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
      }
    } catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER, // ignore: lines_longer_than_80_chars
            ),
          ),
        );
      }
    }
  }

  bool requestAttributeExists() {
    var condition = false;
    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'request') {
        condition = true;
      }
    });
    return condition;
  }

  bool requestUriAttributeExists() {
    var condition = false;
    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'request_uri') {
        condition = true;
      }
    });
    return condition;
  }

  Future<SIOPV2Param> getSIOPV2Parameters() async {
    String? nonce;
    String? redirect_uri;
    String? request_uri;
    String? claims;
    String? requestUriPayload;

    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'nonce') {
        nonce = value;
      }
      if (key == 'redirect_uri') {
        redirect_uri = value;
      }
      if (key == 'claims') {
        claims = value;
      }
      if (key == 'request_uri') {
        request_uri = value;
      }
    });

    if (request_uri != null) {
      final dynamic encodedData =
          await fetchRequestUriPayload(url: request_uri!);
      if (encodedData != null) {
        requestUriPayload = decoder(token: encodedData as String);
      }
    }
    return SIOPV2Param(
      claims: claims,
      nonce: nonce,
      redirect_uri: redirect_uri,
      request_uri: request_uri,
      requestUriPayload: requestUriPayload,
    );
  }

  Future<dynamic> fetchRequestUriPayload({required String url}) async {
    final log = Logger('altme-wallet/qrcode/fetchRequestUriPayload');
    late final dynamic data;

    try {
      final dynamic response = await requestClient.get(url);
      data = response.toString();
    } catch (e) {
      log.severe('An error occurred while connecting to the server.', e);
    }
    return data;
  }

  String decoder({required String token}) {
    final log = Logger('altme-wallet/qrcode/jwtDecode');
    late final String data;

    try {
      final payload = jwtDecode.parseJwt(token);
      data = payload.toString();
    } catch (e) {
      log.severe('An error occurred while decoding.', e);
    }
    return data;
  }

  String getCredential(String claims) {
    final dynamic claimsJson = jsonDecode(claims);
    final fieldsPath = JsonPath(r'$..fields');
    final dynamic credentialField = fieldsPath
        .read(claimsJson)
        .first
        .value
        .where(
          (dynamic e) => e['path'].toString() == r'[$.credentialSubject.type]',
        )
        .toList()
        .first;
    return credentialField['filter']['pattern'] as String;
  }

  String getIssuer(String claims) {
    final dynamic claimsJson = jsonDecode(claims);
    final fieldsPath = JsonPath(r'$..fields');
    final dynamic issuerField = fieldsPath
        .read(claimsJson)
        .first
        .value
        .where(
          (dynamic e) => e['path'].toString() == r'[$.issuer]',
        )
        .toList()
        .first;
    return issuerField['filter']['pattern'] as String;
  }
}
