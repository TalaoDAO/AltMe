import 'dart:convert';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/verify_encoded_data.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:polygonid/polygonid.dart';
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
    required this.polygonIdCubit,
  }) : super(const CredentialDetailsState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final DioClient client;
  final JWTDecode jwtDecode;
  final ProfileCubit profileCubit;
  final PolygonIdCubit polygonIdCubit;

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
              final idx = statusList['idx'];
              statusListIndex = idx is int ? idx : null;
            }
          }
        }

        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.active,
            status: AppStatus.idle,
            statusListIndex: statusListIndex,
            statusListUrl: statusListUri,
          ),
        );
        return;
      }

      if (item.expirationDate != null) {
        final DateTime dateTimeExpirationDate =
            DateTime.parse(item.expirationDate!);
        if (!dateTimeExpirationDate.isAfter(DateTime.now())) {
          emit(
            state.copyWith(
              credentialStatus: CredentialStatus.expired,
              status: AppStatus.idle,
              statusListIndex: statusListIndex,
              statusListUrl: statusListUri,
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
        final selectiveDisclosure = SelectiveDisclosure(item);
        final decryptedDatas = selectiveDisclosure.contents;

        /// check if sd already contain sh256 hash
        for (final element in decryptedDatas) {
          final sh256Hash = profileCubit.oidc4vc.sh256HashOfContent(element);

          if (!listOfSd.contains(sh256Hash)) {
            emit(
              state.copyWith(
                credentialStatus: CredentialStatus.invalidSignature,
                status: AppStatus.idle,
                statusListIndex: statusListIndex,
                statusListUrl: statusListUri,
              ),
            );
            return;
          }
        }

        /// check the status
        final status = item.data['status'];

        if (status != null && status is Map<String, dynamic>) {
          final statusList = status['status_list'];
          if (statusList != null && statusList is Map<String, dynamic>) {
            statusListUri = statusList['uri']?.toString();

            final idx = statusList['idx'];
            statusListIndex = idx is int ? idx : null;

            if (statusListUri != null && statusListIndex is int) {
              final headers = {
                'Content-Type': 'application/json; charset=UTF-8',
                'accept': 'application/statuslist+jwt',
              };

              final response = await client.get(
                statusListUri,
                headers: headers,
                isCachingEnabled: customOidc4vcProfile.statusListCache,
              );

              final payload = jwtDecode.parseJwt(response.toString());

              /// verify the signature of the VC with the kid of the JWT
              final VerificationType isVerified = await verifyEncodedData(
                issuer: payload['iss']?.toString() ?? item.issuer,
                jwtDecode: jwtDecode,
                jwt: response.toString(),
                fromStatusList: true,
                isCachingEnabled: customOidc4vcProfile.statusListCache,
              );

              if (isVerified != VerificationType.verified) {
                emit(
                  state.copyWith(
                    credentialStatus:
                        CredentialStatus.statusListInvalidSignature,
                    status: AppStatus.idle,
                    statusListIndex: statusListIndex,
                    statusListUrl: statusListUri,
                  ),
                );
                return;
              }

              final newStatusList = payload['status_list'];
              if (newStatusList != null &&
                  newStatusList is Map<String, dynamic>) {
                final lst = newStatusList['lst'].toString();

                final bytes = profileCubit.oidc4vc.getByte(statusListIndex);

                // '$idx = $bytes X 8 + $posOfBit'
                final decompressedBytes =
                    profileCubit.oidc4vc.decodeAndZlibDecompress(lst);
                final byteToCheck = decompressedBytes[bytes];

                final posOfBit =
                    profileCubit.oidc4vc.getPositionOfZlibBit(statusListIndex);
                final bit = profileCubit.oidc4vc
                    .getBit(byte: byteToCheck, bitPosition: posOfBit);

                if (bit == 0) {
                  // active
                } else {
                  // revoked
                  emit(
                    state.copyWith(
                      credentialStatus: CredentialStatus.invalidStatus,
                      status: AppStatus.idle,
                      statusListIndex: statusListIndex,
                      statusListUrl: statusListUri,
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
        if (credentialStatus is List<dynamic>) {
          for (final iteratedData in credentialStatus) {
            if (iteratedData is Map<String, dynamic>) {
              final data = CredentialStatusField.fromJson(iteratedData);

              statusListUri = data.statusListCredential;
              final headers = {
                'Content-Type': 'application/json; charset=UTF-8',
                'accept': 'application/statuslist+jwt',
              };

              final response = await client.get(
                statusListUri,
                headers: headers,
                isCachingEnabled: customOidc4vcProfile.statusListCache,
              );

              final payload = jwtDecode.parseJwt(response.toString());

              // verify the signature of the VC with the kid of the JWT
              final VerificationType isVerified = await verifyEncodedData(
                issuer: payload['iss']?.toString() ?? item.issuer,
                jwtDecode: jwtDecode,
                jwt: response.toString(),
                fromStatusList: true,
                isCachingEnabled: customOidc4vcProfile.statusListCache,
              );

              if (isVerified != VerificationType.verified) {
                emit(
                  state.copyWith(
                    credentialStatus:
                        CredentialStatus.statusListInvalidSignature,
                    status: AppStatus.idle,
                    statusListIndex: statusListIndex,
                    statusListUrl: statusListUri,
                  ),
                );
                return;
              }

              final vc = payload['vc'];
              if (vc != null && vc is Map<String, dynamic>) {
                final credentialSubject = vc['credentialSubject'];
                if (credentialSubject != null &&
                    credentialSubject is Map<String, dynamic>) {
                  final encodedList = credentialSubject['encodedList'];

                  if (encodedList != null && encodedList is String) {
                    final decompressedBytes = profileCubit.oidc4vc
                        .decodeAndGzibDecompress(encodedList);

                    statusListIndex = int.parse(data.statusListIndex);

                    final bytes = profileCubit.oidc4vc.getByte(statusListIndex);
                    final byteToCheck = decompressedBytes[bytes];
                    final posOfBit = profileCubit.oidc4vc
                        .getPositionOfGZipBit(statusListIndex);
                    final bit = profileCubit.oidc4vc
                        .getBit(byte: byteToCheck, bitPosition: posOfBit);

                    if (bit == 0) {
                      // active
                    } else {
                      // revoked
                      emit(
                        state.copyWith(
                          credentialStatus: CredentialStatus.invalidStatus,
                          status: AppStatus.idle,
                          statusListIndex: statusListIndex,
                          statusListUrl: statusListUri,
                        ),
                      );
                      return;
                    }
                  }
                }
              }
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
        );

        if (isVerified == VerificationType.verified) {
          emit(
            state.copyWith(
              credentialStatus: CredentialStatus.active,
              status: AppStatus.idle,
              statusListIndex: statusListIndex,
              statusListUrl: statusListUri,
            ),
          );
        } else {
          emit(
            state.copyWith(
              credentialStatus: CredentialStatus.invalidSignature,
              status: AppStatus.idle,
              statusListIndex: statusListIndex,
              statusListUrl: statusListUri,
            ),
          );
        }
      } else if (item.isPolygonssuer) {
        final mnemonic =
            await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);
        await polygonIdCubit.initialise();

        String network = Parameters.POLYGON_MAIN_NETWORK;

        if (item.issuer.contains('polygon:main')) {
          network = Parameters.POLYGON_MAIN_NETWORK;
        } else {
          network = Parameters.POLYGON_TEST_NETWORK;
        }

        final List<ClaimEntity> claim =
            await polygonIdCubit.polygonId.getClaimById(
          claimId: item.id,
          mnemonic: mnemonic!,
          network: network,
        );

        late CredentialStatus credentialStatus;

        if (claim.isEmpty) {
          credentialStatus = CredentialStatus.invalidStatus;
        } else {
          switch (claim[0].state) {
            case ClaimState.active:
              credentialStatus = CredentialStatus.active;
            case ClaimState.expired:
              credentialStatus = CredentialStatus.expired;
            case ClaimState.pending:
              credentialStatus = CredentialStatus.pending;
            case ClaimState.revoked:
              credentialStatus = CredentialStatus.invalidStatus;
          }
        }

        emit(
          state.copyWith(
            credentialStatus: credentialStatus,
            status: AppStatus.idle,
            statusListIndex: statusListIndex,
            statusListUrl: statusListUri,
          ),
        );
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
                statusListIndex: statusListIndex,
                statusListUrl: statusListUri,
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
}
