import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ca'),
    Locale('es'),
    Locale('fr'),
  ];

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error has occurred!'**
  String get genericError;

  /// Title for the Credentials List Page
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get credentialListTitle;

  /// Credential issuer on detail page
  ///
  /// In en, this message translates to:
  /// **'Issued by {issuer}'**
  String credentialDetailIssuedBy(Object issuer);

  /// List action button to refresh the content
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get listActionRefresh;

  /// List action button to set view to list mode
  ///
  /// In en, this message translates to:
  /// **'View as list'**
  String get listActionViewList;

  /// List action button to set view to grid mode
  ///
  /// In en, this message translates to:
  /// **'View as grid'**
  String get listActionViewGrid;

  /// List action button to open filter options
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get listActionFilter;

  /// List action button to open sort options
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get listActionSort;

  /// No description provided for @onBoardingStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lorem ipsum dolor sit ame'**
  String get onBoardingStartSubtitle;

  /// No description provided for @onBoardingTosTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get onBoardingTosTitle;

  /// No description provided for @onBoardingTosText.
  ///
  /// In en, this message translates to:
  /// **'By tapping accept \"I  agree to the terms and condition as well as the disclosure of this information.\"'**
  String get onBoardingTosText;

  /// No description provided for @onBoardingTosButton.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get onBoardingTosButton;

  /// No description provided for @onBoardingRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Recovery'**
  String get onBoardingRecoveryTitle;

  /// No description provided for @onBoardingRecoveryButton.
  ///
  /// In en, this message translates to:
  /// **'Recover'**
  String get onBoardingRecoveryButton;

  /// No description provided for @onBoardingGenPhraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery Phrase'**
  String get onBoardingGenPhraseTitle;

  /// No description provided for @onBoardingGenPhraseButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onBoardingGenPhraseButton;

  /// No description provided for @onBoardingGenTitle.
  ///
  /// In en, this message translates to:
  /// **'Private Key Generation'**
  String get onBoardingGenTitle;

  /// No description provided for @onBoardingGenButton.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get onBoardingGenButton;

  /// No description provided for @onBoardingSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Identifier Created'**
  String get onBoardingSuccessTitle;

  /// No description provided for @onBoardingSuccessButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onBoardingSuccessButton;

  /// No description provided for @credentialDetailShare.
  ///
  /// In en, this message translates to:
  /// **'Share by QR code'**
  String get credentialDetailShare;

  /// No description provided for @credentialAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'A new credential has been successfully added!'**
  String get credentialAddedMessage;

  /// No description provided for @credentialDetailDeleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete this card'**
  String get credentialDetailDeleteCard;

  /// No description provided for @credentialDetailDeleteConfirmationDialog.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this credential?'**
  String get credentialDetailDeleteConfirmationDialog;

  /// No description provided for @credentialDetailDeleteConfirmationDialogYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get credentialDetailDeleteConfirmationDialogYes;

  /// No description provided for @credentialDetailDeleteConfirmationDialogNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get credentialDetailDeleteConfirmationDialogNo;

  /// No description provided for @credentialDetailDeleteSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted.'**
  String get credentialDetailDeleteSuccessMessage;

  /// No description provided for @credentialDetailEditConfirmationDialog.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to edit this credential?'**
  String get credentialDetailEditConfirmationDialog;

  /// No description provided for @credentialDetailEditConfirmationDialogYes.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get credentialDetailEditConfirmationDialogYes;

  /// No description provided for @credentialDetailEditConfirmationDialogNo.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get credentialDetailEditConfirmationDialogNo;

  /// No description provided for @credentialDetailEditSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Successfully edited.'**
  String get credentialDetailEditSuccessMessage;

  /// No description provided for @credentialDetailCopyFieldValue.
  ///
  /// In en, this message translates to:
  /// **'Copied field value to clipboard!'**
  String get credentialDetailCopyFieldValue;

  /// No description provided for @credentialDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get credentialDetailStatus;

  /// No description provided for @credentialPresentTitle.
  ///
  /// In en, this message translates to:
  /// **'Select credential(s)'**
  String get credentialPresentTitle;

  /// No description provided for @credentialPresentTitleDIDAuth.
  ///
  /// In en, this message translates to:
  /// **'DIDAuth Request'**
  String get credentialPresentTitleDIDAuth;

  /// No description provided for @credentialPresentRequiredCredential.
  ///
  /// In en, this message translates to:
  /// **'Someone is asking for your'**
  String get credentialPresentRequiredCredential;

  /// No description provided for @credentialPresentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Select credential(s)'**
  String get credentialPresentConfirm;

  /// No description provided for @credentialPresentCancel.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get credentialPresentCancel;

  /// No description provided for @selectYourTezosAssociatedWallet.
  ///
  /// In en, this message translates to:
  /// **'Select your Tezos associated wallet'**
  String get selectYourTezosAssociatedWallet;

  /// No description provided for @credentialPickSelect.
  ///
  /// In en, this message translates to:
  /// **'Select your credential'**
  String get credentialPickSelect;

  /// No description provided for @siopV2credentialPickSelect.
  ///
  /// In en, this message translates to:
  /// **'Choose only one credential from your wallet to present'**
  String get siopV2credentialPickSelect;

  /// No description provided for @credentialPickAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to give an alias to this credential?'**
  String get credentialPickAlertMessage;

  /// No description provided for @credentialReceiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Credential Offer'**
  String get credentialReceiveTitle;

  /// No description provided for @credentialReceiveHost.
  ///
  /// In en, this message translates to:
  /// **'wants to send you a credential'**
  String get credentialReceiveHost;

  /// No description provided for @credentialAddThisCard.
  ///
  /// In en, this message translates to:
  /// **'Add this card'**
  String get credentialAddThisCard;

  /// No description provided for @credentialReceiveCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel this card'**
  String get credentialReceiveCancel;

  /// No description provided for @credentialDetailListTitle.
  ///
  /// In en, this message translates to:
  /// **'My wallet'**
  String get credentialDetailListTitle;

  /// No description provided for @communicationHostAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get communicationHostAllow;

  /// No description provided for @communicationHostDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get communicationHostDeny;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QRcode'**
  String get scanTitle;

  /// No description provided for @scanPromptHost.
  ///
  /// In en, this message translates to:
  /// **'Do you trust this host?'**
  String get scanPromptHost;

  /// No description provided for @scanRefuseHost.
  ///
  /// In en, this message translates to:
  /// **'The communication request was denied.'**
  String get scanRefuseHost;

  /// No description provided for @scanUnsupportedMessage.
  ///
  /// In en, this message translates to:
  /// **'The extracted url is not valid.'**
  String get scanUnsupportedMessage;

  /// No description provided for @qrCodeSharing.
  ///
  /// In en, this message translates to:
  /// **'You are now sharing'**
  String get qrCodeSharing;

  /// No description provided for @qrCodeNoValidMessage.
  ///
  /// In en, this message translates to:
  /// **'This QRCode does not contain a valid message.'**
  String get qrCodeNoValidMessage;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @personalTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personalTitle;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsTitle;

  /// No description provided for @recoveryKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase'**
  String get recoveryKeyTitle;

  /// No description provided for @showRecoveryPhrase.
  ///
  /// In en, this message translates to:
  /// **'Show Recovery Phrase'**
  String get showRecoveryPhrase;

  /// No description provided for @warningDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Be careful'**
  String get warningDialogTitle;

  /// No description provided for @recoveryText.
  ///
  /// In en, this message translates to:
  /// **'Please enter your recovery phrase'**
  String get recoveryText;

  /// No description provided for @recoveryMnemonicHintText.
  ///
  /// In en, this message translates to:
  /// **'Enter your recovery phrase here.\nOnce you have entered your 12 words,\ntap Import.'**
  String get recoveryMnemonicHintText;

  /// No description provided for @recoveryMnemonicError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mnemonic phrase'**
  String get recoveryMnemonicError;

  /// No description provided for @showDialogYes.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get showDialogYes;

  /// No description provided for @showDialogNo.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get showDialogNo;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @noticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get noticesTitle;

  /// No description provided for @resetWalletButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetWalletButton;

  /// No description provided for @resetWalletConfirmationText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your wallet?'**
  String get resetWalletConfirmationText;

  /// No description provided for @selectThemeText.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectThemeText;

  /// No description provided for @lightThemeText.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightThemeText;

  /// No description provided for @darkThemeText.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkThemeText;

  /// No description provided for @systemThemeText.
  ///
  /// In en, this message translates to:
  /// **'Phone Theme'**
  String get systemThemeText;

  /// No description provided for @genPhraseInstruction.
  ///
  /// In en, this message translates to:
  /// **'Write these words, download the backup file and keep them in a safe place'**
  String get genPhraseInstruction;

  /// No description provided for @genPhraseExplanation.
  ///
  /// In en, this message translates to:
  /// **'If you lose access to this wallet, you will need the words in the correct order and the backup file to recover your credentials.'**
  String get genPhraseExplanation;

  /// No description provided for @errorGeneratingKey.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate key, please try again'**
  String get errorGeneratingKey;

  /// No description provided for @documentHeaderTooltipName.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get documentHeaderTooltipName;

  /// No description provided for @documentHeaderTooltipJob.
  ///
  /// In en, this message translates to:
  /// **'Crypto Trader'**
  String get documentHeaderTooltipJob;

  /// No description provided for @documentHeaderTooltipLabel.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get documentHeaderTooltipLabel;

  /// No description provided for @documentHeaderTooltipValue.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get documentHeaderTooltipValue;

  /// No description provided for @didDisplayId.
  ///
  /// In en, this message translates to:
  /// **'DID'**
  String get didDisplayId;

  /// No description provided for @blockChainDisplayMethod.
  ///
  /// In en, this message translates to:
  /// **'Blockchain'**
  String get blockChainDisplayMethod;

  /// No description provided for @blockChainAdress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get blockChainAdress;

  /// No description provided for @didDisplayCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy DID to clipboard'**
  String get didDisplayCopy;

  /// No description provided for @adressDisplayCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy address to clipboard'**
  String get adressDisplayCopy;

  /// No description provided for @personalSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get personalSave;

  /// No description provided for @personalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile information can be used to complete a certificate when necessary'**
  String get personalSubtitle;

  /// No description provided for @personalFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get personalFirstName;

  /// No description provided for @personalLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get personalLastName;

  /// No description provided for @personalPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get personalPhone;

  /// No description provided for @personalAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get personalAddress;

  /// No description provided for @personalMail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get personalMail;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'gender'**
  String get gender;

  /// No description provided for @birthdate.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get birthdate;

  /// No description provided for @birthplace.
  ///
  /// In en, this message translates to:
  /// **'Birthplace'**
  String get birthplace;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @identifier.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get identifier;

  /// No description provided for @issuer.
  ///
  /// In en, this message translates to:
  /// **'Issued by'**
  String get issuer;

  /// No description provided for @workFor.
  ///
  /// In en, this message translates to:
  /// **'Work for'**
  String get workFor;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get endDate;

  /// No description provided for @employmentType.
  ///
  /// In en, this message translates to:
  /// **'Employment type'**
  String get employmentType;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get jobTitle;

  /// No description provided for @baseSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get baseSalary;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @generalInformationLabel.
  ///
  /// In en, this message translates to:
  /// **'General information'**
  String get generalInformationLabel;

  /// No description provided for @learningAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get learningAchievement;

  /// No description provided for @signedBy.
  ///
  /// In en, this message translates to:
  /// **'Signed by'**
  String get signedBy;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @credential.
  ///
  /// In en, this message translates to:
  /// **'Credential'**
  String get credential;

  /// No description provided for @issuanceDate.
  ///
  /// In en, this message translates to:
  /// **'Issuance date'**
  String get issuanceDate;

  /// No description provided for @appContactWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get appContactWebsite;

  /// No description provided for @trustFrameworkDescription.
  ///
  /// In en, this message translates to:
  /// **'The trust framework is formed by a set of registries that provide a secure and reliable basis for entities within the system to trust and interact with each other.'**
  String get trustFrameworkDescription;

  /// No description provided for @confimrDIDAuth.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log in to the site ?'**
  String get confimrDIDAuth;

  /// No description provided for @evidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidenceLabel;

  /// No description provided for @networkErrorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get networkErrorBadRequest;

  /// No description provided for @networkErrorConflict.
  ///
  /// In en, this message translates to:
  /// **'Error due to a conflict'**
  String get networkErrorConflict;

  /// No description provided for @networkErrorPreconditionFailed.
  ///
  /// In en, this message translates to:
  /// **'Server does not meet one of the preconditions.'**
  String get networkErrorPreconditionFailed;

  /// No description provided for @networkErrorCreated.
  ///
  /// In en, this message translates to:
  /// **''**
  String get networkErrorCreated;

  /// No description provided for @networkErrorGatewayTimeout.
  ///
  /// In en, this message translates to:
  /// **'The gateway encountered a timeout'**
  String get networkErrorGatewayTimeout;

  /// No description provided for @networkErrorInternalServerError.
  ///
  /// In en, this message translates to:
  /// **'This is a server internal error. Contact the server administrator'**
  String get networkErrorInternalServerError;

  /// No description provided for @networkErrorMethodNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'The user does not have access rights to the content'**
  String get networkErrorMethodNotAllowed;

  /// No description provided for @networkErrorNoInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get networkErrorNoInternetConnection;

  /// No description provided for @networkErrorNotAcceptable.
  ///
  /// In en, this message translates to:
  /// **'Not acceptable'**
  String get networkErrorNotAcceptable;

  /// No description provided for @networkErrorNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Not Implemented'**
  String get networkErrorNotImplemented;

  /// No description provided for @networkErrorOk.
  ///
  /// In en, this message translates to:
  /// **''**
  String get networkErrorOk;

  /// No description provided for @networkErrorRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request Cancelled'**
  String get networkErrorRequestCancelled;

  /// No description provided for @networkErrorRequestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get networkErrorRequestTimeout;

  /// No description provided for @networkErrorSendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout in connection with API server'**
  String get networkErrorSendTimeout;

  /// No description provided for @networkErrorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get networkErrorServiceUnavailable;

  /// No description provided for @networkErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'The user has sent too many requests in a given amount of time'**
  String get networkErrorTooManyRequests;

  /// No description provided for @networkErrorUnableToProcess.
  ///
  /// In en, this message translates to:
  /// **'Unable to process the data'**
  String get networkErrorUnableToProcess;

  /// No description provided for @networkErrorUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'The user must authenticate itself to get the requested response'**
  String get networkErrorUnauthenticated;

  /// No description provided for @networkErrorUnauthorizedRequest.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized request'**
  String get networkErrorUnauthorizedRequest;

  /// No description provided for @networkErrorUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get networkErrorUnexpectedError;

  /// No description provided for @networkErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get networkErrorNotFound;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @revoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get revoked;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @unavailable_feature_title.
  ///
  /// In en, this message translates to:
  /// **'Unavailable Feature'**
  String get unavailable_feature_title;

  /// No description provided for @unavailable_feature_message.
  ///
  /// In en, this message translates to:
  /// **'This feature is not available on the browser'**
  String get unavailable_feature_message;

  /// No description provided for @personalSkip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get personalSkip;

  /// No description provided for @restoreCredential.
  ///
  /// In en, this message translates to:
  /// **'Restore credentials'**
  String get restoreCredential;

  /// No description provided for @backupCredential.
  ///
  /// In en, this message translates to:
  /// **'Backup credentials'**
  String get backupCredential;

  /// No description provided for @backupCredentialPhrase.
  ///
  /// In en, this message translates to:
  /// **'Write these words, download the backup file and keep them in a safe place'**
  String get backupCredentialPhrase;

  /// No description provided for @backupCredentialPhraseExplanation.
  ///
  /// In en, this message translates to:
  /// **'To backup your credentials write down your recovery phrase and keep it in a safe place.'**
  String get backupCredentialPhraseExplanation;

  /// No description provided for @backupCredentialButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Save The File'**
  String get backupCredentialButtonTitle;

  /// No description provided for @needStoragePermission.
  ///
  /// In en, this message translates to:
  /// **'Sorry, You need storage permission to download this file.'**
  String get needStoragePermission;

  /// No description provided for @backupCredentialNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get backupCredentialNotificationTitle;

  /// No description provided for @backupCredentialNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'File has been successfully downloaded. Tap to open the file.'**
  String get backupCredentialNotificationMessage;

  /// No description provided for @backupCredentialError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get backupCredentialError;

  /// No description provided for @backupCredentialSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'File has been successfully downloaded.'**
  String get backupCredentialSuccessMessage;

  /// No description provided for @restorationCredentialWarningDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The restoration will erase all the credentials you already have in your wallet.'**
  String get restorationCredentialWarningDialogSubtitle;

  /// No description provided for @recoveryCredentialPhrase.
  ///
  /// In en, this message translates to:
  /// **'Write down the words and upload the backup file if you saved it before'**
  String get recoveryCredentialPhrase;

  /// No description provided for @recoveryCredentialPhraseExplanation.
  ///
  /// In en, this message translates to:
  /// **'You need both words in right order and encrypted backup file to recover your credentials if you lost your credentials somehow'**
  String get recoveryCredentialPhraseExplanation;

  /// No description provided for @recoveryCredentialButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Backup File'**
  String get recoveryCredentialButtonTitle;

  /// Success Message Count
  ///
  /// In en, this message translates to:
  /// **'Successfully recovered {postfix}.'**
  String recoveryCredentialSuccessMessage(Object postfix);

  /// No description provided for @recoveryCredentialJSONFormatErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please upload the valid file.'**
  String get recoveryCredentialJSONFormatErrorMessage;

  /// No description provided for @recoveryCredentialAuthErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, either mnemonics is incorrect or uploaded file is corrupted.'**
  String get recoveryCredentialAuthErrorMessage;

  /// No description provided for @recoveryCredentialDefaultErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get recoveryCredentialDefaultErrorMessage;

  /// No description provided for @selfIssuedCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Self issued credential created successfully'**
  String get selfIssuedCreatedSuccessfully;

  /// No description provided for @companyWebsite.
  ///
  /// In en, this message translates to:
  /// **'Company Website'**
  String get companyWebsite;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @insertYourDIDKey.
  ///
  /// In en, this message translates to:
  /// **'Insert your DID'**
  String get insertYourDIDKey;

  /// No description provided for @importYourRSAKeyJsonFile.
  ///
  /// In en, this message translates to:
  /// **'Import your RSA key json file'**
  String get importYourRSAKeyJsonFile;

  /// No description provided for @didKeyAndRSAKeyVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'DID and RSA key verified successfully'**
  String get didKeyAndRSAKeyVerifiedSuccessfully;

  /// No description provided for @pleaseEnterYourDIDKey.
  ///
  /// In en, this message translates to:
  /// **'Please enter your DID'**
  String get pleaseEnterYourDIDKey;

  /// No description provided for @pleaseImportYourRSAKey.
  ///
  /// In en, this message translates to:
  /// **'Please import your RSA key'**
  String get pleaseImportYourRSAKey;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @pleaseSelectRSAKeyFileWithJsonExtension.
  ///
  /// In en, this message translates to:
  /// **'Please select RSA key file(with json extension)'**
  String get pleaseSelectRSAKeyFileWithJsonExtension;

  /// No description provided for @rsaNotMatchedWithDIDKey.
  ///
  /// In en, this message translates to:
  /// **'RSA key not matched with DID'**
  String get rsaNotMatchedWithDIDKey;

  /// No description provided for @didKeyNotResolved.
  ///
  /// In en, this message translates to:
  /// **'DID not resolved'**
  String get didKeyNotResolved;

  /// No description provided for @anUnknownErrorHappened.
  ///
  /// In en, this message translates to:
  /// **'An unknown error happened'**
  String get anUnknownErrorHappened;

  /// No description provided for @walletType.
  ///
  /// In en, this message translates to:
  /// **'Wallet Type'**
  String get walletType;

  /// No description provided for @chooseYourWalletType.
  ///
  /// In en, this message translates to:
  /// **'Choose your wallet type'**
  String get chooseYourWalletType;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get proceed;

  /// No description provided for @enterpriseWallet.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Wallet'**
  String get enterpriseWallet;

  /// No description provided for @personalWallet.
  ///
  /// In en, this message translates to:
  /// **'Personal Wallet'**
  String get personalWallet;

  /// No description provided for @failedToVerifySelfIssuedCredential.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify self issued credential'**
  String get failedToVerifySelfIssuedCredential;

  /// No description provided for @failedToCreateSelfIssuedCredential.
  ///
  /// In en, this message translates to:
  /// **'Failed to create self issued credential'**
  String get failedToCreateSelfIssuedCredential;

  /// No description provided for @credentialVerificationReturnWarning.
  ///
  /// In en, this message translates to:
  /// **'Credential verification returned some warnings. '**
  String get credentialVerificationReturnWarning;

  /// No description provided for @failedToVerifyCredential.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify credential.'**
  String get failedToVerifyCredential;

  /// No description provided for @somethingsWentWrongTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later. '**
  String get somethingsWentWrongTryAgainLater;

  /// No description provided for @successfullyPresentedYourCredential.
  ///
  /// In en, this message translates to:
  /// **'Successfully presented your credential(s)!'**
  String get successfullyPresentedYourCredential;

  /// No description provided for @successfullyPresentedYourDID.
  ///
  /// In en, this message translates to:
  /// **'Successfully presented your DID!'**
  String get successfullyPresentedYourDID;

  /// No description provided for @thisQRCodeIsNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This QR code is not supported.'**
  String get thisQRCodeIsNotSupported;

  /// No description provided for @thisUrlDoseNotContainAValidMessage.
  ///
  /// In en, this message translates to:
  /// **'This url does not contain a valid message.'**
  String get thisUrlDoseNotContainAValidMessage;

  /// No description provided for @anErrorOccurredWhileConnectingToTheServer.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while connecting to the server.'**
  String get anErrorOccurredWhileConnectingToTheServer;

  /// No description provided for @failedToSaveMnemonicPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to save mnemonic, please try again'**
  String get failedToSaveMnemonicPleaseTryAgain;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile. '**
  String get failedToLoadProfile;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. '**
  String get failedToSaveProfile;

  /// No description provided for @failedToLoadDID.
  ///
  /// In en, this message translates to:
  /// **'Failed to load DID. '**
  String get failedToLoadDID;

  /// No description provided for @personalOpenIdRestrictionMessage.
  ///
  /// In en, this message translates to:
  /// **'Personal wallet does not have access.'**
  String get personalOpenIdRestrictionMessage;

  /// No description provided for @credentialEmptyError.
  ///
  /// In en, this message translates to:
  /// **'You do not have any credential in your wallet.'**
  String get credentialEmptyError;

  /// No description provided for @credentialPresentTitleSiopV2.
  ///
  /// In en, this message translates to:
  /// **'Present Credential'**
  String get credentialPresentTitleSiopV2;

  /// No description provided for @confirmSiopV2.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the credential presented'**
  String get confirmSiopV2;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission required'**
  String get storagePermissionRequired;

  /// No description provided for @storagePermissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Please allow storage access in order to upload the file.'**
  String get storagePermissionDeniedMessage;

  /// No description provided for @storagePermissionPermanentlyDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'You need storage permission for uploading file. Please go to app settings and grant access to storage permission.'**
  String get storagePermissionPermanentlyDeniedMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment...'**
  String get loading;

  /// No description provided for @issuerWebsitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Get credentials'**
  String get issuerWebsitesTitle;

  /// No description provided for @getCredentialTitle.
  ///
  /// In en, this message translates to:
  /// **'Get credentials'**
  String get getCredentialTitle;

  /// No description provided for @participantCredential.
  ///
  /// In en, this message translates to:
  /// **'GaiaX Pass'**
  String get participantCredential;

  /// No description provided for @phonePassCredential.
  ///
  /// In en, this message translates to:
  /// **'Proof of Phone'**
  String get phonePassCredential;

  /// No description provided for @emailPassCredential.
  ///
  /// In en, this message translates to:
  /// **'Proof of Email'**
  String get emailPassCredential;

  /// No description provided for @needEmailPass.
  ///
  /// In en, this message translates to:
  /// **'You need to get a Proof of Email first.'**
  String get needEmailPass;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @proof.
  ///
  /// In en, this message translates to:
  /// **'Proof'**
  String get proof;

  /// No description provided for @verifyMe.
  ///
  /// In en, this message translates to:
  /// **'Verify Me'**
  String get verifyMe;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @credentialAlias.
  ///
  /// In en, this message translates to:
  /// **'Credential Alias'**
  String get credentialAlias;

  /// No description provided for @verificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verificationStatus;

  /// No description provided for @cardsPending.
  ///
  /// In en, this message translates to:
  /// **'Card pending'**
  String get cardsPending;

  /// No description provided for @unableToProcessTheData.
  ///
  /// In en, this message translates to:
  /// **'Unable to process the data'**
  String get unableToProcessTheData;

  /// No description provided for @unimplementedQueryType.
  ///
  /// In en, this message translates to:
  /// **'Unimplemented Query Type'**
  String get unimplementedQueryType;

  /// No description provided for @onSubmittedPassBasePopUp.
  ///
  /// In en, this message translates to:
  /// **'You will receive an email'**
  String get onSubmittedPassBasePopUp;

  /// No description provided for @myCollection.
  ///
  /// In en, this message translates to:
  /// **'My collection'**
  String get myCollection;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @succesfullyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Successfully Updated.'**
  String get succesfullyUpdated;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @myAssets.
  ///
  /// In en, this message translates to:
  /// **'My assets'**
  String get myAssets;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Own your digital identity'**
  String get splashSubtitle;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered By'**
  String get poweredBy;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splashLoading;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @nfts.
  ///
  /// In en, this message translates to:
  /// **'NFTs'**
  String get nfts;

  /// No description provided for @coins.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get coins;

  /// No description provided for @getCards.
  ///
  /// In en, this message translates to:
  /// **'Get Credentials'**
  String get getCards;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @infos.
  ///
  /// In en, this message translates to:
  /// **'Infos'**
  String get infos;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @enterNewPinCode.
  ///
  /// In en, this message translates to:
  /// **'Create a PIN Code\nto protect your wallet'**
  String get enterNewPinCode;

  /// No description provided for @confirmYourPinCode.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN code'**
  String get confirmYourPinCode;

  /// No description provided for @walletAltme.
  ///
  /// In en, this message translates to:
  /// **'Wallet Talao'**
  String get walletAltme;

  /// No description provided for @createTitle.
  ///
  /// In en, this message translates to:
  /// **'Create or import a wallet'**
  String get createTitle;

  /// No description provided for @createSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Would you like to create a new wallet or import an existing one?'**
  String get createSubtitle;

  /// No description provided for @enterYourPinCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN Code'**
  String get enterYourPinCode;

  /// No description provided for @changePinCode.
  ///
  /// In en, this message translates to:
  /// **'Change PIN Code'**
  String get changePinCode;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @credentialSelectionListEmptyError.
  ///
  /// In en, this message translates to:
  /// **'You do not have the requested credential to pursue.'**
  String get credentialSelectionListEmptyError;

  /// No description provided for @trustedIssuer.
  ///
  /// In en, this message translates to:
  /// **'This issuer is approved by EBSI.'**
  String get trustedIssuer;

  /// No description provided for @yourPinCodeChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your PIN Code changed successfully'**
  String get yourPinCodeChangedSuccessfully;

  /// No description provided for @advantagesCards.
  ///
  /// In en, this message translates to:
  /// **'Advantages cards'**
  String get advantagesCards;

  /// No description provided for @advantagesDiscoverCards.
  ///
  /// In en, this message translates to:
  /// **'Unlock exclusive rewards'**
  String get advantagesDiscoverCards;

  /// No description provided for @identityCards.
  ///
  /// In en, this message translates to:
  /// **'Identity cards'**
  String get identityCards;

  /// No description provided for @identityDiscoverCards.
  ///
  /// In en, this message translates to:
  /// **'Simplify ID verification'**
  String get identityDiscoverCards;

  /// No description provided for @contactInfoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get contactInfoCredentials;

  /// No description provided for @contactInfoDiscoverCredentials.
  ///
  /// In en, this message translates to:
  /// **'Verify your contact information'**
  String get contactInfoDiscoverCredentials;

  /// No description provided for @myProfessionalCards.
  ///
  /// In en, this message translates to:
  /// **'Professional cards'**
  String get myProfessionalCards;

  /// No description provided for @otherCards.
  ///
  /// In en, this message translates to:
  /// **'Other cards'**
  String get otherCards;

  /// No description provided for @inMyWallet.
  ///
  /// In en, this message translates to:
  /// **'In my wallet'**
  String get inMyWallet;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @getIt.
  ///
  /// In en, this message translates to:
  /// **'Get it'**
  String get getIt;

  /// No description provided for @getItNow.
  ///
  /// In en, this message translates to:
  /// **'Get it Now'**
  String get getItNow;

  /// No description provided for @getThisCard.
  ///
  /// In en, this message translates to:
  /// **'Get This Card'**
  String get getThisCard;

  /// No description provided for @drawerBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication'**
  String get drawerBiometrics;

  /// No description provided for @drawerTalaoCommunityCard.
  ///
  /// In en, this message translates to:
  /// **'Talao Community Card'**
  String get drawerTalaoCommunityCard;

  /// No description provided for @drawerTalaoCommunityCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Import your Ethereum address and get your Community Card.'**
  String get drawerTalaoCommunityCardTitle;

  /// No description provided for @drawerTalaoCommunityCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'It will give you access to the best discounts, memberships and vouchers cards from our ecosystem of partners.'**
  String get drawerTalaoCommunityCardSubtitle;

  /// No description provided for @drawerTalaoCommunityCardTextBoxMessage.
  ///
  /// In en, this message translates to:
  /// **'Once you have entered your private key, tap Import.\nPlease, make sure to enter the ethereum private key which contains your Talao Token.'**
  String get drawerTalaoCommunityCardTextBoxMessage;

  /// No description provided for @drawerTalaoCommunityCardSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Our Wallet is self-custodial. We never have access to your private keys or funds.'**
  String get drawerTalaoCommunityCardSubtitle2;

  /// No description provided for @drawerTalaoCommunityCardKeyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid private key'**
  String get drawerTalaoCommunityCardKeyError;

  /// No description provided for @loginWithBiometricsMessage.
  ///
  /// In en, this message translates to:
  /// **'Quickly unlock your wallet without having to enter password or PIN Code'**
  String get loginWithBiometricsMessage;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @manageAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage blockchain accounts'**
  String get manageAccounts;

  /// No description provided for @blockchainAccounts.
  ///
  /// In en, this message translates to:
  /// **'Blockchain accounts'**
  String get blockchainAccounts;

  /// No description provided for @educationCredentials.
  ///
  /// In en, this message translates to:
  /// **'Education credentials'**
  String get educationCredentials;

  /// No description provided for @educationDiscoverCredentials.
  ///
  /// In en, this message translates to:
  /// **'Verify your education background'**
  String get educationDiscoverCredentials;

  /// No description provided for @educationCredentialsDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get your digital diploma'**
  String get educationCredentialsDiscoverSubtitle;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @networkAndRegistries.
  ///
  /// In en, this message translates to:
  /// **'Network & Registries'**
  String get networkAndRegistries;

  /// No description provided for @chooseNetwork.
  ///
  /// In en, this message translates to:
  /// **'Choose Network'**
  String get chooseNetwork;

  /// No description provided for @chooseRegistry.
  ///
  /// In en, this message translates to:
  /// **'Choose Registry'**
  String get chooseRegistry;

  /// No description provided for @trustFramework.
  ///
  /// In en, this message translates to:
  /// **'Trust Framework'**
  String get trustFramework;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @issuerRegistry.
  ///
  /// In en, this message translates to:
  /// **'Issuer Registry'**
  String get issuerRegistry;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use & Confidentiality'**
  String get termsOfUse;

  /// No description provided for @scanFingerprintToAuthenticate.
  ///
  /// In en, this message translates to:
  /// **'Scan Fingerprint to Authenticate'**
  String get scanFingerprintToAuthenticate;

  /// No description provided for @biometricsNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Biometrics not supported'**
  String get biometricsNotSupported;

  /// No description provided for @deviceDoNotSupportBiometricsAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Your device does not support biometric authentication'**
  String get deviceDoNotSupportBiometricsAuthentication;

  /// No description provided for @biometricsEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'You can now unlock app with your biometrics.'**
  String get biometricsEnabledMessage;

  /// No description provided for @biometricsDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication has been disabled.'**
  String get biometricsDisabledMessage;

  /// No description provided for @exportSecretKey.
  ///
  /// In en, this message translates to:
  /// **'Export secret key'**
  String get exportSecretKey;

  /// No description provided for @secretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret Key'**
  String get secretKey;

  /// No description provided for @chooseNetWork.
  ///
  /// In en, this message translates to:
  /// **'Choose Network'**
  String get chooseNetWork;

  /// No description provided for @nftEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your digital gallery is empty !'**
  String get nftEmptyMessage;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @cryptoAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get cryptoAccounts;

  /// No description provided for @cryptoAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get cryptoAccount;

  /// No description provided for @cryptoAddAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get cryptoAddAccount;

  /// No description provided for @cryptoAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your crypto account has been successfully added.'**
  String get cryptoAddedMessage;

  /// No description provided for @cryptoEditConfirmationDialog.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to edit this crypto account name?'**
  String get cryptoEditConfirmationDialog;

  /// No description provided for @cryptoEditConfirmationDialogYes.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get cryptoEditConfirmationDialogYes;

  /// No description provided for @cryptoEditConfirmationDialogNo.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cryptoEditConfirmationDialogNo;

  /// No description provided for @cryptoEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get cryptoEditLabel;

  /// No description provided for @onBoardingFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover exclusive Web 3 offers directly in your wallet.'**
  String get onBoardingFirstTitle;

  /// No description provided for @onBoardingFirstSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get Membership cards, Loyalty cards, Vouchers and lot more advantages from your favorite Apps and games.'**
  String get onBoardingFirstSubtitle;

  /// No description provided for @onBoardingSecondTitle.
  ///
  /// In en, this message translates to:
  /// **'Our wallet is much more than a simple Digital Wallet.'**
  String get onBoardingSecondTitle;

  /// No description provided for @onBoardingSecondSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Store & Manage your personal data and get access to any Web 3.0 Apps.'**
  String get onBoardingSecondSubtitle;

  /// No description provided for @onBoardingThirdTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your data with full autonomy, security and privacy.'**
  String get onBoardingThirdTitle;

  /// No description provided for @onBoardingThirdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our wallet use cryptography to give you full control over your data. Nothing goes out of your device.'**
  String get onBoardingThirdSubtitle;

  /// No description provided for @onBoardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onBoardingStart;

  /// No description provided for @learnMoreAboutAltme.
  ///
  /// In en, this message translates to:
  /// **'Learn more about your wallet'**
  String get learnMoreAboutAltme;

  /// No description provided for @scroll.
  ///
  /// In en, this message translates to:
  /// **'Scroll'**
  String get scroll;

  /// No description provided for @agreeTermsAndConditionCheckBox.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and conditions.'**
  String get agreeTermsAndConditionCheckBox;

  /// No description provided for @readTermsOfUseCheckBox.
  ///
  /// In en, this message translates to:
  /// **'I have read the terms of use.'**
  String get readTermsOfUseCheckBox;

  /// No description provided for @createOrImportNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create or import a new account.'**
  String get createOrImportNewAccount;

  /// No description provided for @selectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select account'**
  String get selectAccount;

  /// No description provided for @onbordingSeedPhrase.
  ///
  /// In en, this message translates to:
  /// **'Seed Phrase'**
  String get onbordingSeedPhrase;

  /// No description provided for @onboardingPleaseStoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Please, write down your recovery phrase'**
  String get onboardingPleaseStoreMessage;

  /// No description provided for @onboardingVerifyPhraseMessage.
  ///
  /// In en, this message translates to:
  /// **'Confirm the recovery phrase'**
  String get onboardingVerifyPhraseMessage;

  /// No description provided for @onboardingVerifyPhraseMessageDetails.
  ///
  /// In en, this message translates to:
  /// **'To ensure your recovery phrase is written correctly, select the words in correct order.'**
  String get onboardingVerifyPhraseMessageDetails;

  /// No description provided for @onboardingAltmeMessage.
  ///
  /// In en, this message translates to:
  /// **'The wallet is non-custodial. Your recovery phrase is the only way to recover your account.'**
  String get onboardingAltmeMessage;

  /// No description provided for @onboardingWroteDownMessage.
  ///
  /// In en, this message translates to:
  /// **'I wrote down my recovery phrase'**
  String get onboardingWroteDownMessage;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @pinCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'PIN code prevent unauthorized access to your wallet. You can change it at any time.'**
  String get pinCodeMessage;

  /// No description provided for @enterNameForYourNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for your new account'**
  String get enterNameForYourNewAccount;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @importWalletText.
  ///
  /// In en, this message translates to:
  /// **'Enter your recovery phrase or private key here.'**
  String get importWalletText;

  /// No description provided for @importWalletTextRecoveryPhraseOnly.
  ///
  /// In en, this message translates to:
  /// **'Enter your recovery phrase here.'**
  String get importWalletTextRecoveryPhraseOnly;

  /// No description provided for @recoveryPhraseDescriptions.
  ///
  /// In en, this message translates to:
  /// **'A recovery phrase is a list of 12 words generated by your crypto wallet that gives you access to your funds'**
  String get recoveryPhraseDescriptions;

  /// No description provided for @importEasilyFrom.
  ///
  /// In en, this message translates to:
  /// **'Import your account from :'**
  String get importEasilyFrom;

  /// No description provided for @templeWallet.
  ///
  /// In en, this message translates to:
  /// **'Temple wallet'**
  String get templeWallet;

  /// No description provided for @temple.
  ///
  /// In en, this message translates to:
  /// **'Temple'**
  String get temple;

  /// No description provided for @metaMaskWallet.
  ///
  /// In en, this message translates to:
  /// **'Metamask wallet'**
  String get metaMaskWallet;

  /// No description provided for @metaMask.
  ///
  /// In en, this message translates to:
  /// **'Metamask'**
  String get metaMask;

  /// No description provided for @kukai.
  ///
  /// In en, this message translates to:
  /// **'Kukai'**
  String get kukai;

  /// No description provided for @kukaiWallet.
  ///
  /// In en, this message translates to:
  /// **'Kukai wallet'**
  String get kukaiWallet;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @otherWalletApp.
  ///
  /// In en, this message translates to:
  /// **'Other wallet App'**
  String get otherWalletApp;

  /// hint text when importing additional account
  ///
  /// In en, this message translates to:
  /// **'Once you have entered your 12 words or all the characters of the private key, tap Import.'**
  String importWalletHintText(Object numberCharacters);

  /// No description provided for @importWalletHintTextRecoveryPhraseOnly.
  ///
  /// In en, this message translates to:
  /// **'Once you have entered your 12 words of the recovery phrase, tap Import.'**
  String get importWalletHintTextRecoveryPhraseOnly;

  /// No description provided for @kycDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'To get this card, and other identity cards, you need to verify your ID'**
  String get kycDialogTitle;

  /// No description provided for @idVerificationProcess.
  ///
  /// In en, this message translates to:
  /// **'ID Verification Process'**
  String get idVerificationProcess;

  /// No description provided for @idCheck.
  ///
  /// In en, this message translates to:
  /// **'ID Check'**
  String get idCheck;

  /// No description provided for @facialRecognition.
  ///
  /// In en, this message translates to:
  /// **'Facial recognition'**
  String get facialRecognition;

  /// No description provided for @kycDialogButton.
  ///
  /// In en, this message translates to:
  /// **'Start ID verification'**
  String get kycDialogButton;

  /// No description provided for @kycDialogFooter.
  ///
  /// In en, this message translates to:
  /// **'GDPR and CCPA Compliant + SOC2 Security Level'**
  String get kycDialogFooter;

  /// No description provided for @finishedVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'ID verification in\nprogress'**
  String get finishedVerificationTitle;

  /// No description provided for @finishedVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'You will receive an email to confirm that your ID has been verified'**
  String get finishedVerificationDescription;

  /// No description provided for @verificationPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your ID verification\nis pending'**
  String get verificationPendingTitle;

  /// No description provided for @verificationPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Usually it takes less than 5 min to get verified. You will receive an email when the verification is complete.'**
  String get verificationPendingDescription;

  /// No description provided for @verificationDeclinedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your verification declined'**
  String get verificationDeclinedTitle;

  /// No description provided for @restartVerification.
  ///
  /// In en, this message translates to:
  /// **'Restart ID Verification'**
  String get restartVerification;

  /// No description provided for @verificationDeclinedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your verification declined. Please restart your ID verification.'**
  String get verificationDeclinedDescription;

  /// No description provided for @verifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Well done! Your verification was successful.'**
  String get verifiedTitle;

  /// No description provided for @verifiedDescription.
  ///
  /// In en, this message translates to:
  /// **'You can now start adding your \'over18\' card. Let\'s begin.'**
  String get verifiedDescription;

  /// No description provided for @verfiedButton.
  ///
  /// In en, this message translates to:
  /// **'Adding the over 18 Card'**
  String get verfiedButton;

  /// No description provided for @verifiedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification complete!'**
  String get verifiedNotificationTitle;

  /// No description provided for @verifiedNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have been successfully verified.'**
  String get verifiedNotificationDescription;

  /// No description provided for @showDecentralizedID.
  ///
  /// In en, this message translates to:
  /// **'Show Decentralized ID'**
  String get showDecentralizedID;

  /// No description provided for @manageDecentralizedID.
  ///
  /// In en, this message translates to:
  /// **'Manage Decentralized ID'**
  String get manageDecentralizedID;

  /// No description provided for @addressBook.
  ///
  /// In en, this message translates to:
  /// **'Address Book'**
  String get addressBook;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get home;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @privateKeyDescriptions.
  ///
  /// In en, this message translates to:
  /// **'A private key is a secret number that is used to sign transactions and prove ownership of a blockchain address. On Tezos, private key are usually 54 characters long.'**
  String get privateKeyDescriptions;

  /// No description provided for @importAccount.
  ///
  /// In en, this message translates to:
  /// **'Import account'**
  String get importAccount;

  /// No description provided for @imported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get imported;

  /// No description provided for @cardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card details'**
  String get cardDetails;

  /// No description provided for @publicAddress.
  ///
  /// In en, this message translates to:
  /// **'Public address'**
  String get publicAddress;

  /// No description provided for @didKey.
  ///
  /// In en, this message translates to:
  /// **'DID key'**
  String get didKey;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @didPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'DID private key'**
  String get didPrivateKey;

  /// No description provided for @reveal.
  ///
  /// In en, this message translates to:
  /// **'Reveal'**
  String get reveal;

  /// No description provided for @didPrivateKeyDescription.
  ///
  /// In en, this message translates to:
  /// **'Please be very careful with your private keys, because they control access to your credentials information.'**
  String get didPrivateKeyDescription;

  /// No description provided for @didPrivateKeyDescriptionAlert.
  ///
  /// In en, this message translates to:
  /// **'Please do not share your private key with anyone. This wallet is non custodial, we will never ask for it.'**
  String get didPrivateKeyDescriptionAlert;

  /// No description provided for @iReadTheMessageCorrectly.
  ///
  /// In en, this message translates to:
  /// **'I read the message correctly'**
  String get iReadTheMessageCorrectly;

  /// No description provided for @beCareful.
  ///
  /// In en, this message translates to:
  /// **'Be careful'**
  String get beCareful;

  /// No description provided for @decentralizedIDKey.
  ///
  /// In en, this message translates to:
  /// **'Decentralized ID key'**
  String get decentralizedIDKey;

  /// No description provided for @copySecretKeyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied secret key to clipboard!'**
  String get copySecretKeyToClipboard;

  /// No description provided for @copyDIDKeyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied DID key to clipboard!'**
  String get copyDIDKeyToClipboard;

  /// No description provided for @seeAddress.
  ///
  /// In en, this message translates to:
  /// **'See address'**
  String get seeAddress;

  /// No description provided for @revealPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Reveal private key'**
  String get revealPrivateKey;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareWith.
  ///
  /// In en, this message translates to:
  /// **'Share with'**
  String get shareWith;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard!'**
  String get copiedToClipboard;

  /// No description provided for @privateKey.
  ///
  /// In en, this message translates to:
  /// **'Private key'**
  String get privateKey;

  /// No description provided for @decentralizedID.
  ///
  /// In en, this message translates to:
  /// **'Decentralized IDentifier'**
  String get decentralizedID;

  /// No description provided for @did.
  ///
  /// In en, this message translates to:
  /// **'DID'**
  String get did;

  /// No description provided for @sameAccountNameError.
  ///
  /// In en, this message translates to:
  /// **'This account name was used before; enter the different account name, please'**
  String get sameAccountNameError;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @credentialManifestDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get credentialManifestDescription;

  /// No description provided for @credentialManifestInformations.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get credentialManifestInformations;

  /// No description provided for @credentialDetailsActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get credentialDetailsActivity;

  /// No description provided for @credentialDetailsOrganisation.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get credentialDetailsOrganisation;

  /// No description provided for @credentialDetailsPresented.
  ///
  /// In en, this message translates to:
  /// **'Presented'**
  String get credentialDetailsPresented;

  /// No description provided for @credentialDetailsOrganisationDetail.
  ///
  /// In en, this message translates to:
  /// **'Organization Detail:'**
  String get credentialDetailsOrganisationDetail;

  /// No description provided for @credentialDetailsInWalletSince.
  ///
  /// In en, this message translates to:
  /// **'In wallet since'**
  String get credentialDetailsInWalletSince;

  /// No description provided for @termsOfUseAndLicenses.
  ///
  /// In en, this message translates to:
  /// **'Terms of use and Licenses'**
  String get termsOfUseAndLicenses;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @sendTo.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendTo;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @withdrawalInputHint.
  ///
  /// In en, this message translates to:
  /// **'Copy address or scan'**
  String get withdrawalInputHint;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountSent.
  ///
  /// In en, this message translates to:
  /// **'Amount sent'**
  String get amountSent;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @networkFee.
  ///
  /// In en, this message translates to:
  /// **'Estimated gas fee'**
  String get networkFee;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @selectToken.
  ///
  /// In en, this message translates to:
  /// **'Select token'**
  String get selectToken;

  /// No description provided for @insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get insufficientBalance;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @changeFee.
  ///
  /// In en, this message translates to:
  /// **'Change Fee'**
  String get changeFee;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Click to access'**
  String get link;

  /// No description provided for @myTokens.
  ///
  /// In en, this message translates to:
  /// **'My tokens'**
  String get myTokens;

  /// No description provided for @tezosMainNetwork.
  ///
  /// In en, this message translates to:
  /// **'Tezos Main Network'**
  String get tezosMainNetwork;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get recentTransactions;

  /// symbol name when showing address in receive page
  ///
  /// In en, this message translates to:
  /// **'Only send {symbol} to this address. Sending other tokens may result in permanent loss.'**
  String sendOnlyToThisAddressDescription(Object symbol);

  /// No description provided for @addTokens.
  ///
  /// In en, this message translates to:
  /// **'Add tokens'**
  String get addTokens;

  /// No description provided for @providedBy.
  ///
  /// In en, this message translates to:
  /// **'Provided by'**
  String get providedBy;

  /// No description provided for @issuedOn.
  ///
  /// In en, this message translates to:
  /// **'Issued on'**
  String get issuedOn;

  /// No description provided for @expirationDate.
  ///
  /// In en, this message translates to:
  /// **'Validity period'**
  String get expirationDate;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @selectAccountToGrantAccess.
  ///
  /// In en, this message translates to:
  /// **'Select account to grant access:'**
  String get selectAccountToGrantAccess;

  /// No description provided for @requestPersmissionTo.
  ///
  /// In en, this message translates to:
  /// **'Request Permission to:'**
  String get requestPersmissionTo;

  /// No description provided for @viewAccountBalanceAndNFTs.
  ///
  /// In en, this message translates to:
  /// **'View account balance and NFT\'s'**
  String get viewAccountBalanceAndNFTs;

  /// No description provided for @requestApprovalForTransaction.
  ///
  /// In en, this message translates to:
  /// **'Request approval for transaction'**
  String get requestApprovalForTransaction;

  /// No description provided for @connectedWithBeacon.
  ///
  /// In en, this message translates to:
  /// **'Successfully connect with dApp'**
  String get connectedWithBeacon;

  /// No description provided for @failedToConnectWithBeacon.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect with dApp'**
  String get failedToConnectWithBeacon;

  /// No description provided for @tezosNetwork.
  ///
  /// In en, this message translates to:
  /// **'Tezos Network'**
  String get tezosNetwork;

  /// No description provided for @confirm_sign.
  ///
  /// In en, this message translates to:
  /// **'Confirm Sign'**
  String get confirm_sign;

  /// No description provided for @sign.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get sign;

  /// No description provided for @payload_to_sign.
  ///
  /// In en, this message translates to:
  /// **'Payload to Sign'**
  String get payload_to_sign;

  /// No description provided for @signedPayload.
  ///
  /// In en, this message translates to:
  /// **'Successfully signed payload'**
  String get signedPayload;

  /// No description provided for @failedToSignPayload.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign the payload'**
  String get failedToSignPayload;

  /// No description provided for @voucher.
  ///
  /// In en, this message translates to:
  /// **'Voucher'**
  String get voucher;

  /// No description provided for @tezotopia.
  ///
  /// In en, this message translates to:
  /// **'Tezotopia'**
  String get tezotopia;

  /// No description provided for @operationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Your requested operation has been completed. The transaction may take a few minutes to be displayed in the wallet.'**
  String get operationCompleted;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Your requested operation has failed'**
  String get operationFailed;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membership;

  /// No description provided for @switchNetworkMessage.
  ///
  /// In en, this message translates to:
  /// **'Please switch your network to'**
  String get switchNetworkMessage;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @addCards.
  ///
  /// In en, this message translates to:
  /// **'Add cards'**
  String get addCards;

  /// No description provided for @gaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get gaming;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @socialMedia.
  ///
  /// In en, this message translates to:
  /// **'Social media'**
  String get socialMedia;

  /// No description provided for @advanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get advanceSettings;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @selectCredentialCategoryWhichYouWantToShowInCredentialList.
  ///
  /// In en, this message translates to:
  /// **'Select credential categories that you want to show in credentials list:'**
  String get selectCredentialCategoryWhichYouWantToShowInCredentialList;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @tezos.
  ///
  /// In en, this message translates to:
  /// **'Tezos'**
  String get tezos;

  /// No description provided for @rights.
  ///
  /// In en, this message translates to:
  /// **'Rights'**
  String get rights;

  /// No description provided for @disconnectAndRevokeRights.
  ///
  /// In en, this message translates to:
  /// **'Disconnect & Revoke Rights'**
  String get disconnectAndRevokeRights;

  /// No description provided for @revokeAllRights.
  ///
  /// In en, this message translates to:
  /// **'Revoke all rights'**
  String get revokeAllRights;

  /// No description provided for @revokeSubtitleMessage.
  ///
  /// In en, this message translates to:
  /// **'Are your sure you want to revoke all rights'**
  String get revokeSubtitleMessage;

  /// No description provided for @revokeAll.
  ///
  /// In en, this message translates to:
  /// **'Revoke All'**
  String get revokeAll;

  /// No description provided for @succesfullyDisconnected.
  ///
  /// In en, this message translates to:
  /// **'successfully disconnected from dApp.'**
  String get succesfullyDisconnected;

  /// No description provided for @connectedApps.
  ///
  /// In en, this message translates to:
  /// **'Connected dApps'**
  String get connectedApps;

  /// No description provided for @manageConnectedApps.
  ///
  /// In en, this message translates to:
  /// **'Manage connected dApps'**
  String get manageConnectedApps;

  /// No description provided for @noDappConnected.
  ///
  /// In en, this message translates to:
  /// **'No dApp connected yet'**
  String get noDappConnected;

  /// No description provided for @nftDetails.
  ///
  /// In en, this message translates to:
  /// **'NFT\'s details'**
  String get nftDetails;

  /// No description provided for @failedToDoOperation.
  ///
  /// In en, this message translates to:
  /// **'Failed to do operation'**
  String get failedToDoOperation;

  /// No description provided for @nft.
  ///
  /// In en, this message translates to:
  /// **'NFT'**
  String get nft;

  /// No description provided for @receiveNft.
  ///
  /// In en, this message translates to:
  /// **'Receive NFT'**
  String get receiveNft;

  /// No description provided for @sendOnlyNftToThisAddressDescription.
  ///
  /// In en, this message translates to:
  /// **'Only send Tezos NFT to this address. Sending NFT from other network may result in permanent loss.'**
  String get sendOnlyNftToThisAddressDescription;

  /// No description provided for @beaconShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Only send Tezos(XTZ) and Tezos NFTs(FA2 Standard) to this address. Sending Tezos and NFTs from other networks may result in permanent loss'**
  String get beaconShareMessage;

  /// No description provided for @advantagesCredentialHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Benefit from exclusive advantages in Web3'**
  String get advantagesCredentialHomeSubtitle;

  /// No description provided for @advantagesCredentialDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover loyalty cards and exclusive passes'**
  String get advantagesCredentialDiscoverSubtitle;

  /// No description provided for @identityCredentialHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prove things about yourself while protecting your data'**
  String get identityCredentialHomeSubtitle;

  /// No description provided for @identityCredentialDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get reusable KYC and age verification credentials'**
  String get identityCredentialDiscoverSubtitle;

  /// No description provided for @myProfessionalCredentialDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your professional cards securely'**
  String get myProfessionalCredentialDiscoverSubtitle;

  /// No description provided for @blockchainAccountsCredentialHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prove your blockchain accounts ownership'**
  String get blockchainAccountsCredentialHomeSubtitle;

  /// No description provided for @educationCredentialHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prove your education background instantly'**
  String get educationCredentialHomeSubtitle;

  /// No description provided for @passCredentialHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use exclusive Passes: Supercharge your Web3 experience'**
  String get passCredentialHomeSubtitle;

  /// No description provided for @financeCardsCredentialHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access new investment opportunities in web3'**
  String get financeCardsCredentialHomeSubtitle;

  /// No description provided for @financeCardsCredentialDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get exclusive advantages offered by Communities you like'**
  String get financeCardsCredentialDiscoverSubtitle;

  /// No description provided for @contactInfoCredentialHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your contact information instantly'**
  String get contactInfoCredentialHomeSubtitle;

  /// No description provided for @contactInfoCredentialDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Obtain easy-to-share credentials'**
  String get contactInfoCredentialDiscoverSubtitle;

  /// No description provided for @otherCredentialHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Other types of cards in your wallet'**
  String get otherCredentialHomeSubtitle;

  /// No description provided for @otherCredentialDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Other types of cards you can add'**
  String get otherCredentialDiscoverSubtitle;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'...Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less...'**
  String get showLess;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @transactionErrorBalanceTooLow.
  ///
  /// In en, this message translates to:
  /// **'An operation tried to spend more tokens than the contract has'**
  String get transactionErrorBalanceTooLow;

  /// No description provided for @transactionErrorCannotPayStorageFee.
  ///
  /// In en, this message translates to:
  /// **'The storage fee is higher than the contract balance'**
  String get transactionErrorCannotPayStorageFee;

  /// No description provided for @transactionErrorFeeTooLow.
  ///
  /// In en, this message translates to:
  /// **'Operation fees are too low'**
  String get transactionErrorFeeTooLow;

  /// No description provided for @transactionErrorFeeTooLowForMempool.
  ///
  /// In en, this message translates to:
  /// **'Operation fees are too low to be considered in full mempool'**
  String get transactionErrorFeeTooLowForMempool;

  /// No description provided for @transactionErrorTxRollupBalanceTooLow.
  ///
  /// In en, this message translates to:
  /// **'Tried to spend a ticket index from an index without the required balance'**
  String get transactionErrorTxRollupBalanceTooLow;

  /// No description provided for @transactionErrorTxRollupInvalidZeroTransfer.
  ///
  /// In en, this message translates to:
  /// **'A transfer\'s amount must be greater than zero.'**
  String get transactionErrorTxRollupInvalidZeroTransfer;

  /// No description provided for @transactionErrorTxRollupUnknownAddress.
  ///
  /// In en, this message translates to:
  /// **'The address must exist in the context when signing a transfer with it.'**
  String get transactionErrorTxRollupUnknownAddress;

  /// No description provided for @transactionErrorInactiveChain.
  ///
  /// In en, this message translates to:
  /// **'Attempted validation of a block from an inactive chain.'**
  String get transactionErrorInactiveChain;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @whyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'Why get this card'**
  String get whyGetThisCard;

  /// No description provided for @howToGetIt.
  ///
  /// In en, this message translates to:
  /// **'How to get it'**
  String get howToGetIt;

  /// No description provided for @emailPassWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.'**
  String get emailPassWhyGetThisCard;

  /// No description provided for @emailPassExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get emailPassExpirationDate;

  /// No description provided for @emailPassHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'It’s super easy. We will verify your email ownership by sending a code by email.'**
  String get emailPassHowToGetIt;

  /// No description provided for @tezotopiaMembershipWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This Membership card will give you 25% cash backs on ALL Tezotopia Game transactions when you buy a Drops on the marketplace or mint an NFT on starbase.'**
  String get tezotopiaMembershipWhyGetThisCard;

  /// No description provided for @tezotopiaMembershipExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get tezotopiaMembershipExpirationDate;

  /// No description provided for @tezotopiaMembershipLongDescription.
  ///
  /// In en, this message translates to:
  /// **'Tezotopia is a real-time metaverse NFT game on Tezos, where players yield farm with Tezotops, engage in battles for rewards, and claim land in an immersive blockchain space adventure. Explore the metaverse, collect NFTs and conquer Tezotopia.'**
  String get tezotopiaMembershipLongDescription;

  /// No description provided for @chainbornMembershipHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'To get this card, you need to summon a “Hero” in Chainborn game and an Email Proof. You can find the “Email proof” card in the “Discover” section.'**
  String get chainbornMembershipHowToGetIt;

  /// No description provided for @chainbornMembershipWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'Be among the few that have access to exclusive Chainborn store content, airdrops and other member-only benefits !'**
  String get chainbornMembershipWhyGetThisCard;

  /// No description provided for @chainbornMembershipExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get chainbornMembershipExpirationDate;

  /// No description provided for @chainbornMembershipLongDescription.
  ///
  /// In en, this message translates to:
  /// **'Chainborn is an exciting NFT battle game where players use their own NFTs as heroes, competing for loot and glory. Engage in thrilling fights, gain experience points to boost your hero\'s strength and health, and enhance the value of your NFTs in this captivating Tezos-based adventure.'**
  String get chainbornMembershipLongDescription;

  /// No description provided for @twitterHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'Follow the steps on TezosProfiles https://tzprofiles.com/connect. Then, claim the “Twitter account” card in Talao. Make sure to sign the transaction on TZPROFILES with the same account you are using in Talao.'**
  String get twitterHowToGetIt;

  /// No description provided for @twitterWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This card is a proof that you own your twitter account. Use it to prove your twitter account ownership whenever you need.'**
  String get twitterWhyGetThisCard;

  /// No description provided for @twitterExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will be active for 1 year.'**
  String get twitterExpirationDate;

  /// No description provided for @twitterDummyDesc.
  ///
  /// In en, this message translates to:
  /// **'Prove your twitter account ownership'**
  String get twitterDummyDesc;

  /// No description provided for @tezotopiaMembershipHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You need to present a proof that you are over 13 YO and a proof of your email.'**
  String get tezotopiaMembershipHowToGetIt;

  /// No description provided for @over18WhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.'**
  String get over18WhyGetThisCard;

  /// No description provided for @over18ExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get over18ExpirationDate;

  /// No description provided for @over18HowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can claim this card by performing an age estimate on the wallet.'**
  String get over18HowToGetIt;

  /// No description provided for @over13WhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.'**
  String get over13WhyGetThisCard;

  /// No description provided for @over13ExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get over13ExpirationDate;

  /// No description provided for @over13HowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can claim this card by performing an age estimate on the wallet.'**
  String get over13HowToGetIt;

  /// No description provided for @over15WhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.'**
  String get over15WhyGetThisCard;

  /// No description provided for @over15ExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get over15ExpirationDate;

  /// No description provided for @over15HowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can claim this card by performing an age estimate on the wallet.'**
  String get over15HowToGetIt;

  /// No description provided for @passportFootprintWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.'**
  String get passportFootprintWhyGetThisCard;

  /// No description provided for @passportFootprintExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get passportFootprintExpirationDate;

  /// No description provided for @passportFootprintHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can claim this card by following the KYC check of teh wallet.'**
  String get passportFootprintHowToGetIt;

  /// No description provided for @verifiableIdCardWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This digital identity card contains the same information as your physical ID card. You can use it on a web site for an identity check for example.'**
  String get verifiableIdCardWhyGetThisCard;

  /// No description provided for @verifiableIdCardExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get verifiableIdCardExpirationDate;

  /// No description provided for @verifiableIdCardHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can claim this card by following the KYC check of the wallet.'**
  String get verifiableIdCardHowToGetIt;

  /// No description provided for @verifiableIdCardDummyDesc.
  ///
  /// In en, this message translates to:
  /// **'Get your Digital Identity Card.'**
  String get verifiableIdCardDummyDesc;

  /// No description provided for @phoneProofWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This proof may be required by some applications and web sites to access their service or claim benefits : Membership card, Loyalty card, Rewards, etc.'**
  String get phoneProofWhyGetThisCard;

  /// No description provided for @phoneProofExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get phoneProofExpirationDate;

  /// No description provided for @phoneProofHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'It’s super easy. We will verify your phone number ownership by sending a code by sms.'**
  String get phoneProofHowToGetIt;

  /// No description provided for @tezVoucherWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This Voucher card will give you 10% cash backs on ALL Tezotopia Game transactions when you buy a Drops on the marketplace or mint an NFT on starbase.'**
  String get tezVoucherWhyGetThisCard;

  /// No description provided for @tezVoucherExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 30 days.'**
  String get tezVoucherExpirationDate;

  /// No description provided for @tezVoucherHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **' It’s super easy. You can claim it for free right now.'**
  String get tezVoucherHowToGetIt;

  /// No description provided for @genderWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This Gender Proof is useful to prove your gender (Male / Female) without revealing any other information about you. It can be used in a user survey, etc.'**
  String get genderWhyGetThisCard;

  /// No description provided for @genderExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get genderExpirationDate;

  /// No description provided for @genderHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can claim this card by following the KYC check of the wallet.'**
  String get genderHowToGetIt;

  /// No description provided for @nationalityWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This credential is useful to prove your Nationality without revealing any other information about you. It can be required by Web 3 Apps in a user survey, etc.'**
  String get nationalityWhyGetThisCard;

  /// No description provided for @nationalityExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get nationalityExpirationDate;

  /// No description provided for @nationalityHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can claim this card by following the KYC check of the wallet.'**
  String get nationalityHowToGetIt;

  /// No description provided for @ageRangeWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'This credential is useful to prove your Age Range without revealing any other information about you. It can be required by Web 3 Apps in a user survey or to claim benefits : Membership card, etc.'**
  String get ageRangeWhyGetThisCard;

  /// No description provided for @ageRangeExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This card will remain active and reusable for 1 YEAR.'**
  String get ageRangeExpirationDate;

  /// No description provided for @ageRangeHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'You can claim this card by performing an age estimate on the wallet.'**
  String get ageRangeHowToGetIt;

  /// No description provided for @defiComplianceWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'Obtain verifiable proof of KYC/AML compliance, requested by compliant DeFi protocols and Web3 dApps. Once obtained, you can mint a privacy-preserving, non-transferable NFT for on-chain verification without revealing personal data.'**
  String get defiComplianceWhyGetThisCard;

  /// No description provided for @defiComplianceExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This credential remains active for 3 months. Renewal requires a straightforward compliance check, without new KYC.'**
  String get defiComplianceExpirationDate;

  /// No description provided for @defiComplianceHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'It\'s easy! Complete a one-time KYC check in the wallet (powered by ID360) and request your DeFi compliance credential.'**
  String get defiComplianceHowToGetIt;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @nftTooBigToLoad.
  ///
  /// In en, this message translates to:
  /// **'NFT loading'**
  String get nftTooBigToLoad;

  /// No description provided for @seeTransaction.
  ///
  /// In en, this message translates to:
  /// **'See transaction'**
  String get seeTransaction;

  /// No description provided for @nftListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here are all NFTs and collectibles in your account.'**
  String get nftListSubtitle;

  /// No description provided for @tokenListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here are all tokens in your account.'**
  String get tokenListSubtitle;

  /// No description provided for @my.
  ///
  /// In en, this message translates to:
  /// **'My'**
  String get my;

  /// No description provided for @get.
  ///
  /// In en, this message translates to:
  /// **'Get'**
  String get get;

  /// No description provided for @seeMoreNFTInformationOn.
  ///
  /// In en, this message translates to:
  /// **'See more NFT information on'**
  String get seeMoreNFTInformationOn;

  /// No description provided for @credentialStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get credentialStatus;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get pass;

  /// No description provided for @payloadFormatErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The format of payload is incorrect.'**
  String get payloadFormatErrorMessage;

  /// No description provided for @thisFeatureIsNotSupportedMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature is not supported yet'**
  String get thisFeatureIsNotSupportedMessage;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My wallet'**
  String get myWallet;

  /// No description provided for @ethereumNetwork.
  ///
  /// In en, this message translates to:
  /// **'Ethereum Network'**
  String get ethereumNetwork;

  /// No description provided for @fantomNetwork.
  ///
  /// In en, this message translates to:
  /// **'Fantom Network'**
  String get fantomNetwork;

  /// No description provided for @polygonNetwork.
  ///
  /// In en, this message translates to:
  /// **'Polygon Network'**
  String get polygonNetwork;

  /// No description provided for @binanceNetwork.
  ///
  /// In en, this message translates to:
  /// **'BNB Chain Network'**
  String get binanceNetwork;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @activateBiometricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate Biometrics\nto add a security layer'**
  String get activateBiometricsTitle;

  /// No description provided for @loginWithBiometricsOnBoarding.
  ///
  /// In en, this message translates to:
  /// **'Log in with biometrics'**
  String get loginWithBiometricsOnBoarding;

  /// No description provided for @option.
  ///
  /// In en, this message translates to:
  /// **'Option'**
  String get option;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToThe;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @walletReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your wallet is ready !'**
  String get walletReadyTitle;

  /// No description provided for @walletReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore the world of true identity ownership.'**
  String get walletReadySubtitle;

  /// No description provided for @failedToInitCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera initialization failed!'**
  String get failedToInitCamera;

  /// No description provided for @chooseMethodPageOver18Title.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Over 18 Proof'**
  String get chooseMethodPageOver18Title;

  /// No description provided for @chooseMethodPageOver13Title.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Over 13 Proof'**
  String get chooseMethodPageOver13Title;

  /// No description provided for @chooseMethodPageOver15Title.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Over 15 Proof'**
  String get chooseMethodPageOver15Title;

  /// No description provided for @chooseMethodPageOver21Title.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Over 21 Proof'**
  String get chooseMethodPageOver21Title;

  /// No description provided for @chooseMethodPageOver50Title.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Over 50 Proof'**
  String get chooseMethodPageOver50Title;

  /// No description provided for @chooseMethodPageOver65Title.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Over 65 Proof'**
  String get chooseMethodPageOver65Title;

  /// No description provided for @chooseMethodPageAgeRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Age Range Proof'**
  String get chooseMethodPageAgeRangeTitle;

  /// No description provided for @chooseMethodPageVerifiableIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Verifiable Id Proof'**
  String get chooseMethodPageVerifiableIdTitle;

  /// No description provided for @chooseMethodPageDefiComplianceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to get your Defi Compliance Proof'**
  String get chooseMethodPageDefiComplianceTitle;

  /// No description provided for @chooseMethodPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get verified by taking a real-time photo of yourself or by a classic ID document check .'**
  String get chooseMethodPageSubtitle;

  /// No description provided for @kycTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick photo of you (1min)'**
  String get kycTitle;

  /// No description provided for @kycSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get instantly verified by taking a photo of yourself.'**
  String get kycSubtitle;

  /// No description provided for @passbaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Full ID document check'**
  String get passbaseTitle;

  /// No description provided for @passbaseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get verified with an ID card, passport or driving license.'**
  String get passbaseSubtitle;

  /// No description provided for @verifyYourAge.
  ///
  /// In en, this message translates to:
  /// **'Verify your age'**
  String get verifyYourAge;

  /// No description provided for @verifyYourAgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This age verification process is very easy and simple. All it requires is a real-time photo.'**
  String get verifyYourAgeSubtitle;

  /// No description provided for @verifyYourAgeDescription.
  ///
  /// In en, this message translates to:
  /// **'By accepting, you agree that we use a picture to estimate your age. The estimation is done by our partner Yoti that uses your picture only for this purpose and immediately deletes it.\n\nFor more info, review our Privacy Policy.'**
  String get verifyYourAgeDescription;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @yotiCameraAppbarTitle.
  ///
  /// In en, this message translates to:
  /// **'Please, position your face in the center'**
  String get yotiCameraAppbarTitle;

  /// No description provided for @cameraSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have 5 seconds to take your photo.\nMake sure there’s enough light before starting.'**
  String get cameraSubtitle;

  /// No description provided for @walletSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Protect your wallet with Pin code and biometric authentication'**
  String get walletSecurityDescription;

  /// No description provided for @blockchainSettings.
  ///
  /// In en, this message translates to:
  /// **'Blockchain Settings'**
  String get blockchainSettings;

  /// No description provided for @blockchainSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage accounts, recovery phrase, connected DApps and networks'**
  String get blockchainSettingsDescription;

  /// No description provided for @ssi.
  ///
  /// In en, this message translates to:
  /// **'Self Sovereign Identity Settings'**
  String get ssi;

  /// No description provided for @ssiDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage decentralized identifiers (DIDs) and protocol options'**
  String get ssiDescription;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @helpCenterDescription.
  ///
  /// In en, this message translates to:
  /// **'Contact us and get support if you need assistance on using your wallet'**
  String get helpCenterDescription;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Read about terms of use, confidentiality and licenses'**
  String get aboutDescription;

  /// No description provided for @resetWallet.
  ///
  /// In en, this message translates to:
  /// **'Reset Wallet'**
  String get resetWallet;

  /// No description provided for @resetWalletDescription.
  ///
  /// In en, this message translates to:
  /// **'Erase all data stored on this device and reset your wallet.'**
  String get resetWalletDescription;

  /// No description provided for @showWalletRecoveryPhrase.
  ///
  /// In en, this message translates to:
  /// **'Show wallet recovery phrase'**
  String get showWalletRecoveryPhrase;

  /// No description provided for @showWalletRecoveryPhraseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The recovery phrase acts as a backup key to restore access to a your wallet.'**
  String get showWalletRecoveryPhraseSubtitle;

  /// No description provided for @blockchainNetwork.
  ///
  /// In en, this message translates to:
  /// **'Blockchain network (by default)'**
  String get blockchainNetwork;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get officialWebsite;

  /// No description provided for @yourAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Your app version'**
  String get yourAppVersion;

  /// No description provided for @resetWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your wallet ?'**
  String get resetWalletTitle;

  /// No description provided for @resetWalletSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This action will erase your data. Please, make sure you have saved your recovery phrase and credentials backup file before deleting.'**
  String get resetWalletSubtitle;

  /// No description provided for @resetWalletSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'This wallet is self-custodial so we are not able to recover your funds or credentials for you.'**
  String get resetWalletSubtitle2;

  /// No description provided for @resetWalletCheckBox1.
  ///
  /// In en, this message translates to:
  /// **'I wrote down my recovery phrase'**
  String get resetWalletCheckBox1;

  /// No description provided for @resetWalletCheckBox2.
  ///
  /// In en, this message translates to:
  /// **'I saved my backup credentials file'**
  String get resetWalletCheckBox2;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @fillingThisFieldIsMandatory.
  ///
  /// In en, this message translates to:
  /// **'Filling this field is mandatory.'**
  String get fillingThisFieldIsMandatory;

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourMessage;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @enterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get enterAValidEmail;

  /// No description provided for @failedToSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Failed to send email.'**
  String get failedToSendEmail;

  /// No description provided for @selectAMethodToAddAccount.
  ///
  /// In en, this message translates to:
  /// **'Select a method to add account'**
  String get selectAMethodToAddAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create an account protected by your recovery phrase'**
  String get createAccountDescription;

  /// No description provided for @importAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Import an account from an existing wallet'**
  String get importAccountDescription;

  /// No description provided for @chooseABlockchainForAccountCreation.
  ///
  /// In en, this message translates to:
  /// **'Choose the blockchain on which you want to create a new account.'**
  String get chooseABlockchainForAccountCreation;

  /// No description provided for @tezosAccount.
  ///
  /// In en, this message translates to:
  /// **'Tezos account'**
  String get tezosAccount;

  /// No description provided for @tezosAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new Tezos blockchain address'**
  String get tezosAccountDescription;

  /// No description provided for @ethereumAccount.
  ///
  /// In en, this message translates to:
  /// **'Ethereum account'**
  String get ethereumAccount;

  /// No description provided for @ethereumAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new Ethereum blockchain address'**
  String get ethereumAccountDescription;

  /// No description provided for @fantomAccount.
  ///
  /// In en, this message translates to:
  /// **'Fantom account'**
  String get fantomAccount;

  /// No description provided for @fantomAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new Fantom blockchain address'**
  String get fantomAccountDescription;

  /// No description provided for @polygonAccount.
  ///
  /// In en, this message translates to:
  /// **'Polygon account'**
  String get polygonAccount;

  /// No description provided for @polygonAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new Polygon blockchain address'**
  String get polygonAccountDescription;

  /// No description provided for @binanceAccount.
  ///
  /// In en, this message translates to:
  /// **'BNB Chain account'**
  String get binanceAccount;

  /// No description provided for @binanceAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new BNB Chain blockchain address'**
  String get binanceAccountDescription;

  /// No description provided for @setAccountNameDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you want to give a name to this new account ? Useful if you have several.'**
  String get setAccountNameDescription;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go !'**
  String get letsGo;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations !'**
  String get congratulations;

  /// No description provided for @tezosAccountCreationCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Your new Tezos account has been successfully created.'**
  String get tezosAccountCreationCongratulations;

  /// No description provided for @ethereumAccountCreationCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Your new Ethereum account has been successfully created.'**
  String get ethereumAccountCreationCongratulations;

  /// No description provided for @fantomAccountCreationCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Your new Fantom account has been successfully created.'**
  String get fantomAccountCreationCongratulations;

  /// No description provided for @polygonAccountCreationCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Your new Polygon account has been successfully created.'**
  String get polygonAccountCreationCongratulations;

  /// No description provided for @binanceAccountCreationCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Your new BNB Chain account has been successfully created.'**
  String get binanceAccountCreationCongratulations;

  /// No description provided for @accountImportCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully imported.'**
  String get accountImportCongratulations;

  /// No description provided for @saveBackupCredentialTitle.
  ///
  /// In en, this message translates to:
  /// **'Download the backup file.\nKeep it in a safe place.'**
  String get saveBackupCredentialTitle;

  /// No description provided for @saveBackupCredentialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To recover all your credentials you will need the recovery phrase and this backup file.'**
  String get saveBackupCredentialSubtitle;

  /// No description provided for @saveBackupPolygonCredentialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To recover all your polygon id credentials you will need the recovery phrase and this backup file.'**
  String get saveBackupPolygonCredentialSubtitle;

  /// No description provided for @restoreCredentialStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1 : Enter your 12 recovery phrase words'**
  String get restoreCredentialStep1Title;

  /// No description provided for @restorePhraseTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your recovery phrase (or mnemonic phrase) here...'**
  String get restorePhraseTextFieldHint;

  /// No description provided for @restoreCredentialStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2 : Upload your credentials backup file'**
  String get restoreCredentialStep2Title;

  /// No description provided for @loadFile.
  ///
  /// In en, this message translates to:
  /// **'Load file'**
  String get loadFile;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload file'**
  String get uploadFile;

  /// No description provided for @creators.
  ///
  /// In en, this message translates to:
  /// **'Creators'**
  String get creators;

  /// No description provided for @publishers.
  ///
  /// In en, this message translates to:
  /// **'Publishers'**
  String get publishers;

  /// No description provided for @creationDate.
  ///
  /// In en, this message translates to:
  /// **'Creation date'**
  String get creationDate;

  /// No description provided for @myProfessionalrCards.
  ///
  /// In en, this message translates to:
  /// **'professional cards'**
  String get myProfessionalrCards;

  /// No description provided for @myProfessionalrCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your professional cards securely.'**
  String get myProfessionalrCardsSubtitle;

  /// No description provided for @guardaWallet.
  ///
  /// In en, this message translates to:
  /// **'Guarda Wallet'**
  String get guardaWallet;

  /// No description provided for @exodusWallet.
  ///
  /// In en, this message translates to:
  /// **'Exodus Wallet'**
  String get exodusWallet;

  /// No description provided for @trustWallet.
  ///
  /// In en, this message translates to:
  /// **'Trust Wallet'**
  String get trustWallet;

  /// No description provided for @myetherwallet.
  ///
  /// In en, this message translates to:
  /// **'MyEther Wallet'**
  String get myetherwallet;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @userNotFitErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'You are unable to get this card because some conditions are not fulfilled.'**
  String get userNotFitErrorMessage;

  /// No description provided for @youAreMissing.
  ///
  /// In en, this message translates to:
  /// **'You are missing'**
  String get youAreMissing;

  /// No description provided for @credentialsRequestedBy.
  ///
  /// In en, this message translates to:
  /// **'credentials'**
  String get credentialsRequestedBy;

  /// No description provided for @transactionIsLikelyToFail.
  ///
  /// In en, this message translates to:
  /// **'Transaction is likely to fail.'**
  String get transactionIsLikelyToFail;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy coins'**
  String get buy;

  /// No description provided for @thisFeatureIsNotSupportedYetForFantom.
  ///
  /// In en, this message translates to:
  /// **'This feature is not supported yet for Fantom.'**
  String get thisFeatureIsNotSupportedYetForFantom;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions (FAQs)'**
  String get faqs;

  /// No description provided for @softwareLicenses.
  ///
  /// In en, this message translates to:
  /// **'Software Licenses'**
  String get softwareLicenses;

  /// No description provided for @notAValidWalletAddress.
  ///
  /// In en, this message translates to:
  /// **'Not a valid wallet address!'**
  String get notAValidWalletAddress;

  /// No description provided for @otherAccount.
  ///
  /// In en, this message translates to:
  /// **'Other account'**
  String get otherAccount;

  /// No description provided for @thereIsNoAccountInYourWallet.
  ///
  /// In en, this message translates to:
  /// **'There is no account in your wallet'**
  String get thereIsNoAccountInYourWallet;

  /// No description provided for @credentialSuccessfullyExported.
  ///
  /// In en, this message translates to:
  /// **'Your credential has been successfully exported.'**
  String get credentialSuccessfullyExported;

  /// No description provided for @scanAndDisplay.
  ///
  /// In en, this message translates to:
  /// **'Scan and Display'**
  String get scanAndDisplay;

  /// No description provided for @whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get whatsNew;

  /// No description provided for @okGotIt.
  ///
  /// In en, this message translates to:
  /// **'OK, GOT IT!'**
  String get okGotIt;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'support'**
  String get support;

  /// No description provided for @transactionDoneDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'The transfer may take a few minutes to complete'**
  String get transactionDoneDialogDescription;

  /// No description provided for @withdrawalFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'The account withdrawal was unsuccessful'**
  String get withdrawalFailedMessage;

  /// No description provided for @credentialRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'You must have the required credentials in your wallet to acquire this card:'**
  String get credentialRequiredMessage;

  /// No description provided for @keyDecentralizedIdEdSA.
  ///
  /// In en, this message translates to:
  /// **'did:key EdDSA'**
  String get keyDecentralizedIdEdSA;

  /// No description provided for @keyDecentralizedIDSecp256k1.
  ///
  /// In en, this message translates to:
  /// **'did:key Secp256k1'**
  String get keyDecentralizedIDSecp256k1;

  /// No description provided for @ebsiV3DecentralizedId.
  ///
  /// In en, this message translates to:
  /// **'did:key EBSI P-256'**
  String get ebsiV3DecentralizedId;

  /// No description provided for @requiredCredentialNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'We are unable to find the credential\nyou need in your wallet.'**
  String get requiredCredentialNotFoundTitle;

  /// No description provided for @requiredCredentialNotFoundSubTitle.
  ///
  /// In en, this message translates to:
  /// **'The required credential is not in your wallet'**
  String get requiredCredentialNotFoundSubTitle;

  /// No description provided for @requiredCredentialNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'Please contact us on :'**
  String get requiredCredentialNotFoundDescription;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @searchCredentials.
  ///
  /// In en, this message translates to:
  /// **'Search credentials'**
  String get searchCredentials;

  /// No description provided for @supportChatWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our chat support! We\'re here to assist you with any questions or concerns you may have about your wallet.'**
  String get supportChatWelcomeMessage;

  /// No description provided for @cardChatWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our chat support! We\'re here to assist you with any questions or concerns.'**
  String get cardChatWelcomeMessage;

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// No description provided for @contractAddress.
  ///
  /// In en, this message translates to:
  /// **'Contract address'**
  String get contractAddress;

  /// No description provided for @lastMetadataSync.
  ///
  /// In en, this message translates to:
  /// **'Last metadata sync'**
  String get lastMetadataSync;

  /// No description provided for @e2eEncyptedChat.
  ///
  /// In en, this message translates to:
  /// **'Chat is encrypted from end to end.'**
  String get e2eEncyptedChat;

  /// No description provided for @pincodeAttemptMessage.
  ///
  /// In en, this message translates to:
  /// **'You have entered an incorrect PIN code three times. For security reasons, please wait for one minute before trying again.'**
  String get pincodeAttemptMessage;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @verifyLater.
  ///
  /// In en, this message translates to:
  /// **'Verify Later'**
  String get verifyLater;

  /// No description provided for @welDone.
  ///
  /// In en, this message translates to:
  /// **'Well done!'**
  String get welDone;

  /// No description provided for @mnemonicsVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your revovery phrase is saved correctly.'**
  String get mnemonicsVerifiedMessage;

  /// No description provided for @chatWith.
  ///
  /// In en, this message translates to:
  /// **'Chat with'**
  String get chatWith;

  /// No description provided for @sendAnEmail.
  ///
  /// In en, this message translates to:
  /// **'Send an email'**
  String get sendAnEmail;

  /// No description provided for @livenessCardHowToGetIt.
  ///
  /// In en, this message translates to:
  /// **'It\'s easy! Complete a one-time KYC check in the wallet and request a Liveness credential.'**
  String get livenessCardHowToGetIt;

  /// No description provided for @livenessCardExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'This credential will remain active for 1 year. Renewal is straightforward.'**
  String get livenessCardExpirationDate;

  /// No description provided for @livenessCardWhyGetThisCard.
  ///
  /// In en, this message translates to:
  /// **'Obtain verifiable proof of humanity, requested by most DeFi, GameFi protocols and Web3 dApps. Once obtained, you can mint a privacy-preserving, non-transferable NFT for on-chain verification without revealing personal data.'**
  String get livenessCardWhyGetThisCard;

  /// No description provided for @livenessCardLongDescription.
  ///
  /// In en, this message translates to:
  /// **'This credential is a verifiable proof of humanity. Use it to prove you are not a bot when requested by DeFi protocols, Onchain games or Web3 dApps.'**
  String get livenessCardLongDescription;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @needMnemonicVerificatinoDescription.
  ///
  /// In en, this message translates to:
  /// **'You need to verify your wallet seed phrases to protect your assets!'**
  String get needMnemonicVerificatinoDescription;

  /// No description provided for @succesfullyAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'Successfully Authenticated.'**
  String get succesfullyAuthenticated;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication Failed.'**
  String get authenticationFailed;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentType;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get countryCode;

  /// No description provided for @deviceIncompatibilityMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, your device is not compatible for this feature.'**
  String get deviceIncompatibilityMessage;

  /// No description provided for @tezosProofMessage.
  ///
  /// In en, this message translates to:
  /// **''**
  String get tezosProofMessage;

  /// No description provided for @ethereumProofMessage.
  ///
  /// In en, this message translates to:
  /// **''**
  String get ethereumProofMessage;

  /// No description provided for @fantomProofMessage.
  ///
  /// In en, this message translates to:
  /// **''**
  String get fantomProofMessage;

  /// No description provided for @polygonProofMessage.
  ///
  /// In en, this message translates to:
  /// **''**
  String get polygonProofMessage;

  /// No description provided for @binanceProofMessage.
  ///
  /// In en, this message translates to:
  /// **''**
  String get binanceProofMessage;

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'years old'**
  String get yearsOld;

  /// No description provided for @youAreOver13.
  ///
  /// In en, this message translates to:
  /// **'You are over 13 years old'**
  String get youAreOver13;

  /// No description provided for @youAreOver15.
  ///
  /// In en, this message translates to:
  /// **'You are over 15 years old'**
  String get youAreOver15;

  /// No description provided for @youAreOver18.
  ///
  /// In en, this message translates to:
  /// **'You are over 18 years old'**
  String get youAreOver18;

  /// No description provided for @youAreOver21.
  ///
  /// In en, this message translates to:
  /// **'You are over 21 years old'**
  String get youAreOver21;

  /// No description provided for @youAreOver50.
  ///
  /// In en, this message translates to:
  /// **'You are over 50 years old'**
  String get youAreOver50;

  /// No description provided for @youAreOver65.
  ///
  /// In en, this message translates to:
  /// **'You are over 65 years old'**
  String get youAreOver65;

  /// No description provided for @polygon.
  ///
  /// In en, this message translates to:
  /// **'Polygon'**
  String get polygon;

  /// No description provided for @ebsi.
  ///
  /// In en, this message translates to:
  /// **'EBSI'**
  String get ebsi;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @financeCredentialsHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'My financial credentials'**
  String get financeCredentialsHomeTitle;

  /// No description provided for @financeCredentialsDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Get verified financial credentials'**
  String get financeCredentialsDiscoverTitle;

  /// No description provided for @financeCredentialsDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access new investment opportunities in web3.'**
  String get financeCredentialsDiscoverSubtitle;

  /// No description provided for @financeCredentialsHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access new investment opportunities in web3'**
  String get financeCredentialsHomeSubtitle;

  /// No description provided for @hummanityProofCredentialsHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'My proof of humanity'**
  String get hummanityProofCredentialsHomeTitle;

  /// No description provided for @hummanityProofCredentialsHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Easily prove you are a human and not a bot.'**
  String get hummanityProofCredentialsHomeSubtitle;

  /// No description provided for @hummanityProofCredentialsDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Prove you are not a bot or AI'**
  String get hummanityProofCredentialsDiscoverTitle;

  /// No description provided for @hummanityProofCredentialsDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a reusable proof of humanity to share'**
  String get hummanityProofCredentialsDiscoverSubtitle;

  /// No description provided for @socialMediaCredentialsHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'My social media accounts'**
  String get socialMediaCredentialsHomeTitle;

  /// No description provided for @socialMediaCredentialsHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prove your accounts ownership instantly Proof of humanity'**
  String get socialMediaCredentialsHomeSubtitle;

  /// No description provided for @socialMediaCredentialsDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your social media accounts'**
  String get socialMediaCredentialsDiscoverTitle;

  /// No description provided for @socialMediaCredentialsDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prove your accounts ownership when required'**
  String get socialMediaCredentialsDiscoverSubtitle;

  /// No description provided for @walletIntegrityCredentialsHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet integrity'**
  String get walletIntegrityCredentialsHomeTitle;

  /// No description provided for @walletIntegrityCredentialsHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get walletIntegrityCredentialsHomeSubtitle;

  /// No description provided for @walletIntegrityCredentialsDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'WAllet integrity'**
  String get walletIntegrityCredentialsDiscoverTitle;

  /// No description provided for @walletIntegrityCredentialsDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get walletIntegrityCredentialsDiscoverSubtitle;

  /// No description provided for @polygonCredentialsHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prove your access rights in the Polygon ecosystem'**
  String get polygonCredentialsHomeSubtitle;

  /// No description provided for @polygonCredentialsDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prove your access rights in the Polygon ecosystem'**
  String get polygonCredentialsDiscoverSubtitle;

  /// No description provided for @pendingCredentialsHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'My Pending credentials'**
  String get pendingCredentialsHomeTitle;

  /// No description provided for @pendingCredentialsHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prove your access rights.'**
  String get pendingCredentialsHomeSubtitle;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @takePicture.
  ///
  /// In en, this message translates to:
  /// **'Take a picture'**
  String get takePicture;

  /// No description provided for @kyc.
  ///
  /// In en, this message translates to:
  /// **'KYC'**
  String get kyc;

  /// No description provided for @aiSystemWasNotAbleToEstimateYourAge.
  ///
  /// In en, this message translates to:
  /// **'AI system was not able to estimate your age'**
  String get aiSystemWasNotAbleToEstimateYourAge;

  /// the description for the getting credentials
  ///
  /// In en, this message translates to:
  /// **'You got your {credential} credential.'**
  String youGotAgeCredentials(Object credential);

  ///
  ///
  /// In en, this message translates to:
  /// **'Your AI age estimation is {ageEstimate} years'**
  String yourAgeEstimationIs(Object ageEstimate);

  /// No description provided for @credentialNotFound.
  ///
  /// In en, this message translates to:
  /// **'Credential Not Found'**
  String get credentialNotFound;

  /// No description provided for @cryptographicProof.
  ///
  /// In en, this message translates to:
  /// **'Cryptographic Proof'**
  String get cryptographicProof;

  /// No description provided for @downloadingCircuitLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Downloading circuits. It may take some time. Please wait.'**
  String get downloadingCircuitLoadingMessage;

  /// No description provided for @cryptoAccountAlreadyExistMessage.
  ///
  /// In en, this message translates to:
  /// **'It appears that an account with this crypto information already exists'**
  String get cryptoAccountAlreadyExistMessage;

  /// No description provided for @errorGeneratingProof.
  ///
  /// In en, this message translates to:
  /// **'Error Generating Proof'**
  String get errorGeneratingProof;

  /// No description provided for @createWalletMessage.
  ///
  /// In en, this message translates to:
  /// **'Please create your wallet first.'**
  String get createWalletMessage;

  /// No description provided for @successfullyGeneratingProof.
  ///
  /// In en, this message translates to:
  /// **'Successfully Generated Proof'**
  String get successfullyGeneratingProof;

  /// No description provided for @wouldYouLikeToAcceptThisCredentialsFromThisOrganisation.
  ///
  /// In en, this message translates to:
  /// **'Would you like to accept this credential(s) from this organisation?'**
  String get wouldYouLikeToAcceptThisCredentialsFromThisOrganisation;

  /// No description provided for @thisOrganisationRequestsThisInformation.
  ///
  /// In en, this message translates to:
  /// **'This organisation requests'**
  String get thisOrganisationRequestsThisInformation;

  /// No description provided for @iS.
  ///
  /// In en, this message translates to:
  /// **'is'**
  String get iS;

  /// No description provided for @isSmallerThan.
  ///
  /// In en, this message translates to:
  /// **'is smaller than'**
  String get isSmallerThan;

  /// No description provided for @isBiggerThan.
  ///
  /// In en, this message translates to:
  /// **'is bigger than'**
  String get isBiggerThan;

  /// No description provided for @isOneOfTheFollowingValues.
  ///
  /// In en, this message translates to:
  /// **'is one of the following values'**
  String get isOneOfTheFollowingValues;

  /// No description provided for @isNotOneOfTheFollowingValues.
  ///
  /// In en, this message translates to:
  /// **'is not one of the following values'**
  String get isNotOneOfTheFollowingValues;

  /// No description provided for @isNot.
  ///
  /// In en, this message translates to:
  /// **'is not'**
  String get isNot;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @noInformationWillBeSharedFromThisCredentialMessage.
  ///
  /// In en, this message translates to:
  /// **'No information will be shared from this credential (Zero Knowledge Proof).'**
  String get noInformationWillBeSharedFromThisCredentialMessage;

  /// No description provided for @burn.
  ///
  /// In en, this message translates to:
  /// **'Burn'**
  String get burn;

  /// No description provided for @wouldYouLikeToConfirmThatYouIntendToBurnThisNFT.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to burn this NFT ?'**
  String get wouldYouLikeToConfirmThatYouIntendToBurnThisNFT;

  ///
  ///
  /// In en, this message translates to:
  /// **'Please add {chain} account to connect to the dapp.'**
  String pleaseAddXtoConnectToTheDapp(Object chain);

  ///
  ///
  /// In en, this message translates to:
  /// **'Please switch to polygon {networkType} to perform this action.'**
  String pleaseSwitchPolygonNetwork(Object networkType);

  /// No description provided for @oidc4vcProfile.
  ///
  /// In en, this message translates to:
  /// **'OIDC4VC Profile'**
  String get oidc4vcProfile;

  /// No description provided for @pleaseSwitchToCorrectOIDC4VCProfile.
  ///
  /// In en, this message translates to:
  /// **'Please switch to correct OIDC4VC profile.'**
  String get pleaseSwitchToCorrectOIDC4VCProfile;

  /// No description provided for @authenticationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Authentication Success'**
  String get authenticationSuccess;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @verifyIssuerWebsiteIdentity.
  ///
  /// In en, this message translates to:
  /// **'Confirm issuer access'**
  String get verifyIssuerWebsiteIdentity;

  /// No description provided for @verifyIssuerWebsiteIdentitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable to verify issuer identity before access.'**
  String get verifyIssuerWebsiteIdentitySubtitle;

  /// No description provided for @developerMode.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode'**
  String get developerMode;

  /// No description provided for @developerModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable developer mode to access advanced debugging tools'**
  String get developerModeSubtitle;

  /// No description provided for @confirmVerifierAccess.
  ///
  /// In en, this message translates to:
  /// **'Confirm verifier access'**
  String get confirmVerifierAccess;

  /// No description provided for @confirmVerifierAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disable to skip confirmation when you share your verifiable credentials.'**
  String get confirmVerifierAccessSubtitle;

  /// No description provided for @secureAuthenticationWithPINCode.
  ///
  /// In en, this message translates to:
  /// **'Secure authentication with PIN code'**
  String get secureAuthenticationWithPINCode;

  /// No description provided for @secureAuthenticationWithPINCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disable to skip PIN code for website authentication (not recommended).'**
  String get secureAuthenticationWithPINCodeSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'You can select only {count} credential(s).'**
  String youcanSelectOnlyXCredential(Object count);

  /// No description provided for @theCredentialIsNotReady.
  ///
  /// In en, this message translates to:
  /// **'The credential is not ready.'**
  String get theCredentialIsNotReady;

  /// No description provided for @theCredentialIsNoMoreReady.
  ///
  /// In en, this message translates to:
  /// **'The ceredential is no more available.'**
  String get theCredentialIsNoMoreReady;

  /// No description provided for @lowSecurity.
  ///
  /// In en, this message translates to:
  /// **'Low Security'**
  String get lowSecurity;

  /// No description provided for @highSecurity.
  ///
  /// In en, this message translates to:
  /// **'High Security'**
  String get highSecurity;

  /// No description provided for @theRequestIsRejected.
  ///
  /// In en, this message translates to:
  /// **'The request is rejected.'**
  String get theRequestIsRejected;

  /// No description provided for @userPinIsIncorrect.
  ///
  /// In en, this message translates to:
  /// **'User PIN is incorrect'**
  String get userPinIsIncorrect;

  /// No description provided for @security_level.
  ///
  /// In en, this message translates to:
  /// **'Security Level'**
  String get security_level;

  /// No description provided for @userPinTitle.
  ///
  /// In en, this message translates to:
  /// **'User PIN Digits pre-authorized_code Flow'**
  String get userPinTitle;

  /// No description provided for @userPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable to manage 4 digits PIN code. Default: 6 digits.'**
  String get userPinSubtitle;

  /// No description provided for @responseTypeNotSupported.
  ///
  /// In en, this message translates to:
  /// **'The response type is not supported'**
  String get responseTypeNotSupported;

  /// No description provided for @invalidRequest.
  ///
  /// In en, this message translates to:
  /// **'The request is invalid'**
  String get invalidRequest;

  /// No description provided for @subjectSyntaxTypeNotSupported.
  ///
  /// In en, this message translates to:
  /// **'The subject syntax type is not supported.'**
  String get subjectSyntaxTypeNotSupported;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDenied;

  /// No description provided for @thisRequestIsNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This request is not supported'**
  String get thisRequestIsNotSupported;

  /// No description provided for @unsupportedCredential.
  ///
  /// In en, this message translates to:
  /// **'Unsupported credential'**
  String get unsupportedCredential;

  /// No description provided for @aloginIsRequired.
  ///
  /// In en, this message translates to:
  /// **'A login is required'**
  String get aloginIsRequired;

  /// No description provided for @userConsentIsRequired.
  ///
  /// In en, this message translates to:
  /// **'User consent is required'**
  String get userConsentIsRequired;

  /// No description provided for @theWalletIsNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'The wallet is not registered'**
  String get theWalletIsNotRegistered;

  /// No description provided for @credentialIssuanceDenied.
  ///
  /// In en, this message translates to:
  /// **'Credential issuance denied'**
  String get credentialIssuanceDenied;

  /// No description provided for @thisCredentialFormatIsNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This credential format is not supported'**
  String get thisCredentialFormatIsNotSupported;

  /// No description provided for @thisFormatIsNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This format is not supported'**
  String get thisFormatIsNotSupported;

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'More Details'**
  String get moreDetails;

  /// No description provided for @theCredentialOfferIsInvalid.
  ///
  /// In en, this message translates to:
  /// **'The credential offer is invalid'**
  String get theCredentialOfferIsInvalid;

  /// No description provided for @dateOfRequest.
  ///
  /// In en, this message translates to:
  /// **'Date of Request'**
  String get dateOfRequest;

  /// No description provided for @keyDecentralizedIDP256.
  ///
  /// In en, this message translates to:
  /// **'did:key P-256'**
  String get keyDecentralizedIDP256;

  /// No description provided for @jwkDecentralizedIDP256.
  ///
  /// In en, this message translates to:
  /// **'did:jwk P-256'**
  String get jwkDecentralizedIDP256;

  /// No description provided for @defaultDid.
  ///
  /// In en, this message translates to:
  /// **'Default DID'**
  String get defaultDid;

  /// No description provided for @selectOneOfTheDid.
  ///
  /// In en, this message translates to:
  /// **'Select one of the DIDs'**
  String get selectOneOfTheDid;

  /// No description provided for @theServiceIsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'The service is not available'**
  String get theServiceIsNotAvailable;

  /// No description provided for @issuerDID.
  ///
  /// In en, this message translates to:
  /// **'Issuer DID'**
  String get issuerDID;

  /// No description provided for @subjectDID.
  ///
  /// In en, this message translates to:
  /// **'Subject DID'**
  String get subjectDID;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @credentialExpired.
  ///
  /// In en, this message translates to:
  /// **'Credential Expired'**
  String get credentialExpired;

  /// No description provided for @incorrectSignature.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Signature'**
  String get incorrectSignature;

  /// No description provided for @revokedOrSuspendedCredential.
  ///
  /// In en, this message translates to:
  /// **'Revoked or Suspended Credential'**
  String get revokedOrSuspendedCredential;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @successfullyDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Successfully Downloaded'**
  String get successfullyDownloaded;

  /// No description provided for @advancedSecuritySettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Security Settings'**
  String get advancedSecuritySettings;

  /// No description provided for @theIssuanceOfThisCredentialIsPending.
  ///
  /// In en, this message translates to:
  /// **'The issuance of this credential is pending'**
  String get theIssuanceOfThisCredentialIsPending;

  /// No description provided for @clientId.
  ///
  /// In en, this message translates to:
  /// **'Client Id'**
  String get clientId;

  /// No description provided for @clientSecret.
  ///
  /// In en, this message translates to:
  /// **'Client Secret'**
  String get clientSecret;

  /// No description provided for @walletProfiles.
  ///
  /// In en, this message translates to:
  /// **'Wallet Profile'**
  String get walletProfiles;

  /// No description provided for @walletProfilesDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your wallet profile or customize your own'**
  String get walletProfilesDescription;

  /// No description provided for @protectYourWallet.
  ///
  /// In en, this message translates to:
  /// **'Protect your wallet'**
  String get protectYourWallet;

  /// No description provided for @protectYourWalletMessage.
  ///
  /// In en, this message translates to:
  /// **'Use your fingerprint, face, or PIN code to secure and unlock your wallet. Your data is securely encrypted on this device.'**
  String get protectYourWalletMessage;

  /// No description provided for @pinUnlock.
  ///
  /// In en, this message translates to:
  /// **'PIN unlock'**
  String get pinUnlock;

  /// No description provided for @secureWithDevicePINOnly.
  ///
  /// In en, this message translates to:
  /// **'Secure with PIN code only'**
  String get secureWithDevicePINOnly;

  /// No description provided for @biometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock'**
  String get biometricUnlock;

  /// No description provided for @secureWithFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Secure with fingerprint or facial recognition'**
  String get secureWithFingerprint;

  /// No description provided for @pinUnlockAndBiometric2FA.
  ///
  /// In en, this message translates to:
  /// **'PIN + biometric unlock (2FA)'**
  String get pinUnlockAndBiometric2FA;

  /// No description provided for @secureWithFingerprintAndPINBackup.
  ///
  /// In en, this message translates to:
  /// **'Secure with fingerprint or facial recognition + PIN code'**
  String get secureWithFingerprintAndPINBackup;

  /// No description provided for @secureYourWalletWithPINCodeAndBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Secure your wallet with PIN code and biometrics'**
  String get secureYourWalletWithPINCodeAndBiometrics;

  /// No description provided for @twoFactorAuthenticationHasBeenEnabled.
  ///
  /// In en, this message translates to:
  /// **'Two factor authentication has been enabled.'**
  String get twoFactorAuthenticationHasBeenEnabled;

  /// No description provided for @initialization.
  ///
  /// In en, this message translates to:
  /// **'Initialization'**
  String get initialization;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterYourEmailAndYourCompanyPasswordToCreateYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and your company password to create your account'**
  String get pleaseEnterYourEmailAndYourCompanyPasswordToCreateYourAccount;

  /// No description provided for @enterTheSecurityCodeThatWeSentYouByEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the security code that we sent you by email'**
  String get enterTheSecurityCodeThatWeSentYouByEmail;

  /// No description provided for @enterTheSecurityCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the security code'**
  String get enterTheSecurityCode;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get yourEmail;

  /// No description provided for @publicKeyOfWalletInstance.
  ///
  /// In en, this message translates to:
  /// **'Public Key of Wallet Instance'**
  String get publicKeyOfWalletInstance;

  /// No description provided for @walletInstanceKey.
  ///
  /// In en, this message translates to:
  /// **'Wallet Instance Key'**
  String get walletInstanceKey;

  /// No description provided for @organizationProfile.
  ///
  /// In en, this message translates to:
  /// **'Organization Profile'**
  String get organizationProfile;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Profile Name'**
  String get profileName;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @configFileIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Config file identifier'**
  String get configFileIdentifier;

  /// No description provided for @updateYourWalletConfigNow.
  ///
  /// In en, this message translates to:
  /// **'Update your wallet config now'**
  String get updateYourWalletConfigNow;

  /// No description provided for @updateConfigurationNow.
  ///
  /// In en, this message translates to:
  /// **'Update configuration now'**
  String get updateConfigurationNow;

  /// No description provided for @pleaseEnterYourEmailAndPasswordToUpdateYourOrganizationWalletConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password to update your organization wallet configuration'**
  String
  get pleaseEnterYourEmailAndPasswordToUpdateYourOrganizationWalletConfiguration;

  /// No description provided for @congrats.
  ///
  /// In en, this message translates to:
  /// **'Congrats !'**
  String get congrats;

  /// No description provided for @yourWalletConfigurationHasBeenSuccessfullyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your wallet configuration has been successfully updated'**
  String get yourWalletConfigurationHasBeenSuccessfullyUpdated;

  /// No description provided for @continueString.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueString;

  /// No description provided for @walletProvider.
  ///
  /// In en, this message translates to:
  /// **'Wallet Provider'**
  String get walletProvider;

  /// No description provided for @clientTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to change the client type. Default: DID.'**
  String get clientTypeSubtitle;

  /// No description provided for @thisTypeProofCannotBeUsedWithThisVCFormat.
  ///
  /// In en, this message translates to:
  /// **'This proof type cannot be used with this VC Format.'**
  String get thisTypeProofCannotBeUsedWithThisVCFormat;

  /// No description provided for @blockchainCardsDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Get a proof of crypto account ownership'**
  String get blockchainCardsDiscoverTitle;

  /// No description provided for @blockchainCardsDiscoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a proof of crypto account ownership.'**
  String get blockchainCardsDiscoverSubtitle;

  /// No description provided for @successfullyAddedEnterpriseAccount.
  ///
  /// In en, this message translates to:
  /// **'Successfully added enterprise account!'**
  String get successfullyAddedEnterpriseAccount;

  /// No description provided for @successfullyUpdatedEnterpriseAccount.
  ///
  /// In en, this message translates to:
  /// **'Successfully updated enterprise account!'**
  String get successfullyUpdatedEnterpriseAccount;

  /// No description provided for @thisWalleIsAlreadyConfigured.
  ///
  /// In en, this message translates to:
  /// **'This wallet is already configured'**
  String get thisWalleIsAlreadyConfigured;

  /// No description provided for @walletSettings.
  ///
  /// In en, this message translates to:
  /// **'Wallet Settings'**
  String get walletSettings;

  /// No description provided for @walletSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your language and theme'**
  String get walletSettingsDescription;

  /// No description provided for @languageSelectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectorTitle;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @catalan.
  ///
  /// In en, this message translates to:
  /// **'Català'**
  String get catalan;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @phoneLanguage.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get phoneLanguage;

  /// No description provided for @cardIsValid.
  ///
  /// In en, this message translates to:
  /// **'Card is valid'**
  String get cardIsValid;

  /// No description provided for @cardIsExpired.
  ///
  /// In en, this message translates to:
  /// **'Card is expired'**
  String get cardIsExpired;

  /// No description provided for @signatureIsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Signature is invalid'**
  String get signatureIsInvalid;

  /// No description provided for @statusIsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Status is invalid'**
  String get statusIsInvalid;

  /// No description provided for @statuslListSignatureFailed.
  ///
  /// In en, this message translates to:
  /// **'Status list signature failed'**
  String get statuslListSignatureFailed;

  /// No description provided for @statusList.
  ///
  /// In en, this message translates to:
  /// **'Status list'**
  String get statusList;

  /// No description provided for @statusListIndex.
  ///
  /// In en, this message translates to:
  /// **'Status list index'**
  String get statusListIndex;

  /// No description provided for @theWalletIsSuspended.
  ///
  /// In en, this message translates to:
  /// **'The wallet is suspended.'**
  String get theWalletIsSuspended;

  /// No description provided for @jwkThumbprintP256Key.
  ///
  /// In en, this message translates to:
  /// **'JWK Thumbprint P-256'**
  String get jwkThumbprintP256Key;

  /// No description provided for @walletBlockedPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked 10 minutes'**
  String get walletBlockedPopupTitle;

  /// No description provided for @walletBlockedPopupDescription.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts, your wallet is blocked for your security.\nYou can reset your wallet in order to use it again.'**
  String get walletBlockedPopupDescription;

  /// No description provided for @deleteMyWalletForWrontPincodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Account blocked after 3 unsuccessful attempts'**
  String get deleteMyWalletForWrontPincodeTitle;

  /// No description provided for @deleteMyWalletForWrontPincodeDescription.
  ///
  /// In en, this message translates to:
  /// **'For your security you must reset you wallet to use it again.'**
  String get deleteMyWalletForWrontPincodeDescription;

  /// No description provided for @walletBloced.
  ///
  /// In en, this message translates to:
  /// **'Account blocked'**
  String get walletBloced;

  /// No description provided for @deleteMyWallet.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyWallet;

  /// No description provided for @pincodeRules.
  ///
  /// In en, this message translates to:
  /// **'Your secret code can\'t be a sequence or have 4 identical digit.'**
  String get pincodeRules;

  /// No description provided for @pincodeSerie.
  ///
  /// In en, this message translates to:
  /// **'You can\'t have 4 identical digits.'**
  String get pincodeSerie;

  /// No description provided for @pincodeSequence.
  ///
  /// In en, this message translates to:
  /// **'You can\'t have a sequence of 4 digits.'**
  String get pincodeSequence;

  /// No description provided for @pincodeDifferent.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code.\nBoth codes are not the same.'**
  String get pincodeDifferent;

  ///
  ///
  /// In en, this message translates to:
  /// **'Be carreful, {count} attempt{plural} left.'**
  String codeSecretIncorrectDescription(Object count, Object plural);

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @languageSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageSettingsDescription;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @themeSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your theme'**
  String get themeSettingsDescription;

  /// couldNotFindTheAccountWithThisAddress
  ///
  /// In en, this message translates to:
  /// **'Could not find the address {address} in your account list.'**
  String couldNotFindTheAccountWithThisAddress(Object address);

  /// Message to delete crypto account
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {account}?'**
  String deleteAccountMessage(Object account);

  /// No description provided for @cannotDeleteCurrentAccount.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you cannot delete current account'**
  String get cannotDeleteCurrentAccount;

  /// No description provided for @invalidClientErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'client_id is not conformed to client_id_scheme'**
  String get invalidClientErrorDescription;

  /// No description provided for @vpFormatsNotSupportedErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'The Wallet does not support any of the formats requested by the Verifier, such as those included in the vp_formats registration parameter.'**
  String get vpFormatsNotSupportedErrorDescription;

  /// No description provided for @invalidPresentationDefinitionUriErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'The Presentation Definition URL cannot be reached.'**
  String get invalidPresentationDefinitionUriErrorDescription;

  /// No description provided for @toStopDisplayingThisPopupDeactivateTheDeveloperModeInTheSettings.
  ///
  /// In en, this message translates to:
  /// **'To stop displaying this popup, deactivate the \'developer mode\' in the settings.'**
  String get toStopDisplayingThisPopupDeactivateTheDeveloperModeInTheSettings;

  /// No description provided for @warningDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The recovery phrase contains sensitive information. Please, make sure to keep it private.'**
  String get warningDialogSubtitle;

  /// No description provided for @accountPrivateKeyAlert.
  ///
  /// In en, this message translates to:
  /// **'The recovery phrase contains sensitive information. Please, make sure to keep it private.'**
  String get accountPrivateKeyAlert;

  /// No description provided for @etherlinkNetwork.
  ///
  /// In en, this message translates to:
  /// **'Etherlink Network'**
  String get etherlinkNetwork;

  /// No description provided for @etherlinkAccount.
  ///
  /// In en, this message translates to:
  /// **'Etherlink account'**
  String get etherlinkAccount;

  /// No description provided for @etherlinkAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new Etherlink blockchain address'**
  String get etherlinkAccountDescription;

  /// No description provided for @etherlinkAccountCreationCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Your new Etherlink account has been successfully created.'**
  String get etherlinkAccountCreationCongratulations;

  /// No description provided for @etherlinkProofMessage.
  ///
  /// In en, this message translates to:
  /// **''**
  String get etherlinkProofMessage;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the notification room!\nStay informed with important updates.'**
  String get notificationTitle;

  /// No description provided for @chatRoom.
  ///
  /// In en, this message translates to:
  /// **'Chat room'**
  String get chatRoom;

  /// No description provided for @notificationRoom.
  ///
  /// In en, this message translates to:
  /// **'Notification room'**
  String get notificationRoom;

  /// No description provided for @notificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable to get notifications'**
  String get notificationSubtitle;

  /// No description provided for @header.
  ///
  /// In en, this message translates to:
  /// **'Header'**
  String get header;

  /// No description provided for @payload.
  ///
  /// In en, this message translates to:
  /// **'Payload'**
  String get payload;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @keyBindingHeader.
  ///
  /// In en, this message translates to:
  /// **'Key Binding Header'**
  String get keyBindingHeader;

  /// No description provided for @keyBindingPayload.
  ///
  /// In en, this message translates to:
  /// **'Key Binding Payload'**
  String get keyBindingPayload;

  /// No description provided for @ebsiV4DecentralizedId.
  ///
  /// In en, this message translates to:
  /// **'did:key EBSI V4 P-256'**
  String get ebsiV4DecentralizedId;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @activityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get activityLog;

  /// No description provided for @activityLogDescription.
  ///
  /// In en, this message translates to:
  /// **'See your activities'**
  String get activityLogDescription;

  /// No description provided for @walletInitialized.
  ///
  /// In en, this message translates to:
  /// **'Wallet Initialized'**
  String get walletInitialized;

  /// No description provided for @backupCredentials.
  ///
  /// In en, this message translates to:
  /// **'Backup Credentials'**
  String get backupCredentials;

  /// No description provided for @restoredCredentials.
  ///
  /// In en, this message translates to:
  /// **'Restored Credentials'**
  String get restoredCredentials;

  /// No description provided for @deletedCredential.
  ///
  /// In en, this message translates to:
  /// **'Deleted credential {credential}'**
  String deletedCredential(Object credential);

  /// No description provided for @presentedCredential.
  ///
  /// In en, this message translates to:
  /// **'Presented credential {credential} to {domain}'**
  String presentedCredential(Object credential, Object domain);

  /// No description provided for @keysImported.
  ///
  /// In en, this message translates to:
  /// **'Keys imported'**
  String get keysImported;

  /// No description provided for @approveProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Install configuration'**
  String get approveProfileTitle;

  /// name of the company owning the configuration
  ///
  /// In en, this message translates to:
  /// **'Do you consent to install the configuration of {company}?'**
  String approveProfileDescription(Object company);

  /// No description provided for @updateProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Update configuration'**
  String get updateProfileTitle;

  /// name of the company owning the configuration
  ///
  /// In en, this message translates to:
  /// **'Do you consent to update the configuration of {company}?'**
  String updateProfileDescription(Object company);

  /// No description provided for @replaceProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Install a new configuration'**
  String get replaceProfileTitle;

  /// name of the company owning the configuration
  ///
  /// In en, this message translates to:
  /// **'Do you consent to replace the current configuration with that of {company}?'**
  String replaceProfileDescription(Object company);

  /// No description provided for @saveBackupCredentialSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'To recover all your credentials you will need this backup file.'**
  String get saveBackupCredentialSubtitle2;

  /// No description provided for @createWallet.
  ///
  /// In en, this message translates to:
  /// **'Create Wallet'**
  String get createWallet;

  /// No description provided for @restoreWallet.
  ///
  /// In en, this message translates to:
  /// **'Restore Wallet'**
  String get restoreWallet;

  /// No description provided for @showWalletRecoveryPhraseSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'This recovery phrase is requested to restore a wallet at installation.'**
  String get showWalletRecoveryPhraseSubtitle2;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @restoreACryptoWallet.
  ///
  /// In en, this message translates to:
  /// **'Restore a crypto wallet'**
  String get restoreACryptoWallet;

  /// name of the app
  ///
  /// In en, this message translates to:
  /// **'Restore an {appName} backup'**
  String restoreAnAppBackup(Object appName);

  /// No description provided for @credentialPickShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get credentialPickShare;

  /// No description provided for @credentialPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the credential(s) to get'**
  String get credentialPickTitle;

  /// No description provided for @credentialShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the credential(s) to share'**
  String get credentialShareTitle;

  /// No description provided for @enterYourSecretCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your secret code.'**
  String get enterYourSecretCode;

  /// No description provided for @jwk.
  ///
  /// In en, this message translates to:
  /// **'JWK'**
  String get jwk;

  /// No description provided for @typeYourPINCodeToOpenTheWallet.
  ///
  /// In en, this message translates to:
  /// **'Type your PIN code to open the wallet'**
  String get typeYourPINCodeToOpenTheWallet;

  /// No description provided for @typeYourPINCodeToShareTheData.
  ///
  /// In en, this message translates to:
  /// **'Type your PIN code to share data'**
  String get typeYourPINCodeToShareTheData;

  /// No description provided for @typeYourPINCodeToAuthenticate.
  ///
  /// In en, this message translates to:
  /// **'Type your PIN code to authenticate'**
  String get typeYourPINCodeToAuthenticate;

  /// No description provided for @credentialIssuanceIsStillPending.
  ///
  /// In en, this message translates to:
  /// **'Credential issuance is still pending'**
  String get credentialIssuanceIsStillPending;

  /// No description provided for @bakerFee.
  ///
  /// In en, this message translates to:
  /// **'Baker fee'**
  String get bakerFee;

  /// No description provided for @storageFee.
  ///
  /// In en, this message translates to:
  /// **'Storage Fee'**
  String get storageFee;

  /// No description provided for @doYouWantToSetupTheProfile.
  ///
  /// In en, this message translates to:
  /// **'Do you want to setup the profile?'**
  String get doYouWantToSetupTheProfile;

  /// No description provided for @thisFeatureIsNotSupportedYetForEtherlink.
  ///
  /// In en, this message translates to:
  /// **'This feature is not supported yet for Etherlink Chain.'**
  String get thisFeatureIsNotSupportedYetForEtherlink;

  /// No description provided for @walletSecurityAndBackup.
  ///
  /// In en, this message translates to:
  /// **'Wallet Security and Backup'**
  String get walletSecurityAndBackup;

  /// No description provided for @addedCredential.
  ///
  /// In en, this message translates to:
  /// **'Added credential {credential} by {domain}'**
  String addedCredential(Object credential, Object domain);

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @operation.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get operation;

  /// No description provided for @chooseYourSSIProfileOrCustomizeYourOwn.
  ///
  /// In en, this message translates to:
  /// **'Choose your wallet profile or customize your own'**
  String get chooseYourSSIProfileOrCustomizeYourOwn;

  /// No description provided for @recoveryPhraseIncorrectErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please try again with correct order.'**
  String get recoveryPhraseIncorrectErrorMessage;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get invalidCode;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @iaAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Data will be shared with a remote AI engine. Don\'t share personal data.'**
  String get iaAnalyze;

  /// No description provided for @iaAnalyzeTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Agent'**
  String get iaAnalyzeTitle;

  /// No description provided for @deleteDigit.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteDigit;

  /// No description provided for @aiPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'This treatment can take up to 1 min'**
  String get aiPleaseWait;

  /// No description provided for @trustedList.
  ///
  /// In en, this message translates to:
  /// **'Use trusted list'**
  String get trustedList;

  /// No description provided for @trustedListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'List of trusted entities in the current ecosystem. You are warned in case of interaction with non trusted entity.'**
  String get trustedListSubtitle;

  /// No description provided for @notTrustedEntity.
  ///
  /// In en, this message translates to:
  /// **'This entity is not in the trusted list. You should be very cautious with untrusted entities.'**
  String get notTrustedEntity;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
