// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get genericError => 'An error has occurred!';

  @override
  String get credentialListTitle => 'Credentials';

  @override
  String credentialDetailIssuedBy(Object issuer) {
    return 'Issued by $issuer';
  }

  @override
  String get listActionRefresh => 'Refresh';

  @override
  String get listActionViewList => 'View as list';

  @override
  String get listActionViewGrid => 'View as grid';

  @override
  String get listActionFilter => 'Filter';

  @override
  String get listActionSort => 'Sort';

  @override
  String get onBoardingStartSubtitle => 'Lorem ipsum dolor sit ame';

  @override
  String get onBoardingTosTitle => 'Terms & Conditions';

  @override
  String get onBoardingTosText =>
      'By tapping accept \"I  agree to the terms and condition as well as the disclosure of this information.\"';

  @override
  String get onBoardingTosButton => 'Accept';

  @override
  String get onBoardingRecoveryTitle => 'Key Recovery';

  @override
  String get onBoardingRecoveryButton => 'Recover';

  @override
  String get onBoardingGenPhraseTitle => 'Recovery Phrase';

  @override
  String get onBoardingGenPhraseButton => 'Continue';

  @override
  String get onBoardingGenTitle => 'Private Key Generation';

  @override
  String get onBoardingGenButton => 'Generate';

  @override
  String get onBoardingSuccessTitle => 'Identifier Created';

  @override
  String get onBoardingSuccessButton => 'Continue';

  @override
  String get credentialDetailShare => 'Share by QR code';

  @override
  String get credentialAddedMessage =>
      'A new credential has been successfully added!';

  @override
  String get credentialDetailDeleteCard => 'Delete this card';

  @override
  String get credentialDetailDeleteConfirmationDialog =>
      'Do you really want to delete this credential?';

  @override
  String get credentialDetailDeleteConfirmationDialogYes => 'Yes';

  @override
  String get credentialDetailDeleteConfirmationDialogNo => 'No';

  @override
  String get credentialDetailDeleteSuccessMessage => 'Successfully deleted.';

  @override
  String get credentialDetailEditConfirmationDialog =>
      'Do you really want to edit this credential?';

  @override
  String get credentialDetailEditConfirmationDialogYes => 'Save';

  @override
  String get credentialDetailEditConfirmationDialogNo => 'Cancel';

  @override
  String get credentialDetailEditSuccessMessage => 'Successfully edited.';

  @override
  String get credentialDetailCopyFieldValue =>
      'Copied field value to clipboard!';

  @override
  String get credentialDetailStatus => 'Verification Status';

  @override
  String get credentialPresentTitle => 'Select credential(s)';

  @override
  String get credentialPresentTitleDIDAuth => 'DIDAuth Request';

  @override
  String get credentialPresentRequiredCredential =>
      'Someone is asking for your';

  @override
  String get credentialPresentConfirm => 'Select credential(s)';

  @override
  String get credentialPresentCancel => 'Reject';

  @override
  String get selectYourTezosAssociatedWallet =>
      'Select your Tezos associated wallet';

  @override
  String get credentialPickSelect => 'Select your credential';

  @override
  String get siopV2credentialPickSelect =>
      'Choose only one credential from your wallet to present';

  @override
  String get credentialPickAlertMessage =>
      'Do you want to give an alias to this credential?';

  @override
  String get credentialReceiveTitle => 'Credential Offer';

  @override
  String get credentialReceiveHost => 'wants to send you a credential';

  @override
  String get credentialAddThisCard => 'Add this card';

  @override
  String get credentialReceiveCancel => 'Cancel this card';

  @override
  String get credentialDetailListTitle => 'My wallet';

  @override
  String get communicationHostAllow => 'Allow';

  @override
  String get communicationHostDeny => 'Deny';

  @override
  String get scanTitle => 'Scan QRcode';

  @override
  String get scanPromptHost => 'Do you trust this host?';

  @override
  String get scanRefuseHost => 'The communication request was denied.';

  @override
  String get scanUnsupportedMessage => 'The extracted url is not valid.';

  @override
  String get qrCodeSharing => 'You are now sharing';

  @override
  String get qrCodeNoValidMessage =>
      'This QRCode does not contain a valid message.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get personalTitle => 'Personal';

  @override
  String get termsTitle => 'Terms & Conditions';

  @override
  String get recoveryKeyTitle => 'Recovery phrase';

  @override
  String get showRecoveryPhrase => 'Show Recovery Phrase';

  @override
  String get warningDialogTitle => 'Be careful';

  @override
  String get recoveryText => 'Please enter your recovery phrase';

  @override
  String get recoveryMnemonicHintText =>
      'Enter your recovery phrase here.\nOnce you have entered your 12 words,\ntap Import.';

  @override
  String get recoveryMnemonicError => 'Please enter a valid mnemonic phrase';

  @override
  String get showDialogYes => 'Continue';

  @override
  String get showDialogNo => 'Cancel';

  @override
  String get supportTitle => 'Support';

  @override
  String get noticesTitle => 'Notices';

  @override
  String get resetWalletButton => 'Reset';

  @override
  String get resetWalletConfirmationText =>
      'Are you sure you want to reset your wallet?';

  @override
  String get selectThemeText => 'Select Theme';

  @override
  String get lightThemeText => 'Light Theme';

  @override
  String get darkThemeText => 'Dark Theme';

  @override
  String get systemThemeText => 'Phone Theme';

  @override
  String get genPhraseInstruction =>
      'Write these words, download the backup file and keep them in a safe place';

  @override
  String get genPhraseExplanation =>
      'If you lose access to this wallet, you will need the words in the correct order and the backup file to recover your credentials.';

  @override
  String get errorGeneratingKey => 'Failed to generate key, please try again';

  @override
  String get documentHeaderTooltipName => 'John Doe';

  @override
  String get documentHeaderTooltipJob => 'Crypto Trader';

  @override
  String get documentHeaderTooltipLabel => 'Status:';

  @override
  String get documentHeaderTooltipValue => 'Valid';

  @override
  String get didDisplayId => 'DID';

  @override
  String get blockChainDisplayMethod => 'Blockchain';

  @override
  String get blockChainAdress => 'Address';

  @override
  String get didDisplayCopy => 'Copy DID to clipboard';

  @override
  String get adressDisplayCopy => 'Copy address to clipboard';

  @override
  String get personalSave => 'Save';

  @override
  String get personalSubtitle =>
      'Your profile information can be used to complete a certificate when necessary';

  @override
  String get personalFirstName => 'First Name';

  @override
  String get personalLastName => 'Last Name';

  @override
  String get personalPhone => 'Phone';

  @override
  String get personalAddress => 'Address';

  @override
  String get personalMail => 'E-mail';

  @override
  String get lastName => 'Last name';

  @override
  String get firstName => 'First name';

  @override
  String get gender => 'gender';

  @override
  String get birthdate => 'Birthdate';

  @override
  String get birthplace => 'Birthplace';

  @override
  String get address => 'Address';

  @override
  String get maritalStatus => 'Marital Status';

  @override
  String get nationality => 'Nationality';

  @override
  String get identifier => 'Identifier';

  @override
  String get issuer => 'Issued by';

  @override
  String get workFor => 'Work for';

  @override
  String get startDate => 'Since';

  @override
  String get endDate => 'Until';

  @override
  String get employmentType => 'Employment type';

  @override
  String get jobTitle => 'Job title';

  @override
  String get baseSalary => 'Salary';

  @override
  String get expires => 'Expires';

  @override
  String get generalInformationLabel => 'General information';

  @override
  String get learningAchievement => 'Achievement';

  @override
  String get signedBy => 'Signed by';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get credential => 'Credential';

  @override
  String get issuanceDate => 'Issuance date';

  @override
  String get appContactWebsite => 'Website';

  @override
  String get trustFrameworkDescription =>
      'The trust framework is formed by a set of registries that provide a secure and reliable basis for entities within the system to trust and interact with each other.';

  @override
  String get confimrDIDAuth => 'Do you want to log in to the site ?';

  @override
  String get evidenceLabel => 'Evidence';

  @override
  String get networkErrorBadRequest => 'Bad request';

  @override
  String get networkErrorConflict => 'Error due to a conflict';

  @override
  String get networkErrorPreconditionFailed =>
      'Server does not meet one of the preconditions.';

  @override
  String get networkErrorCreated => '';

  @override
  String get networkErrorGatewayTimeout => 'The gateway encountered a timeout';

  @override
  String get networkErrorInternalServerError =>
      'This is a server internal error. Contact the server administrator';

  @override
  String get networkErrorMethodNotAllowed =>
      'The user does not have access rights to the content';

  @override
  String get networkErrorNoInternetConnection => 'No internet connection';

  @override
  String get networkErrorNotAcceptable => 'Not acceptable';

  @override
  String get networkErrorNotImplemented => 'Not Implemented';

  @override
  String get networkErrorOk => '';

  @override
  String get networkErrorRequestCancelled => 'Request Cancelled';

  @override
  String get networkErrorRequestTimeout => 'Request timeout';

  @override
  String get networkErrorSendTimeout =>
      'Send timeout in connection with API server';

  @override
  String get networkErrorServiceUnavailable => 'Service unavailable';

  @override
  String get networkErrorTooManyRequests =>
      'The user has sent too many requests in a given amount of time';

  @override
  String get networkErrorUnableToProcess => 'Unable to process the data';

  @override
  String get networkErrorUnauthenticated =>
      'The user must authenticate itself to get the requested response';

  @override
  String get networkErrorUnauthorizedRequest => 'Unauthorized request';

  @override
  String get networkErrorUnexpectedError => 'Unexpected error occurred';

  @override
  String get networkErrorNotFound => 'Not Found';

  @override
  String get active => 'Active';

  @override
  String get expired => 'Expired';

  @override
  String get revoked => 'Revoked';

  @override
  String get ok => 'OK';

  @override
  String get unavailable_feature_title => 'Unavailable Feature';

  @override
  String get unavailable_feature_message =>
      'This feature is not available on the browser';

  @override
  String get personalSkip => 'SKIP';

  @override
  String get restoreCredential => 'Restore credentials';

  @override
  String get backupCredential => 'Backup credentials';

  @override
  String get backupCredentialPhrase =>
      'Write these words, download the backup file and keep them in a safe place';

  @override
  String get backupCredentialPhraseExplanation =>
      'To backup your credentials write down your recovery phrase and keep it in a safe place.';

  @override
  String get backupCredentialButtonTitle => 'Save The File';

  @override
  String get needStoragePermission =>
      'Sorry, You need storage permission to download this file.';

  @override
  String get backupCredentialNotificationTitle => 'Success';

  @override
  String get backupCredentialNotificationMessage =>
      'File has been successfully downloaded. Tap to open the file.';

  @override
  String get backupCredentialError =>
      'Something went wrong. Please try again later.';

  @override
  String get backupCredentialSuccessMessage =>
      'File has been successfully downloaded.';

  @override
  String get restorationCredentialWarningDialogSubtitle =>
      'The restoration will erase all the credentials you already have in your wallet.';

  @override
  String get recoveryCredentialPhrase =>
      'Write down the words and upload the backup file if you saved it before';

  @override
  String get recoveryCredentialPhraseExplanation =>
      'You need both words in right order and encrypted backup file to recover your credentials if you lost your credentials somehow';

  @override
  String get recoveryCredentialButtonTitle => 'Upload Backup File';

  @override
  String recoveryCredentialSuccessMessage(Object postfix) {
    return 'Successfully recovered $postfix.';
  }

  @override
  String get recoveryCredentialJSONFormatErrorMessage =>
      'Please upload the valid file.';

  @override
  String get recoveryCredentialAuthErrorMessage =>
      'Sorry, either mnemonics is incorrect or uploaded file is corrupted.';

  @override
  String get recoveryCredentialDefaultErrorMessage =>
      'Something went wrong. Please try again later.';

  @override
  String get selfIssuedCreatedSuccessfully =>
      'Self issued credential created successfully';

  @override
  String get companyWebsite => 'Company Website';

  @override
  String get submit => 'Submit';

  @override
  String get insertYourDIDKey => 'Insert your DID';

  @override
  String get importYourRSAKeyJsonFile => 'Import your RSA key json file';

  @override
  String get didKeyAndRSAKeyVerifiedSuccessfully =>
      'DID and RSA key verified successfully';

  @override
  String get pleaseEnterYourDIDKey => 'Please enter your DID';

  @override
  String get pleaseImportYourRSAKey => 'Please import your RSA key';

  @override
  String get confirm => 'Confirm';

  @override
  String get pleaseSelectRSAKeyFileWithJsonExtension =>
      'Please select RSA key file(with json extension)';

  @override
  String get rsaNotMatchedWithDIDKey => 'RSA key not matched with DID';

  @override
  String get didKeyNotResolved => 'DID not resolved';

  @override
  String get anUnknownErrorHappened => 'An unknown error happened';

  @override
  String get walletType => 'Wallet Type';

  @override
  String get chooseYourWalletType => 'Choose your wallet type';

  @override
  String get proceed => 'Continue';

  @override
  String get enterpriseWallet => 'Enterprise Wallet';

  @override
  String get personalWallet => 'Personal Wallet';

  @override
  String get failedToVerifySelfIssuedCredential =>
      'Failed to verify self issued credential';

  @override
  String get failedToCreateSelfIssuedCredential =>
      'Failed to create self issued credential';

  @override
  String get credentialVerificationReturnWarning =>
      'Credential verification returned some warnings. ';

  @override
  String get failedToVerifyCredential => 'Failed to verify credential.';

  @override
  String get somethingsWentWrongTryAgainLater =>
      'Something went wrong, please try again later. ';

  @override
  String get successfullyPresentedYourCredential =>
      'Successfully presented your credential(s)!';

  @override
  String get successfullyPresentedYourDID => 'Successfully presented your DID!';

  @override
  String get thisQRCodeIsNotSupported => 'This QR code is not supported.';

  @override
  String get thisUrlDoseNotContainAValidMessage =>
      'This url does not contain a valid message.';

  @override
  String get anErrorOccurredWhileConnectingToTheServer =>
      'An error occurred while connecting to the server.';

  @override
  String get failedToSaveMnemonicPleaseTryAgain =>
      'Failed to save mnemonic, please try again';

  @override
  String get failedToLoadProfile => 'Failed to load profile. ';

  @override
  String get failedToSaveProfile => 'Failed to save profile. ';

  @override
  String get failedToLoadDID => 'Failed to load DID. ';

  @override
  String get personalOpenIdRestrictionMessage =>
      'Personal wallet does not have access.';

  @override
  String get credentialEmptyError =>
      'You do not have any credential in your wallet.';

  @override
  String get credentialPresentTitleSiopV2 => 'Present Credential';

  @override
  String get confirmSiopV2 => 'Please confirm the credential presented';

  @override
  String get storagePermissionRequired => 'Storage permission required';

  @override
  String get storagePermissionDeniedMessage =>
      'Please allow storage access in order to upload the file.';

  @override
  String get storagePermissionPermanentlyDeniedMessage =>
      'You need storage permission for uploading file. Please go to app settings and grant access to storage permission.';

  @override
  String get cancel => 'Cancel';

  @override
  String get loading => 'Please wait a moment...';

  @override
  String get issuerWebsitesTitle => 'Get credentials';

  @override
  String get getCredentialTitle => 'Get credentials';

  @override
  String get participantCredential => 'GaiaX Pass';

  @override
  String get phonePassCredential => 'Proof of Phone';

  @override
  String get emailPassCredential => 'Proof of Email';

  @override
  String get needEmailPass => 'You need to get a Proof of Email first.';

  @override
  String get signature => 'Signature';

  @override
  String get proof => 'Proof';

  @override
  String get verifyMe => 'Verify Me';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get credentialAlias => 'Credential Alias';

  @override
  String get verificationStatus => 'Verification Status';

  @override
  String get cardsPending => 'Card pending';

  @override
  String get unableToProcessTheData => 'Unable to process the data';

  @override
  String get unimplementedQueryType => 'Unimplemented Query Type';

  @override
  String get onSubmittedPassBasePopUp => 'You will receive an email';

  @override
  String get myCollection => 'My collection';

  @override
  String get items => 'items';

  @override
  String get succesfullyUpdated => 'Successfully Updated.';

  @override
  String get generate => 'Generate';

  @override
  String get myAssets => 'My assets';

  @override
  String get search => 'Search';

  @override
  String get professional => 'Professional';

  @override
  String get splashSubtitle => 'Own your digital identity and digital assets';

  @override
  String get poweredBy => 'Powered By';

  @override
  String get splashLoading => 'Loading...';

  @override
  String get version => 'Version';

  @override
  String get cards => 'Cards';

  @override
  String get nfts => 'NFTs';

  @override
  String get coins => 'Coins';

  @override
  String get getCards => 'Get Credentials';

  @override
  String get close => 'Close';

  @override
  String get profile => 'Profile';

  @override
  String get infos => 'Infos';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get enterNewPinCode => 'Create a PIN Code\nto protect your wallet';

  @override
  String get confirmYourPinCode => 'Confirm your PIN code';

  @override
  String get walletAltme => 'Wallet Altme';

  @override
  String get createTitle => 'Create or import a wallet';

  @override
  String get createSubtitle =>
      'Would you like to create a new wallet or import an existing one?';

  @override
  String get enterYourPinCode => 'Enter your PIN Code';

  @override
  String get changePinCode => 'Change PIN Code';

  @override
  String get tryAgain => 'Try again';

  @override
  String get credentialSelectionListEmptyError =>
      'You do not have the requested credential to pursue.';

  @override
  String get trustedIssuer => 'This issuer is approved by EBSI.';

  @override
  String get yourPinCodeChangedSuccessfully =>
      'Your PIN Code changed successfully';

  @override
  String get advantagesCards => 'Advantages cards';

  @override
  String get advantagesDiscoverCards => 'Unlock exclusive rewards';

  @override
  String get identityCards => 'Identity cards';

  @override
  String get identityDiscoverCards => 'Simplify ID verification';

  @override
  String get contactInfoCredentials => 'Contact information';

  @override
  String get contactInfoDiscoverCredentials =>
      'Verify your contact information';

  @override
  String get myProfessionalCards => 'Professional cards';

  @override
  String get otherCards => 'Other cards';

  @override
  String get inMyWallet => 'In my wallet';

  @override
  String get details => 'Details';

  @override
  String get getIt => 'Get it';

  @override
  String get getItNow => 'Get it Now';

  @override
  String get getThisCard => 'Get This Card';

  @override
  String get drawerBiometrics => 'Biometric authentication';

  @override
  String get drawerTalaoCommunityCard => 'Talao Community Card';

  @override
  String get drawerTalaoCommunityCardTitle =>
      'Import your Ethereum address and get your Community Card.';

  @override
  String get drawerTalaoCommunityCardSubtitle =>
      'It will give you access to the best discounts, memberships and vouchers cards from our ecosystem of partners.';

  @override
  String get drawerTalaoCommunityCardTextBoxMessage =>
      'Once you have entered your private key, tap Import.\nPlease, make sure to enter the ethereum private key which contains your Talao Token.';

  @override
  String get drawerTalaoCommunityCardSubtitle2 =>
      'Our Wallet is self-custodial. We never have access to your private keys or funds.';

  @override
  String get drawerTalaoCommunityCardKeyError =>
      'Please enter a valid private key';

  @override
  String get loginWithBiometricsMessage =>
      'Quickly unlock your wallet without having to enter password or PIN Code';

  @override
  String get manage => 'Manage';

  @override
  String get wallet => 'Wallet';

  @override
  String get manageAccounts => 'Manage blockchain accounts';

  @override
  String get blockchainAccounts => 'Blockchain accounts';

  @override
  String get educationCredentials => 'Education credentials';

  @override
  String get educationDiscoverCredentials => 'Verify your education background';

  @override
  String get educationCredentialsDiscoverSubtitle => 'Get your digital diploma';

  @override
  String get security => 'Security';

  @override
  String get networkAndRegistries => 'Network & Registries';

  @override
  String get chooseNetwork => 'Choose Network';

  @override
  String get chooseRegistry => 'Choose Registry';

  @override
  String get trustFramework => 'Trust Framework';

  @override
  String get network => 'Network';

  @override
  String get issuerRegistry => 'Issuer Registry';

  @override
  String get termsOfUse => 'Terms of Use & Confidentiality';

  @override
  String get scanFingerprintToAuthenticate =>
      'Scan Fingerprint to Authenticate';

  @override
  String get biometricsNotSupported => 'Biometrics not supported';

  @override
  String get deviceDoNotSupportBiometricsAuthentication =>
      'Your device does not support biometric authentication';

  @override
  String get biometricsEnabledMessage =>
      'You can now unlock app with your biometrics.';

  @override
  String get biometricsDisabledMessage =>
      'Biometric authentication has been disabled.';

  @override
  String get exportSecretKey => 'Export secret key';

  @override
  String get secretKey => 'Secret Key';

  @override
  String get chooseNetWork => 'Choose Network';

  @override
  String get nftEmptyMessage => 'Your digital gallery is empty !';

  @override
  String get myAccount => 'My Account';

  @override
  String get cryptoAccounts => 'Accounts';

  @override
  String get cryptoAccount => 'Account';

  @override
  String get cryptoAddAccount => 'Add Account';

  @override
  String get cryptoAddedMessage =>
      'Your crypto account has been successfully added.';

  @override
  String get cryptoEditConfirmationDialog =>
      'Do you really want to edit this crypto account name?';

  @override
  String get cryptoEditConfirmationDialogYes => 'Save';

  @override
  String get cryptoEditConfirmationDialogNo => 'Cancel';

  @override
  String get cryptoEditLabel => 'Account Name';

  @override
  String get onBoardingFirstTitle =>
      'Discover exclusive Web 3 offers directly in your wallet.';

  @override
  String get onBoardingFirstSubtitle =>
      'Get Membership cards, Loyalty cards, Vouchers and lot more advantages from your favorite Apps and games.';

  @override
  String get onBoardingSecondTitle =>
      'Our wallet is much more than a simple Digital Wallet.';

  @override
  String get onBoardingSecondSubtitle =>
      'Store & Manage your personal data and get access to any Web 3.0 Apps.';

  @override
  String get onBoardingThirdTitle =>
      'Manage your data with full autonomy, security and privacy.';

  @override
  String get onBoardingThirdSubtitle =>
      'Our wallet use cryptography to give you full control over your data. Nothing goes out of your device.';

  @override
  String get onBoardingStart => 'Start';

  @override
  String get learnMoreAboutAltme => 'Learn more about your wallet';

  @override
  String get scroll => 'Scroll';

  @override
  String get agreeTermsAndConditionCheckBox =>
      'I agree to the terms and conditions.';

  @override
  String get readTermsOfUseCheckBox => 'I have read the terms of use.';

  @override
  String get createOrImportNewAccount => 'Create or import a new account.';

  @override
  String get selectAccount => 'Select account';

  @override
  String get onbordingSeedPhrase => 'Seed Phrase';

  @override
  String get onboardingPleaseStoreMessage =>
      'Please, write down your recovery phrase';

  @override
  String get onboardingVerifyPhraseMessage => 'Confirm the recovery phrase';

  @override
  String get onboardingVerifyPhraseMessageDetails =>
      'To ensure your recovery phrase is written correctly, select the words in correct order.';

  @override
  String get onboardingAltmeMessage =>
      'The wallet is non-custodial. Your recovery phrase is the only way to recover your account.';

  @override
  String get onboardingWroteDownMessage => 'I wrote down my recovery phrase';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String get pinCodeMessage =>
      'PIN code prevent unauthorized access to your wallet. You can change it at any time.';

  @override
  String get enterNameForYourNewAccount => 'Enter a name for your new account';

  @override
  String get create => 'Create';

  @override
  String get import => 'Import';

  @override
  String get accountName => 'Account name';

  @override
  String get importWalletText =>
      'Enter your recovery phrase or private key here.';

  @override
  String get importWalletTextRecoveryPhraseOnly =>
      'Enter your recovery phrase here.';

  @override
  String get recoveryPhraseDescriptions =>
      'A recovery phrase is a list of 12 words generated by your crypto wallet that gives you access to your funds';

  @override
  String get importEasilyFrom => 'Import your account from :';

  @override
  String get templeWallet => 'Temple wallet';

  @override
  String get temple => 'Temple';

  @override
  String get metaMaskWallet => 'Metamask wallet';

  @override
  String get metaMask => 'Metamask';

  @override
  String get kukai => 'Kukai';

  @override
  String get kukaiWallet => 'Kukai wallet';

  @override
  String get other => 'Other';

  @override
  String get otherWalletApp => 'Other wallet App';

  @override
  String importWalletHintText(Object numberCharacters) {
    return 'Once you have entered your 12 words or all the characters of the private key, tap Import.';
  }

  @override
  String get importWalletHintTextRecoveryPhraseOnly =>
      'Once you have entered your 12 words of the recovery phrase, tap Import.';

  @override
  String get kycDialogTitle =>
      'To get this card, and other identity cards, you need to verify your ID';

  @override
  String get idVerificationProcess => 'ID Verification Process';

  @override
  String get idCheck => 'ID Check';

  @override
  String get facialRecognition => 'Facial recognition';

  @override
  String get kycDialogButton => 'Start ID verification';

  @override
  String get kycDialogFooter => 'GDPR and CCPA Compliant + SOC2 Security Level';

  @override
  String get finishedVerificationTitle => 'ID verification in\nprogress';

  @override
  String get finishedVerificationDescription =>
      'You will receive an email to confirm that your ID has been verified';

  @override
  String get verificationPendingTitle => 'Your ID verification\nis pending';

  @override
  String get verificationPendingDescription =>
      'Usually it takes less than 5 min to get verified. You will receive an email when the verification is complete.';

  @override
  String get verificationDeclinedTitle => 'Your verification declined';

  @override
  String get restartVerification => 'Restart ID Verification';

  @override
  String get verificationDeclinedDescription =>
      'Your verification declined. Please restart your ID verification.';

  @override
  String get verifiedTitle => 'Well done! Your verification was successful.';

  @override
  String get verifiedDescription =>
      'You can now start adding your \'over18\' card. Let\'s begin.';

  @override
  String get verfiedButton => 'Adding the over 18 Card';

  @override
  String get verifiedNotificationTitle => 'Verification complete!';

  @override
  String get verifiedNotificationDescription =>
      'Congratulations! You have been successfully verified.';

  @override
  String get showDecentralizedID => 'Show Decentralized ID';

  @override
  String get manageDecentralizedID => 'Manage Decentralized ID';

  @override
  String get addressBook => 'Address Book';

  @override
  String get home => 'My Wallet';

  @override
  String get discover => 'Discover';

  @override
  String get settings => 'Settings';

  @override
  String get privateKeyDescriptions =>
      'A private key is a secret number that is used to sign transactions and prove ownership of a blockchain address. On Tezos, private key are usually 54 characters long.';

  @override
  String get importAccount => 'Import account';

  @override
  String get imported => 'Imported';

  @override
  String get cardDetails => 'Card details';

  @override
  String get publicAddress => 'Public address';

  @override
  String get didKey => 'DID key';

  @override
  String get export => 'Export';

  @override
  String get copy => 'Copy';

  @override
  String get didPrivateKey => 'DID private key';

  @override
  String get reveal => 'Reveal';

  @override
  String get didPrivateKeyDescription =>
      'Please be very careful with your private keys, because they control access to your credentials information.';

  @override
  String get didPrivateKeyDescriptionAlert =>
      'Please do not share your private key with anyone. This wallet is non custodial, we will never ask for it.';

  @override
  String get iReadTheMessageCorrectly => 'I read the message correctly';

  @override
  String get beCareful => 'Be careful';

  @override
  String get decentralizedIDKey => 'Decentralized ID key';

  @override
  String get copySecretKeyToClipboard => 'Copied secret key to clipboard!';

  @override
  String get copyDIDKeyToClipboard => 'Copied DID key to clipboard!';

  @override
  String get seeAddress => 'See address';

  @override
  String get revealPrivateKey => 'Reveal private key';

  @override
  String get share => 'Share';

  @override
  String get shareWith => 'Share with';

  @override
  String get copiedToClipboard => 'Copied to clipboard!';

  @override
  String get privateKey => 'Private key';

  @override
  String get decentralizedID => 'Decentralized IDentifier';

  @override
  String get did => 'DID';

  @override
  String get sameAccountNameError =>
      'This account name was used before; enter the different account name, please';

  @override
  String get unknown => 'Unknown';

  @override
  String get credentialManifestDescription => 'Description';

  @override
  String get credentialManifestInformations => 'Information';

  @override
  String get credentialDetailsActivity => 'Activity';

  @override
  String get credentialDetailsOrganisation => 'Organization';

  @override
  String get credentialDetailsPresented => 'Presented';

  @override
  String get credentialDetailsOrganisationDetail => 'Organization Detail:';

  @override
  String get credentialDetailsInWalletSince => 'In wallet since';

  @override
  String get termsOfUseAndLicenses => 'Terms of use and Licenses';

  @override
  String get licenses => 'Licenses';

  @override
  String get sendTo => 'Send to';

  @override
  String get next => 'Next';

  @override
  String get withdrawalInputHint => 'Copy address or scan';

  @override
  String get amount => 'Amount';

  @override
  String get amountSent => 'Amount sent';

  @override
  String get max => 'Max';

  @override
  String get edit => 'Edit';

  @override
  String get networkFee => 'Estimated gas fee';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get selectToken => 'Select token';

  @override
  String get insufficientBalance => 'Insufficient balance';

  @override
  String get slow => 'Slow';

  @override
  String get average => 'Average';

  @override
  String get fast => 'Fast';

  @override
  String get changeFee => 'Change Fee';

  @override
  String get sent => 'Sent';

  @override
  String get done => 'Done';

  @override
  String get link => 'Click to access';

  @override
  String get myTokens => 'My tokens';

  @override
  String get tezosMainNetwork => 'Tezos Main Network';

  @override
  String get send => 'Send';

  @override
  String get receive => 'Receive';

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String sendOnlyToThisAddressDescription(Object symbol) {
    return 'Only send $symbol to this address. Sending other tokens may result in permanent loss.';
  }

  @override
  String get addTokens => 'Add tokens';

  @override
  String get providedBy => 'Provided by';

  @override
  String get issuedOn => 'Issued on';

  @override
  String get expirationDate => 'Validity period';

  @override
  String get connect => 'Connect';

  @override
  String get connection => 'Connection';

  @override
  String get selectAccountToGrantAccess => 'Select account to grant access:';

  @override
  String get requestPersmissionTo => 'Request Permission to:';

  @override
  String get viewAccountBalanceAndNFTs => 'View account balance and NFT\'s';

  @override
  String get requestApprovalForTransaction =>
      'Request approval for transaction';

  @override
  String get connectedWithBeacon => 'Successfully connect with dApp';

  @override
  String get failedToConnectWithBeacon => 'Failed to connect with dApp';

  @override
  String get tezosNetwork => 'Tezos Network';

  @override
  String get confirm_sign => 'Confirm Sign';

  @override
  String get sign => 'Sign';

  @override
  String get payload_to_sign => 'Payload to Sign';

  @override
  String get signedPayload => 'Successfully signed payload';

  @override
  String get failedToSignPayload => 'Failed to sign the payload';

  @override
  String get voucher => 'Voucher';

  @override
  String get tezotopia => 'Tezotopia';

  @override
  String get operationCompleted =>
      'Your requested operation has been completed. The transaction may take a few minutes to be displayed in the wallet.';

  @override
  String get operationFailed => 'Your requested operation has failed';

  @override
  String get membership => 'Membership';

  @override
  String get switchNetworkMessage => 'Please switch your network to';

  @override
  String get fee => 'Fee';

  @override
  String get addCards => 'Add cards';

  @override
  String get gaming => 'Gaming';

  @override
  String get identity => 'Identity';

  @override
  String get payment => 'Payment';

  @override
  String get socialMedia => 'Social media';

  @override
  String get advanceSettings => 'Advanced settings';

  @override
  String get categories => 'Categories';

  @override
  String get selectCredentialCategoryWhichYouWantToShowInCredentialList =>
      'Select credential categories that you want to show in credentials list:';

  @override
  String get community => 'Community';

  @override
  String get tezos => 'Tezos';

  @override
  String get rights => 'Rights';

  @override
  String get disconnectAndRevokeRights => 'Disconnect & Revoke Rights';

  @override
  String get revokeAllRights => 'Revoke all rights';

  @override
  String get revokeSubtitleMessage =>
      'Are your sure you want to revoke all rights';

  @override
  String get revokeAll => 'Revoke All';

  @override
  String get succesfullyDisconnected => 'successfully disconnected from dApp.';

  @override
  String get connectedApps => 'Connected dApps';

  @override
  String get manageConnectedApps => 'Manage connected dApps';

  @override
  String get noDappConnected => 'No dApp connected yet';

  @override
  String get nftDetails => 'NFT\'s details';

  @override
  String get failedToDoOperation => 'Failed to do operation';

  @override
  String get nft => 'NFT';

  @override
  String get receiveNft => 'Receive NFT';

  @override
  String get sendOnlyNftToThisAddressDescription =>
      'Only send Tezos NFT to this address. Sending NFT from other network may result in permanent loss.';

  @override
  String get beaconShareMessage =>
      'Only send Tezos(XTZ) and Tezos NFTs(FA2 Standard) to this address. Sending Tezos and NFTs from other networks may result in permanent loss';

  @override
  String get advantagesCredentialHomeSubtitle =>
      'Benefit from exclusive advantages in Web3';

  @override
  String get advantagesCredentialDiscoverSubtitle =>
      'Discover loyalty cards and exclusive passes';

  @override
  String get identityCredentialHomeSubtitle =>
      'Prove things about yourself while protecting your data';

  @override
  String get identityCredentialDiscoverSubtitle =>
      'Get reusable KYC and age verification credentials';

  @override
  String get myProfessionalCredentialDiscoverSubtitle =>
      'Use your professional cards securely';

  @override
  String get blockchainAccountsCredentialHomeSubtitle =>
      'Prove your blockchain accounts ownership';

  @override
  String get educationCredentialHomeSubtitle =>
      'Prove your education background instantly';

  @override
  String get passCredentialHomeSubtitle =>
      'Use exclusive Passes: Supercharge your Web3 experience';

  @override
  String get financeCardsCredentialHomeSubtitle =>
      'Access new investment opportunities in web3';

  @override
  String get financeCardsCredentialDiscoverSubtitle =>
      'Get exclusive advantages offered by Communities you like';

  @override
  String get contactInfoCredentialHomeSubtitle =>
      'Share your contact information instantly';

  @override
  String get contactInfoCredentialDiscoverSubtitle =>
      'Obtain easy-to-share credentials';

  @override
  String get otherCredentialHomeSubtitle =>
      'Other types of cards in your wallet';

  @override
  String get otherCredentialDiscoverSubtitle =>
      'Other types of cards you can add';

  @override
  String get showMore => '...Show more';

  @override
  String get showLess => 'Show less...';

  @override
  String get gotIt => 'Got it';

  @override
  String get transactionErrorBalanceTooLow =>
      'An operation tried to spend more tokens than the contract has';

  @override
  String get transactionErrorCannotPayStorageFee =>
      'The storage fee is higher than the contract balance';

  @override
  String get transactionErrorFeeTooLow => 'Operation fees are too low';

  @override
  String get transactionErrorFeeTooLowForMempool =>
      'Operation fees are too low to be considered in full mempool';

  @override
  String get transactionErrorTxRollupBalanceTooLow =>
      'Tried to spend a ticket index from an index without the required balance';

  @override
  String get transactionErrorTxRollupInvalidZeroTransfer =>
      'A transfer\'s amount must be greater than zero.';

  @override
  String get transactionErrorTxRollupUnknownAddress =>
      'The address must exist in the context when signing a transfer with it.';

  @override
  String get transactionErrorInactiveChain =>
      'Attempted validation of a block from an inactive chain.';

  @override
  String get website => 'Website';

  @override
  String get whyGetThisCard => 'Why get this card';

  @override
  String get howToGetIt => 'How to get it';

  @override
  String get emailPassWhyGetThisCard =>
      'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.';

  @override
  String get emailPassExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get emailPassHowToGetIt =>
      'It’s super easy. We will verify your email ownership by sending a code by email.';

  @override
  String get tezotopiaMembershipWhyGetThisCard =>
      'This Membership card will give you 25% cash backs on ALL Tezotopia Game transactions when you buy a Drops on the marketplace or mint an NFT on starbase.';

  @override
  String get tezotopiaMembershipExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get tezotopiaMembershipLongDescription =>
      'Tezotopia is a real-time metaverse NFT game on Tezos, where players yield farm with Tezotops, engage in battles for rewards, and claim land in an immersive blockchain space adventure. Explore the metaverse, collect NFTs and conquer Tezotopia.';

  @override
  String get chainbornMembershipHowToGetIt =>
      'To get this card, you need to summon a “Hero” in Chainborn game and an Email Proof. You can find the “Email proof” card in the “Discover” section.';

  @override
  String get chainbornMembershipWhyGetThisCard =>
      'Be among the few that have access to exclusive Chainborn store content, airdrops and other member-only benefits !';

  @override
  String get chainbornMembershipExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get chainbornMembershipLongDescription =>
      'Chainborn is an exciting NFT battle game where players use their own NFTs as heroes, competing for loot and glory. Engage in thrilling fights, gain experience points to boost your hero\'s strength and health, and enhance the value of your NFTs in this captivating Tezos-based adventure.';

  @override
  String get twitterHowToGetIt =>
      'Follow the steps on TezosProfiles https://tzprofiles.com/connect. Then, claim the “Twitter account” card in Altme. Make sure to sign the transaction on TZPROFILES with the same account you are using in Altme.';

  @override
  String get twitterWhyGetThisCard =>
      'This card is a proof that you own your twitter account. Use it to prove your twitter account ownership whenever you need.';

  @override
  String get twitterExpirationDate => 'This card will be active for 1 year.';

  @override
  String get twitterDummyDesc => 'Prove your twitter account ownership';

  @override
  String get tezotopiaMembershipHowToGetIt =>
      'You need to present a proof that you are over 13 YO and a proof of your email.';

  @override
  String get over18WhyGetThisCard =>
      'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.';

  @override
  String get over18ExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get over18HowToGetIt =>
      'You can claim this card by performing an age estimate on the wallet.';

  @override
  String get over13WhyGetThisCard =>
      'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.';

  @override
  String get over13ExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get over13HowToGetIt =>
      'You can claim this card by performing an age estimate on the wallet.';

  @override
  String get over15WhyGetThisCard =>
      'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.';

  @override
  String get over15ExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get over15HowToGetIt =>
      'You can claim this card by performing an age estimate on the wallet.';

  @override
  String get passportFootprintWhyGetThisCard =>
      'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.';

  @override
  String get passportFootprintExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get passportFootprintHowToGetIt =>
      'You can claim this card by following the KYC check of teh wallet.';

  @override
  String get verifiableIdCardWhyGetThisCard =>
      'This digital identity card contains the same information as your physical ID card. You can use it on a web site for an identity check for example.';

  @override
  String get verifiableIdCardExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get verifiableIdCardHowToGetIt =>
      'You can claim this card by following the KYC check of the wallet.';

  @override
  String get verifiableIdCardDummyDesc => 'Get your Digital Identity Card.';

  @override
  String get phoneProofWhyGetThisCard =>
      'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.';

  @override
  String get phoneProofExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get phoneProofHowToGetIt =>
      'It’s super easy. We will verify your phone number ownership by sending a code by sms.';

  @override
  String get tezVoucherWhyGetThisCard =>
      'This Voucher card will give you 10% cash backs on ALL Tezotopia Game transactions when you buy a Drops on the marketplace or mint an NFT on starbase.';

  @override
  String get tezVoucherExpirationDate =>
      'This card will remain active and reusable for 30 days.';

  @override
  String get tezVoucherHowToGetIt =>
      ' It’s super easy. You can claim it for free right now.';

  @override
  String get genderWhyGetThisCard =>
      'This Gender Proof is useful to prove your gender (Male / Female) without revealing any other information about you. It can be used in a user survey, etc.';

  @override
  String get genderExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get genderHowToGetIt =>
      'You can claim this card by following the KYC check of the wallet.';

  @override
  String get nationalityWhyGetThisCard =>
      'This credential is useful to prove your Nationality without revealing any other information about you. It can be required by Web 3 Apps in a user survey, etc.';

  @override
  String get nationalityExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get nationalityHowToGetIt =>
      'You can claim this card by following the KYC check of the wallet.';

  @override
  String get ageRangeWhyGetThisCard =>
      'This credential is useful to prove your Age Range without revealing any other information about you. It can be required by Web 3 Apps in a user survey or to claim benefits : Membership card, etc.';

  @override
  String get ageRangeExpirationDate =>
      'This card will remain active and reusable for 1 YEAR.';

  @override
  String get ageRangeHowToGetIt =>
      'You can claim this card by performing an age estimate on the wallet.';

  @override
  String get defiComplianceWhyGetThisCard =>
      'Obtain verifiable proof of KYC/AML compliance, requested by compliant DeFi protocols and Web3 dApps. Once obtained, you can mint a privacy-preserving, non-transferable NFT for on-chain verification without revealing personal data.';

  @override
  String get defiComplianceExpirationDate =>
      'This credential remains active for 3 months. Renewal requires a straightforward compliance check, without new KYC.';

  @override
  String get defiComplianceHowToGetIt =>
      'It\'s easy! Complete a one-time KYC check in the wallet (powered by ID360) and request your DeFi compliance credential.';

  @override
  String get origin => 'Origin';

  @override
  String get nftTooBigToLoad => 'NFT loading';

  @override
  String get seeTransaction => 'See transaction';

  @override
  String get nftListSubtitle =>
      'Here are all NFTs and collectibles in your account.';

  @override
  String get tokenListSubtitle => 'Here are all tokens in your account.';

  @override
  String get my => 'My';

  @override
  String get get => 'Get';

  @override
  String get seeMoreNFTInformationOn => 'See more NFT information on';

  @override
  String get credentialStatus => 'Status';

  @override
  String get pass => 'Pass';

  @override
  String get payloadFormatErrorMessage => 'The format of payload is incorrect.';

  @override
  String get thisFeatureIsNotSupportedMessage =>
      'This feature is not supported yet';

  @override
  String get myWallet => 'My wallet';

  @override
  String get ethereumNetwork => 'Ethereum Network';

  @override
  String get fantomNetwork => 'Fantom Network';

  @override
  String get polygonNetwork => 'Polygon Network';

  @override
  String get binanceNetwork => 'BNB Chain Network';

  @override
  String get step => 'Step';

  @override
  String get activateBiometricsTitle =>
      'Activate Biometrics\nto add a security layer';

  @override
  String get loginWithBiometricsOnBoarding => 'Log in with biometrics';

  @override
  String get option => 'Option';

  @override
  String get start => 'Start';

  @override
  String get iAgreeToThe => 'I agree to the ';

  @override
  String get termsAndConditions => 'Terms and conditions';

  @override
  String get walletReadyTitle => 'Your wallet is ready !';

  @override
  String get walletReadySubtitle =>
      'Let’s discover everything \nWeb 3 has to offer.';

  @override
  String get failedToInitCamera => 'Camera initialization failed!';

  @override
  String get chooseMethodPageOver18Title =>
      'Choose a method to get your Over 18 Proof';

  @override
  String get chooseMethodPageOver13Title =>
      'Choose a method to get your Over 13 Proof';

  @override
  String get chooseMethodPageOver15Title =>
      'Choose a method to get your Over 15 Proof';

  @override
  String get chooseMethodPageOver21Title =>
      'Choose a method to get your Over 21 Proof';

  @override
  String get chooseMethodPageOver50Title =>
      'Choose a method to get your Over 50 Proof';

  @override
  String get chooseMethodPageOver65Title =>
      'Choose a method to get your Over 65 Proof';

  @override
  String get chooseMethodPageAgeRangeTitle =>
      'Choose a method to get your Age Range Proof';

  @override
  String get chooseMethodPageVerifiableIdTitle =>
      'Choose a method to get your Verifiable Id Proof';

  @override
  String get chooseMethodPageDefiComplianceTitle =>
      'Choose a method to get your Defi Compliance Proof';

  @override
  String get chooseMethodPageSubtitle =>
      'Get verified by taking a real-time photo of yourself or by a classic ID document check .';

  @override
  String get kycTitle => 'Quick photo of you (1min)';

  @override
  String get kycSubtitle =>
      'Get instantly verified by taking a photo of yourself.';

  @override
  String get passbaseTitle => 'Full ID document check';

  @override
  String get passbaseSubtitle =>
      'Get verified with an ID card, passport or driving license.';

  @override
  String get verifyYourAge => 'Verify your age';

  @override
  String get verifyYourAgeSubtitle =>
      'This age verification process is very easy and simple. All it requires is a real-time photo.';

  @override
  String get verifyYourAgeDescription =>
      'By accepting, you agree that we use a picture to estimate your age. The estimation is done by our partner Yoti that uses your picture only for this purpose and immediately deletes it.\n\nFor more info, review our Privacy Policy.';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get yotiCameraAppbarTitle =>
      'Please, position your face in the center';

  @override
  String get cameraSubtitle =>
      'You have 5 seconds to take your photo.\nMake sure there’s enough light before starting.';

  @override
  String get walletSecurityDescription =>
      'Protect your wallet with Pin code and biometric authentication';

  @override
  String get blockchainSettings => 'Blockchain Settings';

  @override
  String get blockchainSettingsDescription =>
      'Manage accounts, recovery phrase, connected DApps and networks';

  @override
  String get ssi => 'Self Sovereign Identity Settings';

  @override
  String get ssiDescription =>
      'Manage decentralized identifiers (DIDs) and protocol options';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get helpCenterDescription =>
      'Contact us and get support if you need assistance on using your wallet';

  @override
  String get about => 'About';

  @override
  String get aboutDescription =>
      'Read about terms of use, confidentiality and licenses';

  @override
  String get resetWallet => 'Reset Wallet';

  @override
  String get resetWalletDescription =>
      'Erase all data stored on this device and reset your wallet.';

  @override
  String get showWalletRecoveryPhrase => 'Show wallet recovery phrase';

  @override
  String get showWalletRecoveryPhraseSubtitle =>
      'The recovery phrase acts as a backup key to restore access to a your wallet.';

  @override
  String get blockchainNetwork => 'Blockchain network (by default)';

  @override
  String get contactUs => 'Contact us';

  @override
  String get officialWebsite => 'Official website';

  @override
  String get yourAppVersion => 'Your app version';

  @override
  String get resetWalletTitle => 'Are you sure you want to reset your wallet ?';

  @override
  String get resetWalletSubtitle =>
      'This action will erase your data. Please, make sure you have saved your recovery phrase and credentials backup file before deleting.';

  @override
  String get resetWalletSubtitle2 =>
      'This wallet is self-custodial so we are not able to recover your funds or credentials for you.';

  @override
  String get resetWalletCheckBox1 => 'I wrote down my recovery phrase';

  @override
  String get resetWalletCheckBox2 => 'I saved my backup credentials file';

  @override
  String get email => 'Email';

  @override
  String get fillingThisFieldIsMandatory => 'Filling this field is mandatory.';

  @override
  String get yourMessage => 'Your message';

  @override
  String get message => 'Message';

  @override
  String get subject => 'Subject';

  @override
  String get enterAValidEmail => 'Enter a valid email.';

  @override
  String get failedToSendEmail => 'Failed to send email.';

  @override
  String get selectAMethodToAddAccount => 'Select a method to add account';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountDescription =>
      'Create an account protected by your recovery phrase';

  @override
  String get importAccountDescription =>
      'Import an account from an existing wallet';

  @override
  String get chooseABlockchainForAccountCreation =>
      'Choose the blockchain on which you want to create a new account.';

  @override
  String get tezosAccount => 'Tezos account';

  @override
  String get tezosAccountDescription => 'Create a new Tezos blockchain address';

  @override
  String get ethereumAccount => 'Ethereum account';

  @override
  String get ethereumAccountDescription =>
      'Create a new Ethereum blockchain address';

  @override
  String get fantomAccount => 'Fantom account';

  @override
  String get fantomAccountDescription =>
      'Create a new Fantom blockchain address';

  @override
  String get polygonAccount => 'Polygon account';

  @override
  String get polygonAccountDescription =>
      'Create a new Polygon blockchain address';

  @override
  String get binanceAccount => 'BNB Chain account';

  @override
  String get binanceAccountDescription =>
      'Create a new BNB Chain blockchain address';

  @override
  String get setAccountNameDescription =>
      'Do you want to give a name to this new account ? Useful if you have several.';

  @override
  String get letsGo => 'Let\'s go !';

  @override
  String get congratulations => 'Congratulations !';

  @override
  String get tezosAccountCreationCongratulations =>
      'Your new Tezos account has been successfully created.';

  @override
  String get ethereumAccountCreationCongratulations =>
      'Your new Ethereum account has been successfully created.';

  @override
  String get fantomAccountCreationCongratulations =>
      'Your new Fantom account has been successfully created.';

  @override
  String get polygonAccountCreationCongratulations =>
      'Your new Polygon account has been successfully created.';

  @override
  String get binanceAccountCreationCongratulations =>
      'Your new BNB Chain account has been successfully created.';

  @override
  String get accountImportCongratulations =>
      'Your account has been successfully imported.';

  @override
  String get saveBackupCredentialTitle =>
      'Download the backup file.\nKeep it in a safe place.';

  @override
  String get saveBackupCredentialSubtitle =>
      'To recover all your credentials you will need the recovery phrase and this backup file.';

  @override
  String get saveBackupPolygonCredentialSubtitle =>
      'To recover all your polygon id credentials you will need the recovery phrase and this backup file.';

  @override
  String get restoreCredentialStep1Title =>
      'Step 1 : Enter your 12 recovery phrase words';

  @override
  String get restorePhraseTextFieldHint =>
      'Enter your recovery phrase (or mnemonic phrase) here...';

  @override
  String get restoreCredentialStep2Title =>
      'Step 2 : Upload your credentials backup file';

  @override
  String get loadFile => 'Load file';

  @override
  String get uploadFile => 'Upload file';

  @override
  String get creators => 'Creators';

  @override
  String get publishers => 'Publishers';

  @override
  String get creationDate => 'Creation date';

  @override
  String get myProfessionalrCards => 'professional cards';

  @override
  String get myProfessionalrCardsSubtitle =>
      'Use your professional cards securely.';

  @override
  String get guardaWallet => 'Guarda Wallet';

  @override
  String get exodusWallet => 'Exodus Wallet';

  @override
  String get trustWallet => 'Trust Wallet';

  @override
  String get myetherwallet => 'MyEther Wallet';

  @override
  String get skip => 'Skip';

  @override
  String get userNotFitErrorMessage =>
      'You are unable to get this card because some conditions are not fulfilled.';

  @override
  String get youAreMissing => 'You are missing';

  @override
  String get credentialsRequestedBy => 'credentials';

  @override
  String get transactionIsLikelyToFail => 'Transaction is likely to fail.';

  @override
  String get buy => 'Buy coins';

  @override
  String get thisFeatureIsNotSupportedYetForFantom =>
      'This feature is not supported yet for Fantom.';

  @override
  String get faqs => 'Frequently Asked Questions (FAQs)';

  @override
  String get softwareLicenses => 'Software Licenses';

  @override
  String get notAValidWalletAddress => 'Not a valid wallet address!';

  @override
  String get otherAccount => 'Other account';

  @override
  String get thereIsNoAccountInYourWallet =>
      'There is no account in your wallet';

  @override
  String get credentialSuccessfullyExported =>
      'Your credential has been successfully exported.';

  @override
  String get scanAndDisplay => 'Scan and Display';

  @override
  String get whatsNew => 'What\'s new';

  @override
  String get okGotIt => 'OK, GOT IT!';

  @override
  String get support => 'support';

  @override
  String get transactionDoneDialogDescription =>
      'The transfer may take a few minutes to complete';

  @override
  String get withdrawalFailedMessage =>
      'The account withdrawal was unsuccessful';

  @override
  String get credentialRequiredMessage =>
      'You must have the required credentials in your wallet to acquire this card:';

  @override
  String get keyDecentralizedIdEdSA => 'did:key EdDSA';

  @override
  String get keyDecentralizedIDSecp256k1 => 'did:key Secp256k1';

  @override
  String get ebsiV3DecentralizedId => 'did:key EBSI P-256';

  @override
  String get requiredCredentialNotFoundTitle =>
      'We are unable to find the credential\nyou need in your wallet.';

  @override
  String get requiredCredentialNotFoundSubTitle =>
      'The required credential is not in your wallet';

  @override
  String get requiredCredentialNotFoundDescription => 'Please contact us on :';

  @override
  String get backToHome => 'Back to home';

  @override
  String get help => 'Help';

  @override
  String get searchCredentials => 'Search credentials';

  @override
  String get supportChatWelcomeMessage =>
      'Welcome to our chat support! We\'re here to assist you with any questions or concerns you may have about your wallet.';

  @override
  String get cardChatWelcomeMessage =>
      'Welcome to our chat support! We\'re here to assist you with any questions or concerns.';

  @override
  String get creator => 'Creator';

  @override
  String get contractAddress => 'Contract address';

  @override
  String get lastMetadataSync => 'Last metadata sync';

  @override
  String get e2eEncyptedChat => 'Chat is encrypted from end to end.';

  @override
  String get pincodeAttemptMessage =>
      'You have entered an incorrect PIN code three times. For security reasons, please wait for one minute before trying again.';

  @override
  String get verifyNow => 'Verify Now';

  @override
  String get verifyLater => 'Verify Later';

  @override
  String get welDone => 'Well done!';

  @override
  String get mnemonicsVerifiedMessage =>
      'Your revovery phrase is saved correctly.';

  @override
  String get chatWith => 'Chat with';

  @override
  String get sendAnEmail => 'Send an email';

  @override
  String get livenessCardHowToGetIt =>
      'It\'s easy! Complete a one-time KYC check in the wallet and request a Liveness credential.';

  @override
  String get livenessCardExpirationDate =>
      'This credential will remain active for 1 year. Renewal is straightforward.';

  @override
  String get livenessCardWhyGetThisCard =>
      'Obtain verifiable proof of humanity, requested by most DeFi, GameFi protocols and Web3 dApps. Once obtained, you can mint a privacy-preserving, non-transferable NFT for on-chain verification without revealing personal data.';

  @override
  String get livenessCardLongDescription =>
      'This credential is a verifiable proof of humanity. Use it to prove you are not a bot when requested by DeFi protocols, Onchain games or Web3 dApps.';

  @override
  String get chat => 'Chat';

  @override
  String get needMnemonicVerificatinoDescription =>
      'You need to verify your wallet seed phrases to protect your assets!';

  @override
  String get succesfullyAuthenticated => 'Successfully Authenticated.';

  @override
  String get authenticationFailed => 'Authentication Failed.';

  @override
  String get documentType => 'Document Type';

  @override
  String get countryCode => 'Country Code';

  @override
  String get deviceIncompatibilityMessage =>
      'Sorry, your device is not compatible for this feature.';

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
  String get yearsOld => 'years old';

  @override
  String get youAreOver13 => 'You are over 13 years old';

  @override
  String get youAreOver15 => 'You are over 15 years old';

  @override
  String get youAreOver18 => 'You are over 18 years old';

  @override
  String get youAreOver21 => 'You are over 21 years old';

  @override
  String get youAreOver50 => 'You are over 50 years old';

  @override
  String get youAreOver65 => 'You are over 65 years old';

  @override
  String get polygon => 'Polygon';

  @override
  String get ebsi => 'EBSI';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get financeCredentialsHomeTitle => 'My financial credentials';

  @override
  String get financeCredentialsDiscoverTitle =>
      'Get verified financial credentials';

  @override
  String get financeCredentialsDiscoverSubtitle =>
      'Access new investment opportunities in web3.';

  @override
  String get financeCredentialsHomeSubtitle =>
      'Access new investment opportunities in web3';

  @override
  String get hummanityProofCredentialsHomeTitle => 'My proof of humanity';

  @override
  String get hummanityProofCredentialsHomeSubtitle =>
      'Easily prove you are a human and not a bot.';

  @override
  String get hummanityProofCredentialsDiscoverTitle =>
      'Prove you are not a bot or AI';

  @override
  String get hummanityProofCredentialsDiscoverSubtitle =>
      'Get a reusable proof of humanity to share';

  @override
  String get socialMediaCredentialsHomeTitle => 'My social media accounts';

  @override
  String get socialMediaCredentialsHomeSubtitle =>
      'Prove your accounts ownership instantly Proof of humanity';

  @override
  String get socialMediaCredentialsDiscoverTitle =>
      'Verify your social media accounts';

  @override
  String get socialMediaCredentialsDiscoverSubtitle =>
      'Prove your accounts ownership when required';

  @override
  String get walletIntegrityCredentialsHomeTitle => 'Wallet integrity';

  @override
  String get walletIntegrityCredentialsHomeSubtitle => 'TBD';

  @override
  String get walletIntegrityCredentialsDiscoverTitle => 'WAllet integrity';

  @override
  String get walletIntegrityCredentialsDiscoverSubtitle => 'TBD';

  @override
  String get polygonCredentialsHomeSubtitle =>
      'Prove your access rights in the Polygon ecosystem';

  @override
  String get polygonCredentialsDiscoverSubtitle =>
      'Prove your access rights in the Polygon ecosystem';

  @override
  String get pendingCredentialsHomeTitle => 'My Pending credentials';

  @override
  String get pendingCredentialsHomeSubtitle => 'Prove your access rights.';

  @override
  String get restore => 'Restore';

  @override
  String get backup => 'Backup';

  @override
  String get takePicture => 'Take a picture';

  @override
  String get kyc => 'KYC';

  @override
  String get aiSystemWasNotAbleToEstimateYourAge =>
      'AI system was not able to estimate your age';

  @override
  String youGotAgeCredentials(Object credential) {
    return 'You got your $credential credential.';
  }

  @override
  String yourAgeEstimationIs(Object ageEstimate) {
    return 'Your AI age estimation is $ageEstimate years';
  }

  @override
  String get credentialNotFound => 'Credential Not Found';

  @override
  String get cryptographicProof => 'Cryptographic Proof';

  @override
  String get downloadingCircuitLoadingMessage =>
      'Downloading circuits. It may take some time. Please wait.';

  @override
  String get cryptoAccountAlreadyExistMessage =>
      'It appears that an account with this crypto information already exists';

  @override
  String get errorGeneratingProof => 'Error Generating Proof';

  @override
  String get createWalletMessage => 'Please create your wallet first.';

  @override
  String get successfullyGeneratingProof => 'Successfully Generated Proof';

  @override
  String get wouldYouLikeToAcceptThisCredentialsFromThisOrganisation =>
      'Would you like to accept this credential(s) from this organisation?';

  @override
  String get thisOrganisationRequestsThisInformation =>
      'This organisation requests';

  @override
  String get iS => 'is';

  @override
  String get isSmallerThan => 'is smaller than';

  @override
  String get isBiggerThan => 'is bigger than';

  @override
  String get isOneOfTheFollowingValues => 'is one of the following values';

  @override
  String get isNotOneOfTheFollowingValues =>
      'is not one of the following values';

  @override
  String get isNot => 'is not';

  @override
  String get approve => 'Approve';

  @override
  String get noInformationWillBeSharedFromThisCredentialMessage =>
      'No information will be shared from this credential (Zero Knowledge Proof).';

  @override
  String get burn => 'Burn';

  @override
  String get wouldYouLikeToConfirmThatYouIntendToBurnThisNFT =>
      'Do you really want to burn this NFT ?';

  @override
  String pleaseAddXtoConnectToTheDapp(Object chain) {
    return 'Please add $chain account to connect to the dapp.';
  }

  @override
  String pleaseSwitchPolygonNetwork(Object networkType) {
    return 'Please switch to polygon $networkType to perform this action.';
  }

  @override
  String get oidc4vcProfile => 'OIDC4VC Profile';

  @override
  String get pleaseSwitchToCorrectOIDC4VCProfile =>
      'Please switch to correct OIDC4VC profile.';

  @override
  String get authenticationSuccess => 'Authentication Success';

  @override
  String get format => 'Format';

  @override
  String get verifyIssuerWebsiteIdentity => 'Confirm issuer access';

  @override
  String get verifyIssuerWebsiteIdentitySubtitle =>
      'Enable to verify issuer identity before access.';

  @override
  String get developerMode => 'Developer Mode';

  @override
  String get developerModeSubtitle =>
      'Enable developer mode to access advanced debugging tools';

  @override
  String get confirmVerifierAccess => 'Confirm verifier access';

  @override
  String get confirmVerifierAccessSubtitle =>
      'Disable to skip confirmation when you share your verifiable credentials.';

  @override
  String get secureAuthenticationWithPINCode =>
      'Secure authentication with PIN code';

  @override
  String get secureAuthenticationWithPINCodeSubtitle =>
      'Disable to skip PIN code for website authentication (not recommended).';

  @override
  String youcanSelectOnlyXCredential(Object count) {
    return 'You can select only $count credential(s).';
  }

  @override
  String get theCredentialIsNotReady => 'The credential is not ready.';

  @override
  String get theCredentialIsNoMoreReady =>
      'The ceredential is no more available.';

  @override
  String get lowSecurity => 'Low Security';

  @override
  String get highSecurity => 'High Security';

  @override
  String get theRequestIsRejected => 'The request is rejected.';

  @override
  String get userPinIsIncorrect => 'User PIN is incorrect';

  @override
  String get security_level => 'Security Level';

  @override
  String get userPinTitle => 'User PIN Digits pre-authorized_code Flow';

  @override
  String get userPinSubtitle =>
      'Enable to manage 4 digits PIN code. Default: 6 digits.';

  @override
  String get responseTypeNotSupported => 'The response type is not supported';

  @override
  String get invalidRequest => 'The request is invalid';

  @override
  String get subjectSyntaxTypeNotSupported =>
      'The subject syntax type is not supported.';

  @override
  String get accessDenied => 'Access denied';

  @override
  String get thisRequestIsNotSupported => 'This request is not supported';

  @override
  String get unsupportedCredential => 'Unsupported credential';

  @override
  String get aloginIsRequired => 'A login is required';

  @override
  String get userConsentIsRequired => 'User consent is required';

  @override
  String get theWalletIsNotRegistered => 'The wallet is not registered';

  @override
  String get credentialIssuanceDenied => 'Credential issuance denied';

  @override
  String get thisCredentialFormatIsNotSupported =>
      'This credential format is not supported';

  @override
  String get thisFormatIsNotSupported => 'This format is not supported';

  @override
  String get moreDetails => 'More Details';

  @override
  String get theCredentialOfferIsInvalid => 'The credential offer is invalid';

  @override
  String get dateOfRequest => 'Date of Request';

  @override
  String get keyDecentralizedIDP256 => 'did:key P-256';

  @override
  String get jwkDecentralizedIDP256 => 'did:jwk P-256';

  @override
  String get defaultDid => 'Default DID';

  @override
  String get selectOneOfTheDid => 'Select one of the DIDs';

  @override
  String get theServiceIsNotAvailable => 'The service is not available';

  @override
  String get issuerDID => 'Issuer DID';

  @override
  String get subjectDID => 'Subject DID';

  @override
  String get type => 'Type';

  @override
  String get credentialExpired => 'Credential Expired';

  @override
  String get incorrectSignature => 'Incorrect Signature';

  @override
  String get revokedOrSuspendedCredential => 'Revoked or Suspended Credential';

  @override
  String get display => 'Display';

  @override
  String get download => 'Download';

  @override
  String get successfullyDownloaded => 'Successfully Downloaded';

  @override
  String get advancedSecuritySettings => 'Advanced Security Settings';

  @override
  String get theIssuanceOfThisCredentialIsPending =>
      'The issuance of this credential is pending';

  @override
  String get clientId => 'Client Id';

  @override
  String get clientSecret => 'Client Secret';

  @override
  String get walletProfiles => 'Wallet Profile';

  @override
  String get walletProfilesDescription =>
      'Choose your wallet profile or customize your own';

  @override
  String get protectYourWallet => 'Protect your wallet';

  @override
  String get protectYourWalletMessage =>
      'Use your fingerprint, face, or PIN code to secure and unlock your wallet. Your data is securely encrypted on this device.';

  @override
  String get pinUnlock => 'PIN unlock';

  @override
  String get secureWithDevicePINOnly => 'Secure with PIN code only';

  @override
  String get biometricUnlock => 'Biometric unlock';

  @override
  String get secureWithFingerprint =>
      'Secure with fingerprint or facial recognition';

  @override
  String get pinUnlockAndBiometric2FA => 'PIN + biometric unlock (2FA)';

  @override
  String get secureWithFingerprintAndPINBackup =>
      'Secure with fingerprint or facial recognition + PIN code';

  @override
  String get secureYourWalletWithPINCodeAndBiometrics =>
      'Secure your wallet with PIN code and biometrics';

  @override
  String get twoFactorAuthenticationHasBeenEnabled =>
      'Two factor authentication has been enabled.';

  @override
  String get initialization => 'Initialization';

  @override
  String get login => 'Login';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterYourEmailAndYourCompanyPasswordToCreateYourAccount =>
      'Please enter your email and your company password to create your account';

  @override
  String get enterTheSecurityCodeThatWeSentYouByEmail =>
      'Enter the security code that we sent you by email';

  @override
  String get enterTheSecurityCode => 'Enter the security code';

  @override
  String get yourEmail => 'Your email';

  @override
  String get publicKeyOfWalletInstance => 'Public Key of Wallet Instance';

  @override
  String get walletInstanceKey => 'Wallet Instance Key';

  @override
  String get organizationProfile => 'Organization Profile';

  @override
  String get profileName => 'Profile Name';

  @override
  String get companyName => 'Company Name';

  @override
  String get configFileIdentifier => 'Config file identifier';

  @override
  String get updateYourWalletConfigNow => 'Update your wallet config now';

  @override
  String get updateConfigurationNow => 'Update configuration now';

  @override
  String
  get pleaseEnterYourEmailAndPasswordToUpdateYourOrganizationWalletConfiguration =>
      'Please enter your email and password to update your organization wallet configuration';

  @override
  String get congrats => 'Congrats !';

  @override
  String get yourWalletConfigurationHasBeenSuccessfullyUpdated =>
      'Your wallet configuration has been successfully updated';

  @override
  String get continueString => 'Continue';

  @override
  String get walletProvider => 'Wallet Provider';

  @override
  String get clientTypeSubtitle =>
      'Switch to change the client type. Default: DID.';

  @override
  String get thisTypeProofCannotBeUsedWithThisVCFormat =>
      'This proof type cannot be used with this VC Format.';

  @override
  String get blockchainCardsDiscoverTitle =>
      'Get a proof of crypto account ownership';

  @override
  String get blockchainCardsDiscoverSubtitle =>
      'Get a proof of crypto account ownership.';

  @override
  String get successfullyAddedEnterpriseAccount =>
      'Successfully added enterprise account!';

  @override
  String get successfullyUpdatedEnterpriseAccount =>
      'Successfully updated enterprise account!';

  @override
  String get thisWalleIsAlreadyConfigured =>
      'This wallet is already configured';

  @override
  String get walletSettings => 'Wallet Settings';

  @override
  String get walletSettingsDescription => 'Choose your language and theme';

  @override
  String get languageSelectorTitle => 'Language';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Español';

  @override
  String get catalan => 'Català';

  @override
  String get english => 'English';

  @override
  String get phoneLanguage => 'Phone language';

  @override
  String get cardIsValid => 'Card is valid';

  @override
  String get cardIsExpired => 'Card is expired';

  @override
  String get signatureIsInvalid => 'Signature is invalid';

  @override
  String get statusIsInvalid => 'Status is invalid';

  @override
  String get statuslListSignatureFailed => 'Status list signature failed';

  @override
  String get statusList => 'Status list';

  @override
  String get statusListIndex => 'Status list index';

  @override
  String get theWalletIsSuspended => 'The wallet is suspended.';

  @override
  String get jwkThumbprintP256Key => 'JWK Thumbprint P-256';

  @override
  String get walletBlockedPopupTitle => 'Blocked 10 minutes';

  @override
  String get walletBlockedPopupDescription =>
      'Too many failed attempts, your wallet is blocked for your security.\nYou can reset your wallet in order to use it again.';

  @override
  String get deleteMyWalletForWrontPincodeTitle =>
      'Account blocked after 3 unsuccessful attempts';

  @override
  String get deleteMyWalletForWrontPincodeDescription =>
      'For your security you must reset you wallet to use it again.';

  @override
  String get walletBloced => 'Account blocked';

  @override
  String get deleteMyWallet => 'Delete my account';

  @override
  String get pincodeRules =>
      'Your secret code can\'t be a sequence or have 4 identical digit.';

  @override
  String get pincodeSerie => 'You can\'t have 4 identical digits.';

  @override
  String get pincodeSequence => 'You can\'t have a sequence of 4 digits.';

  @override
  String get pincodeDifferent =>
      'Incorrect code.\nBoth codes are not the same.';

  @override
  String codeSecretIncorrectDescription(Object count, Object plural) {
    return 'Be carreful, $count attempt$plural left.';
  }

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get languageSettingsDescription => 'Choose your language';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get themeSettingsDescription => 'Choose your theme';

  @override
  String couldNotFindTheAccountWithThisAddress(Object address) {
    return 'Could not find the address $address in your account list.';
  }

  @override
  String deleteAccountMessage(Object account) {
    return 'Are you sure you want to delete $account?';
  }

  @override
  String get cannotDeleteCurrentAccount =>
      'Sorry, you cannot delete current account';

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
      'The recovery phrase contains sensitive information. Please, make sure to keep it private.';

  @override
  String get accountPrivateKeyAlert =>
      'The recovery phrase contains sensitive information. Please, make sure to keep it private.';

  @override
  String get etherlinkNetwork => 'Etherlink Network';

  @override
  String get etherlinkAccount => 'Etherlink account';

  @override
  String get etherlinkAccountDescription =>
      'Create a new Etherlink blockchain address';

  @override
  String get etherlinkAccountCreationCongratulations =>
      'Your new Etherlink account has been successfully created.';

  @override
  String get etherlinkProofMessage => '';

  @override
  String get notification => 'Notification';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationTitle =>
      'Welcome to the notification room!\nStay informed with important updates.';

  @override
  String get chatRoom => 'Chat room';

  @override
  String get notificationRoom => 'Notification room';

  @override
  String get notificationSubtitle => 'Enable to get notifications';

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
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get activityLog => 'Activity Log';

  @override
  String get activityLogDescription => 'See your activities';

  @override
  String get walletInitialized => 'Wallet Initialized';

  @override
  String get backupCredentials => 'Backup Credentials';

  @override
  String get restoredCredentials => 'Restored Credentials';

  @override
  String deletedCredential(Object credential) {
    return 'Deleted credential $credential';
  }

  @override
  String presentedCredential(Object credential, Object domain) {
    return 'Presented credential $credential to $domain';
  }

  @override
  String get keysImported => 'Keys imported';

  @override
  String get approveProfileTitle => 'Install configuration';

  @override
  String approveProfileDescription(Object company) {
    return 'Do you consent to install the configuration of $company?';
  }

  @override
  String get updateProfileTitle => 'Update configuration';

  @override
  String updateProfileDescription(Object company) {
    return 'Do you consent to update the configuration of $company?';
  }

  @override
  String get replaceProfileTitle => 'Install a new configuration';

  @override
  String replaceProfileDescription(Object company) {
    return 'Do you consent to replace the current configuration with that of $company?';
  }

  @override
  String get saveBackupCredentialSubtitle2 =>
      'To recover all your credentials you will need this backup file.';

  @override
  String get createWallet => 'Create Wallet';

  @override
  String get restoreWallet => 'Restore Wallet';

  @override
  String get showWalletRecoveryPhraseSubtitle2 =>
      'This recovery phrase is requested to restore a wallet at installation.';

  @override
  String get documentation => 'Documentation';

  @override
  String get restoreACryptoWallet => 'Restore a crypto wallet';

  @override
  String restoreAnAppBackup(Object appName) {
    return 'Restore an $appName backup';
  }

  @override
  String get credentialPickShare => 'Share';

  @override
  String get credentialPickTitle => 'Choose the credential(s) to get';

  @override
  String get credentialShareTitle => 'Choose the credential(s) to share';

  @override
  String get enterYourSecretCode => 'Enter your secret code.';

  @override
  String get jwk => 'JWK';

  @override
  String get typeYourPINCodeToOpenTheWallet =>
      'Type your PIN code to open the wallet';

  @override
  String get typeYourPINCodeToShareTheData =>
      'Type your PIN code to share data';

  @override
  String get typeYourPINCodeToAuthenticate =>
      'Type your PIN code to authenticate';

  @override
  String get credentialIssuanceIsStillPending =>
      'Credential issuance is still pending';

  @override
  String get bakerFee => 'Baker fee';

  @override
  String get storageFee => 'Storage Fee';

  @override
  String get doYouWantToSetupTheProfile => 'Do you want to setup the profile?';

  @override
  String get thisFeatureIsNotSupportedYetForEtherlink =>
      'This feature is not supported yet for Etherlink Chain.';

  @override
  String get walletSecurityAndBackup => 'Wallet Security and Backup';

  @override
  String addedCredential(Object credential, Object domain) {
    return 'Added credential $credential by $domain';
  }

  @override
  String get reject => 'Reject';

  @override
  String get operation => 'Operation';

  @override
  String get chooseYourSSIProfileOrCustomizeYourOwn =>
      'Choose your wallet profile or customize your own';

  @override
  String get recoveryPhraseIncorrectErrorMessage =>
      'Please try again with correct order.';

  @override
  String get invalidCode => 'Invalid code';

  @override
  String get back => 'Back';

  @override
  String get iaAnalyze =>
      'Data will be shared with a remote AI engine. Don\'t share personal data.';

  @override
  String get iaAnalyzeTitle => 'AI Agent';

  @override
  String get deleteDigit => 'Delete';

  @override
  String get aiPleaseWait => 'This treatment can take up to 1 min';

  @override
  String get trustedList => 'Use trusted list';

  @override
  String get trustedListSubtitle =>
      'List of trusted entities in the current ecosystem. You are warned in case of interaction with non trusted entity.';

  @override
  String get notTrustedEntity =>
      'This entity is not in the trusted list. You should be very cautious with untrusted entities.';
}
