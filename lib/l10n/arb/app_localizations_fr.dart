// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get genericError => 'Une erreur est survenue!';

  @override
  String get credentialListTitle => 'Identifiants';

  @override
  String credentialDetailIssuedBy(Object issuer) {
    return 'Émis par $issuer';
  }

  @override
  String get listActionRefresh => 'Rafraîchir';

  @override
  String get listActionViewList => 'Afficher sous forme de liste';

  @override
  String get listActionViewGrid => 'Afficher sous forme de grille';

  @override
  String get listActionFilter => 'Filtre';

  @override
  String get listActionSort => 'Trier';

  @override
  String get onBoardingStartSubtitle => 'Lorem ipsum dolor sit ame';

  @override
  String get onBoardingTosTitle => 'Conditions Générales d\'Utilisation (CGU)';

  @override
  String get onBoardingTosText =>
      'En appuyant sur Accepter \"J\'accepte les Conditions Générales d\'Utilisation (CGU).\"';

  @override
  String get onBoardingTosButton => 'Accepter';

  @override
  String get onBoardingRecoveryTitle => 'Récupération de clé';

  @override
  String get onBoardingRecoveryButton => 'Récupérer';

  @override
  String get onBoardingGenPhraseTitle => 'Phrase de récupération';

  @override
  String get onBoardingGenPhraseButton => 'Continuer';

  @override
  String get onBoardingGenTitle => 'Génération de clé privée';

  @override
  String get onBoardingGenButton => 'Générer';

  @override
  String get onBoardingSuccessTitle => 'Identifiant créé';

  @override
  String get onBoardingSuccessButton => 'Continuer';

  @override
  String get credentialDetailShare => 'Partager par QR code';

  @override
  String get credentialAddedMessage =>
      'Votre nouvelle attestation a bien été ajoutée !';

  @override
  String get credentialDetailDeleteCard => 'Supprimer';

  @override
  String get credentialDetailDeleteConfirmationDialog =>
      'Voulez-vous vraiment supprimer cette attestation ?';

  @override
  String get credentialDetailDeleteConfirmationDialogYes => 'Oui';

  @override
  String get credentialDetailDeleteConfirmationDialogNo => 'Non';

  @override
  String get credentialDetailDeleteSuccessMessage =>
      'Attestation supprimée avec succès.';

  @override
  String get credentialDetailEditConfirmationDialog =>
      'Voulez-vous vraiment modifier cette attestation ?';

  @override
  String get credentialDetailEditConfirmationDialogYes => 'Enregistrer';

  @override
  String get credentialDetailEditConfirmationDialogNo => 'Annuler';

  @override
  String get credentialDetailEditSuccessMessage => 'Modification réussie.';

  @override
  String get credentialDetailCopyFieldValue =>
      'Valeur du champ copiée dans le presse-papier !';

  @override
  String get credentialDetailStatus => 'Statut de vérification';

  @override
  String get credentialPresentTitle => 'Sélectionnez les attestations';

  @override
  String get credentialPresentTitleDIDAuth => 'Requête DIDAuth';

  @override
  String get credentialPresentRequiredCredential => 'Quelqu\'un demande votre';

  @override
  String get credentialPresentConfirm => 'Sélectionnez les attestations';

  @override
  String get credentialPresentCancel => 'Rejeter';

  @override
  String get selectYourTezosAssociatedWallet =>
      'Sélectionnez votre compte associé Tezos';

  @override
  String get credentialPickSelect => 'Sélectionnez votre identifiant';

  @override
  String get siopV2credentialPickSelect =>
      'Choisissez une attestations à présenter';

  @override
  String get credentialPickAlertMessage =>
      'Voulez-vous donner un alias à cette attestaion ?';

  @override
  String get credentialReceiveTitle => 'Offre d\'attestation';

  @override
  String get credentialReceiveHost => 'veut vous émettre une attestation';

  @override
  String get credentialAddThisCard => 'Ajouter cette attestation';

  @override
  String get credentialReceiveCancel => 'Annuler cette attestation';

  @override
  String get credentialDetailListTitle => 'Mon wallet';

  @override
  String get communicationHostAllow => 'Autoriser';

  @override
  String get communicationHostDeny => 'Refuser';

  @override
  String get scanTitle => 'Scanner le QR code';

  @override
  String get scanPromptHost => 'Faites-vous confiance à ce domaine ?';

  @override
  String get scanRefuseHost => 'La demande de connexion a été refusée.';

  @override
  String get scanUnsupportedMessage => 'L\'URL extraite n\'est pas valide.';

  @override
  String get qrCodeSharing => 'Vous partagez maintenant';

  @override
  String get qrCodeNoValidMessage =>
      'Ce QRCode ne contient pas de message valide.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get personalTitle => 'Personnel';

  @override
  String get termsTitle => 'Conditions Générales d\'Utilisation (CGU)';

  @override
  String get recoveryKeyTitle => 'Phrase de récupération';

  @override
  String get showRecoveryPhrase => 'Afficher la phrase de récupération';

  @override
  String get warningDialogTitle => 'Soyez prudent';

  @override
  String get recoveryText => 'Veuillez entrer votre phrase de récupération';

  @override
  String get recoveryMnemonicHintText =>
      'Saisissez votre phrase de récupération ici.  Une fois que vous avez saisi les 12 mots, appuyez sur Importer.';

  @override
  String get recoveryMnemonicError =>
      'Veuillez entrer une phrase mnémonique valide';

  @override
  String get showDialogYes => 'Continuer';

  @override
  String get showDialogNo => 'Annuler';

  @override
  String get supportTitle => 'Soutien';

  @override
  String get noticesTitle => 'Avis';

  @override
  String get resetWalletButton => 'Réinitialiser le wallet';

  @override
  String get resetWalletConfirmationText =>
      'Êtes-vous sûr de vouloir réinitialiser votre wallet ?';

  @override
  String get selectThemeText => 'Sélectionner un thème';

  @override
  String get lightThemeText => 'Thème clair';

  @override
  String get darkThemeText => 'Thème sombre';

  @override
  String get systemThemeText => 'Thème système';

  @override
  String get genPhraseInstruction =>
      'Écrivez ces 12 mots dans l\'ordre et conservez-les en lieu sûr';

  @override
  String get genPhraseExplanation =>
      'Si vous perdez l\'accès à ce wallet vous aurez besoin des mots dans l\'ordre et du fichier de sauvegarde pour récupérer vos attestations.';

  @override
  String get errorGeneratingKey =>
      'Échec de la génération de la clé, veuillez réessayer';

  @override
  String get documentHeaderTooltipName => 'Jean Doe';

  @override
  String get documentHeaderTooltipJob => 'Cryptocommerçant';

  @override
  String get documentHeaderTooltipLabel => 'Statut :';

  @override
  String get documentHeaderTooltipValue => 'Valide';

  @override
  String get didDisplayId => 'DID';

  @override
  String get blockChainDisplayMethod => 'Blockchain';

  @override
  String get blockChainAdress => 'Adresse';

  @override
  String get didDisplayCopy => 'Copier le DID dans le presse-papiers';

  @override
  String get adressDisplayCopy => 'Copier l\'adresse dans le presse-papiers';

  @override
  String get personalSave => 'Enregistrer';

  @override
  String get personalSubtitle =>
      'Les informations de votre profil peuvent être utilisées';

  @override
  String get personalFirstName => 'Prénom';

  @override
  String get personalLastName => 'Nom de famille';

  @override
  String get personalPhone => 'Téléphone';

  @override
  String get personalAddress => 'Adresse';

  @override
  String get personalMail => 'E-mail';

  @override
  String get lastName => 'Nom de famille';

  @override
  String get firstName => 'Prenom';

  @override
  String get gender => 'Sexe H/F';

  @override
  String get birthdate => 'Date de naissance';

  @override
  String get birthplace => 'Lieu de naissance';

  @override
  String get address => 'Adresse';

  @override
  String get maritalStatus => 'État matrimonial';

  @override
  String get nationality => 'Nationalité';

  @override
  String get identifier => 'Identifiant';

  @override
  String get issuer => 'Émis par';

  @override
  String get workFor => 'Travaille pour';

  @override
  String get startDate => 'Depuis';

  @override
  String get endDate => 'Jusqu\'à';

  @override
  String get employmentType => 'Type d\'emploi';

  @override
  String get jobTitle => 'Titre du poste';

  @override
  String get baseSalary => 'Salaire';

  @override
  String get expires => 'Fin d\'emploi';

  @override
  String get generalInformationLabel => 'Informations generales';

  @override
  String get learningAchievement => 'Réussite';

  @override
  String get signedBy => 'Signé par';

  @override
  String get from => 'De';

  @override
  String get to => 'À';

  @override
  String get credential => 'Attestations digitales';

  @override
  String get issuanceDate => 'Date d\'émission';

  @override
  String get appContactWebsite => 'Site web';

  @override
  String get trustFrameworkDescription =>
      'Le cadre de confiance repose sur un ensemble de registres fiables qui permettent aux entités du système de se faire confiance et d\'interagir ensemble.';

  @override
  String get confimrDIDAuth => 'Voulez-vous vous connecter à ce site ?';

  @override
  String get evidenceLabel => 'Preuve';

  @override
  String get networkErrorBadRequest => 'Mauvaise requête';

  @override
  String get networkErrorConflict => 'Erreur due à un conflit';

  @override
  String get networkErrorPreconditionFailed =>
      'Le serveur ne remplit pas l\'une des conditions préalables.';

  @override
  String get networkErrorCreated => '';

  @override
  String get networkErrorGatewayTimeout => 'Délai d\'attente trop long';

  @override
  String get networkErrorInternalServerError =>
      'Il s\'agit d\'une erreur interne du serveur. Contactez l\'administrateur du serveur';

  @override
  String get networkErrorMethodNotAllowed =>
      'L\'utilisateur n\'a pas les droits d\'accès au contenu';

  @override
  String get networkErrorNoInternetConnection => 'Pas de connexion Internet';

  @override
  String get networkErrorNotAcceptable => 'Non acceptable';

  @override
  String get networkErrorNotImplemented => 'Non implémenté';

  @override
  String get networkErrorOk => '';

  @override
  String get networkErrorRequestCancelled => 'Demande annulée';

  @override
  String get networkErrorRequestTimeout => 'Délai d\'expiration de la demande';

  @override
  String get networkErrorSendTimeout =>
      'Délai d\'envoi en connexion avec le serveur API';

  @override
  String get networkErrorServiceUnavailable => 'Service indisponible';

  @override
  String get networkErrorTooManyRequests =>
      'L\'utilisateur a envoyé trop de requêtes dans un laps de temps donné';

  @override
  String get networkErrorUnableToProcess => 'Impossible de traiter les données';

  @override
  String get networkErrorUnauthenticated =>
      'L\'utilisateur doit s\'authentifier pour obtenir la réponse demandée';

  @override
  String get networkErrorUnauthorizedRequest => 'Requête non autorisée';

  @override
  String get networkErrorUnexpectedError =>
      'Une erreur inattendue s\'est produite';

  @override
  String get networkErrorNotFound => 'Introuvable';

  @override
  String get active => 'Actif';

  @override
  String get expired => 'Expiré';

  @override
  String get revoked => 'Révoqué';

  @override
  String get ok => 'OK';

  @override
  String get unavailable_feature_title => 'Fonctionnalité non disponible';

  @override
  String get unavailable_feature_message =>
      'Cette fonctionnalité n\'est pas disponible sur le navigateur';

  @override
  String get personalSkip => 'Passer';

  @override
  String get restoreCredential => 'Restaurer mes attestations digitales';

  @override
  String get backupCredential => 'Sauvegarder mes attestations digitales';

  @override
  String get backupCredentialPhrase =>
      'Écrivez ces mots, téléchargez le fichier de sauvegarde et conservez-les en lieu sûr';

  @override
  String get backupCredentialPhraseExplanation =>
      'Pour sauvegarder vos informations d\'identification, notez votre phrase de récupération et conservez-la en lieu sûr.';

  @override
  String get backupCredentialButtonTitle => 'Enregistrer le fichier';

  @override
  String get needStoragePermission =>
      'Désolé, vous avez besoin d\'une autorisation pour télécharger ce fichier.';

  @override
  String get backupCredentialNotificationTitle => 'Succès';

  @override
  String get backupCredentialNotificationMessage =>
      'Le fichier a été téléchargé avec succès. Appuyez pour ouvrir le fichier.';

  @override
  String get backupCredentialError =>
      'Une erreur s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get backupCredentialSuccessMessage =>
      'Le fichier a été téléchargé avec succès.';

  @override
  String get restorationCredentialWarningDialogSubtitle =>
      'La restauration effacera toutes attestations que vous avez déjà dans votre wallet.';

  @override
  String get recoveryCredentialPhrase =>
      'Écrivez les mots et téléchargez le fichier de sauvegarde si vous l\'avez enregistré auparavant';

  @override
  String get recoveryCredentialPhraseExplanation =>
      'Vous avez besoin des deux mots dans le bon ordre et d\'un fichier de sauvegarde crypté pour récupérer vos attestations digitales';

  @override
  String get recoveryCredentialButtonTitle =>
      'Télécharger le fichier de sauvegarde';

  @override
  String recoveryCredentialSuccessMessage(Object postfix) {
    return 'Récupération réussie de $postfix.';
  }

  @override
  String get recoveryCredentialJSONFormatErrorMessage =>
      'Veuillez télécharger le fichier valide.';

  @override
  String get recoveryCredentialAuthErrorMessage =>
      'Désolé, soit les mnémoniques sont incorrects, soit le fichier téléchargé est corrompu.';

  @override
  String get recoveryCredentialDefaultErrorMessage =>
      'Une erreur s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get selfIssuedCreatedSuccessfully => 'Identifiant créé avec succès';

  @override
  String get companyWebsite => 'Site Web de l\'entreprise';

  @override
  String get submit => 'Envoyer';

  @override
  String get insertYourDIDKey => 'Insérez votre DID';

  @override
  String get importYourRSAKeyJsonFile =>
      'Importez votre fichier json de clé RSA';

  @override
  String get didKeyAndRSAKeyVerifiedSuccessfully =>
      'Les clés DID et RSA ont été vérifiées avec succès';

  @override
  String get pleaseEnterYourDIDKey => 'Veuillez entrer votre DID';

  @override
  String get pleaseImportYourRSAKey => 'Veuillez importer votre clé RSA';

  @override
  String get confirm => 'Confirmer';

  @override
  String get pleaseSelectRSAKeyFileWithJsonExtension =>
      'Veuillez sélectionner le fichier de clé RSA (avec l\'extension json)';

  @override
  String get rsaNotMatchedWithDIDKey => 'La clé RSA ne correspond pas au DID';

  @override
  String get didKeyNotResolved => 'DID non résolu';

  @override
  String get anUnknownErrorHappened => 'Une erreur inconnue s\'est produite';

  @override
  String get walletType => 'Type de wallet';

  @override
  String get chooseYourWalletType => 'Choisissez votre type de wallet';

  @override
  String get proceed => 'Continuer';

  @override
  String get enterpriseWallet => 'Wallet d\'entreprise';

  @override
  String get personalWallet => 'Wallet personnel';

  @override
  String get failedToVerifySelfIssuedCredential =>
      'Échec de la vérification de l\'identifiant émis';

  @override
  String get failedToCreateSelfIssuedCredential =>
      'Échec de la création de l\'identifiant';

  @override
  String get credentialVerificationReturnWarning =>
      'La vérification des identifiants a renvoyé des alertes. ';

  @override
  String get failedToVerifyCredential =>
      'Échec de la vérification des informations d\'identification.';

  @override
  String get somethingsWentWrongTryAgainLater =>
      'Une erreur s\'est produite, veuillez réessayer plus tard.';

  @override
  String get successfullyPresentedYourCredential =>
      'Votre attestation a été présentée avec succès !';

  @override
  String get successfullyPresentedYourDID =>
      'Votre DID a été présenté avec succès !';

  @override
  String get thisQRCodeIsNotSupported =>
      'Ce QR code n\'est pas pris en charge.';

  @override
  String get thisUrlDoseNotContainAValidMessage =>
      'Cette URL ne contient pas de message valide.';

  @override
  String get anErrorOccurredWhileConnectingToTheServer =>
      'Une erreur s\'est produite lors de la connexion au serveur.';

  @override
  String get failedToSaveMnemonicPleaseTryAgain =>
      'Échec de l\'enregistrement du mnémonique, veuillez réessayer';

  @override
  String get failedToLoadProfile => 'Échec du chargement du profil. ';

  @override
  String get failedToSaveProfile => 'Échec de l\'enregistrement du profil. ';

  @override
  String get failedToLoadDID => 'Échec du chargement du DID. ';

  @override
  String get personalOpenIdRestrictionMessage =>
      'Le wallet personnel n\'a pas accès.';

  @override
  String get credentialEmptyError =>
      'Vous n\'avez aucune attestation dans votre wallet.';

  @override
  String get credentialPresentTitleSiopV2 => 'Présenter l\'attestation';

  @override
  String get confirmSiopV2 => 'Veuillez confirmer l\'attestation présentée';

  @override
  String get storagePermissionRequired => 'Autorisation de stockage requise';

  @override
  String get storagePermissionDeniedMessage =>
      'Veuillez autoriser l\'accès au stockage afin de télécharger le fichier.';

  @override
  String get storagePermissionPermanentlyDeniedMessage =>
      'Vous avez besoin d\'une autorisation de stockage pour télécharger un fichier. Veuillez accéder aux paramètres de l\'application et accorder l\'accès à l\'autorisation de stockage.';

  @override
  String get cancel => 'Annuler';

  @override
  String get loading => 'Veuillez patienter un instant...';

  @override
  String get issuerWebsitesTitle => 'Obtenir les attestations';

  @override
  String get getCredentialTitle => 'Obtenir les attestations';

  @override
  String get participantCredential => 'Pass GaiaX';

  @override
  String get phonePassCredential => 'Preuve de téléphone';

  @override
  String get emailPassCredential => 'Preuve d\'e-mail';

  @override
  String get needEmailPass =>
      'Vous devez d\'abord obtenir une preuve d\'e-mail.';

  @override
  String get signature => 'signature';

  @override
  String get proof => 'preuve';

  @override
  String get verifyMe => 'Vérifiez-moi';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get credentialAlias => 'Alias pour documents';

  @override
  String get verificationStatus => 'État de la vérification';

  @override
  String get cardsPending => 'Attestation en attente';

  @override
  String get unableToProcessTheData => 'Impossible de traiter les données';

  @override
  String get unimplementedQueryType => 'Type de requête non disponible';

  @override
  String get onSubmittedPassBasePopUp => 'Vous allez recevoir un e-mail';

  @override
  String get myCollection => 'Ma collection';

  @override
  String get items => 'articles';

  @override
  String get succesfullyUpdated => 'Mise à jour réussie.';

  @override
  String get generate => 'générer';

  @override
  String get myAssets => 'Mes actifs';

  @override
  String get search => 'Rechercher';

  @override
  String get professional => 'Professionnel';

  @override
  String get splashSubtitle => 'Prenez le contrôle de vos données';

  @override
  String get poweredBy => 'Powered By';

  @override
  String get splashLoading => 'Chargement...';

  @override
  String get version => 'Version';

  @override
  String get cards => 'Cartes';

  @override
  String get nfts => 'NFTs';

  @override
  String get coins => 'Cryptos';

  @override
  String get getCards => 'Obtenir';

  @override
  String get close => 'Fermer';

  @override
  String get profile => 'Profil';

  @override
  String get infos => 'Infos';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get enterNewPinCode => 'Créez un code PIN pour protéger votre wallet';

  @override
  String get confirmYourPinCode => 'Confirmez votre code PIN';

  @override
  String get walletAltme => 'Wallet';

  @override
  String get createTitle => 'Créez ou importez votre adresse de wallet';

  @override
  String get createSubtitle =>
      'Vus êtes seul à avoir un accès à vos actifs ou à votre phase de récupération.';

  @override
  String get enterYourPinCode => 'Entrez votre code PIN';

  @override
  String get changePinCode => 'Modifier le code PIN';

  @override
  String get tryAgain => 'Réessayez';

  @override
  String get credentialSelectionListEmptyError =>
      'Il vous manque une ou plusieurs attestations pour poursuivre.';

  @override
  String get trustedIssuer => 'Cet émetteur est approuvé par l\'EBSI.';

  @override
  String get yourPinCodeChangedSuccessfully =>
      'Votre code PIN a bien été modifié';

  @override
  String get advantagesCards => 'Cartes avantages';

  @override
  String get advantagesDiscoverCards => 'Débloquer des récompenses uniques';

  @override
  String get identityCards => 'Attestations d\'identités';

  @override
  String get identityDiscoverCards => 'Simplifiez la vérification d\'identité';

  @override
  String get contactInfoCredentials => 'Cartes de communauté';

  @override
  String get contactInfoDiscoverCredentials =>
      'Vérifiez vos informations de contact';

  @override
  String get myProfessionalCards => 'Attestations professionnelles';

  @override
  String get otherCards => 'Autres cartes et attestations';

  @override
  String get inMyWallet => 'Dans mon wallet';

  @override
  String get details => 'Détails';

  @override
  String get getIt => 'Obtenir';

  @override
  String get getItNow => 'Obtenir maintenant';

  @override
  String get getThisCard => 'Obtenir maintenant';

  @override
  String get drawerBiometrics => 'Authentification biométrique';

  @override
  String get drawerTalaoCommunityCard => 'Carte de communauté Talao';

  @override
  String get drawerTalaoCommunityCardTitle =>
      'Importez votre adresse Ethereum et obtenez votre carte de membre.';

  @override
  String get drawerTalaoCommunityCardSubtitle =>
      'Elle vous donnera accès aux meilleures réductions, adhésions et bons d\'achat de notre écosystème de partenaires.';

  @override
  String get drawerTalaoCommunityCardTextBoxMessage =>
      'Une fois que vous avez entré votre clé privée, appuyez sur Importer. Veuillez vous assurer d\'entrer la clé privée Ethereum qui contient vos tokens Talao.';

  @override
  String get drawerTalaoCommunityCardSubtitle2 =>
      'Le wallet est entièrement décentralisé. Nous n\'avons jamais accès à vos clés privées ou à vos actifs.';

  @override
  String get drawerTalaoCommunityCardKeyError =>
      'Veuillez saisir une clé privée valide';

  @override
  String get loginWithBiometricsMessage =>
      'Déverrouillez rapidement votre wallet sans avoir à saisir de mot de passe ou de code PIN';

  @override
  String get manage => 'Gérer';

  @override
  String get wallet => 'Wallet';

  @override
  String get manageAccounts => 'Gérer vos comptes blockchain';

  @override
  String get blockchainAccounts => 'Comptes blockchain';

  @override
  String get educationCredentials => 'Attestations académiques';

  @override
  String get educationDiscoverCredentials =>
      'Vérifiez votre parcours académique';

  @override
  String get educationCredentialsDiscoverSubtitle =>
      'Obtenez vos diplômes sous forme digitale';

  @override
  String get security => 'Sécurité';

  @override
  String get networkAndRegistries => 'Réseau et registres';

  @override
  String get chooseNetwork => 'Choisir un réseau';

  @override
  String get chooseRegistry => 'Choisir le registre';

  @override
  String get trustFramework => 'Cadre de confiance';

  @override
  String get network => 'Réseau';

  @override
  String get issuerRegistry => 'Registre des émetteurs';

  @override
  String get termsOfUse => 'Conditions Générales d\'Utilisation (CGU)';

  @override
  String get scanFingerprintToAuthenticate =>
      'Scanner l\'empreinte digitale pour s\'authentifier';

  @override
  String get biometricsNotSupported =>
      'La biométrie n\'est pas prise en charge';

  @override
  String get deviceDoNotSupportBiometricsAuthentication =>
      'Votre appareil ne prend pas en charge l\'authentification biométrique';

  @override
  String get biometricsEnabledMessage =>
      'Vous pouvez maintenant déverrouiller l\'application avec vos données biométriques.';

  @override
  String get biometricsDisabledMessage =>
      'L\'identification biométrique a été désactivée.';

  @override
  String get exportSecretKey => 'Exporter la clé secrète';

  @override
  String get secretKey => 'Clé secrète';

  @override
  String get chooseNetWork => 'Choisir un réseau';

  @override
  String get nftEmptyMessage => 'Votre collection NFT est vide !';

  @override
  String get myAccount => 'Mon compte';

  @override
  String get cryptoAccounts => 'Comptes';

  @override
  String get cryptoAccount => 'Compte';

  @override
  String get cryptoAddAccount => 'Ajouter un compte';

  @override
  String get cryptoAddedMessage =>
      'Votre compte crypto a été ajouté avec succès.';

  @override
  String get cryptoEditConfirmationDialog =>
      'Voulez-vous vraiment modifier le nom de ce compte crypto ?';

  @override
  String get cryptoEditConfirmationDialogYes => 'Enregistrer';

  @override
  String get cryptoEditConfirmationDialogNo => 'Annuler';

  @override
  String get cryptoEditLabel => 'Nom du compte';

  @override
  String get onBoardingFirstTitle =>
      'Découvrez des offres uniques directement dans votre wallet.';

  @override
  String get onBoardingFirstSubtitle =>
      'Obtenez des cartes de membre, des cartes de fidélité et bien d\'autres avantages.';

  @override
  String get onBoardingSecondTitle =>
      'Ce wallet est bien plus qu\'un simple wallet.';

  @override
  String get onBoardingSecondSubtitle =>
      'Stockez et gérez vos données personnelles et accédez aux applications Web3.';

  @override
  String get onBoardingThirdTitle =>
      'Gérez vos données en toute autonomie, sécurité et confidentialité.';

  @override
  String get onBoardingThirdSubtitle =>
      'Ce wallet utilise la cryptographie pour vous donner un contrôle total sur vos données. Rien ne sort de votre téléphone.';

  @override
  String get onBoardingStart => 'Démarrer';

  @override
  String get learnMoreAboutAltme => 'En savoir plus sur le wallet';

  @override
  String get scroll => 'Défilement';

  @override
  String get agreeTermsAndConditionCheckBox =>
      'J\'accepte les Conditions Générales d\'Utilisation (CGU).';

  @override
  String get readTermsOfUseCheckBox =>
      'J\'ai lu les Conditions Générales d\'Utilisation (CGU).';

  @override
  String get createOrImportNewAccount => 'Créer ou importer un nouveau compte.';

  @override
  String get selectAccount => 'Sélectionner un compte';

  @override
  String get onbordingSeedPhrase => 'Phrase de récupération';

  @override
  String get onboardingPleaseStoreMessage =>
      'Veuillez noter votre phrase de récupération';

  @override
  String get onboardingVerifyPhraseMessage =>
      'Confirmez votre phrase de récupération';

  @override
  String get onboardingVerifyPhraseMessageDetails =>
      'Pour vous assurer que votre phrase de récupération est écrite correctement, sélectionnez les mots dans l\'ordre.';

  @override
  String get onboardingAltmeMessage =>
      'Ce wallet est décentralisé (non custodial). Votre phrase de récupération est le seul moyen de récupérer votre compte.';

  @override
  String get onboardingWroteDownMessage =>
      'J\'ai écrit ma phrase de récupération';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  @override
  String get pinCodeMessage =>
      'Le code PIN protège contre un accès non autorisé à votre wallet. Vous pouvez le modifier à tout moment.';

  @override
  String get enterNameForYourNewAccount =>
      'Entrez un nom pour votre nouveau compte';

  @override
  String get create => 'Créer';

  @override
  String get import => 'Importer';

  @override
  String get accountName => 'Nom du compte';

  @override
  String get importWalletText =>
      'Entrez ici votre phrase de récupération ou votre clé privée.';

  @override
  String get importWalletTextRecoveryPhraseOnly =>
      'Saisissez votre phrase de récupération ici.';

  @override
  String get recoveryPhraseDescriptions =>
      'Une phrase de récupération est une liste de 12 mots générés par votre crypto wallet donnant accès à vos actifs';

  @override
  String get importEasilyFrom => 'Importez votre compte depuis :';

  @override
  String get templeWallet => 'Temple';

  @override
  String get temple => 'Temple';

  @override
  String get metaMaskWallet => 'Metamask';

  @override
  String get metaMask => 'Metamask';

  @override
  String get kukai => 'Kukai';

  @override
  String get kukaiWallet => 'Kukai';

  @override
  String get other => 'Autre';

  @override
  String get otherWalletApp => 'Autre wallet';

  @override
  String importWalletHintText(Object numberCharacters) {
    return 'Une fois que vous avez saisi les 12 mots de phrase de récupération ou les $numberCharacters caractères de la clé privée, appuyez sur Importer.';
  }

  @override
  String get importWalletHintTextRecoveryPhraseOnly =>
      'Une fois que vous avez entré les 12 mots de la phrase de récupération, appuyer sur Importer.';

  @override
  String get kycDialogTitle =>
      'Pour obtenir cette attestation, vous devez faire vérifier votre identité';

  @override
  String get idVerificationProcess => 'Processus de vérification d\'identité';

  @override
  String get idCheck => 'Vérification d\'identité';

  @override
  String get facialRecognition => 'Reconnaissance faciale';

  @override
  String get kycDialogButton => 'Démarrer la vérification d\'identité';

  @override
  String get kycDialogFooter => 'Conforme RGPD + Niveau de sécurité SOC2';

  @override
  String get finishedVerificationTitle => 'Vérification d\'identité en cours';

  @override
  String get finishedVerificationDescription =>
      'Vous recevrez un e-mail une fois que votre identité aura été vérifiée';

  @override
  String get verificationPendingTitle =>
      'Votre vérification d\'identité est en cours';

  @override
  String get verificationPendingDescription =>
      'En général, la vérification prend moins de 5 minutes. Vous recevrez un e-mail une fois la vérification terminée.';

  @override
  String get verificationDeclinedTitle => 'La vérification a échoué';

  @override
  String get restartVerification => 'Redémarrer la vérification d\'identité';

  @override
  String get verificationDeclinedDescription =>
      'La vérification a échoué. Veuillez redémarrer votre vérification d\'identité.';

  @override
  String get verifiedTitle => 'Bravo ! La vérification est réussie.';

  @override
  String get verifiedDescription =>
      'Vous pouvez ajouter votre preuve d\'âge. Commençons.';

  @override
  String get verfiedButton => 'Ajout de la preuve d\'âge : + de 18 ans';

  @override
  String get verifiedNotificationTitle => 'Vérification terminée !';

  @override
  String get verifiedNotificationDescription =>
      'Félicitations ! Vous avez été vérifié avec succès.';

  @override
  String get showDecentralizedID =>
      'Afficher l\'identifiant décentralisé (DID)';

  @override
  String get manageDecentralizedID =>
      'Gérer les identifiants décentralisés (DID)';

  @override
  String get addressBook => 'Carnet d\'adresses';

  @override
  String get home => 'Mon wallet';

  @override
  String get discover => 'Découvrir';

  @override
  String get settings => 'Paramètres';

  @override
  String get privateKeyDescriptions =>
      'Une clé privée est un code secret utilisé pour signer des transactions et prouver la propriété d\'un compte blockchain. La clé privée comporte généralement de 32 à 54 caractères.';

  @override
  String get importAccount => 'Importer un compte';

  @override
  String get imported => 'Importé';

  @override
  String get cardDetails => 'Détails';

  @override
  String get publicAddress => 'Adresse publique';

  @override
  String get didKey => 'Clé';

  @override
  String get export => 'Exporter';

  @override
  String get copy => 'Copier';

  @override
  String get didPrivateKey => 'Clé privée';

  @override
  String get reveal => 'Révéler';

  @override
  String get didPrivateKeyDescription =>
      'Soyez prudent avec vos clés privées, car elles contrôlent l\'accès à vos informations personnelles.';

  @override
  String get didPrivateKeyDescriptionAlert =>
      'Ne partagez votre clé privée sous aucun prétexte.';

  @override
  String get iReadTheMessageCorrectly => 'J\'ai bien lu le message';

  @override
  String get beCareful => 'Soyez prudent';

  @override
  String get decentralizedIDKey => 'Clé de l\'identité décentralisée';

  @override
  String get copySecretKeyToClipboard =>
      'Clé secrète copiée dans le presse-papier !';

  @override
  String get copyDIDKeyToClipboard => 'Clé copiée dans le presse-papier !';

  @override
  String get seeAddress => 'Voir l\'adresse';

  @override
  String get revealPrivateKey => 'Révéler la clé privée';

  @override
  String get share => 'Partager';

  @override
  String get shareWith => 'Partager avec';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papier !';

  @override
  String get privateKey => 'Clé privée';

  @override
  String get decentralizedID => 'Identité décentralisée (DID)';

  @override
  String get did => 'DID';

  @override
  String get sameAccountNameError =>
      'Ce nom de compte a déjà été utilisé ; entrez un nom de compte dTemifférent, svp';

  @override
  String get unknown => 'Inconnu';

  @override
  String get credentialManifestDescription => 'Description';

  @override
  String get credentialManifestInformations => 'Informations';

  @override
  String get credentialDetailsActivity => 'Activité';

  @override
  String get credentialDetailsOrganisation => 'Organisation';

  @override
  String get credentialDetailsPresented => 'Présenté';

  @override
  String get credentialDetailsOrganisationDetail =>
      'Détail de l\'organisation :';

  @override
  String get credentialDetailsInWalletSince => 'Dans le wallet depuis';

  @override
  String get termsOfUseAndLicenses =>
      'Conditions Générales d\'Utilisation (CGU) et licences';

  @override
  String get licenses => 'Licences';

  @override
  String get sendTo => 'Envoyer';

  @override
  String get next => 'Suivant';

  @override
  String get withdrawalInputHint => 'Copier l\'adresse, scanner ou rechercher';

  @override
  String get amount => 'Montant';

  @override
  String get amountSent => 'Montant envoyé';

  @override
  String get max => 'Max';

  @override
  String get edit => 'Éditer';

  @override
  String get networkFee => 'Frais de réseau';

  @override
  String get totalAmount => 'Montant total';

  @override
  String get selectToken => 'Sélectionner le token';

  @override
  String get insufficientBalance => 'Solde insuffisant';

  @override
  String get slow => 'Lent';

  @override
  String get average => 'Moyen';

  @override
  String get fast => 'Rapide';

  @override
  String get changeFee => 'Modifier les frais';

  @override
  String get sent => 'Envoyé';

  @override
  String get done => 'fait';

  @override
  String get link => 'Cliquez pour accéder';

  @override
  String get myTokens => 'Mes Cryptos';

  @override
  String get tezosMainNetwork => 'Réseau principal Tezos';

  @override
  String get send => 'Envoyer';

  @override
  String get receive => 'Recevoir';

  @override
  String get recentTransactions => 'Transactions récentes';

  @override
  String sendOnlyToThisAddressDescription(Object symbol) {
    return 'Envoyez uniquement $symbol à cette adresse. L\'envoi d\'autres cryptos peut entraîner une perte.';
  }

  @override
  String get addTokens => 'Ajouter des Cryptos';

  @override
  String get providedBy => 'Fourni par';

  @override
  String get issuedOn => 'Émis le';

  @override
  String get expirationDate => 'Date d\'expiration';

  @override
  String get connect => 'Se connecter';

  @override
  String get connection => 'Connexion';

  @override
  String get selectAccountToGrantAccess =>
      'Sélectionnez le compte auquel accorder l\'accès :';

  @override
  String get requestPersmissionTo => 'Demander l\'autorisation à :';

  @override
  String get viewAccountBalanceAndNFTs =>
      'Afficher le solde du compte et les NFTs';

  @override
  String get requestApprovalForTransaction =>
      'Demande d\'approbation pour la transaction';

  @override
  String get connectedWithBeacon => 'Connexion réussie';

  @override
  String get failedToConnectWithBeacon => 'Échec de la connexion';

  @override
  String get tezosNetwork => 'Réseau Tezos';

  @override
  String get confirm_sign => 'Confirmer la signature';

  @override
  String get sign => 'Signer';

  @override
  String get payload_to_sign => 'Transaction à signer';

  @override
  String get signedPayload => 'Transaction signée avec succès';

  @override
  String get failedToSignPayload => 'Échec de la signature';

  @override
  String get voucher => 'Bon';

  @override
  String get tezotopia => 'Tezotopia';

  @override
  String get operationCompleted =>
      'Votre demande a été prise en compte. La transaction peut mettre quelques minutes à s\'afficher.';

  @override
  String get operationFailed => 'L\'opération a échoué';

  @override
  String get membership => 'Adhésion';

  @override
  String get switchNetworkMessage => 'Veuillez changer de réseau';

  @override
  String get fee => 'Frais';

  @override
  String get addCards => 'Ajouter';

  @override
  String get gaming => 'Jeux';

  @override
  String get identity => 'identité';

  @override
  String get payment => 'Paiement';

  @override
  String get socialMedia => 'Réseaux sociaux';

  @override
  String get advanceSettings => 'Paramètres avancés';

  @override
  String get categories => 'Catégories';

  @override
  String get selectCredentialCategoryWhichYouWantToShowInCredentialList =>
      'Sélectionnez les types d\'attestations que vous souhaitez afficher dans la liste :';

  @override
  String get community => 'Communauté';

  @override
  String get tezos => 'Tezos';

  @override
  String get rights => 'Droits';

  @override
  String get disconnectAndRevokeRights => 'Déconnecter et révoquer les droits';

  @override
  String get revokeAllRights => 'Révoquer tous les droits';

  @override
  String get revokeSubtitleMessage =>
      'Êtes-vous sûr de vouloir révoquer tous les droits';

  @override
  String get revokeAll => 'Révoquer tout';

  @override
  String get succesfullyDisconnected => 'Déconnexion réussie.';

  @override
  String get connectedApps => 'DApps connectées';

  @override
  String get manageConnectedApps => 'Gérer les DApps connectées';

  @override
  String get noDappConnected => 'Aucune DApp connectée pour le moment';

  @override
  String get nftDetails => 'Détails';

  @override
  String get failedToDoOperation => 'Échec de l\'opération';

  @override
  String get nft => 'NFT';

  @override
  String get receiveNft => 'Recevoir NFT';

  @override
  String get sendOnlyNftToThisAddressDescription =>
      'Envoyez uniquement des NFTs à cette adresse. L\'envoi de NFT depuis un autre réseau peut entraîner une perte permanente.';

  @override
  String get beaconShareMessage =>
      'Envoyez uniquement des tokens et NFTs Tezos (FA2 Standard) à cette adresse. L\'envoi de Tezos et de NFT depuis d\'autres réseaux peut entraîner une perte permanente';

  @override
  String get advantagesCredentialHomeSubtitle =>
      'Bénéficiez d\'avantages offerts par les jeux Web3.';

  @override
  String get advantagesCredentialDiscoverSubtitle =>
      'Bénéficiez d\'avantages offerts par les jeux Web3.';

  @override
  String get identityCredentialHomeSubtitle =>
      'Prouvez votre identité tout en protégeant vos données.';

  @override
  String get identityCredentialDiscoverSubtitle =>
      'Prouvez votre identité tout en protégeant vos données.';

  @override
  String get myProfessionalCredentialDiscoverSubtitle =>
      'Utilisez vos attestations professionnelles en toute sécurité.';

  @override
  String get blockchainAccountsCredentialHomeSubtitle =>
      'Utilisez vos comptes blockchains en toute sécurité.';

  @override
  String get educationCredentialHomeSubtitle =>
      'Prouvez votre formation instantanément.';

  @override
  String get passCredentialHomeSubtitle =>
      'Utilisez des pass exclusifs : améliorez votre expérience web3.';

  @override
  String get financeCardsCredentialHomeSubtitle =>
      'Accédez à de nouvelles opportunités d\'investissement dans le web3';

  @override
  String get financeCardsCredentialDiscoverSubtitle =>
      'Obtenez des avantages uniques offerts par les communautés que vous aimez';

  @override
  String get contactInfoCredentialHomeSubtitle =>
      'Partagez instantanément vos données de contact';

  @override
  String get contactInfoCredentialDiscoverSubtitle =>
      'Obtenez des attestations digitales et faciles à partager';

  @override
  String get otherCredentialHomeSubtitle =>
      'Autres types d\'attestations digitales de votre wallet';

  @override
  String get otherCredentialDiscoverSubtitle =>
      'Autres types d\'attestations que vous pouvez ajouter';

  @override
  String get showMore => '...Afficher plus';

  @override
  String get showLess => 'Afficher moins...';

  @override
  String get gotIt => 'J\'ai compris';

  @override
  String get transactionErrorBalanceTooLow =>
      'Votre solde n\'est pas suffisant';

  @override
  String get transactionErrorCannotPayStorageFee =>
      'Les frais sont supérieurs au solde de votre compte';

  @override
  String get transactionErrorFeeTooLow =>
      'Les frais de transaction ne sont pas assez élevés';

  @override
  String get transactionErrorFeeTooLowForMempool =>
      'Les frais sont trop faibles pour être pris en compte dans le mempool';

  @override
  String get transactionErrorTxRollupBalanceTooLow =>
      'Vous n\'avez pas le solde requis';

  @override
  String get transactionErrorTxRollupInvalidZeroTransfer =>
      'Le montant doit être supérieur à zéro.';

  @override
  String get transactionErrorTxRollupUnknownAddress =>
      'L\'adresse n\'est pas reconnue.';

  @override
  String get transactionErrorInactiveChain =>
      'Blockchain inactive actuellement.';

  @override
  String get website => 'Website';

  @override
  String get whyGetThisCard => 'Description';

  @override
  String get howToGetIt => 'Comment l\'obtenir';

  @override
  String get emailPassWhyGetThisCard =>
      'Cette attestation peut être requise par certaines applications ou sites web pour accéder à leurs services ou obtenir des avantages : Carte de membre, Carte de fidélité, Rewards, etc.';

  @override
  String get emailPassExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 an.';

  @override
  String get emailPassHowToGetIt =>
      'La vérification sera réalisée en envoyant un code secret sur votre adresse email.';

  @override
  String get tezotopiaMembershipWhyGetThisCard =>
      'Cette carte de membre vous donnera 25 % de remise sur TOUTES les transactions du jeu Tezotopia lorsque vous achetez un Drops sur le marché ou mintez un NFT sur starbase.';

  @override
  String get tezotopiaMembershipExpirationDate =>
      'Cetteattestation restera active et réutilisable pendant 1 AN.';

  @override
  String get tezotopiaMembershipLongDescription =>
      'Tezotopia est un jeu NFT en temps réel sur Tezos, où les joueurs participent à des batailles pour des récompenses et revendiquent des terres dans une aventure immersive. Explorez le métaverse, collectez des NFTs et conquérez Tezotopia.';

  @override
  String get chainbornMembershipHowToGetIt =>
      'Pour obtenir cette carte, vous devez invoquer un \"héros\" dans le jeu Chainborn et partager une preuve d\'e-mail. Vous pouvez trouver la carte \"Attestation d\'email\" dans la section \"Découvrir\".';

  @override
  String get chainbornMembershipWhyGetThisCard =>
      'Soyez parmi les premiers à accéder au contenu exclusif de la boutique Chainborn, aux airdrops et aux autres avantages réservés aux membres !';

  @override
  String get chainbornMembershipExpirationDate =>
      'Cetteattestation restera active et réutilisable pendant 1 AN.';

  @override
  String get chainbornMembershipLongDescription =>
      'Chainborn est un jeu de bataille NFT où les joueurs utilisent leurs propres NFT comme héros. Participez à des combats palpitants, gagnez des points d\'expérience pour renforcer la force et la santé de votre héros, et augmentez la valeur de vos NFT dans cette captivante aventure Tezos.';

  @override
  String get twitterHowToGetIt =>
      'Suivez les étapes sur TezosProfiles https://tzprofiles.com/connect. Ensuite, obtenez la carte \"compte Twitter\" dans votre wallet. Assurez-vous de signer la transaction sur TZPROFILES avec le même compte que vous utilisez dans le wallet. ';

  @override
  String get twitterWhyGetThisCard =>
      'Cetteattestation est une preuve que vous possédez votre compte Twitter. Utilisez-la pour prouver la propriété de votre compte Twitter chaque fois que vous en avez besoin.';

  @override
  String get twitterExpirationDate =>
      'Cetteattestation sera active pendant 1 an.';

  @override
  String get twitterDummyDesc => 'Prouvez la propriété de votre compte Twitter';

  @override
  String get tezotopiaMembershipHowToGetIt =>
      'Vous devez présenter une attestation de nationalité et une preuve de tranche d\'âge. Obtenez-les en réalisant une vérification d\'identité.';

  @override
  String get over18WhyGetThisCard =>
      'Cette attestation peut être requise par certaines applications ou sites internet pour accéder à leurs services ou obtenir des avantages : Carte de membre, Carte de fidélité, Rewards, etc.';

  @override
  String get over18ExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get over18HowToGetIt =>
      'Vous pouvez obtenir cette attestation en réalisant une estimation d\'âge avec le wallet.';

  @override
  String get over13WhyGetThisCard =>
      'Cette attestation peut être requise par certaines applications ou sites internet pour accéder à leurs services ou obtenir des avantages : Carte de membre, Carte de fidélité, Rewards, etc.';

  @override
  String get over13ExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get over13HowToGetIt =>
      'Vous pouvez obtenir cette attestation en réalisant une estimation d\'âge avec le wallet.';

  @override
  String get over15WhyGetThisCard =>
      'Cette attesttaion peut être requise par certaines applications ou sites internet pour accéder à leurs services ou obtenir des avantages : Carte de membre, fidélité, Rewards, etc.';

  @override
  String get over15ExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get over15HowToGetIt =>
      'Vous pouvez obtenir cette attestation en réalisant une estimation d\'âge avec le wallet.';

  @override
  String get passportFootprintWhyGetThisCard =>
      'Cette attestation peut être requise par certaines applications ou sites internet pour accéder à leurs services ou obtenir des avantages : Carte de membre, Carte de fidélité, Rewards, etc.';

  @override
  String get passportFootprintExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get passportFootprintHowToGetIt =>
      'Vous pouvez obtenir cette attestation en réalisant une vérification d\'identité avec le wallet.';

  @override
  String get verifiableIdCardWhyGetThisCard =>
      'Cette attestation digitale contient les mêmes informations que votre carte d\'identité physique. Vous pouvez l\'utiliser pour prouver votre identité.';

  @override
  String get verifiableIdCardExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get verifiableIdCardHowToGetIt =>
      'Vous pouvez obtenir cette attestation en réalisant une vérification d\'identité avec le wallet.';

  @override
  String get verifiableIdCardDummyDesc =>
      'Obtenez votre carte d\'identité digitale.';

  @override
  String get phoneProofWhyGetThisCard =>
      'Cette attestation peut être requise par certaines applications ou sites internet pour accéder à leur service ou obtenir des avantages : Carte de membre, Carte de fidélité, Rewards, etc.';

  @override
  String get phoneProofExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get phoneProofHowToGetIt =>
      'La vérification sera réalisée en envoyant un code secret par SMS.';

  @override
  String get tezVoucherWhyGetThisCard =>
      'Cette attestation vous donnera 10 % de remise en argent sur TOUTES les transactions du jeu Tezotopia lorsque vous achetez un Drops sur le marché ou frappez un NFT sur starbase.';

  @override
  String get tezVoucherExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 30 jours.';

  @override
  String get tezVoucherHowToGetIt =>
      ' C\'est super facile. Vous pouvez l\'obtenir gratuitement dès maintenant.';

  @override
  String get genderWhyGetThisCard =>
      'Cette attestation est utile pour prouver votre sexe (Homme / Femme) sans révéler aucune autre information vous concernant. Elle peut être utilisée dans une enquête auprès d\'utilisateurs, etc.';

  @override
  String get genderExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get genderHowToGetIt =>
      'Vous pouvez obtenir cette attestation en réalisant une vérification d\'identité en ligne.';

  @override
  String get nationalityWhyGetThisCard =>
      'Cette information d\'identification est utile pour prouver votre nationalité sans révéler aucune autre information vous concernant. Elle peut être requise par certains sites ou applications.';

  @override
  String get nationalityExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get nationalityHowToGetIt =>
      'Vous pouvez obtenir cetteattestation en réalisant une vérification d\'identité avec le wallet.';

  @override
  String get ageRangeWhyGetThisCard =>
      'Cet identifiant est utile pour prouver votre tranche d\'âge sans révéler aucune autre information vous concernant. Il peut être requis par certains sites ou applications ou pour obtenir des avantages : carte de membre, etc.';

  @override
  String get ageRangeExpirationDate =>
      'Cette attestation restera active et réutilisable pendant 1 AN.';

  @override
  String get ageRangeHowToGetIt =>
      'Vous pouvez obtenir cetteattestation en réalisant une estimation d\'âge avec le wallet.';

  @override
  String get defiComplianceWhyGetThisCard =>
      'Obtenez une attestation de conformité KYC/AML, souvent demandée par les protocoles DeFi et les applications Web3. Vous pourrez ensuite obtenir un NFT non transférable pour être vérifiée directement on-chain sans révéler vos données personnelles.';

  @override
  String get defiComplianceExpirationDate =>
      'Cette attestation restera active pendant 3 mois. Le renouvellement nécessite une vérification simple.';

  @override
  String get defiComplianceHowToGetIt =>
      'C\'est facile ! Effectuez une vérification d\'identité avec le wallet et demandez votre attestation de conformité pour la DeFi.';

  @override
  String get origin => 'Origine';

  @override
  String get nftTooBigToLoad => 'En cours de chargement';

  @override
  String get seeTransaction => 'Voir la transaction';

  @override
  String get nftListSubtitle => 'Voici tous les NFTs de votre collection.';

  @override
  String get tokenListSubtitle => 'Voici toutes les cryptos de votre compte.';

  @override
  String get my => 'Mes';

  @override
  String get get => 'Obtenir';

  @override
  String get seeMoreNFTInformationOn =>
      'Voir plus d\'informations sur les NFT sur';

  @override
  String get credentialStatus => 'Statut';

  @override
  String get pass => 'passe';

  @override
  String get payloadFormatErrorMessage => 'Le format est incorrect.';

  @override
  String get thisFeatureIsNotSupportedMessage =>
      'Cette fonctionnalité n\'est pas encore prise en charge';

  @override
  String get myWallet => 'Mon wallet';

  @override
  String get ethereumNetwork => 'Réseau Ethereum';

  @override
  String get fantomNetwork => 'Réseau Fantom';

  @override
  String get polygonNetwork => 'Réseau Polygon';

  @override
  String get binanceNetwork => 'Réseau BNB Chain';

  @override
  String get step => 'Étape';

  @override
  String get activateBiometricsTitle =>
      'Activer le contrôle bométrique pour renforcer la sécurité';

  @override
  String get loginWithBiometricsOnBoarding => 'Contôle biométrique';

  @override
  String get option => 'Option';

  @override
  String get start => 'Démarrer';

  @override
  String get iAgreeToThe => 'J\'accepte les ';

  @override
  String get termsAndConditions => 'Conditions Générales d\'Utilisation (CGU)';

  @override
  String get walletReadyTitle => 'Votre wallet est prêt !';

  @override
  String get walletReadySubtitle => 'Explorez l\'univers Web3.';

  @override
  String get failedToInitCamera => 'L\'initialisation de la caméra a échoué !';

  @override
  String get chooseMethodPageOver18Title =>
      'Choisissez une méthode pour vérifier que vous avez + de 18 ans';

  @override
  String get chooseMethodPageOver13Title =>
      'Choisissez une méthode pour vérifier que vous avez + de 13 ans';

  @override
  String get chooseMethodPageOver15Title =>
      'Choisissez une méthode pour obtenir votre attestation de + de 15 ans';

  @override
  String get chooseMethodPageOver21Title =>
      'Choisissez une méthode pour obtenir votre attestation de + de 21 ans';

  @override
  String get chooseMethodPageOver50Title =>
      'Choisissez une méthode pour obtenir votre attestation de + de 50 ans';

  @override
  String get chooseMethodPageOver65Title =>
      'Choisissez une méthode pour obtenir votre attestation de + de 65 ans';

  @override
  String get chooseMethodPageAgeRangeTitle =>
      'Choisissez une méthode pour obtenir une preuve de tranche d\'âge';

  @override
  String get chooseMethodPageVerifiableIdTitle =>
      'Choisissez une méthode pour obtenir une attestation digitale d\'identité';

  @override
  String get chooseMethodPageDefiComplianceTitle =>
      'Choisissez une méthode pour obtenir une attestation de conformité pour la DeFi';

  @override
  String get chooseMethodPageSubtitle =>
      'Identifiez-vous en prenant une photo ou en partageant un document d\'identité.';

  @override
  String get kycTitle => 'Selfie / Photo (1 min)';

  @override
  String get kycSubtitle =>
      'Obtenez une estimation instantanée de votre âge en vous prenant en photo.';

  @override
  String get passbaseTitle => 'Vérification avec document d\'identité';

  @override
  String get passbaseSubtitle =>
      'Obtenez une vérification avec une carte d\'identité, un passeport ou un permis de conduire.';

  @override
  String get verifyYourAge => 'Vérifiez votre âge';

  @override
  String get verifyYourAgeSubtitle =>
      'Ce mode de vérification de l\'âge est très simple. Il suffit d\'un selfie.';

  @override
  String get verifyYourAgeDescription =>
      'En acceptant, vous donnez l\'autorisation d\'utiliser votre photo pour estimer votre âge. L\'estimation est effectuée par notre partenaire Yoti qui utilise votre photo uniquement à cette fin et la supprime immédiatement après. Pour plus d\'information, consultez les CGU.';

  @override
  String get accept => 'Accepter';

  @override
  String get decline => 'Refuser';

  @override
  String get yotiCameraAppbarTitle =>
      'Rapprochez votre visage au plus près du smartphone avant de prendre la photo';

  @override
  String get cameraSubtitle =>
      'Vous avez 5 secondes pour prendre votre photo. Rapprochez votre visage au plus près avant de commencer.';

  @override
  String get walletSecurityDescription =>
      'Protégez votre wallet avec le code PIN ou l\'authentification biométrique et faites une sauvegarde';

  @override
  String get blockchainSettings => 'Paramètres pour les blockchains';

  @override
  String get blockchainSettingsDescription =>
      'Gérez vos comptes, votre phrase de récupération et les dApps';

  @override
  String get ssi => 'Identité décentralisée (DID)';

  @override
  String get ssiDescription =>
      'Gérez votre identité décentralisée et recherchez des attestations digitales';

  @override
  String get helpCenter => 'Centre d\'aide';

  @override
  String get helpCenterDescription =>
      'Contactez-nous, accédez à la documentation ou obtenez de l\'aide';

  @override
  String get about => 'À propos';

  @override
  String get aboutDescription =>
      'En savoir plus sur les conditions générales d\'utilisation, la protection des données et les licences';

  @override
  String get resetWallet => 'Réinitialisation';

  @override
  String get resetWalletDescription =>
      'Effacez les données et remettez le wallet dans son état initial';

  @override
  String get showWalletRecoveryPhrase => 'Afficher la phrase de récupération';

  @override
  String get showWalletRecoveryPhraseSubtitle =>
      'La phrase de récupération est nécessaire pour restaurer votre wallet.';

  @override
  String get blockchainNetwork => 'Réseau Blockchain (par défaut)';

  @override
  String get contactUs => 'Contactez-nous';

  @override
  String get officialWebsite => 'Site officiel';

  @override
  String get yourAppVersion => 'La version de votre wallet';

  @override
  String get resetWalletTitle =>
      'Êtes-vous certain de vouloir réinitialiser votre wallet ?';

  @override
  String get resetWalletSubtitle =>
      'Cette action effacera vos données. Veuillez vous assurer d\'avoir enregistré votre phrase de récupération et le fichier d\'attestations digitales avant de réinitialiser votre wallet.';

  @override
  String get resetWalletSubtitle2 =>
      'Ce wallet n\'est pas hébergé sur un serveur, nous ne sommes donc pas en mesure de récupérer vos actifs ou vos attestations digitales à votre place.';

  @override
  String get resetWalletCheckBox1 => 'J\'ai noté ma phrase de récupération';

  @override
  String get resetWalletCheckBox2 =>
      'J\'ai sauvegardé le fichier d\'attestations';

  @override
  String get email => 'E-mail';

  @override
  String get fillingThisFieldIsMandatory => 'Remplir ce champ est obligatoire.';

  @override
  String get yourMessage => 'Votre message';

  @override
  String get message => 'Message';

  @override
  String get subject => 'Sujet';

  @override
  String get enterAValidEmail => 'Entrez un email valide.';

  @override
  String get failedToSendEmail => 'Échec de l\'envoi d\'email.';

  @override
  String get selectAMethodToAddAccount =>
      'Sélectionnez une méthode pour ajouter un compte';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createAccountDescription =>
      'Créez un compte protégé par votre phrase de récupération';

  @override
  String get importAccountDescription =>
      'Importer un compte depuis un wallet existant';

  @override
  String get chooseABlockchainForAccountCreation =>
      'Choisissez la blockchain sur laquelle vous souhaitez créer un nouveau compte.';

  @override
  String get tezosAccount => 'Compte Tezos';

  @override
  String get tezosAccountDescription => 'Créer une nouvelle adresse Tezos';

  @override
  String get ethereumAccount => 'Compte Ethereum';

  @override
  String get ethereumAccountDescription =>
      'Créer une nouvelle adresse Ethereum';

  @override
  String get fantomAccount => 'Compte Fantom';

  @override
  String get fantomAccountDescription => 'Créer une nouvelle adresse Fantom';

  @override
  String get polygonAccount => 'Compte Polygone';

  @override
  String get polygonAccountDescription => 'Créer une nouvelle adresse Polygon';

  @override
  String get binanceAccount => 'Compte BNB Chain';

  @override
  String get binanceAccountDescription => 'Créer une nouvelle adresse BNB';

  @override
  String get setAccountNameDescription =>
      'Voulez-vous donner un nom à ce nouveau compte ? Utile si vous en avez plusieurs.';

  @override
  String get letsGo => 'Allons-y !';

  @override
  String get congratulations => 'Félicitations !';

  @override
  String get tezosAccountCreationCongratulations =>
      'Votre nouveau compte Tezos a été créé avec succès.';

  @override
  String get ethereumAccountCreationCongratulations =>
      'Votre nouveau compte Ethereum a été créé avec succès.';

  @override
  String get fantomAccountCreationCongratulations =>
      'Votre nouveau compte Fantom a été créé avec succès.';

  @override
  String get polygonAccountCreationCongratulations =>
      'Votre nouveau compte Polygon a été créé avec succès.';

  @override
  String get binanceAccountCreationCongratulations =>
      'Votre nouveau compte BNB Chain a été créé avec succès.';

  @override
  String get accountImportCongratulations =>
      'Votre compte a été importé avec succès.';

  @override
  String get saveBackupCredentialTitle =>
      'Téléchargez le fichier de sauvegarde et conservez-le en lieu sûr.';

  @override
  String get saveBackupCredentialSubtitle =>
      'Pour récupérer vos attestations, vous aurez besoin de votre phrase de récupération et de ce fichier de sauvegarde.';

  @override
  String get saveBackupPolygonCredentialSubtitle =>
      'To recover all your polygon id credentials you will need the recovery phrase and this backup file.';

  @override
  String get restoreCredentialStep1Title =>
      'Etape 1 : Entrez les 12 mots de votre phrase de récupération';

  @override
  String get restorePhraseTextFieldHint =>
      'Entrez votre phrase de récupération ici...';

  @override
  String get restoreCredentialStep2Title =>
      'Etape 2 : Téléchargez le fichier de sauvegarde contenant vos attestations digitales';

  @override
  String get loadFile => 'Charger le fichier';

  @override
  String get uploadFile => 'Télécharger le fichier';

  @override
  String get creators => 'Créateurs';

  @override
  String get publishers => 'Éditeurs';

  @override
  String get creationDate => 'Créer une date';

  @override
  String get myProfessionalrCards => 'Attestations professionnelles';

  @override
  String get myProfessionalrCardsSubtitle =>
      'Partager vos attestations professionnelles en 1 clic.';

  @override
  String get guardaWallet => 'Guarda';

  @override
  String get exodusWallet => 'Exodus';

  @override
  String get trustWallet => 'Trust';

  @override
  String get myetherwallet => 'MyEtherWallet';

  @override
  String get skip => 'Ignorer';

  @override
  String get userNotFitErrorMessage =>
      'Vous ne pouvez pas obtenir cette attestation car certaines conditions ne sont pas remplies.';

  @override
  String get youAreMissing => 'Vous êtes absent';

  @override
  String get credentialsRequestedBy => 'informations demandées par';

  @override
  String get transactionIsLikelyToFail =>
      'La transaction est susceptible d\'échouer.';

  @override
  String get buy => 'Acheter';

  @override
  String get thisFeatureIsNotSupportedYetForFantom =>
      'Cette fonctionnalité n\'est pas encore prise en charge pour Fantom.';

  @override
  String get faqs => 'FAQ';

  @override
  String get softwareLicenses => 'Licences logicielles';

  @override
  String get notAValidWalletAddress => 'L\'adresse n\'est pas valide !';

  @override
  String get otherAccount => 'Autre compte';

  @override
  String get thereIsNoAccountInYourWallet =>
      'Il n\'y a pas de compte dans votre wallet';

  @override
  String get credentialSuccessfullyExported =>
      'Votre identifiant a été exporté avec succès.';

  @override
  String get scanAndDisplay => 'Numériser et afficher';

  @override
  String get whatsNew => 'Nouveautés';

  @override
  String get okGotIt => 'Ok, compris !';

  @override
  String get support => 'support';

  @override
  String get transactionDoneDialogDescription =>
      'Cela peut prendre quelques minutes';

  @override
  String get withdrawalFailedMessage => 'Le retrait a échoué';

  @override
  String get credentialRequiredMessage =>
      'Vous devez d\'abord posséder ces attestations pour obtenir celle ci :';

  @override
  String get keyDecentralizedIdEdSA => 'Clé d\'Identité Décentralisée EdDSA';

  @override
  String get keyDecentralizedIDSecp256k1 =>
      'Clé d\'Identité Décentralisée Secp256k1';

  @override
  String get ebsiV3DecentralizedId => 'Identité Décentralisée EBSI V3';

  @override
  String get requiredCredentialNotFoundTitle =>
      'Nous ne parvenons pas à trouver l\'attestation\ndont vous avez besoin dans votre wallet.';

  @override
  String get requiredCredentialNotFoundSubTitle =>
      'L\'attestation demandée n\'est pas dans votre wallet';

  @override
  String get requiredCredentialNotFoundDescription =>
      'Veuillez nous contacter sur :';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get help => 'Aide';

  @override
  String get searchCredentials => 'Rechercher des attestations';

  @override
  String get supportChatWelcomeMessage =>
      'Bienvenue sur notre chat ! Nous sommes là pour répondre à vos questions.';

  @override
  String get cardChatWelcomeMessage =>
      'Bienvenue sur notre chat ! Nous sommes là pour répondre à vos questions.';

  @override
  String get creator => 'Créateur';

  @override
  String get contractAddress => 'Adresse du contrat';

  @override
  String get lastMetadataSync => 'Dernière synchronisation des métadonnées';

  @override
  String get e2eEncyptedChat => 'Les échanges sont chiffrés de bout en bout.';

  @override
  String get pincodeAttemptMessage =>
      'Vous avez saisi un code PIN incorrect trois fois. Veuillez attendre une minute avant de réessayer.';

  @override
  String get verifyNow => 'Vérifier maintenant';

  @override
  String get verifyLater => 'Vérifier plus tard';

  @override
  String get welDone => 'Bravo !';

  @override
  String get mnemonicsVerifiedMessage =>
      'Votre phrase de récupération est enregistrée correctement.';

  @override
  String get chatWith => 'Discuter avec';

  @override
  String get sendAnEmail => 'Envoyer un email';

  @override
  String get livenessCardHowToGetIt =>
      'C\'est facile ! Effectuez une vérification d\'identité et obtenez votre preuve d\'humanité.';

  @override
  String get livenessCardExpirationDate =>
      'Cette attestation restera valable pendant 1 an. Son renouvellement est simple.';

  @override
  String get livenessCardWhyGetThisCard =>
      'Obtenez une preuve d\'humanité, demandée par la plupart des protocoles DeFi ou dApps Web3. Une fois obtenue, vous pourrez demander un NFT non transférable pour prouver votre humanité onchain.';

  @override
  String get livenessCardLongDescription =>
      'Cette attestation est une preuve d\'humanité. Utilisez-le pour prouver que vous n\'êtes pas un robot lorsque cela est nécessaire.';

  @override
  String get chat => 'Chat';

  @override
  String get needMnemonicVerificatinoDescription =>
      'Vous devez vérifier les phrases de récupération de votre wallet pour protéger vos actifs !';

  @override
  String get succesfullyAuthenticated => 'Authentification réussie.';

  @override
  String get authenticationFailed => 'Échec de l\'authentification.';

  @override
  String get documentType => 'Type d\'Attestation';

  @override
  String get countryCode => 'Code Pays';

  @override
  String get deviceIncompatibilityMessage =>
      'Désolé, votre appareil n\'est pas compatible avec cette fonctionnalité.';

  @override
  String get tezosProofMessage => '';

  @override
  String get ethereumProofMessage => '';

  @override
  String get fantomProofMessage => '';

  @override
  String get polygonProofMessage => '';

  @override
  String get binanceProofMessage => '';

  @override
  String get yearsOld => 'ans';

  @override
  String get youAreOver13 => 'Vous avez + de 13 ans';

  @override
  String get youAreOver15 => 'Vous avez + de 15 ans';

  @override
  String get youAreOver18 => 'Vous avez + de 18 ans';

  @override
  String get youAreOver21 => 'Vous avez + de 21 ans';

  @override
  String get youAreOver50 => 'Vous avez + de 50 ans';

  @override
  String get youAreOver65 => 'Vous avez + de 65 ans';

  @override
  String get polygon => 'Polygon';

  @override
  String get ebsi => 'EBSI';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get financeCredentialsHomeTitle => 'Mes justifs financiers';

  @override
  String get financeCredentialsDiscoverTitle =>
      'Obtenez des justifs financiers vérifiés';

  @override
  String get financeCredentialsDiscoverSubtitle =>
      'Accédez à de nouvelles opportunités d\'investissement dans le web3.';

  @override
  String get financeCredentialsHomeSubtitle =>
      'Accédez à de nouvelles opportunités d\'investissement dans le web3';

  @override
  String get hummanityProofCredentialsHomeTitle => 'Ma preuve d\'humanité';

  @override
  String get hummanityProofCredentialsHomeSubtitle =>
      'Prouvez facilement que vous êtes humain et non un robot.';

  @override
  String get hummanityProofCredentialsDiscoverTitle =>
      'Prouvez que vous n\'êtes pas un robot ou une IA';

  @override
  String get hummanityProofCredentialsDiscoverSubtitle =>
      'Obtenez une preuve d\'humanité à partager';

  @override
  String get socialMediaCredentialsHomeTitle => 'Mes réseaux sociaux';

  @override
  String get socialMediaCredentialsHomeSubtitle =>
      'Prouvez instantanément la propriété de vos comptes';

  @override
  String get socialMediaCredentialsDiscoverTitle =>
      'Vérifiez vos comptes de réseaux sociaux';

  @override
  String get socialMediaCredentialsDiscoverSubtitle =>
      'Prouvez la propriété de vos réseaux sociaux';

  @override
  String get walletIntegrityCredentialsHomeTitle => 'Intégrité du wallet';

  @override
  String get walletIntegrityCredentialsHomeSubtitle => 'TBD';

  @override
  String get walletIntegrityCredentialsDiscoverTitle => 'Intégrité du wallet';

  @override
  String get walletIntegrityCredentialsDiscoverSubtitle => 'TBD';

  @override
  String get polygonCredentialsHomeSubtitle =>
      'Prouvez votre identité dans l\'écosystème Polygon';

  @override
  String get polygonCredentialsDiscoverSubtitle =>
      'Prouvez vos droits d\'accès dans l\'écosystème Polygon';

  @override
  String get pendingCredentialsHomeTitle => 'Mes références en attente';

  @override
  String get pendingCredentialsHomeSubtitle => 'Prouvez vos droits d\'accès.';

  @override
  String get restore => 'Restaurer';

  @override
  String get backup => 'Sauvegarder';

  @override
  String get takePicture => 'Prendre une photo';

  @override
  String get kyc => 'KYC';

  @override
  String get aiSystemWasNotAbleToEstimateYourAge =>
      'L\'IA de YOTI n\'a pas pu estimer votre âge';

  @override
  String youGotAgeCredentials(Object credential) {
    return 'Vous avez votre attestation $credential.';
  }

  @override
  String yourAgeEstimationIs(Object ageEstimate) {
    return 'Votre âge estimé est de $ageEstimate ans';
  }

  @override
  String get credentialNotFound => 'Référence non trouvée';

  @override
  String get cryptographicProof => 'Preuve';

  @override
  String get downloadingCircuitLoadingMessage =>
      'Téléchargement. Cela peut prendre un certain temps. Veuillez patienter.';

  @override
  String get cryptoAccountAlreadyExistMessage =>
      'Il semble qu\'un compte avec ces informations existe déjà';

  @override
  String get errorGeneratingProof =>
      'Erreur lors de la génération de la preuve';

  @override
  String get createWalletMessage => 'Veuillez d\'abord créer votre wallet.';

  @override
  String get successfullyGeneratingProof => 'Preuve générée avec Succès';

  @override
  String get wouldYouLikeToAcceptThisCredentialsFromThisOrganisation =>
      'Acceptez vous cette attestation ?';

  @override
  String get thisOrganisationRequestsThisInformation =>
      'Cette organisation demande';

  @override
  String get iS => 'est';

  @override
  String get isSmallerThan => 'est inférieur à';

  @override
  String get isBiggerThan => 'est supérieur à';

  @override
  String get isOneOfTheFollowingValues => 'est l\'une des valeurs suivantes';

  @override
  String get isNotOneOfTheFollowingValues =>
      'n\'est pas l\'une des valeurs suivantes';

  @override
  String get isNot => 'n\'est pas';

  @override
  String get approve => 'Approuver';

  @override
  String get noInformationWillBeSharedFromThisCredentialMessage =>
      'Aucune information personnelle ne sera partagée.';

  @override
  String get burn => 'Détruire';

  @override
  String get wouldYouLikeToConfirmThatYouIntendToBurnThisNFT =>
      'Voulez-vous vraiment détruire / burn ce NFT ?';

  @override
  String pleaseAddXtoConnectToTheDapp(Object chain) {
    return 'Veuillez ajouter un compte $chain pour vous connecter à l\'application.';
  }

  @override
  String pleaseSwitchPolygonNetwork(Object networkType) {
    return 'Veuillez passer au réseau Polygon $networkType pour effectuer cette action.';
  }

  @override
  String get oidc4vcProfile => 'Profil OIDC4VC';

  @override
  String get pleaseSwitchToCorrectOIDC4VCProfile =>
      'Veuillez passer au bon profil OIDC4VC.';

  @override
  String get authenticationSuccess => 'Authentification Réussie';

  @override
  String get format => 'Format';

  @override
  String get verifyIssuerWebsiteIdentity => 'Confirmer l\'accès à l\'émetteur';

  @override
  String get verifyIssuerWebsiteIdentitySubtitle =>
      'Par défaut : Désactivé\nActivez pour vérifier le nom de domaine du site web émetteur.';

  @override
  String get developerMode => 'Mode développeur';

  @override
  String get developerModeSubtitle =>
      'Activez le mode développeur pour accéder à des outils de débug avancés';

  @override
  String get confirmVerifierAccess => 'Confirmer le partage des attestations';

  @override
  String get confirmVerifierAccessSubtitle =>
      'Par défaut : Activé\nDésactivez pour partagez vos attestations sans confirmation.';

  @override
  String get secureAuthenticationWithPINCode =>
      'Authentification avec code PIN';

  @override
  String get secureAuthenticationWithPINCodeSubtitle =>
      'Par défaut : Activé\nDésactivez pour vous authentifier avec le wallet sans code PIN (non recommandé).';

  @override
  String youcanSelectOnlyXCredential(Object count) {
    return 'Vous pouvez sélectionner uniquement $count attestations(s).';
  }

  @override
  String get theCredentialIsNotReady =>
      'L\'attestation n\'est pas encore disponible.';

  @override
  String get theCredentialIsNoMoreReady =>
      'Cette attestation n\'est plus disponible.';

  @override
  String get lowSecurity => 'Sécurité faible';

  @override
  String get highSecurity => 'Sécurité élevée';

  @override
  String get theRequestIsRejected => 'La demande est rejetée.';

  @override
  String get userPinIsIncorrect => 'Le code PIN est incorrect';

  @override
  String get security_level => 'Niveau de Sécurité';

  @override
  String get userPinTitle => 'User PIN Digits pre-authorized_code Flow';

  @override
  String get userPinSubtitle =>
      'Par défaut : 6 chiffres\nActivez pour avoir un code PIN à 4 chiffres';

  @override
  String get responseTypeNotSupported =>
      'Le type de réponse n\'est pas pris en charge';

  @override
  String get invalidRequest => 'La demande n\'est pas valide';

  @override
  String get subjectSyntaxTypeNotSupported =>
      'Le type de syntaxe n\'est pas pris en charge.';

  @override
  String get accessDenied => 'Accès refusé';

  @override
  String get thisRequestIsNotSupported =>
      'Cette demande n\'est pas prise en charge';

  @override
  String get unsupportedCredential => 'Référence non prise en charge';

  @override
  String get aloginIsRequired => 'Une connexion est requise';

  @override
  String get userConsentIsRequired =>
      'Le consentement de l\'utilisateur est requis';

  @override
  String get theWalletIsNotRegistered => 'Ce wallet n\'est pas enregistré';

  @override
  String get credentialIssuanceDenied => 'Émission de l\'attestation refusée';

  @override
  String get thisCredentialFormatIsNotSupported =>
      'Ce format n\'est pas pris en charge';

  @override
  String get thisFormatIsNotSupported => 'Ce format n\'est pas pris en charge';

  @override
  String get moreDetails => 'Plus de détails';

  @override
  String get theCredentialOfferIsInvalid =>
      'Cette attestation n\'est pas valide';

  @override
  String get dateOfRequest => 'Date de la Demande';

  @override
  String get keyDecentralizedIDP256 => 'Clé d\'Identité Décentralisée P-256';

  @override
  String get jwkDecentralizedIDP256 => 'JWK d\'Identité Décentralisée P-256';

  @override
  String get defaultDid => 'DID par Défaut';

  @override
  String get selectOneOfTheDid => 'Sélectionnez l\'un des DIDs';

  @override
  String get theServiceIsNotAvailable => 'Le service n\'est pas disponible';

  @override
  String get issuerDID => 'DID de l\'Émetteur';

  @override
  String get subjectDID => 'DID du Sujet';

  @override
  String get type => 'Type';

  @override
  String get credentialExpired => 'Attestation expirée';

  @override
  String get incorrectSignature => 'Signature incorrecte';

  @override
  String get revokedOrSuspendedCredential =>
      'Attestation révoquée ou suspendue';

  @override
  String get display => 'Afficher';

  @override
  String get download => 'Télécharger';

  @override
  String get successfullyDownloaded => 'Téléchargé avec succès';

  @override
  String get advancedSecuritySettings =>
      'Afficher les paramètres avançés de sécurité';

  @override
  String get theIssuanceOfThisCredentialIsPending =>
      'L\'émission de cette attestation est en cours';

  @override
  String get clientId => 'ID client';

  @override
  String get clientSecret => 'Secret client';

  @override
  String get walletProfiles => 'Profil du wallet';

  @override
  String get walletProfilesDescription =>
      'Choisissez un écosystème pour votre wallet';

  @override
  String get protectYourWallet => 'Protéger son wallet';

  @override
  String get protectYourWalletMessage =>
      'Utilisez une empreinte digitale, la reconnaissance faciale ou le code PIN de votre smartphone pour sécuriser et déverrouiller votre wallet.';

  @override
  String get pinUnlock => 'Déverrouillage par code PIN';

  @override
  String get secureWithDevicePINOnly =>
      'Sécurisé uniquement avec le code PIN du smartphone';

  @override
  String get biometricUnlock => 'Déverrouillage par contôle biométrique';

  @override
  String get secureWithFingerprint =>
      'Sécurisé avec une empreinte digitale ou la reconnaissance faciale';

  @override
  String get pinUnlockAndBiometric2FA =>
      'Déverrouillage par code PIN et contrôle biométrique (2FA)';

  @override
  String get secureWithFingerprintAndPINBackup =>
      'Sécurisé avec une empreinte digitale ou la reconnaissance faciale et le code PIN';

  @override
  String get secureYourWalletWithPINCodeAndBiometrics =>
      'Sécurisez votre wallet avec un code PIN et un contrôle biométrique';

  @override
  String get twoFactorAuthenticationHasBeenEnabled =>
      'L\'authentification à deux facteurs a été activée.';

  @override
  String get initialization => 'Initialisation';

  @override
  String get login => 'Connexion';

  @override
  String get password => 'Mot de Passe';

  @override
  String get pleaseEnterYourEmailAndYourCompanyPasswordToCreateYourAccount =>
      'Veuillez entrer votre email et le mot de passe pour créer votre compte';

  @override
  String get enterTheSecurityCodeThatWeSentYouByEmail =>
      'Entrez le code de sécurité qui a été envoyé par email';

  @override
  String get enterTheSecurityCode => 'Entrez le code de sécurité';

  @override
  String get yourEmail => 'Votre email';

  @override
  String get publicKeyOfWalletInstance =>
      'Clé publique de l\'instance de Wallet';

  @override
  String get walletInstanceKey => 'Clé d\'instance du wallet';

  @override
  String get organizationProfile => 'Profil de l\'organisation';

  @override
  String get profileName => 'Nom du profil';

  @override
  String get companyName => 'Nom de l\'entreprise';

  @override
  String get configFileIdentifier => 'Identifiant du fichier de configuration';

  @override
  String get updateYourWalletConfigNow =>
      'Mettez à jour votre configuration maintenant';

  @override
  String get updateConfigurationNow =>
      'Mettre à jour la configuration maintenant';

  @override
  String
  get pleaseEnterYourEmailAndPasswordToUpdateYourOrganizationWalletConfiguration =>
      'Veuillez entrer votre email et votre mot de passe pour mettre à jour votre wallet';

  @override
  String get congrats => 'Félicitation !';

  @override
  String get yourWalletConfigurationHasBeenSuccessfullyUpdated =>
      'La configuration de votre wallet a été mise à jour avec succès';

  @override
  String get continueString => 'Continuer';

  @override
  String get walletProvider => 'Fournisseur de Wallet';

  @override
  String get clientTypeSubtitle =>
      'Par défaut : DID\nSwitch pour changer le type de client';

  @override
  String get thisTypeProofCannotBeUsedWithThisVCFormat =>
      'Ce type de preuve ne peut pas être utilisé avec ce format de VC.';

  @override
  String get blockchainCardsDiscoverTitle =>
      'Prouvez que vous possédez un compte crypto.';

  @override
  String get blockchainCardsDiscoverSubtitle =>
      'Prouvez que vous possédez un compte crypto.';

  @override
  String get successfullyAddedEnterpriseAccount =>
      'Compte entreprise ajouté avec succès !';

  @override
  String get successfullyUpdatedEnterpriseAccount =>
      'Compte entreprise mis à jour avec succès !';

  @override
  String get thisWalleIsAlreadyConfigured => 'Ce wallet est déjà configuré';

  @override
  String get walletSettings => 'Paramètres du wallet';

  @override
  String get walletSettingsDescription =>
      'Choisissez la langue et le thème du wallet';

  @override
  String get languageSelectorTitle => 'Langue';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Español';

  @override
  String get catalan => 'Català';

  @override
  String get english => 'English';

  @override
  String get phoneLanguage => 'Langue du téléphone';

  @override
  String get cardIsValid => 'Attestation valide';

  @override
  String get cardIsExpired => 'Attestation expirée';

  @override
  String get signatureIsInvalid => 'Signature invalide';

  @override
  String get statusIsInvalid => 'Statut invalide';

  @override
  String get statuslListSignatureFailed => 'Status list signature invalide';

  @override
  String get statusList => 'Status list';

  @override
  String get statusListIndex => 'Status list index';

  @override
  String get theWalletIsSuspended => 'Le wallet est suspendu.';

  @override
  String get jwkThumbprintP256Key => 'JWK Thumbprint P-256';

  @override
  String get walletBlockedPopupTitle => 'Le wallet est bloqué 10 minutes';

  @override
  String get walletBlockedPopupDescription =>
      'Le wallet est bloqué.\nVous devez ré-initialiser votre wallet.';

  @override
  String get deleteMyWalletForWrontPincodeTitle =>
      'Compte bloqué après 3 essais';

  @override
  String get deleteMyWalletForWrontPincodeDescription =>
      'Pour la sécurité vous devez ré-initialiser votre wallet.';

  @override
  String get walletBloced => 'Compte bloqué';

  @override
  String get deleteMyWallet => 'Effacer mon compte';

  @override
  String get pincodeRules =>
      'Votre code secret ne peut avoir 4 caractères identitiques ou 4 chiffres successifs.';

  @override
  String get pincodeSerie =>
      'Votre code secret ne peut pas avoir 4 caractères identiques.';

  @override
  String get pincodeSequence =>
      'Votre code secret ne peut pas avoir 4 chiffres successifs.';

  @override
  String get pincodeDifferent =>
      'Code invalide.\nLes deux codes doivent être identiques.';

  @override
  String codeSecretIncorrectDescription(Object count, Object plural) {
    return 'Attention, plus que $count essai(s).';
  }

  @override
  String get languageSettings => 'Langues';

  @override
  String get languageSettingsDescription => 'Choisissez la langue';

  @override
  String get themeSettings => 'Thèmes';

  @override
  String get themeSettingsDescription => 'Choisissez votre thème';

  @override
  String couldNotFindTheAccountWithThisAddress(Object address) {
    return 'Impossible de trouver $address dans la liste des comptes.';
  }

  @override
  String deleteAccountMessage(Object account) {
    return 'Confirmez l\'effacement du compte $account?';
  }

  @override
  String get cannotDeleteCurrentAccount =>
      'Vous ne pouvez pas effacer le compte actif';

  @override
  String get invalidClientErrorDescription =>
      'client_id is not conformed to client_id_scheme';

  @override
  String get vpFormatsNotSupportedErrorDescription =>
      'The Wallet does not support any of the formats requested by the Verifier, such as those included in the vp_formats registration parameter.';

  @override
  String get invalidPresentationDefinitionUriErrorDescription =>
      'The Presentation Definition URL cannot be reached.';

  @override
  String get toStopDisplayingThisPopupDeactivateTheDeveloperModeInTheSettings =>
      'To stop displaying this popup, deactivate the \'developer mode\' in the settings.';

  @override
  String get warningDialogSubtitle =>
      'Ces données sont confidentielles, ne les communiquez à personne.';

  @override
  String get accountPrivateKeyAlert =>
      'Ces données sont confidentielles, ne les communiquez à personne.';

  @override
  String get etherlinkNetwork => 'Etherlink Network';

  @override
  String get etherlinkAccount => 'Compte Etherlink';

  @override
  String get etherlinkAccountDescription =>
      'Créer une nouvelle adresse Etherlink';

  @override
  String get etherlinkAccountCreationCongratulations =>
      'Votre nouvelle adresse Etherlink a été créée.';

  @override
  String get etherlinkProofMessage => '';

  @override
  String get notification => 'Notification';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationTitle =>
      'Bienvenue dans le salon de notification!\nRestez informé des nouveautés.';

  @override
  String get chatRoom => 'Salon de chat';

  @override
  String get notificationRoom => 'Salon de notification';

  @override
  String get notificationSubtitle => 'Autorisez les notifications';

  @override
  String get header => 'Header';

  @override
  String get payload => 'Payload';

  @override
  String get data => 'Data';

  @override
  String get keyBindingHeader => 'Key Binding Header';

  @override
  String get keyBindingPayload => 'Key Binding Payload';

  @override
  String get ebsiV4DecentralizedId => 'did:key EBSI V4 P-256';

  @override
  String get noNotificationsYet => 'Aucune notification';

  @override
  String get activityLog => 'Journal des évènements';

  @override
  String get activityLogDescription => 'Consultez le journal des évènements';

  @override
  String get walletInitialized => 'Wallet initialisé';

  @override
  String get backupCredentials => 'Sauvegarde des attestations';

  @override
  String get restoredCredentials => 'Restauration des attestations';

  @override
  String deletedCredential(Object credential) {
    return 'Attestation $credential effaçée';
  }

  @override
  String presentedCredential(Object credential, Object domain) {
    return 'Attestation présentée $credential à $domain';
  }

  @override
  String get keysImported => 'Keys imported';

  @override
  String get approveProfileTitle => 'Installez la configuration';

  @override
  String approveProfileDescription(Object company) {
    return 'Confirmez l\'installation de la configuration de $company?';
  }

  @override
  String get updateProfileTitle => 'Metre à jour la configuration';

  @override
  String updateProfileDescription(Object company) {
    return 'Confirmez la mise à jour de la configuration de $company?';
  }

  @override
  String get replaceProfileTitle => 'Installez une nouvelle configuration';

  @override
  String replaceProfileDescription(Object company) {
    return 'Confirmez le remplacement de la configuration actuelle par celle de $company?';
  }

  @override
  String get saveBackupCredentialSubtitle2 =>
      'Pour restaurer toutes vos attestations vous aurez besoin de ce fichier.';

  @override
  String get createWallet => 'Créer un Wallet';

  @override
  String get restoreWallet => 'Restaurer un Wallet';

  @override
  String get showWalletRecoveryPhraseSubtitle2 =>
      'Cette phrase de récupération est nécessaire pour restaurer un wallet.';

  @override
  String get documentation => 'Documentation';

  @override
  String get restoreACryptoWallet => 'Restaurer un wallet crypto';

  @override
  String restoreAnAppBackup(Object appName) {
    return 'Restaurer une sauvegarde de $appName';
  }

  @override
  String get credentialPickShare => 'Partager';

  @override
  String get credentialPickTitle =>
      'Choisissez une ou plusieurs attestation(s)';

  @override
  String get credentialShareTitle =>
      'Choisissez une ou plusieurs attestation(s)';

  @override
  String get enterYourSecretCode => 'Entrez votre code secret.';

  @override
  String get jwk => 'JWK';

  @override
  String get typeYourPINCodeToOpenTheWallet =>
      'Entrez votre code PIN pour ouvrir le wallet';

  @override
  String get typeYourPINCodeToShareTheData =>
      'Entrez votre code PIN pour partager les données';

  @override
  String get typeYourPINCodeToAuthenticate =>
      'Entrez votre code PIN pour vous authentifier';

  @override
  String get credentialIssuanceIsStillPending =>
      'L\'émission de l\'attestation est en cours';

  @override
  String get bakerFee => 'Baker fee';

  @override
  String get storageFee => 'Storage Fee';

  @override
  String get doYouWantToSetupTheProfile =>
      'Souhaitez vous paramétrer ce profil';

  @override
  String get thisFeatureIsNotSupportedYetForEtherlink =>
      'Cette fonctionalité n\'est pas supportée sur Etherlink.';

  @override
  String get walletSecurityAndBackup => 'Sécurité et sauvegarde';

  @override
  String addedCredential(Object credential, Object domain) {
    return 'Attestation $credential de $domain ajoutée';
  }

  @override
  String get reject => 'Rejet';

  @override
  String get operation => 'Opération';

  @override
  String get chooseYourSSIProfileOrCustomizeYourOwn =>
      'Choisissez un écosystème pour votre wallet';

  @override
  String get recoveryPhraseIncorrectErrorMessage =>
      'Veuillez recommencer dans le bon ordre.';

  @override
  String get invalidCode => 'Code invalide';

  @override
  String get back => 'Back';

  @override
  String get iaAnalyze =>
      'Data will be shared with a remote AI engine. Don\'t share personal data.';

  @override
  String get iaAnalyzeTitle => 'AI Agent';

  @override
  String get deleteDigit => 'Effacer';

  @override
  String get aiPleaseWait => 'Ce traitement peut prendre jusqu\'à 30s';

  @override
  String get trustedList => 'Use trusted list';

  @override
  String get trustedListSubtitle =>
      'List of trusted entities in the current ecosystem. You are warned in case of interaction with non trusted entity.';

  @override
  String get notTrustedEntity =>
      'This entity is not in the trusted list. You should be very cautious with untrusted entities.';
}
