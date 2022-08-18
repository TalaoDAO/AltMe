import 'package:altme/app/app.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'import_talao_community_card_cubit.g.dart';
part 'import_talao_community_card_state.dart';

class ImportTalaoCommunityCardCubit
    extends Cubit<ImportTalaoCommunityCardState> {
  ImportTalaoCommunityCardCubit({
    required this.walletCubit,
  }) : super(const ImportTalaoCommunityCardState());

  final WalletCubit walletCubit;

  void isPrivateKeyValid(String value) {
    emit(
      state.populating(
        isTextFieldEdited: value.isNotEmpty,
        isPrivateKeyValid: isValidPrivateKey(value),
      ),
    );
  }
}
