import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/app/shared/constants/discover_list.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_list_cubit.g.dart';
part 'credential_list_state.dart';

class CredentialListCubit extends Cubit<CredentialListState> {
  CredentialListCubit() : super(CredentialListState());

  CredentialSubjectType identityCredentialCard =
      CredentialSubjectType.identityCard;

  Future<void> initialise(WalletCubit walletCubit) async {
    emit(state.fetching());

    await Future<void>.delayed(const Duration(milliseconds: 500));
    final gamingCredentials = <HomeCredential>[];
    final communityCredentials = <HomeCredential>[];
    final identityCredentials = <HomeCredential>[];
    final proofOfOwnershipsCredentials = <HomeCredential>[];
    final othersCredentials = <HomeCredential>[];
    final gamingCategories = state.gamingCategories;
    final identityCategories = state.identityCategories;
    final communityCategories = state.communityCategories;

    /// tezVoucher is available only on Android platform
    if (!isAndroid()) {
      gamingCategories.remove(CredentialSubjectType.tezVoucher);
    }

    for (final credential in walletCubit.state.credentials) {
      final CredentialSubjectModel credentialSubject =
          credential.credentialPreview.credentialSubjectModel;

      /// remove over18 if exists

      final credentialSubjectType = credential
          .credentialPreview.credentialSubjectModel.credentialSubjectType;

      switch (credentialSubjectType) {
        case CredentialSubjectType.tezotopiaMembership:
          break;
        case CredentialSubjectType.ageRange:
          identityCategories.remove(CredentialSubjectType.ageRange);
          break;
        case CredentialSubjectType.nationality:
          identityCategories.remove(CredentialSubjectType.nationality);
          break;
        case CredentialSubjectType.gender:
          identityCategories.remove(CredentialSubjectType.gender);
          break;
        case CredentialSubjectType.tezosAssociatedWallet:
          break;
        case CredentialSubjectType.certificateOfEmployment:
          break;
        case CredentialSubjectType.defaultCredential:
          break;
        case CredentialSubjectType.ecole42LearningAchievement:
          break;
        case CredentialSubjectType.emailPass:
          break;
        case CredentialSubjectType.identityPass:
          identityCategories.remove(CredentialSubjectType.identityPass);
          break;
        case CredentialSubjectType.identityCard:
          identityCategories.remove(CredentialSubjectType.identityCard);
          break;
        case CredentialSubjectType.learningAchievement:
          break;
        case CredentialSubjectType.loyaltyCard:
          break;
        case CredentialSubjectType.over18:
          identityCategories.remove(CredentialSubjectType.over18);
          break;
        case CredentialSubjectType.phonePass:
          break;
        case CredentialSubjectType.professionalExperienceAssessment:
          break;
        case CredentialSubjectType.professionalSkillAssessment:
          break;
        case CredentialSubjectType.professionalStudentCard:
          break;
        case CredentialSubjectType.residentCard:
          identityCategories.remove(CredentialSubjectType.residentCard);
          break;
        case CredentialSubjectType.selfIssued:
          break;
        case CredentialSubjectType.studentCard:
          break;
        case CredentialSubjectType.voucher:
          break;
        case CredentialSubjectType.tezVoucher:
          break;
        case CredentialSubjectType.talaoCommunityCard:
          break;
        case CredentialSubjectType.aragoEmailPass:
          break;
        case CredentialSubjectType.aragoIdentityCard:
          break;
        case CredentialSubjectType.aragoLearningAchievement:
          break;
        case CredentialSubjectType.aragoOver18:
          break;
      }
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
/* Disable display of dummies when displaying credentials.
// TODO(all)Uncomment if we need to display dummies again. 
    /// adding dummy gaming credentials
    gamingCredentials.addAll(dummyListFromCategory(gamingCategories));

    /// adding dummy community credentials
    communityCredentials.addAll(dummyListFromCategory(communityCategories));

    /// adding dummy identity credentials
    identityCredentials.addAll(dummyListFromCategory(identityCategories));
*/
    emit(
      state.populate(
        gamingCredentials: gamingCredentials,
        communityCredentials: communityCredentials,
        identityCredentials: identityCredentials,
        proofOfOwnershipCredentials: proofOfOwnershipsCredentials,
        othersCredentials: othersCredentials,
        gamingCategories: gamingCategories,
        communityCategories: communityCategories,
        identityCategories: identityCategories,
      ),
    );
  }

  List<HomeCredential> dummyListFromCategory(
    List<CredentialSubjectType> categories,
  ) {
    final List<HomeCredential> dummyCredentialsList = [];
    for (final credentialSubjectType in categories) {
      dummyCredentialsList.add(HomeCredential.isDummy(credentialSubjectType));
    }
    return dummyCredentialsList;
  }

  Future insertCredential(CredentialModel credential) async {
    emit(state.loading());
    final identityCategories = state.identityCategories;
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
        switch (credentialSubjectType) {
          case CredentialSubjectType.tezotopiaMembership:
            break;
          case CredentialSubjectType.ageRange:
            _removeDummyIfCredentialExist(
              _credentials,
              identityCategories,
              CredentialSubjectType.ageRange,
            );
            break;
          case CredentialSubjectType.nationality:
            _removeDummyIfCredentialExist(
              _credentials,
              identityCategories,
              CredentialSubjectType.nationality,
            );
            break;
          case CredentialSubjectType.gender:
            _removeDummyIfCredentialExist(
              _credentials,
              identityCategories,
              CredentialSubjectType.gender,
            );
            break;
          case CredentialSubjectType.tezosAssociatedWallet:
            break;
          case CredentialSubjectType.certificateOfEmployment:
            break;
          case CredentialSubjectType.defaultCredential:
            break;
          case CredentialSubjectType.ecole42LearningAchievement:
            break;
          case CredentialSubjectType.emailPass:
            break;
          case CredentialSubjectType.identityPass:
            _removeDummyIfCredentialExist(
              _credentials,
              identityCategories,
              CredentialSubjectType.identityPass,
            );
            break;
          case CredentialSubjectType.identityCard:
            _removeDummyIfCredentialExist(
              _credentials,
              identityCategories,
              CredentialSubjectType.identityCard,
            );
            break;
          case CredentialSubjectType.learningAchievement:
            break;
          case CredentialSubjectType.loyaltyCard:
            break;
          case CredentialSubjectType.over18:
            _removeDummyIfCredentialExist(
              _credentials,
              identityCategories,
              CredentialSubjectType.over18,
            );
            break;
          case CredentialSubjectType.phonePass:
            break;
          case CredentialSubjectType.professionalExperienceAssessment:
            break;
          case CredentialSubjectType.professionalSkillAssessment:
            break;
          case CredentialSubjectType.professionalStudentCard:
            break;
          case CredentialSubjectType.residentCard:
            _removeDummyIfCredentialExist(
              _credentials,
              identityCategories,
              CredentialSubjectType.residentCard,
            );
            break;
          case CredentialSubjectType.selfIssued:
            break;
          case CredentialSubjectType.studentCard:
            break;
          case CredentialSubjectType.voucher:
            break;
          case CredentialSubjectType.tezVoucher:
            break;
          case CredentialSubjectType.talaoCommunityCard:
            break;
          case CredentialSubjectType.aragoEmailPass:
            break;
          case CredentialSubjectType.aragoIdentityCard:
            break;
          case CredentialSubjectType.aragoLearningAchievement:
            break;
          case CredentialSubjectType.aragoOver18:
            break;
        }

        emit(
          state.populate(
            identityCredentials: _credentials,
            identityCategories: identityCategories,
          ),
        );
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

  void _removeDummyIfCredentialExist(
    List<HomeCredential> _credentials,
    List<CredentialSubjectType> identityCategoriesqs,
    CredentialSubjectType credentialSubjectType,
  ) {
    final HomeCredential? dummyCredential = _credentials.firstWhereOrNull(
      (element) =>
          element.isDummy &&
          element.credentialSubjectType == credentialSubjectType,
    );
    if (dummyCredential != null) {
      _credentials.remove(dummyCredential);
    }
    identityCategoriesqs.remove(credentialSubjectType);
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
    final identityCategories = state.identityCategories;
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

        _credentials = List.of(state.identityCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );

        switch (credentialSubjectType) {
          case CredentialSubjectType.tezotopiaMembership:
            break;
          case CredentialSubjectType.ageRange:
            // TODO(all): Uncomment if we need to display dummies again.
            // _credentials.add(
            //   HomeCredential.isDummy(
            //     CredentialSubjectType.ageRange,
            //   ),
            // );
            identityCategories.add(CredentialSubjectType.ageRange);
            break;
          case CredentialSubjectType.nationality:
            // TODO(all): Uncomment if we need to display dummies again.
            // _credentials.add(
            //   HomeCredential.isDummy(
            //     CredentialSubjectType.nationality,
            //   ),
            // );
            identityCategories.add(CredentialSubjectType.nationality);
            break;
          case CredentialSubjectType.gender:
            // TODO(all): Uncomment if we need to display dummies again.
            // _credentials.add(
            //   HomeCredential.isDummy(
            //     CredentialSubjectType.gender,
            //   ),
            // );
            identityCategories.add(CredentialSubjectType.gender);
            break;
          case CredentialSubjectType.tezosAssociatedWallet:
            break;
          case CredentialSubjectType.certificateOfEmployment:
            break;
          case CredentialSubjectType.defaultCredential:
            break;
          case CredentialSubjectType.ecole42LearningAchievement:
            break;
          case CredentialSubjectType.emailPass:
            break;
          case CredentialSubjectType.identityPass:
            break;
          case CredentialSubjectType.identityCard:
            // TODO(all): Uncomment if we need to display dummies again.
            // _credentials.add(
            //   HomeCredential.isDummy(
            //     CredentialSubjectType.identityCard,
            //   ),
            // );
            identityCategories.add(CredentialSubjectType.identityCard);
            break;
          case CredentialSubjectType.learningAchievement:
            break;
          case CredentialSubjectType.loyaltyCard:
            break;
          case CredentialSubjectType.over18:
            // TODO(all): Uncomment if we need to display dummies again.
            // _credentials.add(
            //   HomeCredential.isDummy(
            //     CredentialSubjectType.over18,
            //   ),
            // );
            identityCategories.add(CredentialSubjectType.over18);
            break;
          case CredentialSubjectType.phonePass:
            break;
          case CredentialSubjectType.professionalExperienceAssessment:
            break;
          case CredentialSubjectType.professionalSkillAssessment:
            break;
          case CredentialSubjectType.professionalStudentCard:
            break;
          case CredentialSubjectType.residentCard:
            break;
          case CredentialSubjectType.selfIssued:
            break;
          case CredentialSubjectType.studentCard:
            break;
          case CredentialSubjectType.voucher:
            break;
          case CredentialSubjectType.tezVoucher:
            break;
          case CredentialSubjectType.talaoCommunityCard:
            break;
          case CredentialSubjectType.aragoEmailPass:
            break;
          case CredentialSubjectType.aragoIdentityCard:
            break;
          case CredentialSubjectType.aragoLearningAchievement:
            break;
          case CredentialSubjectType.aragoOver18:
            break;
        }

        emit(
          state.populate(
            identityCredentials: _credentials,
            identityCategories: identityCategories,
          ),
        );
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
        gamingCategories: List.from(DiscoverList.gamingCategories),
        communityCategories: List.from(DiscoverList.communityCategories),
        identityCategories: List.from(DiscoverList.identityCategories),
      ),
    );
  }
}
