import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_list_cubit.g.dart';
part 'credential_list_state.dart';

class CredentialListCubit extends Cubit<CredentialListState> {
  CredentialListCubit() : super(CredentialListState());

  final List<CredentialSubjectType> gamingCategories = [
    CredentialSubjectType.voucher
  ];

  final List<CredentialSubjectType> communityCategories = [
    CredentialSubjectType.studentCard,
  ];

  final List<CredentialSubjectType> identityCategories = [
    CredentialSubjectType.emailPass,
    CredentialSubjectType.over18,
    CredentialSubjectType.certificateOfEmployment,
    CredentialSubjectType.learningAchievement,
    CredentialSubjectType.phonePass,
  ];

  Future<void> initialise(WalletCubit walletCubit) async {
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

          /// adding real credentials
          gamingCredentials.add(HomeCredential.isNotDummy(credential));

          /// updating dummy credentials list if exists
          if (gamingCategories.contains(credentialSubjectType)) {
            gamingCategories.remove(credentialSubjectType);
          }
          break;
        case CredentialCategory.communityCards:

          /// adding real credentials
          communityCredentials.add(HomeCredential.isNotDummy(credential));

          /// updating dummy credentials list if exists
          if (communityCategories.contains(credentialSubjectType)) {
            communityCategories.remove(credentialSubjectType);
          }
          break;
        case CredentialCategory.identityCards:

          /// adding real credentials
          identityCredentials.add(HomeCredential.isNotDummy(credential));

          /// updating dummy credentials list if exists
          if (identityCategories.contains(credentialSubjectType)) {
            identityCategories.remove(credentialSubjectType);
          }
          break;
        case CredentialCategory.othersCards:

          /// adding real credentials
          othersCredentials.add(HomeCredential.isNotDummy(credential));
          break;
      }
    }

    /// adding dummy gaming credentials
    for (final credentialSubjectType in gamingCategories) {
      gamingCredentials.add(HomeCredential.isDummy(credentialSubjectType));
    }

    /// adding dummy community credentials
    for (final credentialSubjectType in communityCategories) {
      communityCredentials.add(HomeCredential.isDummy(credentialSubjectType));
    }

    /// adding dummy identity credentials
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

  Future insertCredential(CredentialModel credential) async {
    final CredentialSubjectModel credentialSubject =
        credential.credentialPreview.credentialSubjectModel;
    switch (credentialSubject.credentialCategory) {
      case CredentialCategory.gamingCards:

        /// adding real credentials
        final gamingCredentials = List.of(state.gamingCredentials)
          ..add(HomeCredential.isNotDummy(credential));

        /// remove dummy credentials list if exists
        final HomeCredential? dummyCredential =
            gamingCredentials.firstWhereOrNull(
          (element) =>
              element.isDummy &&
              element.credentialSubjectType ==
                  credentialSubject.credentialSubjectType,
        );
        if (dummyCredential != null) {
          gamingCredentials.remove(dummyCredential);
        }

        emit(state.populate(gamingCredentials: gamingCredentials));

        break;

      case CredentialCategory.communityCards:

        /// adding real credentials
        final communityCredentials = List.of(state.communityCredentials)
          ..add(HomeCredential.isNotDummy(credential));

        /// remove dummy credentials list if exists
        final HomeCredential? dummyCredential =
            communityCredentials.firstWhereOrNull(
          (element) =>
              element.isDummy &&
              element.credentialSubjectType ==
                  credentialSubject.credentialSubjectType,
        );
        if (dummyCredential != null) {
          communityCredentials.remove(dummyCredential);
        }

        emit(state.populate(communityCredentials: communityCredentials));
        break;

      case CredentialCategory.identityCards:

        /// adding real credentials
        final identityCredentials = List.of(state.identityCredentials)
          ..add(HomeCredential.isNotDummy(credential));

        /// remove dummy credentials list if exists
        final HomeCredential? dummyCredential =
            identityCredentials.firstWhereOrNull(
          (element) =>
              element.isDummy &&
              element.credentialSubjectType ==
                  credentialSubject.credentialSubjectType,
        );
        if (dummyCredential != null) {
          identityCredentials.remove(dummyCredential);
        }

        emit(state.populate(identityCredentials: identityCredentials));
        break;

      case CredentialCategory.othersCards:

        /// adding real credentials
        final othersCredentials = List.of(state.othersCredentials)
          ..add(HomeCredential.isNotDummy(credential));

        emit(state.populate(othersCredentials: othersCredentials));
        break;
    }
  }
}
