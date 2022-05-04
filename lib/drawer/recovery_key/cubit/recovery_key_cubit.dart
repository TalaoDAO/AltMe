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
  }) : super(const RecoveryKeyState()) {
    loadMnemonic();
  }

  final SecureStorageProvider secureStorageProvider;

  Future<void> loadMnemonic() async {
    emit(state.loading());
    final phrase =
        (await secureStorageProvider.get(SecureStorageKeys.mnemonic))!;
    emit(state.success(mnemonic: phrase.split(' ')));
  }
}
