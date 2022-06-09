import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_list_cubit.g.dart';
part 'credential_list_state.dart';

class CredentialListCubit extends Cubit<CredentialListState> {
  CredentialListCubit({
    required this.walletCubit,
  }) : super(CredentialListState());

  final WalletCubit walletCubit;

  Future<void> initialise() async {
    emit(state.loading());
    final gamingCredentials = <HomeCredential>[];
    final communityCredentials = <HomeCredential>[];
    final identityCredentials = <HomeCredential>[];
    final othersCredentials = <HomeCredential>[];

    for (final credential in walletCubit.state.credentials) {
      final CredentialSubjectType credentialSubjectType = credential
          .credentialPreview.credentialSubjectModel.credentialSubjectType;

      switch (credential
          .credentialPreview.credentialSubjectModel.credentialCategory) {
        case CredentialCategory.gamingCards:
          gamingCredentials.add(HomeCredential.isNotDummy(credential));
          if (gamingCategories.contains(credentialSubjectType)) {
            gamingCategories.remove(credentialSubjectType);
          }
          break;
        case CredentialCategory.communityCards:
          communityCredentials.add(HomeCredential.isNotDummy(credential));
          if (communityCategories.contains(credentialSubjectType)) {
            communityCategories.remove(credentialSubjectType);
          }
          break;
        case CredentialCategory.identityCards:
          identityCredentials.add(HomeCredential.isNotDummy(credential));
          if (identityCategories.contains(credentialSubjectType)) {
            identityCategories.remove(credentialSubjectType);
          }
          break;
        case CredentialCategory.othersCards:
          othersCredentials.add(HomeCredential.isNotDummy(credential));
          break;
      }
    }

    for (final credentialSubjectType in gamingCategories) {
      gamingCredentials.add(HomeCredential.isDummy(credentialSubjectType));
    }

    for (final credentialSubjectType in communityCategories) {
      communityCredentials.add(HomeCredential.isDummy(credentialSubjectType));
    }

    for (final credentialSubjectType in identityCategories) {
      identityCredentials.add(HomeCredential.isDummy(credentialSubjectType));
    }

    emit(
      state.populate(
        gamingCredentials: gamingCredentials,
        communityCredentials: communityCredentials,
        identityCredentials: identityCredentials,
        othersCredentials: othersCredentials,
      ),
    );
  }
}
