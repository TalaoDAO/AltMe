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
  }) : super(Parameters.defaultAdvanceSettingsState) {
    initialise();
  }

  final SecureStorageProvider secureStorageProvider;

  Future<void> initialise() async {
    final isGamingEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isGamingEnabled) ??
                'true') ==
            'true';
    final isIdentityEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isIdentityEnabled) ??
                'true') ==
            'true';
    final isCommunityEnabled = (await secureStorageProvider
                .get(SecureStorageKeys.isCommunityEnabled) ??
            'true') ==
        'true';
    final isOtherEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isOtherEnabled) ??
                'true') ==
            'true';
    final isBlockchainAccountsEnabled = (await secureStorageProvider
                .get(SecureStorageKeys.isBlockchainAccountsEnabled) ??
            'false') ==
        'true';
    final isEducationEnabled = (await secureStorageProvider
                .get(SecureStorageKeys.isEducationEnabled) ??
            'true') ==
        'true';
    final isSocialMediaEnabled = (await secureStorageProvider
                .get(SecureStorageKeys.isSocialMediaEnabled) ??
            'true') ==
        'true';
    final isPassEnabled =
        (await secureStorageProvider.get(SecureStorageKeys.isPassEnabled) ??
                'true') ==
            'true';

    emit(
      AdvanceSettingsState(
        isGamingEnabled: isGamingEnabled,
        isIdentityEnabled: isIdentityEnabled,
        isBlockchainAccountsEnabled: isBlockchainAccountsEnabled,
        isEducationEnabled: isEducationEnabled,
        isSocialMediaEnabled: isSocialMediaEnabled,
        isCommunityEnabled: isCommunityEnabled,
        isOtherEnabled: isOtherEnabled,
        isPassEnabled: isPassEnabled,
      ),
    );
  }

  Future<void> setState(AdvanceSettingsState newState) async {
    await secureStorageProvider.set(
      SecureStorageKeys.isGamingEnabled,
      newState.isGamingEnabled.toString(),
    );

    await secureStorageProvider.set(
      SecureStorageKeys.isIdentityEnabled,
      newState.isIdentityEnabled.toString(),
    );
    await secureStorageProvider.set(
      SecureStorageKeys.isBlockchainAccountsEnabled,
      newState.isBlockchainAccountsEnabled.toString(),
    );

    await secureStorageProvider.set(
      SecureStorageKeys.isEducationEnabled,
      newState.isEducationEnabled.toString(),
    );

    await secureStorageProvider.set(
      SecureStorageKeys.isSocialMediaEnabled,
      newState.isSocialMediaEnabled.toString(),
    );

    await secureStorageProvider.set(
      SecureStorageKeys.isCommunityEnabled,
      newState.isCommunityEnabled.toString(),
    );

    await secureStorageProvider.set(
      SecureStorageKeys.isPassEnabled,
      newState.isPassEnabled.toString(),
    );

    await secureStorageProvider.set(
      SecureStorageKeys.isOtherEnabled,
      newState.isOtherEnabled.toString(),
    );
    emit(newState);
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
    emit(
      state.copyWith(
        isBlockchainAccountsEnabled: !state.isBlockchainAccountsEnabled,
      ),
    );
    secureStorageProvider.set(
      SecureStorageKeys.isBlockchainAccountsEnabled,
      state.isBlockchainAccountsEnabled.toString(),
    );
  }

  void toggleEducationRadio() {
    emit(
      state.copyWith(
        isEducationEnabled: !state.isEducationEnabled,
      ),
    );
    secureStorageProvider.set(
      SecureStorageKeys.isEducationEnabled,
      state.isEducationEnabled.toString(),
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
    getLogger('AdvanceSettingCubit').i('Why I am called');
    emit(state.copyWith(isOtherEnabled: !state.isOtherEnabled));
    secureStorageProvider.set(
      SecureStorageKeys.isOtherEnabled,
      state.isOtherEnabled.toString(),
    );
  }
}
