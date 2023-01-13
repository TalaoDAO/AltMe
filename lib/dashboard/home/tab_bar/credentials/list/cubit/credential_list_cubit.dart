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

  Future<void> initialise(WalletCubit walletCubit) async {
    emit(state.fetching());

    await Future<void>.delayed(const Duration(milliseconds: 500));
    final gamingCredentials = <HomeCredential>[];
    final communityCredentials = <HomeCredential>[];
    final identityCredentials = <HomeCredential>[];
    final passCredentials = <HomeCredential>[];
    final blockchainAccountsCredentials = <HomeCredential>[];
    final othersCredentials = <HomeCredential>[];
    final myProfessionalCredentials = <HomeCredential>[];
    final gamingCategories = state.gamingCategories;
    final identityCategories = state.identityCategories;
    final communityCategories = state.communityCategories;
    final myProfessionalCategories = state.myProfessionalCategories;

    /// tezVoucher and tezotopiaMembership is available only on Android platform
    if (!isAndroid()) {
      gamingCategories.remove(CredentialSubjectType.tezVoucher);
      //gamingCategories.remove(CredentialSubjectType.tezotopiaMembership);
    }

    for (final credential in walletCubit.state.credentials) {
      final CredentialSubjectModel credentialSubject =
          credential.credentialPreview.credentialSubjectModel;

      /// remove over18,tezotopiaMembership,ageRange,nationality,gender,
      /// identityPass,identityCard,residentCard,voucher,tezVoucher if exists

      final credentialSubjectType = credential
          .credentialPreview.credentialSubjectModel.credentialSubjectType;

      switch (credentialSubjectType) {
        case CredentialSubjectType.voucher:
        case CredentialSubjectType.tezVoucher:
        case CredentialSubjectType.diplomaCard:
        case CredentialSubjectType.tezotopiaMembership:
        case CredentialSubjectType.chainbornMembership:
          gamingCategories.remove(credentialSubjectType);
          break;

        case CredentialSubjectType.ageRange:
        case CredentialSubjectType.nationality:
        case CredentialSubjectType.gender:
        case CredentialSubjectType.identityPass:
        case CredentialSubjectType.verifiableIdCard:
        case CredentialSubjectType.over18:
        case CredentialSubjectType.over13:
        case CredentialSubjectType.passportFootprint:
        case CredentialSubjectType.residentCard:
        case CredentialSubjectType.twitterCard:
          identityCategories.remove(credentialSubjectType);
          break;

        case CredentialSubjectType.linkedInCard:
          myProfessionalCategories.remove(credentialSubjectType);
          break;

        case CredentialSubjectType.talaoCommunityCard:
        case CredentialSubjectType.aragoEmailPass:
        case CredentialSubjectType.aragoIdentityCard:
        case CredentialSubjectType.aragoLearningAchievement:
        case CredentialSubjectType.aragoOver18:
        case CredentialSubjectType.aragoPass:
        case CredentialSubjectType.pcdsAgentCertificate:
        case CredentialSubjectType.phonePass:
        case CredentialSubjectType.professionalExperienceAssessment:
        case CredentialSubjectType.professionalSkillAssessment:
        case CredentialSubjectType.professionalStudentCard:
        case CredentialSubjectType.tezosAssociatedWallet:
        case CredentialSubjectType.ethereumAssociatedWallet:
        case CredentialSubjectType.certificateOfEmployment:
        case CredentialSubjectType.defaultCredential:
        case CredentialSubjectType.ecole42LearningAchievement:
        case CredentialSubjectType.emailPass:
        case CredentialSubjectType.walletCredential:
        case CredentialSubjectType.bloometaPass:
        case CredentialSubjectType.dogamiPass:
        case CredentialSubjectType.bunnyPass:
        case CredentialSubjectType.troopezPass:
        case CredentialSubjectType.tzlandPass:
        case CredentialSubjectType.matterlightPass:
        case CredentialSubjectType.pigsPass:
        case CredentialSubjectType.tezoniaPass:
        case CredentialSubjectType.learningAchievement:
        case CredentialSubjectType.loyaltyCard:
        case CredentialSubjectType.selfIssued:
        case CredentialSubjectType.studentCard:
        case CredentialSubjectType.fantomAssociatedWallet:
        case CredentialSubjectType.polygonAssociatedWallet:
        case CredentialSubjectType.binanceAssociatedWallet:
        case CredentialSubjectType.tezosPooAddress:
        case CredentialSubjectType.ethereumPooAddress:
        case CredentialSubjectType.fantomPooAddress:
        case CredentialSubjectType.polygonPooAddress:
        case CredentialSubjectType.binancePooAddress:
          break;
      }

      switch (credentialSubject.credentialCategory) {
        case CredentialCategory.myProfessionalCards:

          /// adding real credentials
          myProfessionalCredentials.add(HomeCredential.isNotDummy(credential));
          break;
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

        case CredentialCategory.blockchainAccountsCards:

          /// adding real credentials
          blockchainAccountsCredentials
              .add(HomeCredential.isNotDummy(credential));
          break;

        case CredentialCategory.passCards:

          /// adding real credentials
          passCredentials.add(HomeCredential.isNotDummy(credential));
          break;

        case CredentialCategory.othersCards:

          /// adding real credentials
          othersCredentials.add(HomeCredential.isNotDummy(credential));
          break;
      }
    }
/* Disable display of dummies when displaying credentials.
    /// Note: Uncomment if we need to display dummies again. 
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
        blockchainAccountsCredentials: blockchainAccountsCredentials,
        passCredentials: passCredentials,
        othersCredentials: othersCredentials,
        myProfessionalCredentials: myProfessionalCredentials,
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

  Future insertCredential({required CredentialModel credential}) async {
    emit(state.loading());
    final identityCategories = state.identityCategories;
    final gamingCategories = state.gamingCategories;
    final myProfessionalCategories = state.myProfessionalCategories;
    final CredentialSubjectModel credentialSubject =
        credential.credentialPreview.credentialSubjectModel;
    switch (credentialSubject.credentialCategory) {
      case CredentialCategory.myProfessionalCards:

        /// adding real credentials
        final _credentials = List.of(state.myProfessionalCredentials)
          ..insert(0, HomeCredential.isNotDummy(credential));
        emit(state.populate(myProfessionalCredentials: _credentials));
        break;
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
          case CredentialSubjectType.chainbornMembership:
          case CredentialSubjectType.voucher:
          case CredentialSubjectType.tezVoucher:
            _removeDummyIfCredentialExist(
              _credentials,
              gamingCategories,
              credentialSubjectType,
            );
            break;

          case CredentialSubjectType.ageRange:
          case CredentialSubjectType.nationality:
          case CredentialSubjectType.identityPass:
          case CredentialSubjectType.verifiableIdCard:
          case CredentialSubjectType.over18:
          case CredentialSubjectType.over13:
          case CredentialSubjectType.passportFootprint:
          case CredentialSubjectType.residentCard:
          case CredentialSubjectType.gender:
          case CredentialSubjectType.twitterCard:
            _removeDummyIfCredentialExist(
              _credentials,
              identityCategories,
              credentialSubjectType,
            );
            break;

          case CredentialSubjectType.linkedInCard:
            _removeDummyIfCredentialExist(
              _credentials,
              myProfessionalCategories,
              credentialSubjectType,
            );
            break;

          case CredentialSubjectType.tezosAssociatedWallet:
          case CredentialSubjectType.ethereumAssociatedWallet:
          case CredentialSubjectType.certificateOfEmployment:
          case CredentialSubjectType.defaultCredential:
          case CredentialSubjectType.ecole42LearningAchievement:
          case CredentialSubjectType.emailPass:
          case CredentialSubjectType.diplomaCard:
          case CredentialSubjectType.bloometaPass:
          case CredentialSubjectType.walletCredential:
          case CredentialSubjectType.learningAchievement:
          case CredentialSubjectType.loyaltyCard:
          case CredentialSubjectType.phonePass:
          case CredentialSubjectType.professionalExperienceAssessment:
          case CredentialSubjectType.professionalSkillAssessment:
          case CredentialSubjectType.professionalStudentCard:
          case CredentialSubjectType.selfIssued:
          case CredentialSubjectType.studentCard:
          case CredentialSubjectType.talaoCommunityCard:
          case CredentialSubjectType.aragoEmailPass:
          case CredentialSubjectType.aragoIdentityCard:
          case CredentialSubjectType.aragoLearningAchievement:
          case CredentialSubjectType.aragoOver18:
          case CredentialSubjectType.aragoPass:
          case CredentialSubjectType.tezoniaPass:
          case CredentialSubjectType.tzlandPass:
          case CredentialSubjectType.troopezPass:
          case CredentialSubjectType.pigsPass:
          case CredentialSubjectType.matterlightPass:
          case CredentialSubjectType.dogamiPass:
          case CredentialSubjectType.bunnyPass:
          case CredentialSubjectType.pcdsAgentCertificate:
          case CredentialSubjectType.fantomAssociatedWallet:
          case CredentialSubjectType.polygonAssociatedWallet:
          case CredentialSubjectType.binanceAssociatedWallet:
          case CredentialSubjectType.tezosPooAddress:
          case CredentialSubjectType.ethereumPooAddress:
          case CredentialSubjectType.fantomPooAddress:
          case CredentialSubjectType.polygonPooAddress:
          case CredentialSubjectType.binancePooAddress:
            break;
        }

        emit(
          state.populate(
            identityCredentials: _credentials,
            gamingCategories: gamingCategories,
            identityCategories: identityCategories,
          ),
        );
        break;

      case CredentialCategory.blockchainAccountsCards:

        /// adding real credentials
        final _credentials = List.of(state.blockchainAccountsCredentials)
          ..insert(0, HomeCredential.isNotDummy(credential));
        emit(state.populate(blockchainAccountsCredentials: _credentials));
        break;

      case CredentialCategory.passCards:

        /// adding real credentials
        final _credentials = List.of(state.passCredentials)
          ..insert(0, HomeCredential.isNotDummy(credential));
        emit(state.populate(passCredentials: _credentials));
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
    List<CredentialSubjectType> categories,
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
    categories.remove(credentialSubjectType);
  }

  Future updateCredential(CredentialModel credential) async {
    emit(state.loading());
    final CredentialSubjectModel credentialSubject =
        credential.credentialPreview.credentialSubjectModel;
    switch (credentialSubject.credentialCategory) {
      case CredentialCategory.myProfessionalCards:

        ///finding index of updated credential
        final index = state.myProfessionalCredentials.indexWhere(
          (element) => element.credentialModel?.id == credential.id,
        );

        ///create updated credential list
        final _credentials = List.of(state.myProfessionalCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          )
          ..insert(index, HomeCredential.isNotDummy(credential));

        emit(state.populate(myProfessionalCredentials: _credentials));
        break;
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

      case CredentialCategory.blockchainAccountsCards:

        ///finding index of updated credential
        final index = state.blockchainAccountsCredentials.indexWhere(
          (element) => element.credentialModel?.id == credential.id,
        );

        ///create updated credential list
        final _credentials = List.of(state.blockchainAccountsCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          )
          ..insert(index, HomeCredential.isNotDummy(credential));

        emit(state.populate(blockchainAccountsCredentials: _credentials));
        break;

      case CredentialCategory.passCards:

        ///finding index of updated credential
        final index = state.passCredentials.indexWhere(
          (element) => element.credentialModel?.id == credential.id,
        );

        ///create updated credential list
        final _credentials = List.of(state.passCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          )
          ..insert(index, HomeCredential.isNotDummy(credential));

        emit(state.populate(passCredentials: _credentials));
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
        final gamingCategories = state.gamingCategories;
        final _credentials = List.of(state.gamingCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );

        //check if type of credential is memberShip,tezVoucher or voucher then
        //add it again to discover
        final credentialSubjectType = credential
            .credentialPreview.credentialSubjectModel.credentialSubjectType;

        if (credentialSubjectType ==
                CredentialSubjectType.tezotopiaMembership ||
            credentialSubjectType ==
                CredentialSubjectType.chainbornMembership) {
          gamingCategories.add(credentialSubjectType);
        }

        if (credentialSubjectType == CredentialSubjectType.tezVoucher &&
            isAndroid()) {
          gamingCategories.add(credentialSubjectType);
        }
        if (credentialSubjectType == CredentialSubjectType.voucher &&
            isAndroid()) {
          gamingCategories.add(credentialSubjectType);
        }

        emit(
          state.populate(
            gamingCredentials: _credentials,
            gamingCategories: gamingCategories,
          ),
        );
        break;

      case CredentialCategory.myProfessionalCards:
        final myProfessionalCategories = state.myProfessionalCategories;
        final _credentials = List.of(state.myProfessionalCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );
        final credentialSubjectType = credential
            .credentialPreview.credentialSubjectModel.credentialSubjectType;

        if (credentialSubjectType == CredentialSubjectType.linkedInCard) {
          myProfessionalCategories.add(credentialSubjectType);
        }
        emit(
          state.populate(
            myProfessionalCredentials: _credentials,
            myProfessionalCategories: myProfessionalCategories,
          ),
        );
        break;
      case CredentialCategory.communityCards:
        final _credentials = List.of(state.communityCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );
        emit(state.populate(communityCredentials: _credentials));
        break;

      case CredentialCategory.identityCards:
        final identityCategories = state.identityCategories;
        late List<HomeCredential> _credentials;

        final credentialSubjectType = credential
            .credentialPreview.credentialSubjectModel.credentialSubjectType;

        _credentials = List.of(state.identityCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );

        switch (credentialSubjectType) {
          case CredentialSubjectType.ageRange:
          case CredentialSubjectType.verifiableIdCard:
          case CredentialSubjectType.nationality:
          case CredentialSubjectType.gender:
          case CredentialSubjectType.over18:
          case CredentialSubjectType.over13:
          case CredentialSubjectType.passportFootprint:
          case CredentialSubjectType.twitterCard:
            // // Note: Uncomment if we need to display dummies again.
            // _credentials.add(HomeCredential.isDummy(credentialSubjectType));
            identityCategories.add(credentialSubjectType);
            break;
          case CredentialSubjectType.phonePass:
          case CredentialSubjectType.professionalExperienceAssessment:
          case CredentialSubjectType.professionalSkillAssessment:
          case CredentialSubjectType.professionalStudentCard:
          case CredentialSubjectType.residentCard:
          case CredentialSubjectType.selfIssued:
          case CredentialSubjectType.studentCard:
          case CredentialSubjectType.voucher:
          case CredentialSubjectType.tezVoucher:
          case CredentialSubjectType.talaoCommunityCard:
          case CredentialSubjectType.aragoPass:
          case CredentialSubjectType.aragoEmailPass:
          case CredentialSubjectType.aragoIdentityCard:
          case CredentialSubjectType.aragoLearningAchievement:
          case CredentialSubjectType.aragoOver18:
          case CredentialSubjectType.pcdsAgentCertificate:
          case CredentialSubjectType.tezosAssociatedWallet:
          case CredentialSubjectType.ethereumAssociatedWallet:
          case CredentialSubjectType.certificateOfEmployment:
          case CredentialSubjectType.defaultCredential:
          case CredentialSubjectType.ecole42LearningAchievement:
          case CredentialSubjectType.emailPass:
          case CredentialSubjectType.diplomaCard:
          case CredentialSubjectType.identityPass:
          case CredentialSubjectType.learningAchievement:
          case CredentialSubjectType.loyaltyCard:
          case CredentialSubjectType.walletCredential:
          case CredentialSubjectType.bloometaPass:
          case CredentialSubjectType.dogamiPass:
          case CredentialSubjectType.troopezPass:
          case CredentialSubjectType.tzlandPass:
          case CredentialSubjectType.bunnyPass:
          case CredentialSubjectType.pigsPass:
          case CredentialSubjectType.tezoniaPass:
          case CredentialSubjectType.matterlightPass:
          case CredentialSubjectType.tezotopiaMembership:
          case CredentialSubjectType.chainbornMembership:
          case CredentialSubjectType.fantomAssociatedWallet:
          case CredentialSubjectType.polygonAssociatedWallet:
          case CredentialSubjectType.binanceAssociatedWallet:
          case CredentialSubjectType.linkedInCard:
          case CredentialSubjectType.tezosPooAddress:
          case CredentialSubjectType.ethereumPooAddress:
          case CredentialSubjectType.fantomPooAddress:
          case CredentialSubjectType.polygonPooAddress:
          case CredentialSubjectType.binancePooAddress:
            break;
        }

        emit(
          state.populate(
            identityCredentials: _credentials,
            identityCategories: identityCategories,
          ),
        );
        break;

      case CredentialCategory.blockchainAccountsCards:
        final _credentials = List.of(state.blockchainAccountsCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );
        emit(state.populate(blockchainAccountsCredentials: _credentials));
        break;

      case CredentialCategory.passCards:
        final _credentials = List.of(state.passCredentials)
          ..removeWhere(
            (element) => element.credentialModel?.id == credential.id,
          );
        emit(state.populate(passCredentials: _credentials));
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
        blockchainAccountsCredentials: [],
        passCredentials: [],
        othersCredentials: [],
        myProfessionalCredentials: [],
        gamingCategories: List.from(DiscoverList.gamingCategories),
        communityCategories: List.from(DiscoverList.communityCategories),
        identityCategories: List.from(DiscoverList.identityCategories),
        myProfessionalCategories:
            List.from(DiscoverList.myProfessionalCategories),
      ),
    );
  }
}
