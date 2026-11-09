import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

part 'home_cubit.g.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.client,
    required this.secureStorageProvider,
    required this.oidc4vc,
    required this.profileCubit,
    required this.didKitProvider,
  }) : super(const HomeState());

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;
  final OIDC4VCIClient oidc4vc;
  final ProfileCubit profileCubit;
  final DIDKitProvider didKitProvider;

  final log = getLogger('HomeCubit');

  Future<void> emitHasWallet() async {
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
}
