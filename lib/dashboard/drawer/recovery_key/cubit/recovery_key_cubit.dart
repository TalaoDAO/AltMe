import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'recovery_key_cubit.g.dart';
part 'recovery_key_state.dart';

class RecoveryKeyCubit extends Cubit<RecoveryKeyState> {
  RecoveryKeyCubit({
    required this.secureStorageProvider,
  }) : super(const RecoveryKeyState());

  final SecureStorageProvider secureStorageProvider;

  Future<void> getMnemonics() async {
    emit(state.loading());
    final mnemonics = await getssiMnemonicsInList(secureStorageProvider);

    bool isMnemonicsVerified = false;

    final hasVerifiedMnemonics =
        await secureStorageProvider.get(SecureStorageKeys.hasVerifiedMnemonics);

    if (hasVerifiedMnemonics != null && hasVerifiedMnemonics == 'yes') {
      isMnemonicsVerified = true;
    }

    emit(
      state.copyWith(
        status: AppStatus.idle,
        mnemonics: mnemonics,
        hasVerifiedMnemonics: isMnemonicsVerified,
      ),
    );
  }

  Future<void> getVerifiedStatus() async {
    emit(state.loading());
    bool isMnemonicsVerified = false;

    final hasVerifiedMnemonics =
        await secureStorageProvider.get(SecureStorageKeys.hasVerifiedMnemonics);

    if (hasVerifiedMnemonics != null && hasVerifiedMnemonics == 'yes') {
      isMnemonicsVerified = true;
    }

    emit(
      state.copyWith(
        status: AppStatus.idle,
        hasVerifiedMnemonics: isMnemonicsVerified,
      ),
    );
  }
}
