import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'advance_settings_cubit.g.dart';

part 'advance_settings_state.dart';

class AdvanceSettingsCubit extends Cubit<AdvanceSettingsState> {
  AdvanceSettingsCubit({
    required this.secureStorageProvider,
  }) : super(
          const AdvanceSettingsState(
            isGamingEnabled: true,
            isIdentityEnabled: true,
            isPaymentEnabled: false,
            isSocialMediaEnabled: false,
            isCommunityEnabled: true,
            isOtherEnabled: true,
          ),
        ) {
    initialise();
  }

  final SecureStorageProvider secureStorageProvider;

  Future<void> initialise() async {
    final isGamingEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isGamingEnabled) ??
                true.toString()) ==
            'true';
    final isIdentityEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isIdentityEnabled) ??
                true.toString()) ==
            'true';
    final isCommunityEnabled = (await secureStorageProvider
                .get(SecureStorageKeys.isCommunityEnabled) ??
            true.toString()) ==
        'true';
    final isOtherEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isOtherEnabled) ??
                true.toString()) ==
            'true';
    final isPaymentEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isPaymentEnabled) ??
                false.toString()) ==
            'true';
    final isSocialMediaEnabled = (await secureStorageProvider
                .get(SecureStorageKeys.isSocialMediaEnabled) ??
            false.toString()) ==
        'true';
    emit(
      AdvanceSettingsState(
        isGamingEnabled: isGamingEnabled,
        isIdentityEnabled: isIdentityEnabled,
        isPaymentEnabled: isPaymentEnabled,
        isSocialMediaEnabled: isSocialMediaEnabled,
        isCommunityEnabled: isCommunityEnabled,
        isOtherEnabled: isOtherEnabled,
      ),
    );
  }

  void toggleGamingRadio() {
    emit(state.copyWith(isGamingEnabled: !state.isGamingEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isGamingEnabled,
      state.isGamingEnabled.toString(),
    );
  }

  void toggleIdentityRadio() {
    emit(state.copyWith(isIdentityEnabled: !state.isIdentityEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isIdentityEnabled,
      state.isIdentityEnabled.toString(),
    );
  }

  void togglePaymentRadio() {
    emit(state.copyWith(isPaymentEnabled: !state.isPaymentEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isPaymentEnabled,
      state.isPaymentEnabled.toString(),
    );
  }

  void toggleSocialMediaRadio() {
    emit(state.copyWith(isSocialMediaEnabled: !state.isSocialMediaEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isSocialMediaEnabled,
      state.isSocialMediaEnabled.toString(),
    );
  }

  void toggleCommunityRadio() {
    emit(state.copyWith(isCommunityEnabled: !state.isCommunityEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isCommunityEnabled,
      state.isCommunityEnabled.toString(),
    );
  }

  void toggleOtherRadio() {
    emit(state.copyWith(isOtherEnabled: !state.isOtherEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isOtherEnabled,
      state.isOtherEnabled.toString(),
    );
  }
}
