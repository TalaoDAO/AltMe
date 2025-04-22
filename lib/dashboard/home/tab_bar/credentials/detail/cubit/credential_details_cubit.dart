import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:altme/oidc4vc/helper_function/verify_encoded_data.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

part 'credential_details_cubit.g.dart';
part 'credential_details_state.dart';

class CredentialDetailsCubit extends Cubit<CredentialDetailsState> {
  CredentialDetailsCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.client,
    required this.jwtDecode,
    required this.profileCubit,
  }) : super(const CredentialDetailsState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final DioClient client;
  final JWTDecode jwtDecode;
  final ProfileCubit profileCubit;

  void changeTabStatus(CredentialDetailTabStatus credentialDetailTabStatus) {
    emit(state.copyWith(credentialDetailTabStatus: credentialDetailTabStatus));
  }

  Future<void> verifyCredential(CredentialModel item) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      String? statusListUri;
      int? statusListIndex;

      if (!customOidc4vcProfile.securityLevel) {
        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.noStatus,
            status: AppStatus.idle,
          ),
        );
        return;
      }

      if (item.credentialPreview.credentialSubjectModel.credentialSubjectType ==
          CredentialSubjectType.walletCredential) {
        final jwt = item.jwt;

        if (jwt != null) {
          final payload = JWTDecode().parseJwt(jwt);
          final status = payload['status'];
          if (status != null && status is Map<String, dynamic>) {
            final statusList = status['status_list'];
            if (statusList != null && statusList is Map<String, dynamic>) {
              statusListUri = statusList['uri']?.toString();
              statusListIndex = int.tryParse(statusList['idx'].toString());
            }
          }
        }

        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.active,
            status: AppStatus.idle,
          ),
        );
        return;
      }

      if (item.expirationDate != null) {
        final DateTime dateTimeExpirationDate =
            UiDate.parseExpirationDate(item.expirationDate!);
        if (!dateTimeExpirationDate.isAfter(DateTime.now())) {
          emit(
            state.copyWith(
              credentialStatus: CredentialStatus.expired,
              status: AppStatus.idle,
            ),
          );
          return;
        }
      }

      /// sd-jwt
      final credentialSupported = item.credentialSupported;
      final claims = credentialSupported?['claims'];

      final data = item.data;

      final listOfSd = collectSdValues(data);

      if (claims != null && listOfSd.isNotEmpty) {
        /// check the status
        final status = item.data['status'];

        if (status != null && status is Map<String, dynamic>) {
          final statusList = status['status_list'];
          if (statusList != null && statusList is Map<String, dynamic>) {
            statusListUri = statusList['uri']?.toString();
            statusListIndex = int.tryParse(statusList['idx'].toString());

            if (statusListUri != null && statusListIndex is int) {
              final headers = {
                'Content-Type': 'application/json; charset=UTF-8',
                'accept': 'application/statuslist+jwt',
              };

              final response = await client.get(
                statusListUri,
                headers: headers,
                isCachingEnabled: customOidc4vcProfile.statusListCache,
                options: Options().copyWith(
                  sendTimeout: const Duration(seconds: 10),
                  receiveTimeout: const Duration(seconds: 10),
                ),
              );

              final payload = jwtDecode.parseJwt(response.toString());

              /// verify the signature of the VC with the kid of the JWT
              final VerificationType isVerified = await verifyEncodedData(
                issuer: payload['iss']?.toString() ?? item.issuer,
                jwtDecode: jwtDecode,
                jwt: response.toString(),
                fromStatusList: true,
                isCachingEnabled: customOidc4vcProfile.statusListCache,
                useOAuthAuthorizationServerLink:
                    useOauthServerAuthEndPoint(profileCubit.state.model),
              );

              if (isVerified != VerificationType.verified) {
                emit(
                  state.copyWith(
                    credentialStatus:
                        CredentialStatus.statusListInvalidSignature,
                    status: AppStatus.idle,
                  ),
                );
                return;
              }

              final newStatusList = payload['status_list'];
              if (newStatusList != null &&
                  newStatusList is Map<String, dynamic>) {
                final lst = newStatusList['lst'].toString();

                final bit = getBit(index: statusListIndex, encodedList: lst);

                if (bit == 0) {
                  // active
                } else {
                  // revoked
                  emit(
                    state.copyWith(
                      credentialStatus:
                          CredentialStatus.statusListInvalidSignature,
                      status: AppStatus.idle,
                    ),
                  );
                  return;
                }
              }
            }
          }
        }
      }

      final credentialStatus = item.credentialPreview.credentialStatus;
      if (credentialStatus != null) {
        if (credentialStatus is Map<String, dynamic>) {
          final isStatusInvalid = await checkStatusList(
            credentialStatus: credentialStatus,
            item: item,
          );
          if (isStatusInvalid) return;
        }
        if (credentialStatus is List<dynamic>) {
          for (final iteratedData in credentialStatus) {
            if (iteratedData is Map<String, dynamic>) {
              final isStatusInvalid = await checkStatusList(
                credentialStatus: iteratedData,
                item: item,
              );
              if (isStatusInvalid) return;
            }
          }
        }
      }

      if (item.jwt != null) {
        final jwt = item.jwt!;
        final Map<String, dynamic> payload = jwtDecode.parseJwt(jwt);
        final Map<String, dynamic> header =
            decodeHeader(jwtDecode: jwtDecode, token: jwt);

        Map<String, dynamic>? publicKeyJwk;

        final x5c = header['x5c'];
        if (x5c != null && x5c is List) {
          publicKeyJwk = await checkX509(
            encodedData: jwt,
            header: header,
            clientId: payload['iss'].toString(),
          );
        }

        final VerificationType isVerified = await verifyEncodedData(
          issuer: item.issuer,
          jwtDecode: jwtDecode,
          jwt: jwt,
          publicKeyJwk: publicKeyJwk,
          useOAuthAuthorizationServerLink:
              useOauthServerAuthEndPoint(profileCubit.state.model),
          isSdJwtVc: item.getFormat == VCFormatType.vcSdJWT.vcValue,
        );

        if (isVerified == VerificationType.verified) {
          emit(
            state.copyWith(
              credentialStatus: CredentialStatus.active,
              status: AppStatus.idle,
            ),
          );
        } else {
          emit(
            state.copyWith(
              credentialStatus: CredentialStatus.invalidSignature,
              status: AppStatus.idle,
            ),
          );
        }
      } else {
        if (item.credentialPreview.credentialStatus != null) {
          final CredentialStatus credentialStatus =
              await item.checkRevocationStatus();
          if (credentialStatus == CredentialStatus.active) {
            await verifyProofOfPurpose(item);
          } else {
            emit(
              state.copyWith(
                credentialStatus: CredentialStatus.invalidStatus,
                status: AppStatus.idle,
              ),
            );
          }
        } else {
          await verifyProofOfPurpose(item);
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          credentialStatus: CredentialStatus.invalidStatus,
          status: AppStatus.idle,
        ),
      );
    }
  }

  Future<void> verifyProofOfPurpose(CredentialModel item) async {
    if (item.data.isEmpty) {
      return emit(
        state.copyWith(
          credentialStatus: CredentialStatus.pending,
          status: AppStatus.idle,
        ),
      );
    }
    final vcStr = jsonEncode(item.data);
    final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
    final result = await didKitProvider.verifyCredential(vcStr, optStr);
    final jsonResult = jsonDecode(result) as Map<String, dynamic>;

    if ((jsonResult['warnings'] as List).isNotEmpty) {
      emit(
        state.copyWith(
          credentialStatus: CredentialStatus.active,
          status: AppStatus.idle,
        ),
      );
    } else if ((jsonResult['errors'] as List).isNotEmpty) {
      if (jsonResult['errors'][0] == 'No applicable proof') {
        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.invalidStatus,
            status: AppStatus.idle,
          ),
        );
      } else {
        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.invalidStatus,
            status: AppStatus.idle,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          credentialStatus: CredentialStatus.active,
          status: AppStatus.idle,
        ),
      );
    }
  }

  Future<bool> checkStatusList({
    required Map<String, dynamic> credentialStatus,
    required CredentialModel item,
  }) async {
    final data = CredentialStatusField.fromJson(credentialStatus);

    final statusListUri = data.statusListCredential;
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      // 'accept': 'application/statuslist+jwt',
    };
    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    // TODO(hawkbee): Using Dio directly is solving the issue but it probably
    /// means an issue.
    /// in the paramaers of DioClient
    /// Status invalid of an emailpass in a jwt_vc_json format #3283
    final response = await Dio().get<String>(
      statusListUri,
      options: Options(
        headers: headers,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final payload = jwtDecode.parseJwt(response.toString());

    // verify the signature of the VC with the kid of the JWT
    final VerificationType isVerified = await verifyEncodedData(
      issuer: payload['iss']?.toString() ?? item.issuer,
      jwtDecode: jwtDecode,
      jwt: response.toString(),
      fromStatusList: true,
      isCachingEnabled: customOidc4vcProfile.statusListCache,
      useOAuthAuthorizationServerLink:
          useOauthServerAuthEndPoint(profileCubit.state.model),
    );

    if (isVerified != VerificationType.verified) {
      emit(
        state.copyWith(
          credentialStatus: CredentialStatus.statusListInvalidSignature,
          status: AppStatus.idle,
        ),
      );
      return true;
    }

    final vc = payload['vc'];
    if (vc != null && vc is Map<String, dynamic>) {
      final credentialSubject = vc['credentialSubject'];
      if (credentialSubject != null &&
          credentialSubject is Map<String, dynamic>) {
        final encodedList = credentialSubject['encodedList'];

        if (encodedList != null && encodedList is String) {
          final statusListIndex = int.tryParse(data.statusListIndex);
          if (statusListIndex == null) {
            throw Exception('statusListIndex is not a numeric value');
          }
          final bit = getBit(
            index: statusListIndex,
            encodedList: encodedList,
          );

          if (bit == 0) {
            // active
          } else {
            // revoked
            emit(
              state.copyWith(
                credentialStatus: CredentialStatus.invalidStatus,
                status: AppStatus.idle,
              ),
            );
            return true;
          }
        }
      }
    }
    return false;
  }
}
