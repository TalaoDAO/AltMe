import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/qr_code/qr_code.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
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
    required this.queryByExampleCubit,
    required this.deepLinkCubit,
    required this.jwtDecode,
  }) : super(const QRCodeScanStateWorking());

  final DioClient client;
  final DioClient requestClient;
  final ScanCubit scanCubit;
  final QueryByExampleCubit queryByExampleCubit;
  final DeepLinkCubit deepLinkCubit;
  final JWTDecode jwtDecode;

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  void emitWorkingState() {
    emit(QRCodeScanStateWorking(isDeepLink: state.isDeepLink));
  }

  Future<void> host({required String? url, required bool isDeepLink}) async {
    try {
      if (url == null) {
        emit(
          QRCodeScanStateMessage(
            isDeepLink: isDeepLink,
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_THIS_QR_CODE_DOSE_NOT_CONTAIN_A_VALID_MESSAGE, // ignore: lines_longer_than_80_chars
              ),
            ),
          ),
        );
      } else {
        final uri = Uri.parse(url);

        /// current QRCodeScanStateMessage may already be the
        /// QRCodeScanStateHost we want to emit and nothing will happen if
        /// that's the case.
        ///
        /// In order to avoid this, we emit QRCodeScanStateWorking which
        /// don't trigger any action.
        emit(QRCodeScanStateWorking(isDeepLink: isDeepLink));
        emit(QRCodeScanStateHost(isDeepLink: isDeepLink, uri: uri));
      }
    } on FormatException {
      emit(
        QRCodeScanStateMessage(
          isDeepLink: isDeepLink,
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_THIS_QR_CODE_DOSE_NOT_CONTAIN_A_VALID_MESSAGE, // ignore: lines_longer_than_80_chars
            ),
          ),
        ),
      );
    }
  }

  Future<void> deepLink() async {
    final deepLinkUrl = deepLinkCubit.state;
    if (deepLinkUrl != '') {
      deepLinkCubit.resetDeepLink();
      try {
        final uri = Uri.parse(deepLinkUrl);
        emit(QRCodeScanStateHost(uri: uri, isDeepLink: true));
      } on FormatException {
        emit(
          QRCodeScanStateMessage(
            isDeepLink: true,
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_THIS_QR_CODE_DOSE_NOT_CONTAIN_A_VALID_MESSAGE, // ignore: lines_longer_than_80_chars
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> accept({required Uri uri}) async {
    final log = Logger('altme-wallet/qrcode/accept');

    late final dynamic data;

    try {
      final dynamic response = await client.get(uri.toString());
      data = response is String ? jsonDecode(response) : response;

      scanCubit.emitScanStatePreview(preview: data as Map<String, dynamic>);
      switch (data['type']) {
        case 'CredentialOffer':
          emit(
            QRCodeScanStateSuccess(
              isDeepLink: state.isDeepLink,
              route: CredentialsReceivePage.route(uri),
            ),
          );
          break;

        case 'VerifiablePresentationRequest':
          if (data['query'] != null) {
            queryByExampleCubit.setQueryByExampleCubit(
              (data['query']).first as Map<String, dynamic>,
            );
            if (data['query'].first['type'] == 'DIDAuth') {
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
              emit(
                QRCodeScanStateSuccess(
                  isDeepLink: state.isDeepLink,
                  route: CredentialsPresentPage.route(uri: uri),
                ),
              );
            } else {
              throw UnimplementedError('Unimplemented Query Type');
            }
          } else {
            emit(
              QRCodeScanStateSuccess(
                isDeepLink: state.isDeepLink,
                route: CredentialsPresentPage.route(uri: uri),
              ),
            );
          }
          break;

        default:
          emit(
            QRCodeScanStateUnknown(
              isDeepLink: state.isDeepLink,
              uri: state.uri!,
            ),
          );
          break;
      }
    } catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      emit(
        QRCodeScanStateMessage(
          isDeepLink: true,
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER, // ignore: lines_longer_than_80_chars
            ),
          ),
        ),
      );
    }
  }

  bool isOpenIdUrl() {
    var condition = false;
    if (state.uri?.queryParameters['scope'] == 'openid') {
      condition = true;
    }
    return condition;
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

  Future<SIOPV2Param> getSIOPV2Parameters({required bool isDeepLink}) async {
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

  void emitQRCodeScanStateUnknown() {
    emit(QRCodeScanStateUnknown(isDeepLink: state.isDeepLink, uri: state.uri!));
  }
}
