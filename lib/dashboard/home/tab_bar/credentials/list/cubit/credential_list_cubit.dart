import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_list_cubit.g.dart';
part 'credential_list_state.dart';

class CredentialListCubit extends Cubit<CredentialListState> {
  CredentialListCubit() : super(CredentialListState());

  final List<CredentialSubjectType> gamingCategories = [
    //CredentialSubjectType.tezVoucher
  ];

  final List<CredentialSubjectType> communityCategories = [
    // CredentialSubjectType.talaoCommunityCard
  ];

  final List<CredentialSubjectType> identityCategories = [
    CredentialSubjectType.emailPass,
    CredentialSubjectType.over18,
    //CredentialSubjectType.identityCard,
  ];

  CredentialSubjectType over18 = CredentialSubjectType.over18;

  Future<void> initialise(WalletCubit walletCubit) async {
    emit(state.fetching());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final gamingCredentials = <HomeCredential>[];
    final communityCredentials = <HomeCredential>[];
    final identityCredentials = <HomeCredential>[];
    final proofOfOwnershipsCredentials = <HomeCredential>[];
    final othersCredentials = <HomeCredential>[];

    for (final credential in walletCubit.state.credentials) {
      final CredentialSubjectModel credentialSubject =
          credential.credentialPreview.credentialSubjectModel;

      switch (credentialSubject.credentialCategory) {
        case CredentialCategory.gamingCards:

          /// adding real credentials
          gamingCredentials.add(HomeCredential.isNotDummy(credential));
          break;

        case CredentialCategory.communityCards:

          /// adding real credentials
          communityCredentials.add(HomeCredential.isNotDummy(credential));
          break;

        case CredentialCategory.identityCards:

          /// adding real credentials
          identityCredentials.add(HomeCredential.isNotDummy(credential));

          /// remove over18 if exists

          final credentialSubjectType = credential
              .credentialPreview.credentialSubjectModel.credentialSubjectType;

          if (credentialSubjectType == over18) {
            identityCategories.remove(over18);
          }
          break;

        case CredentialCategory.proofOfOwnershipCards:

          /// adding real credentials except tezosAssociatedWallet
          // if (credential.credentialPreview.credentialSubjectModel
          //         .credentialSubjectType !=
          //     CredentialSubjectType.tezosAssociatedWallet) {
          //   othersCredentials.add(HomeCredential.isNotDummy(credential));
          // }

          proofOfOwnershipsCredentials
              .add(HomeCredential.isNotDummy(credential));
          break;

        case CredentialCategory.othersCards:
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
        proofOfOwnershipCredentials: proofOfOwnershipsCredentials,
        othersCredentials: othersCredentials,
      ),
    );
  }

  Future insertCredential(CredentialModel credential) async {
    emit(state.loading());
    final CredentialSubjectModel credentialSubject =
        credential.credentialPreview.credentialSubjectModel;
    switch (credentialSubject.credentialCategory) {
      case CredentialCategory.gamingCards:

        /// adding real credentials
        final _credentials = List.of(state.gamingCredentials)
          ..insert(0, HomeCredential.isNotDummy(credential));
        emit(state.populate(gamingCredentials: _credentials));
        break;

      case CredentialCategory.communityCards:

        /// adding real credentials
        final _credentials = List.of(state.communityCredentials)
          ..insert(0, HomeCredential.isNotDummy(credential));
        emit(state.populate(communityCredentials: _credentials));
        break;

      case CredentialCategory.identityCards:

        /// adding real credentials
        final _credentials = List.of(state.identityCredentials)
          ..insert(0, HomeCredential.isNotDummy(credential));

        final credentialSubjectType = credential
            .credentialPreview.credentialSubjectModel.credentialSubjectType;

        if (credentialSubjectType == over18) {
          /// remove dummy over18 credentials if exists
          final HomeCredential? dummyCredential = _credentials.firstWhereOrNull(
            (element) =>
                element.isDummy && element.credentialSubjectType == over18,
          );
          if (dummyCredential != null) {
            _credentials.remove(dummyCredential);
          }
        }

        emit(state.populate(identityCredentials: _credentials));
        break;

      case CredentialCategory.proofOfOwnershipCards:

        /// adding real credentials
        final _credentials = List.of(state.proofOfOwnershipCredentials)
          ..insert(0, HomeCredential.isNotDummy(credential));
        emit(state.populate(proofOfOwnershipCredentials: _credentials));
        break;

      case CredentialCategory.othersCards:

        /// adding real credentials
        final _credentials = List.of(state.othersCredentials)
          ..insert(0, HomeCredential.isNotDummy(credential));
        emit(state.populate(othersCredentials: _credentials));
        break;
    }
  }

  Future updateCredential(CredentialModel credential) async {
    emit(state.loading());
    final CredentialSubjectModel credentialSubject =
        credential.credentialPreview.credentialSubjectModel;
    switch (credentialSubject.credentialCategory) {
      case CredentialCategory.gamingCards:

        ///finding index of updated credential
        final index = state.gamingCredentials.indexWhere(
          (element) => element.credentialModel?.id == credential.id,
        );

        ///create updated credential list
        final _credentials = List.of(state.gamingCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          )
          ..insert(index, HomeCredential.isNotDummy(credential));

        emit(state.populate(gamingCredentials: _credentials));
        break;

      case CredentialCategory.communityCards:

        ///finding index of updated credential
        final index = state.communityCredentials.indexWhere(
          (element) => element.credentialModel?.id == credential.id,
        );

        ///create updated credential list
        final _credentials = List.of(state.communityCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          )
          ..insert(index, HomeCredential.isNotDummy(credential));

        emit(state.populate(communityCredentials: _credentials));
        break;

      case CredentialCategory.identityCards:

        ///finding index of updated credential
        final index = state.identityCredentials.indexWhere(
          (element) => element.credentialModel?.id == credential.id,
        );

        ///create updated credential list
        final _credentials = List.of(state.identityCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          )
          ..insert(index, HomeCredential.isNotDummy(credential));

        emit(state.populate(identityCredentials: _credentials));
        break;

      case CredentialCategory.proofOfOwnershipCards:

        ///finding index of updated credential
        final index = state.proofOfOwnershipCredentials.indexWhere(
          (element) => element.credentialModel?.id == credential.id,
        );

        ///create updated credential list
        final _credentials = List.of(state.proofOfOwnershipCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          )
          ..insert(index, HomeCredential.isNotDummy(credential));

        emit(state.populate(proofOfOwnershipCredentials: _credentials));
        break;

      case CredentialCategory.othersCards:

        ///finding index of updated credential
        final index = state.othersCredentials.indexWhere(
          (element) => element.credentialModel?.id == credential.id,
        );

        ///create updated credential list
        final _credentials = List.of(state.othersCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          )
          ..insert(index, HomeCredential.isNotDummy(credential));

        emit(state.populate(othersCredentials: _credentials));
        break;
    }
  }

  Future deleteById(CredentialModel credential) async {
    emit(state.loading());
    final CredentialSubjectModel credentialSubject =
        credential.credentialPreview.credentialSubjectModel;
    switch (credentialSubject.credentialCategory) {
      case CredentialCategory.gamingCards:
        final _credentials = List.of(state.gamingCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );
        emit(state.populate(gamingCredentials: _credentials));
        break;

      case CredentialCategory.communityCards:
        final _credentials = List.of(state.communityCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );
        emit(state.populate(communityCredentials: _credentials));
        break;

      case CredentialCategory.identityCards:
        late List<HomeCredential> _credentials;

        final credentialSubjectType = credential
            .credentialPreview.credentialSubjectModel.credentialSubjectType;

        //add dummmy over18 credentials
        if (credentialSubjectType == over18) {
          _credentials = List.of(state.identityCredentials)
            ..removeWhere(
              (element) => element.credentialModel?.id == credential.id,
            )
            ..add(HomeCredential.isDummy(over18));
        } else {
          _credentials = List.of(state.identityCredentials)
            ..removeWhere(
              (element) => element.credentialModel?.id == credential.id,
            );
        }

        emit(state.populate(identityCredentials: _credentials));
        break;

      case CredentialCategory.proofOfOwnershipCards:
        final _credentials = List.of(state.proofOfOwnershipCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );
        emit(state.populate(proofOfOwnershipCredentials: _credentials));
        break;

      case CredentialCategory.othersCards:
        final _credentials = List.of(state.othersCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );
        emit(state.populate(othersCredentials: _credentials));
        break;
    }
  }

  Future clearHomeCredentials() async {
    emit(
      state.populate(
        gamingCredentials: [],
        communityCredentials: [],
        identityCredentials: [],
        proofOfOwnershipCredentials: [],
        othersCredentials: [],
      ),
    );
  }
}
