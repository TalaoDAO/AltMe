import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:passbase_flutter/passbase_flutter.dart';

part 'home_cubit.g.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.client,
    required this.didCubit,
  }) : super(const HomeState());

  final DioClient client;
  final DIDCubit didCubit;

  Timer? timer;

  void emitHasWallet() {
    emit(
      state.copyWith(
        status: AppStatus.populate,
        homeStatus: HomeStatus.hasWallet,
      ),
    );
  }

  void emitHasNoWallet() {
    emit(
      state.copyWith(
        status: AppStatus.populate,
        homeStatus: HomeStatus.hasNoWallet,
      ),
    );
  }

  Future<void> launchUrl({String? link}) async {
    await LaunchUrl.launch(link ?? state.link!);
  }

  int i = 0;

  Future<void> checkForPassBaseStatusThenLaunchUrl({
    required String link,
  }) async {
    emit(state.loading());
    final did = didCubit.state.did!;

    try {
      final passBaseStatus = await getPassBaseStatus(did);

      if (passBaseStatus == PassBaseStatus.approved) {
        await launchUrl(link: link);
        emit(
          state.copyWith(
            status: AppStatus.populate,
            passBaseStatus: PassBaseStatus.approved,
            link: link,
          ),
        );
      } else if (passBaseStatus == PassBaseStatus.declined) {
        emit(
          state.copyWith(
            status: AppStatus.populate,
            passBaseStatus: PassBaseStatus.declined,
            link: link,
          ),
        );
      } else if (passBaseStatus == PassBaseStatus.pending) {
        getPassBaseStatusBackground(link: link);
        emit(
          state.copyWith(
            status: AppStatus.populate,
            passBaseStatus: PassBaseStatus.pending,
            link: link,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppStatus.populate,
            passBaseStatus: PassBaseStatus.undone,
            link: link,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.populate,
          passBaseStatus: PassBaseStatus.declined,
          link: link,
        ),
      );
    }
  }

  void getPassBaseStatusBackground({
    required String link,
  }) {
    timer = Timer.periodic(const Duration(minutes: 3), (timer) async {
      timer.cancel();

      final did = didCubit.state.did!;

      try {
        final passBaseStatus = await getPassBaseStatus(did);
        if (passBaseStatus == PassBaseStatus.approved) {
          emit(
            state.copyWith(
              status: AppStatus.populate,
              passBaseStatus: PassBaseStatus.verified,
              link: link,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AppStatus.idle,
              passBaseStatus: PassBaseStatus.idle,
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: AppStatus.idle,
            passBaseStatus: PassBaseStatus.idle,
          ),
        );
      }
    });
  }

  void startPassbaseVerification(WalletCubit walletCubit) {
    emit(state.loading());
    final did = didCubit.state.did!;
    //setKYCMetadata(walletCubit);
    PassbaseSDK.startVerification(
      onFinish: (identityAccessKey) async {
        //22a363e6-2f93-4dd3-9ac8-6cba5a046acd
        try {
          final dynamic response = await client.post(
            '/wallet/webhook',
            headers: <String, dynamic>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer mytoken',
            },
            data: <String, dynamic>{
              'identityAccessKey': identityAccessKey,
              'DID': did,
            },
          );

          if (response == 'ok') {
            emit(
              state.copyWith(
                status: AppStatus.idle,
                passBaseStatus: PassBaseStatus.complete,
              ),
            );
          } else {
            throw Exception();
          }
        } catch (e) {
          emit(
            state.copyWith(
              status: AppStatus.populate,
              passBaseStatus: PassBaseStatus.declined,
            ),
          );
        }
      },
    );
  }

  Future<PassBaseStatus> getPassBaseStatus(String did) async {
    try {
      final dynamic response = await client.get(
        '/passbase/check/$did',
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'Authorization': 'Bearer mytoken',
        },
      );

      switch (response) {
        case 'approved':
          return PassBaseStatus.approved;
        case 'declined':
          return PassBaseStatus.declined;
        case 'pending':
          return PassBaseStatus.pending;
        case 'undone':
          return PassBaseStatus.undone;
        case 'notdone':
          return PassBaseStatus.undone;
        default:
          return PassBaseStatus.undone;
      }
    } catch (e) {
      return PassBaseStatus.undone;
    }
  }

  /// Give user metadata to KYC. Currently we are just sending user DID.
  bool setKYCMetadata(WalletCubit walletCubit) {
    final selectedCredentials = <CredentialModel>[];
    for (final credentialModel in walletCubit.state.credentials) {
      final credentialTypeList = credentialModel.credentialPreview.type;

      ///credential and issuer provided in claims
      if (credentialTypeList.contains('EmailPass')) {
        final credentialSubjectModel = credentialModel
            .credentialPreview.credentialSubjectModel as EmailPassModel;
        if (credentialSubjectModel.passbaseMetadata != '') {
          selectedCredentials.add(credentialModel);
        }
      }
    }
    if (selectedCredentials.isNotEmpty) {
      final firstEmailPassCredentialSubject =
          selectedCredentials.first.credentialPreview.credentialSubjectModel;
      if (firstEmailPassCredentialSubject is EmailPassModel) {
        /// Give user email from first EmailPass to KYC. When KYC is successful
        /// this email is used to send the over18 credential link to user.

        PassbaseSDK.prefillUserEmail = firstEmailPassCredentialSubject.email;
        PassbaseSDK.metaData = firstEmailPassCredentialSubject.passbaseMetadata;
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
