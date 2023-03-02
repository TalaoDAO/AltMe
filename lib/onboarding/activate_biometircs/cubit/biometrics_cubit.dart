import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/onboarding/helper_function/helper_function.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

part 'biometrics_cubit.g.dart';
part 'biometrics_state.dart';

class BiometricsCubit extends Cubit<BiometricsState> {
  BiometricsCubit({
    required this.secureStorageProvider,
    required this.keyGenerator,
    required this.didKitProvider,
    required this.didCubit,
    required this.homeCubit,
    required this.walletCubit,
    required this.splashCubit,
  }) : super(const BiometricsState()) {
    init();
  }

  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final DIDKitProvider didKitProvider;
  final DIDCubit didCubit;
  final HomeCubit homeCubit;
  final WalletCubit walletCubit;
  final SplashCubit splashCubit;

  Future<void> init() async {
    final fingerprintEnabled =
        await getSecureStorage.get(SecureStorageKeys.fingerprintEnabled);
    setFingerprintEnabled(enabled: fingerprintEnabled == true.toString());
  }

  void setFingerprintEnabled({bool enabled = false}) {
    emit(state.copyWith(isBiometricsEnabled: enabled));
  }

  Future<void> generateSSIAndCryptoAccount(List<String> mnemonic) async {
    final log = getLogger('BiometricsCubit');
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      await generateAccount(
        mnemonic: mnemonic,
        secureStorageProvider: secureStorageProvider,
        keyGenerator: keyGenerator,
        didKitProvider: didKitProvider,
        didCubit: didCubit,
        homeCubit: homeCubit,
        walletCubit: walletCubit,
        splashCubit: splashCubit,
      );
      emit(state.success());
    } catch (error) {
      log.e('something went wrong when generating a key', error);
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY,
          ),
        ),
      );
    }
  }
}
