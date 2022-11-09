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
            isBlockchainAccountsEnabled: true,
            isSocialMediaEnabled: false,
            isCommunityEnabled: false,
            isOtherEnabled: false,
            isPassEnabled: false,
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
            false.toString()) ==
        'true';
    final isOtherEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isOtherEnabled) ??
                true.toString()) ==
            'true';
    final isBlockchainAccountsEnabled = (await secureStorageProvider
                .get(SecureStorageKeys.isBlockchainAccountsEnabled) ??
            true.toString()) ==
        'true';
    final isSocialMediaEnabled = (await secureStorageProvider
                .get(SecureStorageKeys.isSocialMediaEnabled) ??
            false.toString()) ==
        'true';
    final isPassEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isPassEnabled) ??
                false.toString()) ==
            'true';
    emit(
      AdvanceSettingsState(
        isGamingEnabled: isGamingEnabled,
        isIdentityEnabled: isIdentityEnabled,
        isBlockchainAccountsEnabled: isBlockchainAccountsEnabled,
        isSocialMediaEnabled: isSocialMediaEnabled,
        isCommunityEnabled: isCommunityEnabled,
        isOtherEnabled: isOtherEnabled,
        isPassEnabled: isPassEnabled,
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

  void toggleBlockchainAccountsRadio() {
    emit(state.copyWith(
        isBlockchainAccountsEnabled: !state.isBlockchainAccountsEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isBlockchainAccountsEnabled,
      state.isBlockchainAccountsEnabled.toString(),
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

  void togglePassRadio() {
    emit(state.copyWith(isPassEnabled: !state.isPassEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isPassEnabled,
      state.isPassEnabled.toString(),
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
