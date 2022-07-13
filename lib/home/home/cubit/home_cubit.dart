import 'package:altme/app/app.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/home/home.dart';
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

  Future<void> checkForPassBaseStatusThenLaunchUrl({
    required String link,
  }) async {
    emit(state.loading());
    final did = didCubit.state.did!;

    final passBaseStatus = await getPassBaseStatus(did);

    if (passBaseStatus == PassBaseStatus.approved) {
      await LaunchUrl.launch(link);
      emit(
        state.copyWith(
          status: AppStatus.populate,
          passBaseStatus: PassBaseStatus.approved,
        ),
      );
    } else if (passBaseStatus == PassBaseStatus.declined) {
      emit(
        state.copyWith(
          status: AppStatus.populate,
          passBaseStatus: PassBaseStatus.declined,
        ),
      );
    } else if (passBaseStatus == PassBaseStatus.pending) {
      emit(
        state.copyWith(
          status: AppStatus.populate,
          passBaseStatus: PassBaseStatus.pending,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AppStatus.populate,
          passBaseStatus: PassBaseStatus.undone,
        ),
      );
    }
  }

  void startPassbaseVerification(WalletCubit walletCubit) {
    setKYCMetadata(walletCubit);
    PassbaseSDK.startVerification(
      onFinish: (identityAccessKey) {
        //e.g 7760b08c-15d8-4132-8e7c-b9e39a2c29f0
        emit(state.copyWith(status: AppStatus.success, passBaseStatus: null));
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
}
