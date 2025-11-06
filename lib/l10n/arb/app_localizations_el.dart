// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get genericError => 'Εμφανίστηκε σφάλμα!';

  @override
  String get credentialListTitle => 'Πιστοποιητικά';

  @override
  String credentialDetailIssuedBy(Object issuer) {
    return 'Εκδόθηκε από $issuer';
  }

  @override
  String get listActionRefresh => 'Ανανέωση';

  @override
  String get listActionViewList => 'Προβολή σε λίστα';

  @override
  String get listActionViewGrid => 'Προβολή ως πίνακας';

  @override
  String get listActionFilter => 'Φίλτρο';

  @override
  String get listActionSort => 'Ταξινόμηση';

  @override
  String get onBoardingStartSubtitle => 'Lorem ipsum dolor sit ame';

  @override
  String get onBoardingTosTitle => 'Όροι και προϋποθέσεις';

  @override
  String get onBoardingTosText =>
      'Πατώντας αποδοχή «Συμφωνώ με τους όρους και τις προϋποθέσεις, καθώς και με την κοινοποίηση αυτών των πληροφοριών.»';

  @override
  String get onBoardingTosButton => 'Αποδοχή';

  @override
  String get onBoardingRecoveryTitle => 'Ανάκτηση κωδικού';

  @override
  String get onBoardingRecoveryButton => 'Ανάκτηση';

  @override
  String get onBoardingGenPhraseTitle => 'Φράση Ανάκτησης';

  @override
  String get onBoardingGenPhraseButton => 'Συνέχεια';

  @override
  String get onBoardingGenTitle => 'Έκδοση Ιδιωτικού Κωδικού';

  @override
  String get onBoardingGenButton => 'Έκδοση';

  @override
  String get onBoardingSuccessTitle => 'Δημιουργήθηκε Αναγνωριστικό';

  @override
  String get onBoardingSuccessButton => 'Συνέχεια';

  @override
  String get credentialDetailShare => 'Κοινοποίηση με κωδικό QR';

  @override
  String get credentialAddedMessage =>
      'Ένα νέο πιστοποιητικό προστέθηκε επιτυχώς!';

  @override
  String get credentialDetailDeleteCard => 'Διαγραφή αυτής της κάρτας';

  @override
  String get credentialDetailDeleteConfirmationDialog =>
      'Θέλετε πραγματικά να διαγράψετε αυτό το πιστοποιητικό;';

  @override
  String get credentialDetailDeleteConfirmationDialogYes => 'Ναι';

  @override
  String get credentialDetailDeleteConfirmationDialogNo => 'Όχι';

  @override
  String get credentialDetailDeleteSuccessMessage => 'Επιτυχής διαγραφή.';

  @override
  String get credentialDetailEditConfirmationDialog =>
      'Θέλετε πραγματικά να επεξεργαστείτε αυτό το πιστοποιητικό;';

  @override
  String get credentialDetailEditConfirmationDialogYes => 'Αποθήκευση';

  @override
  String get credentialDetailEditConfirmationDialogNo => 'Ακύρωση';

  @override
  String get credentialDetailEditSuccessMessage => 'Επιτυχής επεξεργασία.';

  @override
  String get credentialDetailCopyFieldValue =>
      'Αντιγραφή τιμής πεδίου στο πρόχειρο!';

  @override
  String get credentialDetailStatus => 'Κατάσταση επαλήθευσης';

  @override
  String get credentialPresentTitle => 'Επιλέξτε πιστοποιητικό(α)';

  @override
  String get credentialPresentTitleDIDAuth => 'Αίτημα DIDAuth';

  @override
  String get credentialPresentRequiredCredential =>
      'Κάποιος ζητάει το δικό σας';

  @override
  String get credentialPresentConfirm => 'Επιλέξτε πιστοποιητικό(α)';

  @override
  String get credentialPresentCancel => 'Απόρριψη';

  @override
  String get selectYourTezosAssociatedWallet =>
      'Επιλέξτε το σχετιζόμενο Tezos πορτοφόλι σας';

  @override
  String get credentialPickSelect => 'Επιλογή του πιστοποιητικού σας';

  @override
  String get siopV2credentialPickSelect =>
      'Επιλέξτε μόνο ένα πιστοποιητικό για παρουσίαση';

  @override
  String get credentialPickAlertMessage =>
      'Θέλετε να δώσετε ένα όνομα σε αυτό το πιστοποιητικό;';

  @override
  String get credentialReceiveTitle => 'Προσφορά Πιστοποιητικού';

  @override
  String get credentialReceiveHost => 'θέλει να σας στείλει ένα πιστοποιητικό';

  @override
  String get credentialAddThisCard => 'Προσθήκη της κάρτας';

  @override
  String get credentialReceiveCancel => 'Ακύρωση της κάρτας';

  @override
  String get credentialDetailListTitle => 'Το πορτοφόλι μου';

  @override
  String get communicationHostAllow => 'Αποδοχή';

  @override
  String get communicationHostDeny => 'Άρνηση';

  @override
  String get scanTitle => 'Σάρωση QR κωδικού';

  @override
  String get scanPromptHost => 'Εμπιστεύεστε αυτόν τον πάροχο;';

  @override
  String get scanRefuseHost => 'Το αίτημα επικοινωνίας απορρίφθηκε.';

  @override
  String get scanUnsupportedMessage => 'Το εξαγόµενο url δεν είναι έγκυρο.';

  @override
  String get qrCodeSharing => 'Τώρα κοινοποιείτε';

  @override
  String get qrCodeNoValidMessage =>
      'Αυτός ο κωδικός QR δεν περιέχει έγκυρο μήνυμα.';

  @override
  String get profileTitle => 'Προφίλ';

  @override
  String get personalTitle => 'Προσωπικό';

  @override
  String get termsTitle => 'Όροι και προϋποθέσεις';

  @override
  String get recoveryKeyTitle => 'Φράση ανάκτησης';

  @override
  String get showRecoveryPhrase => 'Εμφάνιση φράσης ανάκτησης';

  @override
  String get warningDialogTitle => 'Προσοχή';

  @override
  String get recoveryText => 'Εισάγετε τη φράση ανάκτησης';

  @override
  String get recoveryMnemonicHintText =>
      'Εισάγετε τη φράση ανάκτησης εδώ.\nΌταν θα έχετε εισάγει τις 12 λέξεις σας,\nπατήστε Εισαγωγή.';

  @override
  String get recoveryMnemonicError => 'Εισάγετε μια έγκυρη μνημονική φράση';

  @override
  String get showDialogYes => 'Συνέχεια';

  @override
  String get showDialogNo => 'Ακύρωση';

  @override
  String get supportTitle => 'Βοήθεια';

  @override
  String get noticesTitle => 'Ειδοποιήσεις';

  @override
  String get resetWalletButton => 'Επαναφορά';

  @override
  String get resetWalletConfirmationText =>
      'Είστε σίγουροι ότι θέλετε να επαναφέρετε το πορτοφόλι σας;';

  @override
  String get selectThemeText => 'Επιλογή θέματος';

  @override
  String get lightThemeText => 'Ανοιχτόχρωμη Λειτουργία';

  @override
  String get darkThemeText => 'Σκουρόχρωμη Λειτουργία';

  @override
  String get systemThemeText => 'Ρύθμιση Θέματος';

  @override
  String get genPhraseInstruction =>
      'Γράψτε αυτές τις λέξεις, κατεβάστε το αρχείο αντιγράφων ασφαλείας και φυλάξτε τις σε ασφαλές μέρος';

  @override
  String get genPhraseExplanation =>
      'Εάν χάσετε την πρόσβαση σε αυτό το πορτοφόλι, θα χρειαστείτε τις λέξεις με τη σωστή σειρά και το αρχείο αντιγράφου ασφαλείας για να ανακτήσετε τα πιστοποιητικά σας.';

  @override
  String get errorGeneratingKey =>
      'Απέτυχε η δημιουργία κλειδιού, παρακαλούμε δοκιμάστε ξανά';

  @override
  String get documentHeaderTooltipName => 'John Doe';

  @override
  String get documentHeaderTooltipJob => 'Crypto Trader';

  @override
  String get documentHeaderTooltipLabel => 'Κατάσταση:';

  @override
  String get documentHeaderTooltipValue => 'Έγκυρο';

  @override
  String get didDisplayId => 'DID';

  @override
  String get blockChainDisplayMethod => 'Blockchain';

  @override
  String get blockChainAdress => 'Διεύθυνση';

  @override
  String get didDisplayCopy => 'Αντιγραφή DID';

  @override
  String get adressDisplayCopy => 'Αντιγραφή διεύθυνσης';

  @override
  String get personalSave => 'Αποθήκευση';

  @override
  String get personalSubtitle =>
      'Οι πληροφορίες του προφίλ σας μπορούν να χρησιμοποιηθούν για τη συμπλήρωση ενός πιστοποιητικού όταν είναι απαραίτητο';

  @override
  String get personalFirstName => 'Όνομα';

  @override
  String get personalLastName => 'Επίθετο';

  @override
  String get personalPhone => 'Τηλέφωνο';

  @override
  String get personalAddress => 'Διεύθυνση';

  @override
  String get personalMail => 'E-mail';

  @override
  String get lastName => 'Επίθετο';

  @override
  String get firstName => 'Όνομα';

  @override
  String get gender => 'Φύλο';

  @override
  String get birthdate => 'Ημερομηνία γέννησης';

  @override
  String get birthplace => 'Τόπος γέννησης';

  @override
  String get address => 'Διεύθυνση';

  @override
  String get maritalStatus => 'Οικογενειακή κατάσταση';

  @override
  String get nationality => 'Υπηκοότητα';

  @override
  String get identifier => 'Αναγνωριστικό';

  @override
  String get issuer => 'Εκδόθηκε από';

  @override
  String get workFor => 'Εργάζομαι για';

  @override
  String get startDate => 'Από';

  @override
  String get endDate => 'Έως';

  @override
  String get employmentType => 'Κατηγορία απασχόλησης';

  @override
  String get jobTitle => 'Τίτλος εργασίας';

  @override
  String get baseSalary => 'Μισθός';

  @override
  String get expires => 'Λήγει';

  @override
  String get generalInformationLabel => 'Γενικές πληροφορίες';

  @override
  String get learningAchievement => 'Επίτευγμα';

  @override
  String get signedBy => 'Υπογεγραμμένο από';

  @override
  String get from => 'Από';

  @override
  String get to => 'Ως';

  @override
  String get credential => 'Πιστοποιητικό';

  @override
  String get issuanceDate => 'Ημερομηνία έκδοσης';

  @override
  String get appContactWebsite => 'Ιστοσελίδα';

  @override
  String get trustFrameworkDescription =>
      'Το πλαίσιο εμπιστοσύνης αποτελείται από ένα σύνολο μητρώων που παρέχουν μια ασφαλή και αξιόπιστη βάση για την εμπιστοσύνη και την αλληλεπίδραση μεταξύ των οντοτήτων του συστήματος.';

  @override
  String get confimrDIDAuth => 'Θέλετε να συνδεθείτε στον ιστότοπο ?';

  @override
  String get evidenceLabel => 'Τεκμήριο';

  @override
  String get networkErrorBadRequest => 'Λανθασμένο αίτημα';

  @override
  String get networkErrorConflict => 'Σφάλμα λόγω διαφοράς δεδομένων';

  @override
  String get networkErrorPreconditionFailed =>
      'Ο διακομιστής δεν πληροί μία από τις προϋποθέσεις.';

  @override
  String get networkErrorCreated => '';

  @override
  String get networkErrorGatewayTimeout =>
      'Ο διακομιστής αντιμετώπισε ένα χρονικό όριο';

  @override
  String get networkErrorInternalServerError =>
      'Πρόκειται για εσωτερικό σφάλμα του διακομιστή. Επικοινωνήστε με το διαχειριστή';

  @override
  String get networkErrorMethodNotAllowed =>
      'Ο χρήστης δεν έχει δικαιώματα πρόσβασης στο περιεχόμενο';

  @override
  String get networkErrorNoInternetConnection =>
      'Δεν υπάρχει σύνδεση στο διαδίκτυο';

  @override
  String get networkErrorNotAcceptable => 'Μη αποδεκτό';

  @override
  String get networkErrorNotImplemented => 'Μη υλοποιημένο';

  @override
  String get networkErrorOk => '';

  @override
  String get networkErrorRequestCancelled => 'Το αίτημα ακυρώθηκε';

  @override
  String get networkErrorRequestTimeout => 'Το αίτημα έληξε';

  @override
  String get networkErrorSendTimeout =>
      'Χρονικό όριο αποστολής σε σύνδεση με διακομιστή API';

  @override
  String get networkErrorServiceUnavailable => 'Μη διαθέσιμη υπηρεσία';

  @override
  String get networkErrorTooManyRequests =>
      'Ο χρήστης έχει αποστείλει υπερβολικό αριθμό αιτημάτων σε δεδομένο χρονικό διάστημα';

  @override
  String get networkErrorUnableToProcess =>
      'Δεν είναι δυνατή η επεξεργασία των δεδομένων';

  @override
  String get networkErrorUnauthenticated =>
      'Ο χρήστης πρέπει να πιστοποιηθεί για να λάβει τη ζητούμενη απάντηση';

  @override
  String get networkErrorUnauthorizedRequest => 'Μη επιτρεπόμενο αίτημα';

  @override
  String get networkErrorUnexpectedError => 'Εμφανίστηκε σφάλμα';

  @override
  String get networkErrorNotFound => 'Δε βρέθηκε';

  @override
  String get active => 'Ενεργό';

  @override
  String get expired => 'Έχει λήξει';

  @override
  String get revoked => 'Ανακλήθηκε';

  @override
  String get ok => 'ΟΚ';

  @override
  String get unavailable_feature_title => 'Μη Διαθέσιμη Λειτουργία';

  @override
  String get unavailable_feature_message =>
      'Μη διαθέσιμη λειτουργία στον browser';

  @override
  String get personalSkip => 'ΠΑΡΑΛΕΙΨΗ';

  @override
  String get restoreCredential => 'Επαναφορά πιστοποιητικών';

  @override
  String get backupCredential => 'Αντίγραφο ασφαλείας πιστοποιητικών';

  @override
  String get backupCredentialPhrase =>
      'Γράψτε αυτές τις λέξεις, κατεβάστε το αρχείο αντιγράφων ασφαλείας και φυλάξτε τις σε ασφαλές μέρος';

  @override
  String get backupCredentialPhraseExplanation =>
      'Για τη δημιουργία αντιγράφων ασφαλείας των πιστοποιητικών σας, σημειώστε τη φράση ανάκτησης και φυλάξτε τη σε ασφαλές μέρος.';

  @override
  String get backupCredentialButtonTitle => 'Αποθήκευση Αρχείου';

  @override
  String get needStoragePermission =>
      'Χρειάζεστε άδεια αποθήκευσης για να κατεβάσετε αυτό το αρχείο.';

  @override
  String get backupCredentialNotificationTitle => 'Επιτυχία';

  @override
  String get backupCredentialNotificationMessage =>
      'Η λήψη του αρχείου ολοκληρώθηκε επιτυχώς. Πατήστε για να ανοίξετε το αρχείο.';

  @override
  String get backupCredentialError =>
      'Παρουσιάστηκε λάθος. Παρακαλούμε, δοκιμάστε αργότερα.';

  @override
  String get backupCredentialSuccessMessage =>
      'Η λήψη του αρχείου ολοκληρώθηκε επιτυχώς.';

  @override
  String get restorationCredentialWarningDialogSubtitle =>
      'Η αποκατάσταση θα διαγράψει όλα τα πιστοποιητικά που έχετε ήδη στο πορτοφόλι σας.';

  @override
  String get recoveryCredentialPhrase =>
      'Γράψτε τις λέξεις και ανεβάστε το αρχείο αντιγράφων ασφαλείας, αν το είχατε αποθηκεύσει προηγουμένως';

  @override
  String get recoveryCredentialPhraseExplanation =>
      'Χρειάζεστε και τις δύο λέξεις με τη σωστή σειρά και ένα κρυπτογραφημένο αρχείο αντιγράφων ασφαλείας για να ανακτήσετε τα πιστοποιητικά σας εάν χαθούν';

  @override
  String get recoveryCredentialButtonTitle =>
      'Ανέβασμα αρχείου αντιγράφων ασφαλείας';

  @override
  String recoveryCredentialSuccessMessage(Object postfix) {
    return 'Επιτυχής ανάκτηση του $postfix.';
  }

  @override
  String get recoveryCredentialJSONFormatErrorMessage =>
      'Παρακαλούμε ανεβάστε το έγκυρο αρχείο.';

  @override
  String get recoveryCredentialAuthErrorMessage =>
      'Τα μνημονικά είναι λανθασμένα ή το αρχείο που μεταφορτώσατε είναι κατεστραμμένο.';

  @override
  String get recoveryCredentialDefaultErrorMessage =>
      'Παρουσιάστηκε λάθος. Παρακαλούμε, δοκιμάστε αργότερα.';

  @override
  String get selfIssuedCreatedSuccessfully =>
      'Αυτοεκδιδόμενο πιστοποιητικό δημιουργήθηκε με επιτυχία';

  @override
  String get companyWebsite => 'Ιστοσελίδα εταιρείας';

  @override
  String get submit => 'Αποστολή';

  @override
  String get insertYourDIDKey => 'Εισάγετε το DID σας';

  @override
  String get importYourRSAKeyJsonFile =>
      'Εισαγωγή του αρχείου JSON του κλειδιού RSA';

  @override
  String get didKeyAndRSAKeyVerifiedSuccessfully =>
      'Το κλειδί DID και RSA επαληθεύτηκαν επιτυχώς';

  @override
  String get pleaseEnterYourDIDKey => 'Εισάγετε το DID σας';

  @override
  String get pleaseImportYourRSAKey => 'Εισάγετε το RSA κλειδί σας';

  @override
  String get confirm => 'Επιβεβαίωση';

  @override
  String get pleaseSelectRSAKeyFileWithJsonExtension =>
      'Παρακαλούμε επιλέξτε αρχείο κλειδιού RSA (με επέκταση json)';

  @override
  String get rsaNotMatchedWithDIDKey => 'Το κλειδί RSA δεν ταιριάζει με το DID';

  @override
  String get didKeyNotResolved => 'Το DID δεν έχει επιλυθεί';

  @override
  String get anUnknownErrorHappened => 'Προέκυψε άγνωστο σφάλμα';

  @override
  String get walletType => 'Τύπος πορτοφολιού';

  @override
  String get chooseYourWalletType => 'Επιλογή τύπου του πορτοφολιού σας';

  @override
  String get proceed => 'Συνέχεια';

  @override
  String get enterpriseWallet => 'Πορτοφόλι Επιχείρησης';

  @override
  String get personalWallet => 'Προσωπικό πορτοφόλι';

  @override
  String get failedToVerifySelfIssuedCredential =>
      'Αποτυχία επαλήθευσης του αυτοεκδιδόμενου πιστοποιητικού';

  @override
  String get failedToCreateSelfIssuedCredential =>
      'Απέτυχε η δημιουργία αυτοεκδιδόμενου πιστοποιητικού';

  @override
  String get credentialVerificationReturnWarning =>
      'Η επαλήθευση των πιστοποιητικών επέστρεψε ορισμένες προειδοποιήσεις. ';

  @override
  String get failedToVerifyCredential => 'Αποτυχία επαλήθευσης πιστοποιητικού.';

  @override
  String get somethingsWentWrongTryAgainLater =>
      'Εμφανίστηκε λάθος. Δοκιμάστε αργότερα. ';

  @override
  String get successfullyPresentedYourCredential =>
      'Επιτυχής παρουσίαση του πιστοποιητικού(ών) σας!';

  @override
  String get successfullyPresentedYourDID => 'Επιτυχής παρουσίαση του DID σας!';

  @override
  String get thisQRCodeIsNotSupported => 'Αυτό το QR code δεν υποστηρίζεται.';

  @override
  String get thisUrlDoseNotContainAValidMessage =>
      'Αυτός ο σύνδεσμος δεν περιέχει έγκυρο μήνυμα.';

  @override
  String get anErrorOccurredWhileConnectingToTheServer =>
      'Παρουσιάστηκε σφάλμα κατά τη σύνδεση με το διακομιστή.';

  @override
  String get failedToSaveMnemonicPleaseTryAgain =>
      'Αποτυχία αποθήκευσης μνημονικού. Παρακαλούμε, προσπαθήστε αργότερα';

  @override
  String get failedToLoadProfile => 'Αποτυχία φόρτωσης προφίλ. ';

  @override
  String get failedToSaveProfile => 'Αποτυχία αποθήκευσης προφίλ. ';

  @override
  String get failedToLoadDID => 'Αποτυχία φόρτωσης του DID. ';

  @override
  String get personalOpenIdRestrictionMessage =>
      'Το προσωπικό πορτοφόλι δεν έχει πρόσβαση.';

  @override
  String get credentialEmptyError =>
      'Δεν έχετε κανένα πιστοποιητικό στο πορτοφόλι.';

  @override
  String get credentialPresentTitleSiopV2 => 'Παρουσιάστε το πιστοποιητικό';

  @override
  String get confirmSiopV2 =>
      'Παρακαλούμε επιβεβαιώστε το πιστοποιητικό που παρουσιάστηκε';

  @override
  String get storagePermissionRequired => 'Απαιτείται άδεια αποθήκευσης';

  @override
  String get storagePermissionDeniedMessage =>
      'Επιτρέψτε την πρόσβαση στον αποθηκευτικό χώρο για να φορτωθεί το αρχείο.';

  @override
  String get storagePermissionPermanentlyDeniedMessage =>
      'Χρειάζεστε άδεια αποθήκευσης για τη φόρτωση αρχείου. Μεταβείτε στις ρυθμίσεις της εφαρμογής και δώστε πρόσβαση στο δικαίωμα αποθήκευσης.';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get loading => 'Παρακαλούμε περιμένετε...';

  @override
  String get issuerWebsitesTitle => 'Λήψη πιστοποιητικών';

  @override
  String get getCredentialTitle => 'Λήψη πιστοποιητικών';

  @override
  String get participantCredential => 'GaiaX Pass';

  @override
  String get phonePassCredential => 'Πιστοποίηση Τηλεφώνου';

  @override
  String get emailPassCredential => 'Πιστοποίηση e-mail';

  @override
  String get needEmailPass => 'Πρέπει πρώτα να έχετε αποδεικτικό email.';

  @override
  String get signature => 'Υπογραφή';

  @override
  String get proof => 'Πιστοποίηση';

  @override
  String get verifyMe => 'Επαληθεύστε με';

  @override
  String get yes => 'Ναι';

  @override
  String get no => 'Όχι';

  @override
  String get credentialAlias => 'Όνομα Πιστοποιητικού';

  @override
  String get verificationStatus => 'Κατάσταση Επαλήθευσης';

  @override
  String get cardsPending => 'Εκκρεμής κάρτα';

  @override
  String get unableToProcessTheData =>
      'Η επεξεργασία των δεδομένων δεν είναι δυνατή';

  @override
  String get unimplementedQueryType => 'Μη εφαρμοσμένος τύπος ερωτήματος';

  @override
  String get onSubmittedPassBasePopUp => 'Θα λάβετε ένα e-mail';

  @override
  String get myCollection => 'Η συλλογή μου';

  @override
  String get items => 'στοιχεία';

  @override
  String get succesfullyUpdated => 'Επιτυχής επικαιροποίηση.';

  @override
  String get generate => 'Δημιουργία';

  @override
  String get myAssets => 'Τα στοιχεία μου';

  @override
  String get search => 'Αναζήτηση';

  @override
  String get professional => 'Επαγγελματίας';

  @override
  String get splashSubtitle =>
      'Κατέχετε την ψηφιακή σας ταυτότητα και τα ψηφιακά σας στοιχεία';

  @override
  String get poweredBy => 'Με την υποστήριξη της';

  @override
  String get splashLoading => 'Φόρτωση...';

  @override
  String get version => 'Έκδοση';

  @override
  String get cards => 'Κάρτες';

  @override
  String get nfts => 'NFTs';

  @override
  String get coins => 'Crypto';

  @override
  String get getCards => 'Λήψη πιστοποιητικών';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get profile => 'Προφίλ';

  @override
  String get infos => 'Πληροφορίες';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get enterNewPinCode =>
      'Δημιουργία κωδικού PIN\nγια να προστατέψετε το πορτοφόλι σας';

  @override
  String get confirmYourPinCode => 'Επιβεβαιώστε τον κωδικό PIN σας';

  @override
  String get walletAltme => 'Πορτοφόλι Altme';

  @override
  String get createTitle => 'Δημιουργία ή εισαγωγή πορτοφολιού';

  @override
  String get createSubtitle =>
      'Θέλετε να δημιουργήσετε ένα νέο πορτοφόλι ή να εισαγάγετε ένα υπάρχον;';

  @override
  String get enterYourPinCode => 'Εισάγετε τον κωδικό PIN σας';

  @override
  String get changePinCode => 'Αλλαγή κωδικού PIN';

  @override
  String get tryAgain => 'Δοκιμάστε ξανά';

  @override
  String get credentialSelectionListEmptyError =>
      'Δεν έχετε τα απαιτούμενα πιστοποιητικά για να συνεχίσετε.';

  @override
  String get trustedIssuer => 'Αυτός ο εκδότης έχει εγκριθεί από την EBSI.';

  @override
  String get yourPinCodeChangedSuccessfully =>
      'Ο κωδικός PIN σας άλλαξε με επιτυχία';

  @override
  String get advantagesCards => 'Κάρτες Προνομίων';

  @override
  String get advantagesDiscoverCards => 'Ξεκλειδώστε αποκλειστικά προνόμια';

  @override
  String get identityCards => 'Δελτία ταυτότητας';

  @override
  String get identityDiscoverCards => 'Απλοποίηση της επαλήθευσης ταυτότητας';

  @override
  String get contactInfoCredentials => 'Στοιχεία επικοινωνίας';

  @override
  String get contactInfoDiscoverCredentials =>
      'Επαληθεύστε τα στοιχεία επικοινωνίας σας';

  @override
  String get myProfessionalCards => 'Επαγγελματικές κάρτες';

  @override
  String get otherCards => 'Λοιπές κάρτες';

  @override
  String get inMyWallet => 'Στο πορτοφόλι μου';

  @override
  String get details => 'Λεπτομέρειες';

  @override
  String get getIt => 'Αποκτήστε το';

  @override
  String get getItNow => 'Αποκτήστε το τώρα';

  @override
  String get getThisCard => 'Αποκτήστε αυτή την κάρτα';

  @override
  String get drawerBiometrics => 'Βιομετρικός έλεγχος';

  @override
  String get drawerTalaoCommunityCard => 'Κάρτα κοινότητας Talao';

  @override
  String get drawerTalaoCommunityCardTitle =>
      'Εισαγάγετε τη διεύθυνση Ethereum και λάβετε την κάρτα κοινότητας.';

  @override
  String get drawerTalaoCommunityCardSubtitle =>
      'Θα σας δώσει πρόσβαση στις καλύτερες εκπτώσεις, συνδρομές και κάρτες κουπονιών από το οικοσύστημα των συνεργατών μας.';

  @override
  String get drawerTalaoCommunityCardTextBoxMessage =>
      'Μόλις εισαγάγετε το ιδιωτικό σας κλειδί, πατήστε Εισαγωγή.\nΒεβαιωθείτε ότι έχετε εισάγει το ιδιωτικό κλειδί ethereum που περιέχει το Talao Token σας.';

  @override
  String get drawerTalaoCommunityCardSubtitle2 =>
      'Το πορτοφόλι μας είναι αυτοεξουσιοδοτούμενο. Δεν έχουμε ποτέ πρόσβαση στα ιδιωτικά κλειδιά ή τα χρήματά σας.';

  @override
  String get drawerTalaoCommunityCardKeyError =>
      'Παρακαλώ εισάγετε ένα έγκυρο ιδιωτικό κλειδί';

  @override
  String get loginWithBiometricsMessage =>
      'Ξεκλειδώστε γρήγορα το πορτοφόλι σας χωρίς να χρειάζεται να πληκτρολογήσετε κωδικό πρόσβασης ή κωδικό PIN';

  @override
  String get manage => 'Διαχείριση';

  @override
  String get wallet => 'Πορτοφόλι';

  @override
  String get manageAccounts => 'Διαχείριση λογαριασμών blockchain';

  @override
  String get blockchainAccounts => 'Λογαριασμοί Blockchain';

  @override
  String get educationCredentials => 'Πιστοποιητικά εκπαίδευσης';

  @override
  String get educationDiscoverCredentials =>
      'Επαληθεύστε το εκπαιδευτικό σας υπόβαθρο';

  @override
  String get educationCredentialsDiscoverSubtitle =>
      'Αποκτήστε το ψηφιακό σας δίπλωμα (EBSI)';

  @override
  String get security => 'Ασφάλεια';

  @override
  String get networkAndRegistries => 'Δίκτυο & Μητρώα';

  @override
  String get chooseNetwork => 'Επιλέξτε Δίκτυο';

  @override
  String get chooseRegistry => 'Επιλέξτε Μητρώο';

  @override
  String get trustFramework => 'Πλαίσιο εμπιστοσύνης';

  @override
  String get network => 'Δίκτυο';

  @override
  String get issuerRegistry => 'Μητρώο εκδότη';

  @override
  String get termsOfUse => 'Όροι χρήσης & εμπιστευτικότητα';

  @override
  String get scanFingerprintToAuthenticate =>
      'Σάρωση δακτυλικού αποτυπώματος για πιστοποίηση';

  @override
  String get biometricsNotSupported => 'Δεν υποστηρίζονται βιομετρικά στοιχεία';

  @override
  String get deviceDoNotSupportBiometricsAuthentication =>
      'Η συσκευή σας δεν υποστηρίζει βιομετρικό έλεγχο ταυτότητας';

  @override
  String get biometricsEnabledMessage =>
      'Τώρα μπορείτε να ξεκλειδώσετε την εφαρμογή με τα βιομετρικά σας στοιχεία.';

  @override
  String get biometricsDisabledMessage =>
      'Ο βιομετρικός έλεγχος ταυτότητας έχει απενεργοποιηθεί.';

  @override
  String get exportSecretKey => 'Εξαγωγή μυστικού κλειδιού';

  @override
  String get secretKey => 'Μυστικό κλειδί';

  @override
  String get chooseNetWork => 'Επιλέξτε Δίκτυο';

  @override
  String get nftEmptyMessage => 'Η ψηφιακή σας γκαλερί είναι άδεια!';

  @override
  String get myAccount => 'Ο λογαριασμός μου';

  @override
  String get cryptoAccounts => 'Λογαριασμοί';

  @override
  String get cryptoAccount => 'Λογαριασμός';

  @override
  String get cryptoAddAccount => 'Προσθήκη λογαριασμού';

  @override
  String get cryptoAddedMessage => 'Ο λογαριασμός σας έχει προστεθεί επιτυχώς.';

  @override
  String get cryptoEditConfirmationDialog =>
      'Θέλετε πραγματικά να επεξεργαστείτε αυτό το όνομα λογαριασμού;';

  @override
  String get cryptoEditConfirmationDialogYes => 'Αποθήκευση';

  @override
  String get cryptoEditConfirmationDialogNo => 'Ακύρωση';

  @override
  String get cryptoEditLabel => 'Όνομα Λογαριασμού';

  @override
  String get onBoardingFirstTitle =>
      'Ανακαλύψτε αποκλειστικές προσφορές Web 3 απευθείας στο πορτοφόλι σας.';

  @override
  String get onBoardingFirstSubtitle =>
      'Αποκτήστε κάρτες μέλους, κάρτες επιβράβευσης, κουπόνια και πολλά άλλα πλεονεκτήματα από τις αγαπημένες σας εφαρμογές και παιχνίδια.';

  @override
  String get onBoardingSecondTitle =>
      'Το πορτοφόλι μας είναι κάτι πολύ περισσότερο από ένα απλό ψηφιακό πορτοφόλι.';

  @override
  String get onBoardingSecondSubtitle =>
      'Αποθηκεύστε και διαχειριστείτε τα προσωπικά σας δεδομένα και αποκτήστε πρόσβαση σε όλες τις εφαρμογές Web 3.0.';

  @override
  String get onBoardingThirdTitle =>
      'Διαχειριστείτε τα δεδομένα σας με πλήρη αυτονομία, ασφάλεια και απόρρητο.';

  @override
  String get onBoardingThirdSubtitle =>
      'Το πορτοφόλι μας χρησιμοποιεί κρυπτογραφία για να σας παρέχει πλήρη έλεγχο των δεδομένων σας. Τίποτα δεν εξέρχεται από τη συσκευή σας.';

  @override
  String get onBoardingStart => 'Έναρξη';

  @override
  String get learnMoreAboutAltme => 'Μάθετε περισσότερα για το πορτοφόλι σας';

  @override
  String get scroll => 'Κύλιση';

  @override
  String get agreeTermsAndConditionCheckBox =>
      'Συμφωνώ με τους όρους και τις προϋποθέσεις.';

  @override
  String get readTermsOfUseCheckBox => 'Έχω διαβάσει τους όρους χρήσης.';

  @override
  String get createOrImportNewAccount =>
      'Δημιουργία ή εισαγωγή νέου πορτοφολιού.';

  @override
  String get selectAccount => 'Επιλέξτε λογαριασμό';

  @override
  String get onbordingSeedPhrase => 'Φράση ανάκτησης';

  @override
  String get onboardingPleaseStoreMessage =>
      'Παρακαλώ, γράψτε τη φράση ανάκτησης σας';

  @override
  String get onboardingVerifyPhraseMessage => 'Επιβεβαιώστε τη φράση ανάκτησης';

  @override
  String get onboardingVerifyPhraseMessageDetails =>
      'Για να βεβαιωθείτε ότι η φράση ανάκτησης είναι σωστά γραμμένη, επιλέξτε τις λέξεις με τη σωστή σειρά.';

  @override
  String get onboardingAltmeMessage =>
      'Το πορτοφόλι λειτουργεί χωρίς επιμέλεια. Η φράση ανάκτησης είναι ο μόνος τρόπος για την ανάκτηση του λογαριασμού σας.';

  @override
  String get onboardingWroteDownMessage => 'Έγραψα τη φράση ανάκτησης μου';

  @override
  String get copyToClipboard => 'Αντιγραφή';

  @override
  String get pinCodeMessage =>
      'Ο κωδικός PIN αποτρέπει τη μη εξουσιοδοτημένη πρόσβαση στο πορτοφόλι σας. Μπορείτε να τον αλλάξετε ανά πάσα στιγμή.';

  @override
  String get enterNameForYourNewAccount =>
      'Εισάγετε ένα όνομα για το νέο σας λογαριασμό';

  @override
  String get create => 'Δημιουργία';

  @override
  String get import => 'Εισαγωγή';

  @override
  String get accountName => 'Όνομα πορτοφολιού';

  @override
  String get importWalletText =>
      'Εισάγετε τη φράση ανάκτησης ή το ιδιωτικό κλειδί σας εδώ.';

  @override
  String get importWalletTextRecoveryPhraseOnly =>
      'Εισάγετε τη φράση ανάκτησης εδώ.';

  @override
  String get recoveryPhraseDescriptions =>
      'Η φράση ανάκτησης είναι ένας κατάλογος 12 λέξεων που δημιουργείται από το πορτοφόλι σας και σας δίνει πρόσβαση στα κεφάλαια σας';

  @override
  String get importEasilyFrom => 'Εισάγετε τον λογαριασμό σας από:';

  @override
  String get templeWallet => 'Πορτοφόλι Temple';

  @override
  String get temple => 'Temple';

  @override
  String get metaMaskWallet => 'Πορτοφόλι MetaMask';

  @override
  String get metaMask => 'MetaΜask';

  @override
  String get kukai => 'Kukai';

  @override
  String get kukaiWallet => 'Πορτοφόλι Kukai';

  @override
  String get other => 'Άλλο';

  @override
  String get otherWalletApp => 'Άλλο πορτοφόλι';

  @override
  String importWalletHintText(Object numberCharacters) {
    return 'Μόλις εισαγάγετε τις 12 λέξεις ή όλους τους χαρακτήρες του ιδιωτικού κλειδιού, πατήστε Εισαγωγή.';
  }

  @override
  String get importWalletHintTextRecoveryPhraseOnly =>
      'Μόλις εισαγάγετε τις 12 λέξεις της φράσης ανάκτησης, πατήστε Εισαγωγή.';

  @override
  String get kycDialogTitle =>
      'Για να αποκτήσετε αυτή την κάρτα, καθώς και άλλες ταυτότητες, πρέπει να επαληθεύσετε την ταυτότητά σας';

  @override
  String get idVerificationProcess => 'Διαδικασία επαλήθευσης ταυτότητας';

  @override
  String get idCheck => 'Έλεγχος ταυτότητας';

  @override
  String get facialRecognition => 'Αναγνώριση προσώπου';

  @override
  String get kycDialogButton => 'Έναρξη επαλήθευσης ταυτότητας';

  @override
  String get kycDialogFooter =>
      'Συμμόρφωση με GDPR και CCPA + Επίπεδο ασφαλείας SOC2';

  @override
  String get finishedVerificationTitle => 'Επαλήθευση ταυτότητας\nσε εξέλιξη';

  @override
  String get finishedVerificationDescription =>
      'Θα λάβετε ένα email για να επιβεβαιώσετε ότι το αναγνωριστικό σας έχει επαληθευτεί.';

  @override
  String get verificationPendingTitle =>
      'Η επαλήθευση της ταυτότητάς σας\nεκκρεμεί';

  @override
  String get verificationPendingDescription =>
      'Συνήθως χρειάζεται λιγότερο από 5 λεπτά για να επαληθευτεί. Θα λάβετε ένα email όταν ολοκληρωθεί η επαλήθευση.';

  @override
  String get verificationDeclinedTitle => 'Η επαλήθευσή σας απορρίφθηκε';

  @override
  String get restartVerification => 'Επανεκκίνηση επαλήθευσης ταυτότητας';

  @override
  String get verificationDeclinedDescription =>
      'Η επαλήθευσή σας απορρίφθηκε. Δοκιμάστε ξανά.';

  @override
  String get verifiedTitle => 'Συγχαρητήρια! Η επαλήθευσή σας ήταν επιτυχής.';

  @override
  String get verifiedDescription =>
      'Μπορείτε τώρα να αρχίσετε να προσθέτετε την κάρτα σας \'άνω των 18\'. Ας ξεκινήσουμε.';

  @override
  String get verfiedButton => 'Προσθήκη της κάρτας άνω των 18 ετών';

  @override
  String get verifiedNotificationTitle => 'Η επαλήθευση ολοκληρώθηκε!';

  @override
  String get verifiedNotificationDescription =>
      'Συγχαρητήρια! Έχετε επαληθευτεί επιτυχώς.';

  @override
  String get showDecentralizedID => 'Εμφάνιση αποκεντρωμένης ταυτότητας';

  @override
  String get manageDecentralizedID => 'Διαχείριση αποκεντρωμένης ταυτότητας';

  @override
  String get addressBook => 'Βιβλίο διευθύνσεων';

  @override
  String get home => 'Πορτοφολι';

  @override
  String get discover => 'Discover';

  @override
  String get settings => 'Ρυθμισεις';

  @override
  String get privateKeyDescriptions =>
      'Το ιδιωτικό κλειδί είναι ένας μυστικός αριθμός που χρησιμοποιείται για την υπογραφή συναλλαγών και την απόδειξη της ιδιοκτησίας μιας διεύθυνσης blockchain. Στο Tezos, το ιδιωτικό κλειδί έχει συνήθως μήκος 54 χαρακτήρων.';

  @override
  String get importAccount => 'Εισαγωγή λογαριασμού';

  @override
  String get imported => 'Εισήχθη';

  @override
  String get cardDetails => 'Λεπτομέρειες κάρτας';

  @override
  String get publicAddress => 'Δημόσια διεύθυνση';

  @override
  String get didKey => 'Κλειδί DID';

  @override
  String get export => 'Εξαγωγή';

  @override
  String get copy => 'Αντιγραφή';

  @override
  String get didPrivateKey => 'Ιδιωτικό κλειδί DID';

  @override
  String get reveal => 'Αποκάλυψη';

  @override
  String get didPrivateKeyDescription =>
      'Παρακαλούμε να είστε πολύ προσεκτικοί με τα ιδιωτικά σας κλειδιά, επειδή ελέγχουν την πρόσβαση στις πληροφορίες των πιστοποιητικών σας.';

  @override
  String get didPrivateKeyDescriptionAlert =>
      'Παρακαλούμε μη μοιραστείτε το ιδιωτικό σας κλειδί με κανέναν. Αυτό το πορτοφόλι δεν είναι φυλασσόμενο, δε θα σας το ζητήσουμε ποτέ.';

  @override
  String get iReadTheMessageCorrectly => 'Διάβασα σωστά το μήνυμα';

  @override
  String get beCareful => 'Να είστε προσεκτικοί';

  @override
  String get decentralizedIDKey => 'Αποκεντρωμένο κλειδί ID';

  @override
  String get copySecretKeyToClipboard =>
      'Αντιγραφή μυστικού κλειδιού στο πρόχειρο!';

  @override
  String get copyDIDKeyToClipboard =>
      'Αντιγραφή του κλειδιού DID στο πρόχειρο!';

  @override
  String get seeAddress => 'Εμφάνιση διεύθυνσης';

  @override
  String get revealPrivateKey => 'Αποκάλυψη ιδιωτικού κλειδιού';

  @override
  String get share => 'Κοινοποίηση';

  @override
  String get shareWith => 'Κοινοποίηση με';

  @override
  String get copiedToClipboard => 'Αντιγραφή στο πρόχειρο!';

  @override
  String get privateKey => 'Ιδιωτικό κλειδί';

  @override
  String get decentralizedID => 'Αποκεντρωμένο αναγνωριστικό ταυτότητας';

  @override
  String get did => 'DID';

  @override
  String get sameAccountNameError =>
      'Αυτό το όνομα λογαριασμού χρησιμοποιήθηκε προηγουμένως. Εισαγάγετε ένα διαφορετικό όνομα λογαριασμού.';

  @override
  String get unknown => 'Άγνωστο';

  @override
  String get credentialManifestDescription => 'Περιγραφή';

  @override
  String get credentialManifestInformations => 'Πληροφορίες';

  @override
  String get credentialDetailsActivity => 'Δραστηριότητα';

  @override
  String get credentialDetailsOrganisation => 'Οργανισμός';

  @override
  String get credentialDetailsPresented => 'Παρουσιάστηκε';

  @override
  String get credentialDetailsOrganisationDetail => 'Λεπτομέρεια οργανισμού:';

  @override
  String get credentialDetailsInWalletSince => 'Στο πορτοφόλι από τις';

  @override
  String get termsOfUseAndLicenses => 'Όροι χρήσης και άδειες χρήσης';

  @override
  String get licenses => 'Άδειες';

  @override
  String get sendTo => 'Αποστολή στο';

  @override
  String get next => 'Συνέχεια';

  @override
  String get withdrawalInputHint => 'Αντιγραφή διεύθυνσης ή σάρωση';

  @override
  String get amount => 'Ποσό';

  @override
  String get amountSent => 'Απεσταλμένο ποσό';

  @override
  String get max => 'Max';

  @override
  String get edit => 'Επεξεργασία';

  @override
  String get networkFee => 'Εκτιμώμενο τέλος φυσικού αερίου';

  @override
  String get totalAmount => 'Συνολικό ποσό';

  @override
  String get selectToken => 'Επιλέξτε token';

  @override
  String get insufficientBalance => 'Ανεπαρκές υπόλοιπο';

  @override
  String get slow => 'Επιβραδυμένη';

  @override
  String get average => 'Μέση';

  @override
  String get fast => 'Γρήγορη';

  @override
  String get changeFee => 'Χρέωση συναλλαγής';

  @override
  String get sent => 'Αποστολή';

  @override
  String get done => 'Ολοκληρώθηκε';

  @override
  String get link => 'Κλικ για πρόσβαση';

  @override
  String get myTokens => 'Τα tokens μου';

  @override
  String get tezosMainNetwork => 'Tezos Mainnet';

  @override
  String get send => 'Αποστολή';

  @override
  String get receive => 'Λήψη';

  @override
  String get recentTransactions => 'Πρόσφατες συναλλαγές';

  @override
  String sendOnlyToThisAddressDescription(Object symbol) {
    return 'Στείλτε μόνο $symbol σε αυτή τη διεύθυνση. Η αποστολή άλλων tokens μπορεί να οδηγήσει σε μόνιμη απώλεια.';
  }

  @override
  String get addTokens => 'Προσθήκη tokens';

  @override
  String get providedBy => 'Παρέχεται από';

  @override
  String get issuedOn => 'Εκδόθηκε στις';

  @override
  String get expirationDate => 'Περίοδος ισχύος';

  @override
  String get connect => 'Σύνδεση';

  @override
  String get connection => 'Σύνδεση';

  @override
  String get selectAccountToGrantAccess =>
      'Επιλέξτε λογαριασμό για να χορηγήσετε πρόσβαση:';

  @override
  String get requestPersmissionTo => 'Αίτηση άδειας για:';

  @override
  String get viewAccountBalanceAndNFTs =>
      'Προβολή υπολοίπου λογαριασμού και NFT\'s';

  @override
  String get requestApprovalForTransaction => 'Αίτηση έγκρισης για συναλλαγή';

  @override
  String get connectedWithBeacon => 'Επιτυχής σύνδεση με dApp';

  @override
  String get failedToConnectWithBeacon => 'Απέτυχε η σύνδεση με την dApp';

  @override
  String get tezosNetwork => 'Tezos';

  @override
  String get confirm_sign => 'Επιβεβαίωση υπογραφής';

  @override
  String get sign => 'Υπογραφή';

  @override
  String get payload_to_sign => 'Φορτίο προς υπογραφή';

  @override
  String get signedPayload => 'Υπογραφή φορτίου ολοκληρώθηκε';

  @override
  String get failedToSignPayload => 'Μη επιτυχής υπογραφή';

  @override
  String get voucher => 'Κουπόνι';

  @override
  String get tezotopia => 'Tezotopia';

  @override
  String get operationCompleted =>
      'Η ζητούμενη λειτουργία ολοκληρώθηκε. Η συναλλαγή μπορεί να χρειαστεί μερικά λεπτά για να εμφανιστεί στο πορτοφόλι.';

  @override
  String get operationFailed => 'Η αιτούμενη σας λειτουργία απέτυχε';

  @override
  String get membership => 'Συνδρομή';

  @override
  String get switchNetworkMessage => 'Παρακαλούμε αλλάξτε το δίκτυο σας σε';

  @override
  String get fee => 'Χρέωση';

  @override
  String get addCards => 'Προσθήκη καρτών';

  @override
  String get gaming => 'Παιχνίδι';

  @override
  String get identity => 'Ταυτότητα';

  @override
  String get payment => 'Πληρωμή';

  @override
  String get socialMedia => 'Μέσα κοινωνικής δικτύωσης';

  @override
  String get advanceSettings => 'Προηγμένες ρυθμίσεις';

  @override
  String get categories => 'Κατηγορίες';

  @override
  String get selectCredentialCategoryWhichYouWantToShowInCredentialList =>
      'Επιλέξτε τις κατηγορίες πιστοποιητικών που θέλετε να εμφανίζονται στη λίστα πιστοποιητικών:';

  @override
  String get community => 'Κοινότητα';

  @override
  String get tezos => 'Tezos';

  @override
  String get rights => 'Δικαιώματα';

  @override
  String get disconnectAndRevokeRights => 'Αποσύνδεση & Ανάκληση δικαιωμάτων';

  @override
  String get revokeAllRights => 'Ανάκληση όλων των δικαιωμάτων';

  @override
  String get revokeSubtitleMessage =>
      'Είστε σίγουροι ότι θέλετε να ανακαλέσετε όλα τα δικαιώματα';

  @override
  String get revokeAll => 'Ανάκληση όλων';

  @override
  String get succesfullyDisconnected => 'αποσυνδέθηκε επιτυχώς από την dApp.';

  @override
  String get connectedApps => 'Συνδεδεμένες dApps';

  @override
  String get manageConnectedApps => 'Διαχείριση συνδεδεμένων dApps';

  @override
  String get noDappConnected => 'Δεν έχει συνδεθεί ακόμα dApp';

  @override
  String get nftDetails => 'λεπτομέρειες NFT\'s';

  @override
  String get failedToDoOperation => 'Αποτυχία εκτέλεσης της λειτουργίας';

  @override
  String get nft => 'NFT';

  @override
  String get receiveNft => 'Λήψη NFT';

  @override
  String get sendOnlyNftToThisAddressDescription =>
      'Στείλτε μόνο Tezos NFT σε αυτή τη διεύθυνση. Η αποστολή NFT από άλλο δίκτυο μπορεί να οδηγήσει σε μόνιμη απώλεια.';

  @override
  String get beaconShareMessage =>
      'Στείλτε μόνο Tezos(XTZ) και Tezos NFTs(FA2 Standard) σε αυτή τη διεύθυνση. Η αποστολή Tezos και NFTs από άλλα δίκτυα μπορεί να οδηγήσει σε μόνιμη απώλεια';

  @override
  String get advantagesCredentialHomeSubtitle =>
      'Επωφεληθείτε από τα αποκλειστικά πλεονεκτήματα του Web3';

  @override
  String get advantagesCredentialDiscoverSubtitle =>
      'Ανακαλύψτε τις κάρτες επιβράβευσης και τα αποκλειστικά πάσα';

  @override
  String get identityCredentialHomeSubtitle =>
      'Αποδείξτε πράγματα για τον εαυτό σας προστατεύοντας παράλληλα τα δεδομένα σας';

  @override
  String get identityCredentialDiscoverSubtitle =>
      'Αποκτήστε επαναχρησιμοποιήσιμα πιστοποιητικά KYC και επαλήθευσης ηλικίας';

  @override
  String get myProfessionalCredentialDiscoverSubtitle =>
      'Χρησιμοποιήστε τις επαγγελματικές σας κάρτες με ασφάλεια';

  @override
  String get blockchainAccountsCredentialHomeSubtitle =>
      'Αποδείξτε την ιδιοκτησία των blockchain λογαριασμών σας';

  @override
  String get educationCredentialHomeSubtitle =>
      'Αποδείξτε άμεσα το εκπαιδευτικό σας υπόβαθρο';

  @override
  String get passCredentialHomeSubtitle =>
      'Χρησιμοποιήστε αποκλειστικά Passes: Ενισχύστε την εμπειρία σας στο Web3';

  @override
  String get financeCardsCredentialHomeSubtitle =>
      'Πρόσβαση σε νέες επενδυτικές ευκαιρίες στο web3';

  @override
  String get financeCardsCredentialDiscoverSubtitle =>
      'Αποκτήστε αποκλειστικά πλεονεκτήματα που προσφέρονται από κοινότητες που σας αρέσουν';

  @override
  String get contactInfoCredentialHomeSubtitle =>
      'Μοιραστείτε άμεσα τα στοιχεία επικοινωνίας σας';

  @override
  String get contactInfoCredentialDiscoverSubtitle =>
      'Αποκτήστε πιστοποιητικά, εύκολα να μοιραστείτε';

  @override
  String get otherCredentialHomeSubtitle =>
      'Άλλοι τύποι καρτών στο πορτοφόλι σας';

  @override
  String get otherCredentialDiscoverSubtitle =>
      'Άλλοι τύποι καρτών που μπορείτε να προσθέσετε';

  @override
  String get showMore => '... περισσότερα';

  @override
  String get showLess => 'λιγότερα ...';

  @override
  String get gotIt => 'Το κατάλαβα';

  @override
  String get transactionErrorBalanceTooLow =>
      'Μια λειτουργία προσπάθησε να ξοδέψει περισσότερα κουπόνια από όσα έχει το smart contract';

  @override
  String get transactionErrorCannotPayStorageFee =>
      'Οι χρεώσεις υπερβαίνουν το υπόλοιπο του λογαριασμού σας';

  @override
  String get transactionErrorFeeTooLow =>
      'Τα τέλη λειτουργίας είναι πολύ χαμηλά';

  @override
  String get transactionErrorFeeTooLowForMempool =>
      'Τα τέλη λειτουργίας είναι πολύ χαμηλά για να θεωρηθούν';

  @override
  String get transactionErrorTxRollupBalanceTooLow =>
      'Δε διαθέτετε το απαιτούμενο υπόλοιπο';

  @override
  String get transactionErrorTxRollupInvalidZeroTransfer =>
      'Το ποσό μιας μεταφοράς πρέπει να είναι μεγαλύτερο του μηδενός.';

  @override
  String get transactionErrorTxRollupUnknownAddress =>
      'Η διεύθυνση δεν αναγνωρίζεται.';

  @override
  String get transactionErrorInactiveChain =>
      'Προσπάθεια επικύρωσης ενός block, από ανενεργό επί του παρόντος blockchain.';

  @override
  String get website => 'Ιστοσελίδα';

  @override
  String get whyGetThisCard => 'Γιατί να αποκτήσετε αυτή την κάρτα';

  @override
  String get howToGetIt => 'Πώς να την αποκτήσετε';

  @override
  String get emailPassWhyGetThisCard =>
      'Αυτή η απόδειξη μπορεί να απαιτείται από ορισμένες εφαρμογές και ιστότοπους για την πρόσβαση στις υπηρεσίες τους ή για την απόκτηση παροχών : Κάρτα μέλους, κάρτα επιβράβευσης, ανταμοιβές κ.λπ.';

  @override
  String get emailPassExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get emailPassHowToGetIt =>
      'Είναι πανεύκολο. Θα επαληθεύσουμε την ιδιοκτησία του email σας στέλνοντας έναν κωδικό μέσω email.';

  @override
  String get tezotopiaMembershipWhyGetThisCard =>
      'Αυτή η κάρτα μέλους θα σας δώσει 25% επιστροφή μετρητών σε ΟΛΕΣ τις συναλλαγές του Tezotopia όταν αγοράζετε Drops στην αγορά ή όταν κάνετε mint ένα NFT στη starbase.';

  @override
  String get tezotopiaMembershipExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get tezotopiaMembershipLongDescription =>
      'Το Tezotopia είναι ένα παιχνίδι metaverse NFT σε πραγματικό χρόνο στο Tezos, όπου οι παίκτες καλλιεργούν με Tezotops, συμμετέχουν σε μάχες για ανταμοιβές και διεκδικούν γη σε μια συναρπαστική περιπέτεια στο διάστημα με blockchain. Εξερευνήστε το metaverse, συλλέξτε NFTs και κατακτήστε την Tezotopia.';

  @override
  String get chainbornMembershipHowToGetIt =>
      'Για να λάβετε αυτή την κάρτα, πρέπει να καλέσετε έναν \"Ήρωα\" στο παιχνίδι Chainborn και μια απόδειξη ηλεκτρονικού ταχυδρομείου. Μπορείτε να βρείτε την κάρτα \"Απόδειξη ηλεκτρονικού ταχυδρομείου\" στην ενότητα \"Discover\".';

  @override
  String get chainbornMembershipWhyGetThisCard =>
      'Γίνετε ένας από τους λίγους που έχουν πρόσβαση σε αποκλειστικό περιεχόμενο του καταστήματος Chainborn, σε airdrops και σε άλλα προνόμια μόνο για τα μέλη!';

  @override
  String get chainbornMembershipExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get chainbornMembershipLongDescription =>
      'Το Chainborn είναι ένα συναρπαστικό παιχνίδι μάχης NFTs, όπου οι παίκτες χρησιμοποιούν τα δικά τους NFTs ως ήρωες, ανταγωνιζόμενοι για λάφυρα και δόξα. Συμμετέχετε σε συναρπαστικές μάχες, κερδίστε πόντους εμπειρίας για να ενισχύσετε τη δύναμη και την υγεία του ήρωά σας και ενισχύστε την αξία των NFTs σας σε αυτή τη συναρπαστική περιπέτεια που βασίζεται στο Tezos.';

  @override
  String get twitterHowToGetIt =>
      'Ακολουθήστε τα βήματα στο TezosProfiles https://tzprofiles.com/connect. Στη συνέχεια, αποκτήστε την κάρτα \"Twitter account\" στο Altme. Φροντίστε να υπογράψετε τη συναλλαγή στο TZPROFILES με τον ίδιο λογαριασμό που χρησιμοποιείτε στο Altme.';

  @override
  String get twitterWhyGetThisCard =>
      'Αυτή η κάρτα αποτελεί απόδειξη ότι είστε ιδιοκτήτης του λογαριασμού σας στο twitter. Χρησιμοποιήστε την για να αποδείξετε την ιδιοκτησία του λογαριασμού σας στο twitter όποτε το χρειάζεστε.';

  @override
  String get twitterExpirationDate =>
      'Αυτή η κάρτα θα είναι ενεργή για 1 έτος.';

  @override
  String get twitterDummyDesc =>
      'Αποδείξτε την ιδιοκτησία του λογαριασμού σας στο twitter';

  @override
  String get tezotopiaMembershipHowToGetIt =>
      'Θα πρέπει να προσκομίσετε μια απόδειξη ότι είστε άνω των 13 ετών και μια απόδειξη του email σας.';

  @override
  String get over18WhyGetThisCard =>
      'Αυτή η απόδειξη μπορεί να απαιτείται από ορισμένες εφαρμογές και ιστότοπους για την πρόσβαση στις υπηρεσίες τους ή για την απόκτηση προνομίων : Κάρτα μέλους, κάρτα επιβράβευσης, ανταμοιβές κλπ.';

  @override
  String get over18ExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get over18HowToGetIt =>
      'Μπορείτε να αποκτήσετε αυτή την κάρτα κάνοντας μια εκτίμηση ηλικίας στο πορτοφόλι.';

  @override
  String get over13WhyGetThisCard =>
      'Αυτή η απόδειξη μπορεί να απαιτείται από ορισμένες εφαρμογές και ιστότοπους για την πρόσβαση στις υπηρεσίες τους ή για την απόκτηση προνομίων : Κάρτα μέλους, κάρτα επιβράβευσης, ανταμοιβές κλπ.';

  @override
  String get over13ExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get over13HowToGetIt =>
      'Μπορείτε να αποκτήσετε αυτή την κάρτα κάνοντας μια εκτίμηση ηλικίας στο πορτοφόλι.';

  @override
  String get over15WhyGetThisCard =>
      'Αυτή η απόδειξη μπορεί να απαιτείται από ορισμένες εφαρμογές και ιστότοπους για την πρόσβαση στις υπηρεσίες τους ή για την απόκτηση προνομίων : Κάρτα μέλους, κάρτα επιβράβευσης, ανταμοιβές κλπ.';

  @override
  String get over15ExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get over15HowToGetIt =>
      'Μπορείτε να αποκτήσετε αυτή την κάρτα κάνοντας μια εκτίμηση ηλικίας στο πορτοφόλι.';

  @override
  String get passportFootprintWhyGetThisCard =>
      'Αυτή η απόδειξη μπορεί να απαιτείται από ορισμένες εφαρμογές και ιστότοπους για την πρόσβαση στις υπηρεσίες τους ή για την απόκτηση προνομίων : Κάρτα μέλους, κάρτα επιβράβευσης, ανταμοιβές κλπ.';

  @override
  String get passportFootprintExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get passportFootprintHowToGetIt =>
      'Μπορείτε να αποκτήσετε αυτή την κάρτα ακολουθώντας τον έλεγχο KYC του πορτοφολιού teh.';

  @override
  String get verifiableIdCardWhyGetThisCard =>
      'Αυτή η ψηφιακή ταυτότητα περιέχει τις ίδιες πληροφορίες με τη φυσική σας ταυτότητα. Μπορείτε να τη χρησιμοποιήσετε σε έναν ιστότοπο για έλεγχο ταυτότητας, για παράδειγμα.';

  @override
  String get verifiableIdCardExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get verifiableIdCardHowToGetIt =>
      'Μπορείτε να αποκτήσετε αυτή την κάρτα ακολουθώντας τον έλεγχο KYC του πορτοφολιού.';

  @override
  String get verifiableIdCardDummyDesc =>
      'Αποκτήστε την ψηφιακή σας ταυτότητα.';

  @override
  String get phoneProofWhyGetThisCard =>
      'Αυτή η απόδειξη μπορεί να απαιτείται από ορισμένες εφαρμογές και ιστότοπους για την πρόσβαση στις υπηρεσίες τους ή για την απόκτηση προνομίων : Κάρτα μέλους, κάρτα επιβράβευσης, ανταμοιβές κ.λπ.';

  @override
  String get phoneProofExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get phoneProofHowToGetIt =>
      'Είναι πανεύκολο. Θα επαληθεύσουμε την ιδιοκτησία του τηλεφωνικού σας αριθμού στέλνοντας έναν κωδικό μέσω sms.';

  @override
  String get tezVoucherWhyGetThisCard =>
      'Αυτή η κάρτα κουπονιού θα σας δώσει 10% επιστροφή μετρητών σε ΟΛΕΣ τις συναλλαγές του παιχνιδιού Tezotopia, όταν αγοράζετε Drops στην αγορά ή όταν κόβετε ένα NFT στη starbase.';

  @override
  String get tezVoucherExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 30 ημέρες.';

  @override
  String get tezVoucherHowToGetIt =>
      ' Είναι πανεύκολο. Μπορείτε να το αποκτήσετε δωρεάν τώρα.';

  @override
  String get genderWhyGetThisCard =>
      'Αυτή η απόδειξη φύλου είναι χρήσιμη για να αποδείξετε το φύλο σας (Άντρας/Γυναίκα) χωρίς να αποκαλύψετε άλλες πληροφορίες για εσάς. Μπορεί να χρησιμοποιηθεί σε μια έρευνα χρηστών κ.λπ.';

  @override
  String get genderExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get genderHowToGetIt =>
      'Μπορείτε να αποκτήσετε αυτή την κάρτα ακολουθώντας τον έλεγχο KYC του πορτοφολιού.';

  @override
  String get nationalityWhyGetThisCard =>
      'Αυτό το πιστοποιητικό είναι χρήσιμο για την απόδειξη της εθνικότητάς σας χωρίς να αποκαλύπτει άλλες πληροφορίες για εσάς. Μπορεί να ζητηθεί από το Web 3 Apps σε μια έρευνα χρηστών κλπ.';

  @override
  String get nationalityExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get nationalityHowToGetIt =>
      'Μπορείτε να αποκτήσετε αυτή την κάρτα ακολουθώντας τον έλεγχο KYC του πορτοφολιού.';

  @override
  String get ageRangeWhyGetThisCard =>
      'Αυτό το πιστοποιητικό είναι χρήσιμο για να αποδείξετε το εύρος ηλικίας σας χωρίς να αποκαλύψετε άλλες πληροφορίες για εσάς. Μπορεί να απαιτηθεί από το Web 3 Apps σε μια έρευνα χρηστών ή για να αποκτήσετε παροχές : Κάρτα μέλους κλπ.';

  @override
  String get ageRangeExpirationDate =>
      'Αυτή η κάρτα θα παραμείνει ενεργή και επαναχρησιμοποιήσιμη για 1 ΕΤΟΣ.';

  @override
  String get ageRangeHowToGetIt =>
      'Μπορείτε να αποκτήσετε αυτή την κάρτα κάνοντας μια εκτίμηση ηλικίας στο πορτοφόλι.';

  @override
  String get defiComplianceWhyGetThisCard =>
      'Αποκτήστε επαληθεύσιμη απόδειξη της συμμόρφωσης KYC/AML, που ζητείται από συμβατά πρωτόκολλα DeFi και Web3 dApps. Μόλις το αποκτήσετε, μπορείτε να κάνετε mint ένα μη μεταβιβάσιμο NFT με προστασία της ιδιωτικής ζωής για επαλήθευση στην αλυσίδα, χωρίς να αποκαλύπτετε προσωπικά δεδομένα.';

  @override
  String get defiComplianceExpirationDate =>
      'Αυτό το πιστοποιητικό παραμένει ενεργό για 3 μήνες. Η ανανέωση απαιτεί έναν απλό έλεγχο συμμόρφωσης, χωρίς νέο KYC.';

  @override
  String get defiComplianceHowToGetIt =>
      'Είναι εύκολο! Ολοκληρώστε έναν εφάπαξ έλεγχο KYC στο πορτοφόλι (που υποστηρίζεται από το ID360) και ζητήστε το πιστοποιητικό συμμόρφωσης DeFi.';

  @override
  String get origin => 'Προέλευση';

  @override
  String get nftTooBigToLoad => 'Φόρτωση NFT';

  @override
  String get seeTransaction => 'Δείτε τη συναλλαγή';

  @override
  String get nftListSubtitle =>
      'Εδώ είναι όλα τα NFTs και τα συλλεκτικά αντικείμενα στο λογαριασμό σας.';

  @override
  String get tokenListSubtitle =>
      'Εδώ είναι όλα τα κουπόνια στο λογαριασμό σας.';

  @override
  String get my => 'Το  μου';

  @override
  String get get => 'Αποκτήστε το';

  @override
  String get seeMoreNFTInformationOn =>
      'Δείτε περισσότερες πληροφορίες για το NFT στο';

  @override
  String get credentialStatus => 'Κατάσταση';

  @override
  String get pass => 'Pass';

  @override
  String get payloadFormatErrorMessage => 'Η μορφή είναι λανθασμένη.';

  @override
  String get thisFeatureIsNotSupportedMessage =>
      'Αυτή η λειτουργία δεν υποστηρίζεται ακόμη';

  @override
  String get myWallet => 'Το πορτοφόλι μου';

  @override
  String get ethereumNetwork => 'Δίκτυο Ethereum';

  @override
  String get fantomNetwork => 'Δίκτυο Fantom';

  @override
  String get polygonNetwork => 'Δίκτυο Polygon';

  @override
  String get binanceNetwork => 'Δίκτυο αλυσίδων BNB';

  @override
  String get step => 'Βήμα';

  @override
  String get activateBiometricsTitle =>
      'Ενεργοποίηση βιομετρικών στοιχείων\nγια να προσθέσετε ένα επίπεδο ασφαλείας';

  @override
  String get loginWithBiometricsOnBoarding => 'Σύνδεση με βιομετρικά στοιχεία';

  @override
  String get option => 'Επιλογή';

  @override
  String get start => 'Έναρξη';

  @override
  String get iAgreeToThe => 'Συμφωνώ με το ';

  @override
  String get termsAndConditions => 'Όροι και προϋποθέσεις';

  @override
  String get walletReadyTitle => 'Το πορτοφόλι σας είναι έτοιμο !';

  @override
  String get walletReadySubtitle =>
      'Ας ανακαλύψουμε τα πάντα\nWeb 3 έχει να προσφέρει.';

  @override
  String get failedToInitCamera => 'Η εκκίνησης της κάμερας απέτυχε!';

  @override
  String get chooseMethodPageOver18Title =>
      'Επιλέξτε μια μέθοδο για να λάβετε το Over 18 Proof σας';

  @override
  String get chooseMethodPageOver13Title =>
      'Επιλέξτε μια μέθοδο για να λάβετε το Over 13 Proof σας';

  @override
  String get chooseMethodPageOver15Title =>
      'Επιλέξτε μια μέθοδο για να λάβετε το Over 15 Proof σας';

  @override
  String get chooseMethodPageOver21Title =>
      'Επιλέξτε μια μέθοδο για να λάβετε την απόδειξη Over 21 Proof';

  @override
  String get chooseMethodPageOver50Title =>
      'Επιλέξτε μια μέθοδο για να λάβετε το Over 50 Proof σας';

  @override
  String get chooseMethodPageOver65Title =>
      'Επιλέξτε μια μέθοδο για να λάβετε το Over 65 Proof σας';

  @override
  String get chooseMethodPageAgeRangeTitle =>
      'Επιλέξτε μια μέθοδο για να λάβετε την απόδειξη του εύρους ηλικίας σας';

  @override
  String get chooseMethodPageVerifiableIdTitle =>
      'Επιλέξτε μια μέθοδο για να λάβετε την επαληθεύσιμη απόδειξη ταυτότητας';

  @override
  String get chooseMethodPageDefiComplianceTitle =>
      'Επιλέξτε μια μέθοδο για να λάβετε την απόδειξη συμμόρφωσης Defi σας';

  @override
  String get chooseMethodPageSubtitle =>
      'Επαληθεύστε τον εαυτό σας με μια φωτογραφία σας σε πραγματικό χρόνο ή με έναν κλασικό έλεγχο εγγράφων ταυτότητας .';

  @override
  String get kycTitle => 'Γρήγορη φωτογραφία σας (1min)';

  @override
  String get kycSubtitle => 'Επαληθεύστε αμέσως με μια φωτογραφία σας.';

  @override
  String get passbaseTitle => 'Πλήρης έλεγχος εγγράφων ταυτότητας';

  @override
  String get passbaseSubtitle =>
      'Επιβεβαιωθείτε με ταυτότητα, διαβατήριο ή άδεια οδήγησης.';

  @override
  String get verifyYourAge => 'Επαληθεύστε την ηλικία σας';

  @override
  String get verifyYourAgeSubtitle =>
      'Αυτή η διαδικασία επαλήθευσης της ηλικίας είναι πολύ εύκολη και απλή. Το μόνο που απαιτείται είναι μια φωτογραφία σε πραγματικό χρόνο.';

  @override
  String get verifyYourAgeDescription =>
      'Με την αποδοχή, συμφωνείτε ότι χρησιμοποιούμε μια φωτογραφία για να εκτιμήσουμε την ηλικία σας. Η εκτίμηση γίνεται από τον συνεργάτη μας Yoti που χρησιμοποιεί τη φωτογραφία σας μόνο για αυτόν τον σκοπό και τη διαγράφει αμέσως.\n\nΓια περισσότερες πληροφορίες, ανατρέξτε στην Πολιτική απορρήτου μας.';

  @override
  String get accept => 'Αποδοχή';

  @override
  String get decline => 'Απόρριψη';

  @override
  String get yotiCameraAppbarTitle =>
      'Παρακαλώ, τοποθετήστε το πρόσωπό σας στο κέντρο';

  @override
  String get cameraSubtitle =>
      'Έχετε 5 δευτερόλεπτα για να τραβήξετε τη φωτογραφία σας.\nΒεβαιωθείτε ότι υπάρχει αρκετό φως πριν ξεκινήσετε.';

  @override
  String get walletSecurityDescription =>
      'Προστατέψτε το πορτοφόλι σας με κωδικό Pin και βιομετρικό έλεγχο ταυτότητας';

  @override
  String get blockchainSettings => 'Ρυθμίσεις Blockchain';

  @override
  String get blockchainSettingsDescription =>
      'Διαχείριση λογαριασμών, φράσεων ανάκτησης, συνδεδεμένων DApps και δικτύων';

  @override
  String get ssi => 'Ρυθμίσεις αυτοκυριαρχικής ταυτότητας';

  @override
  String get ssiDescription =>
      'Διαχείριση αποκεντρωμένων αναγνωριστικών (DID) και επιλογών πρωτοκόλλου';

  @override
  String get helpCenter => 'Κέντρο βοήθειας';

  @override
  String get helpCenterDescription =>
      'Επικοινωνήστε μαζί μας και λάβετε υποστήριξη εάν χρειάζεστε βοήθεια για τη χρήση του πορτοφολιού σας';

  @override
  String get about => 'Σχετικά';

  @override
  String get aboutDescription =>
      'Διαβάστε σχετικά με τους όρους χρήσης, την εμπιστευτικότητα και τις άδειες χρήσης';

  @override
  String get resetWallet => 'Επαναφορά πορτοφολιού';

  @override
  String get resetWalletDescription =>
      'Διαγράψτε όλα τα δεδομένα που είναι αποθηκευμένα σε αυτή τη συσκευή και επαναφέρετε το πορτοφόλι σας.';

  @override
  String get showWalletRecoveryPhrase =>
      'Εμφάνιση φράσης ανάκτησης πορτοφολιού';

  @override
  String get showWalletRecoveryPhraseSubtitle =>
      'Η φράση ανάκτησης λειτουργεί ως εφεδρικό κλειδί για την αποκατάσταση της πρόσβασης στο πορτοφόλι σας.';

  @override
  String get blockchainNetwork => 'Δίκτυο blockchain (προεπιλογή)';

  @override
  String get contactUs => 'Επικοινωνία';

  @override
  String get officialWebsite => 'Επίσημη ιστοσελίδα';

  @override
  String get yourAppVersion => 'Η έκδοση της εφαρμογής σας';

  @override
  String get resetWalletTitle =>
      'Είστε σίγουροι ότι θέλετε να επαναφέρετε το πορτοφόλι σας ?';

  @override
  String get resetWalletSubtitle =>
      'Αυτή η ενέργεια θα διαγράψει τα δεδομένα σας. Παρακαλούμε, βεβαιωθείτε ότι έχετε αποθηκεύσει τη φράση ανάκτησης και το αρχείο αντιγράφων ασφαλείας των πιστοποιητικών σας πριν από τη διαγραφή.';

  @override
  String get resetWalletSubtitle2 =>
      'Αυτό το πορτοφόλι είναι αυτοελεγχόμενο, επομένως δεν είμαστε σε θέση να ανακτήσουμε τα χρήματα ή τα πιστοποιητικά σας για λογαριασμό σας.';

  @override
  String get resetWalletCheckBox1 => 'Έγραψα τη φράση ανάκτησης μου';

  @override
  String get resetWalletCheckBox2 =>
      'Έχω αποθηκεύσει το αρχείο πιστοποιητικών ασφαλείας μου';

  @override
  String get email => 'Ηλεκτρονικό ταχυδρομείο';

  @override
  String get fillingThisFieldIsMandatory =>
      'Η συμπλήρωση αυτού του πεδίου είναι υποχρεωτική.';

  @override
  String get yourMessage => 'Το μήνυμά σας';

  @override
  String get message => 'Μήνυμα';

  @override
  String get subject => 'Θέμα';

  @override
  String get enterAValidEmail => 'Εισάγετε ένα έγκυρο email.';

  @override
  String get failedToSendEmail => 'Η αποστολή email απέτυχε.';

  @override
  String get selectAMethodToAddAccount =>
      'Επιλέξτε μια μέθοδο για την προσθήκη λογαριασμού';

  @override
  String get createAccount => 'Δημιουργία λογαριασμού';

  @override
  String get createAccountDescription =>
      'Δημιουργήστε έναν λογαριασμό που προστατεύεται από τη φράση ανάκτησης';

  @override
  String get importAccountDescription =>
      'Εισαγωγή λογαριασμού από υπάρχον πορτοφόλι';

  @override
  String get chooseABlockchainForAccountCreation =>
      'Επιλέξτε το blockchain στο οποίο θέλετε να δημιουργήσετε έναν νέο λογαριασμό.';

  @override
  String get tezosAccount => 'Λογαριασμός Tezos';

  @override
  String get tezosAccountDescription =>
      'Δημιουργήστε μια νέα διεύθυνση blockchain Tezos';

  @override
  String get ethereumAccount => 'Λογαριασμός Ethereum';

  @override
  String get ethereumAccountDescription =>
      'Δημιουργήστε μια νέα διεύθυνση blockchain Ethereum';

  @override
  String get fantomAccount => 'Λογαριασμός Fantom';

  @override
  String get fantomAccountDescription =>
      'Δημιουργήστε μια νέα διεύθυνση blockchain Fantom';

  @override
  String get polygonAccount => 'Λογαριασμός Polygon';

  @override
  String get polygonAccountDescription =>
      'Δημιουργήστε μια νέα διεύθυνση blockchain Polygon';

  @override
  String get binanceAccount => 'Λογαριασμός BNB Chain';

  @override
  String get binanceAccountDescription =>
      'Δημιουργήστε μια νέα διεύθυνση blockchain BNB Chain';

  @override
  String get setAccountNameDescription =>
      'Θέλετε να δώσετε ένα όνομα σε αυτόν τον νέο λογαριασμό ? Χρήσιμο αν έχετε πολλούς.';

  @override
  String get letsGo => 'Πάμε!';

  @override
  String get congratulations => 'Συγχαρητήρια!';

  @override
  String get tezosAccountCreationCongratulations =>
      'Ο νέος σας λογαριασμός Tezos δημιουργήθηκε με επιτυχία.';

  @override
  String get ethereumAccountCreationCongratulations =>
      'Ο νέος σας λογαριασμός Ethereum δημιουργήθηκε με επιτυχία.';

  @override
  String get fantomAccountCreationCongratulations =>
      'Ο νέος σας λογαριασμός Fantom δημιουργήθηκε με επιτυχία.';

  @override
  String get polygonAccountCreationCongratulations =>
      'Ο νέος σας λογαριασμός Polygon δημιουργήθηκε με επιτυχία.';

  @override
  String get binanceAccountCreationCongratulations =>
      'Ο νέος σας λογαριασμός BNB Chain δημιουργήθηκε με επιτυχία.';

  @override
  String get accountImportCongratulations =>
      'Ο λογαριασμός σας έχει εισαχθεί με επιτυχία.';

  @override
  String get saveBackupCredentialTitle =>
      'Κατεβάστε το αρχείο αντιγράφων ασφαλείας.\nΦυλάξτε το σε ασφαλές μέρος.';

  @override
  String get saveBackupCredentialSubtitle =>
      'Για να ανακτήσετε όλα τα πιστοποιητικά σας θα χρειαστείτε τη φράση ανάκτησης και αυτό το αρχείο αντιγράφου ασφαλείας.';

  @override
  String get saveBackupPolygonCredentialSubtitle =>
      'Για να ανακτήσετε όλα τα πιστοποιητικά των αναγνωριστικών polygon σας θα χρειαστείτε τη φράση ανάκτησης και αυτό το αρχείο αντιγράφων ασφαλείας.';

  @override
  String get restoreCredentialStep1Title =>
      'Βήμα 1 : Εισάγετε τις 12 λέξεις της φράσης αποκατάστασης';

  @override
  String get restorePhraseTextFieldHint =>
      'Εισάγετε τη φράση ανάκτησης (ή τη μνημονική σας φράση) εδώ...';

  @override
  String get restoreCredentialStep2Title =>
      'Βήμα 2 : Ανεβάστε το αρχείο αντιγράφων ασφαλείας των πιστοποιητικών σας';

  @override
  String get loadFile => 'Φόρτωση αρχείου';

  @override
  String get uploadFile => 'Φόρτωση αρχείου';

  @override
  String get creators => 'Δημιουργοί';

  @override
  String get publishers => 'Εκδότες';

  @override
  String get creationDate => 'Ημερομηνία δημιουργίας';

  @override
  String get myProfessionalrCards => 'επαγγελματικές κάρτες';

  @override
  String get myProfessionalrCardsSubtitle =>
      'Χρησιμοποιήστε τις επαγγελματικές σας κάρτες με ασφάλεια.';

  @override
  String get guardaWallet => 'Πορτοφόλι Guarda';

  @override
  String get exodusWallet => 'Πορτοφόλι Exodus';

  @override
  String get trustWallet => 'Πορτοφόλι Trust';

  @override
  String get myetherwallet => 'Πορτοφόλι MyEther';

  @override
  String get skip => 'Παράλειψη';

  @override
  String get userNotFitErrorMessage =>
      'Δεν μπορείτε να λάβετε αυτή την κάρτα επειδή δεν πληρούνται ορισμένες προϋποθέσεις.';

  @override
  String get youAreMissing => 'Σας λείπει';

  @override
  String get credentialsRequestedBy => 'πιστοποιητικά';

  @override
  String get transactionIsLikelyToFail =>
      'Η συναλλαγή είναι πιθανό να αποτύχει.';

  @override
  String get buy => 'Αγοράστε νομίσματα';

  @override
  String get thisFeatureIsNotSupportedYetForFantom =>
      'Αυτή η λειτουργία δεν υποστηρίζεται ακόμα για το Fantom.';

  @override
  String get faqs => 'Συχνές ερωτήσεις (FAQ)';

  @override
  String get softwareLicenses => 'Άδειες χρήσης λογισμικού';

  @override
  String get notAValidWalletAddress => 'Μη έγκυρη διεύθυνση πορτοφολιού!';

  @override
  String get otherAccount => 'Άλλος λογαριασμός';

  @override
  String get thereIsNoAccountInYourWallet =>
      'Δεν υπάρχει λογαριασμός στο πορτοφόλι σας';

  @override
  String get credentialSuccessfullyExported =>
      'Το πιστοποιητικό σας εξήχθη επιτυχώς.';

  @override
  String get scanAndDisplay => 'Σάρωση και εμφάνιση';

  @override
  String get whatsNew => 'Τι νέο υπάρχει';

  @override
  String get okGotIt => 'ΟΚ, ΤΟ ΚΑΤΑΛΑΒΑ!';

  @override
  String get support => 'υποστήριξη';

  @override
  String get transactionDoneDialogDescription =>
      'Η μεταφορά μπορεί να διαρκέσει μερικά λεπτά για να ολοκληρωθεί';

  @override
  String get withdrawalFailedMessage => 'Η ανάληψη λογαριασμού ήταν ανεπιτυχής';

  @override
  String get credentialRequiredMessage =>
      'Πρέπει να έχετε τα απαιτούμενα πιστοποιητικά στο πορτοφόλι σας για να αποκτήσετε αυτή την κάρτα:';

  @override
  String get keyDecentralizedIdEdSA => 'did:key EdDSA';

  @override
  String get keyDecentralizedIDSecp256k1 => 'did:key Secp256k1';

  @override
  String get ebsiV3DecentralizedId => 'did:key EBSI P-256';

  @override
  String get requiredCredentialNotFoundTitle =>
      'Δεν μπορούμε να βρούμε το πιστοποιητικό\nπου χρειάζεστε στο πορτοφόλι σας.';

  @override
  String get requiredCredentialNotFoundSubTitle =>
      'Τα απαιτούμενα πιστοποιητικά δε βρίσκονται στο πορτοφόλι σας';

  @override
  String get requiredCredentialNotFoundDescription =>
      'Επικοινωνήστε μαζί μας στο :';

  @override
  String get backToHome => 'Επιστροφή στην αρχική σελίδα';

  @override
  String get help => 'Βοήθεια';

  @override
  String get searchCredentials => 'Αναζήτηση πιστοποιητικών';

  @override
  String get supportChatWelcomeMessage =>
      'Καλώς ήρθατε στη συνομιλία υποστήριξης! Είμαστε εδώ για να σας βοηθήσουμε με οποιεσδήποτε ερωτήσεις ή ανησυχίες έχετε σχετικά με το πορτοφόλι σας.';

  @override
  String get cardChatWelcomeMessage =>
      'Καλώς ήρθατε στη συνομιλία υποστήριξης! Είμαστε εδώ για να σας βοηθήσουμε με οποιεσδήποτε ερωτήσεις ή ανησυχίες.';

  @override
  String get creator => 'Δημιουργός';

  @override
  String get contractAddress => 'Διεύθυνση συμβολαίου';

  @override
  String get lastMetadataSync => 'Τελευταίος συγχρονισμός μεταδεδομένων';

  @override
  String get e2eEncyptedChat =>
      'Η συνομιλία είναι κρυπτογραφημένη από άκρο σε άκρο.';

  @override
  String get pincodeAttemptMessage =>
      'Έχετε πληκτρολογήσει λανθασμένο κωδικό PIN τρεις φορές. Για λόγους ασφαλείας, περιμένετε ένα λεπτό πριν προσπαθήσετε ξανά.';

  @override
  String get verifyNow => 'Επαλήθευση τώρα';

  @override
  String get verifyLater => 'Επαλήθευση αργότερα';

  @override
  String get welDone => 'Μπράβο!';

  @override
  String get mnemonicsVerifiedMessage =>
      'Η φράση ανάκτησης έχει αποθηκευτεί σωστά.';

  @override
  String get chatWith => 'Συνομιλία με';

  @override
  String get sendAnEmail => 'Αποστολή email';

  @override
  String get livenessCardHowToGetIt =>
      'Είναι εύκολο! Ολοκληρώστε έναν εφάπαξ έλεγχο KYC στο πορτοφόλι και ζητήστε ένα πιστοποιητικό Liveness.';

  @override
  String get livenessCardExpirationDate =>
      'Αυτό το πιστοποιητικό θα παραμείνει ενεργό για 1 έτος. Η ανανέωση είναι απλή.';

  @override
  String get livenessCardWhyGetThisCard =>
      'Αποκτήστε μια απόδειξη ανθρώπινης υπόστασης, η οποία απαιτείται από τα περισσότερα πρωτόκολλα DeFi ή τις εφαρμογές Web3 dApps. Μόλις το αποκτήσετε, μπορείτε να ζητήσετε ένα μη μεταβιβάσιμο NFT για να αποδείξετε την ανθρώπινη υπόστασή σας onchain.';

  @override
  String get livenessCardLongDescription =>
      'Αυτό το πιστοποιητικό είναι μια επαληθεύσιμη απόδειξη της ανθρώπινης ιδιότητας. Χρησιμοποιήστε το για να αποδείξετε ότι δεν είστε bot όταν σας ζητείται από πρωτόκολλα DeFi, παιχνίδια Onchain ή dApps Web3.';

  @override
  String get chat => 'Συνομιλία';

  @override
  String get needMnemonicVerificatinoDescription =>
      'Πρέπει να ελέγξετε τις φράσεις ανάκτησης του πορτοφολιού σας για να προστατέψετε τα στοιχεία που διαθέτετε!';

  @override
  String get succesfullyAuthenticated => 'Επιτυχής πιστοποίηση ταυτότητας.';

  @override
  String get authenticationFailed => 'Αποτυχία ελέγχου ταυτότητας.';

  @override
  String get documentType => 'Τύπος εγγράφου';

  @override
  String get countryCode => 'Κωδικός χώρας';

  @override
  String get deviceIncompatibilityMessage =>
      'Λυπούμαστε, η συσκευή σας δεν είναι συμβατή για αυτή τη λειτουργία.';

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
  String get yearsOld => 'ετών';

  @override
  String get youAreOver13 => 'Είστε άνω των 13 ετών';

  @override
  String get youAreOver15 => 'Είστε άνω των 15 ετών';

  @override
  String get youAreOver18 => 'Είστε άνω των 18 ετών';

  @override
  String get youAreOver21 => 'Είστε άνω των 21 ετών';

  @override
  String get youAreOver50 => 'Είστε άνω των 50 ετών';

  @override
  String get youAreOver65 => 'Είστε άνω των 65 ετών';

  @override
  String get polygon => 'Polygon';

  @override
  String get ebsi => 'EBSI';

  @override
  String get comingSoon => 'Σύντομα';

  @override
  String get financeCredentialsHomeTitle => 'Τα οικονομικά μου πιστοποιητικά';

  @override
  String get financeCredentialsDiscoverTitle =>
      'Αποκτήστε επαληθευμένα οικονομικά πιστοποιητικά';

  @override
  String get financeCredentialsDiscoverSubtitle =>
      'Πρόσβαση σε νέες επενδυτικές ευκαιρίες στο web3.';

  @override
  String get financeCredentialsHomeSubtitle =>
      'Πρόσβαση σε νέες επενδυτικές ευκαιρίες στο web3';

  @override
  String get hummanityProofCredentialsHomeTitle =>
      'Η απόδειξη της ανθρώπινης υπόστασης μου';

  @override
  String get hummanityProofCredentialsHomeSubtitle =>
      'Αποδείξτε εύκολα ότι είστε άνθρωπος και όχι ρομπότ.';

  @override
  String get hummanityProofCredentialsDiscoverTitle =>
      'Αποδείξτε ότι δεν είστε bot ή AI';

  @override
  String get hummanityProofCredentialsDiscoverSubtitle =>
      'Αποκτήστε μια επαναχρησιμοποιήσιμη απόδειξη της ανθρώπινης υπόστασης για να τη μοιραστείτε';

  @override
  String get socialMediaCredentialsHomeTitle =>
      'Οι λογαριασμοί μου στα μέσα κοινωνικής δικτύωσης';

  @override
  String get socialMediaCredentialsHomeSubtitle =>
      'Prove your accounts ownership instantly Proof of humanity';

  @override
  String get socialMediaCredentialsDiscoverTitle =>
      'Επαληθεύστε τους λογαριασμούς σας στα μέσα κοινωνικής δικτύωσης';

  @override
  String get socialMediaCredentialsDiscoverSubtitle =>
      'Αποδείξτε την κυριότητα των λογαριασμών σας όταν απαιτείται';

  @override
  String get walletIntegrityCredentialsHomeTitle => 'Ακεραιότητα πορτοφολιού';

  @override
  String get walletIntegrityCredentialsHomeSubtitle => 'TBD';

  @override
  String get walletIntegrityCredentialsDiscoverTitle =>
      'Ακεραιότητα του WAllet';

  @override
  String get walletIntegrityCredentialsDiscoverSubtitle => 'TBD';

  @override
  String get polygonCredentialsHomeSubtitle =>
      'Αποδείξτε τα δικαιώματα πρόσβασής σας στο οικοσύστημα Polygon';

  @override
  String get polygonCredentialsDiscoverSubtitle =>
      'Αποδείξτε τα δικαιώματα πρόσβασής σας στο οικοσύστημα Polygon';

  @override
  String get pendingCredentialsHomeTitle => 'Τα εκκρεμή πιστοποιητικά μου';

  @override
  String get pendingCredentialsHomeSubtitle =>
      'Αποδείξτε τα δικαιώματα πρόσβασής σας.';

  @override
  String get restore => 'Επαναφορά';

  @override
  String get backup => 'Δημιουργία αντιγράφων ασφαλείας';

  @override
  String get takePicture => 'Τραβήξτε μια φωτογραφία';

  @override
  String get kyc => 'KYC';

  @override
  String get aiSystemWasNotAbleToEstimateYourAge =>
      'Το σύστημα τεχνητής νοημοσύνης δεν μπόρεσε να εκτιμήσει την ηλικία σας';

  @override
  String youGotAgeCredentials(Object credential) {
    return 'Έχετε το $credential πιστοποιητικό σας.';
  }

  @override
  String yourAgeEstimationIs(Object ageEstimate) {
    return 'Η εκτίμηση της ηλικίας σας ως AI είναι $ageEstimate έτη';
  }

  @override
  String get credentialNotFound => 'Δε βρέθηκε πιστοποιητικό';

  @override
  String get cryptographicProof => 'Κρυπτογραφική απόδειξη';

  @override
  String get downloadingCircuitLoadingMessage =>
      'Λήψη κυκλωμάτων. Μπορεί να πάρει λίγο χρόνο. Παρακαλώ περιμένετε.';

  @override
  String get cryptoAccountAlreadyExistMessage =>
      'Φαίνεται ότι ένας λογαριασμός με αυτές τις πληροφορίες κρυπτογράφησης υπάρχει ήδη';

  @override
  String get errorGeneratingProof => 'Απόδειξη δημιουργίας σφάλματος';

  @override
  String get createWalletMessage => 'Δημιουργήστε πρώτα το πορτοφόλι σας.';

  @override
  String get successfullyGeneratingProof => 'Επιτυχημένη δημιουργία απόδειξη';

  @override
  String get wouldYouLikeToAcceptThisCredentialsFromThisOrganisation =>
      'Θα θέλατε να αποδεχθείτε το πιστοποιητικό(ά) από τον εν λόγω οργανισμό;';

  @override
  String get thisOrganisationRequestsThisInformation => 'Η οργάνωση αυτή ζητά';

  @override
  String get iS => 'είναι';

  @override
  String get isSmallerThan => 'είναι μικρότερη από';

  @override
  String get isBiggerThan => 'είναι μεγαλύτερη από';

  @override
  String get isOneOfTheFollowingValues => 'είναι μία από τις ακόλουθες τιμές';

  @override
  String get isNotOneOfTheFollowingValues =>
      'δεν είναι μία από τις ακόλουθες τιμές';

  @override
  String get isNot => 'δεν είναι';

  @override
  String get approve => 'Έγκριση';

  @override
  String get noInformationWillBeSharedFromThisCredentialMessage =>
      'Καμία πληροφορία δε θα κοινοποιηθεί από αυτό το πιστοποιητικό (Zero Knowledge Proof).';

  @override
  String get burn => 'Burn';

  @override
  String get wouldYouLikeToConfirmThatYouIntendToBurnThisNFT =>
      'Θέλετε πραγματικά να κάψετε αυτό το NFT;';

  @override
  String pleaseAddXtoConnectToTheDapp(Object chain) {
    return 'Προσθέστε $chain λογαριασμό για να συνδεθείτε στην εφαρμογή.';
  }

  @override
  String pleaseSwitchPolygonNetwork(Object networkType) {
    return 'Παρακαλούμε μεταβείτε στο polygon $networkType για να εκτελέσετε αυτή την ενέργεια.';
  }

  @override
  String get oidc4vcProfile => 'Προφίλ OIDC4VC';

  @override
  String get pleaseSwitchToCorrectOIDC4VCProfile =>
      'Παρακαλούμε μεταβείτε στο σωστό προφίλ OIDC4VC.';

  @override
  String get authenticationSuccess => 'Επιτυχία ελέγχου ταυτότητας';

  @override
  String get format => 'Μορφή';

  @override
  String get verifyIssuerWebsiteIdentity => 'Επιβεβαίωση πρόσβασης του εκδότη';

  @override
  String get verifyIssuerWebsiteIdentitySubtitle =>
      'Ενεργοποίηση για την επαλήθευση της ταυτότητας του εκδότη πριν από την πρόσβαση.';

  @override
  String get developerMode => 'Λειτουργία προγραμματιστή';

  @override
  String get developerModeSubtitle =>
      'Ενεργοποιήστε τη λειτουργία προγραμματιστή για πρόσβαση σε προηγμένα εργαλεία εντοπισμού σφαλμάτων';

  @override
  String get confirmVerifierAccess => 'Επιβεβαίωση πρόσβασης ελεγκτή';

  @override
  String get confirmVerifierAccessSubtitle =>
      'Απενεργοποιήστε το για να παραλείψετε την επιβεβαίωση όταν μοιράζεστε τα επαληθεύσιμα πιστοποιητικά σας.';

  @override
  String get secureAuthenticationWithPINCode =>
      'Ασφαλής έλεγχος ταυτότητας με κωδικό PIN';

  @override
  String get secureAuthenticationWithPINCodeSubtitle =>
      'Απενεργοποιήστε για να παραλείψετε τον κωδικό PIN για τον έλεγχο ταυτότητας του ιστότοπου (δε συνιστάται).';

  @override
  String youcanSelectOnlyXCredential(Object count) {
    return 'Μπορείτε να επιλέξετε μόνο τα πιστοποιητικά $count.';
  }

  @override
  String get theCredentialIsNotReady => 'Το πιστοποιητικό δεν είναι έτοιμο.';

  @override
  String get theCredentialIsNoMoreReady =>
      'Το πιστοποιητικό δεν είναι πλέον διαθέσιμο.';

  @override
  String get lowSecurity => 'Χαμηλή ασφάλεια';

  @override
  String get highSecurity => 'Υψηλή ασφάλεια';

  @override
  String get theRequestIsRejected => 'Η αίτηση απορρίπτεται.';

  @override
  String get userPinIsIncorrect => 'Το PIN χρήστη είναι λανθασμένο';

  @override
  String get security_level => 'Επίπεδο ασφαλείας';

  @override
  String get userPinTitle => 'User PIN Digits pre-authorized_code Flow';

  @override
  String get userPinSubtitle =>
      'Ενεργοποίηση για τη διαχείριση του 4ψήφιου κωδικού PIN. Προεπιλογή: 6 ψηφία.';

  @override
  String get responseTypeNotSupported => 'Ο τύπος απόκρισης δεν υποστηρίζεται';

  @override
  String get invalidRequest => 'Το αίτημα είναι άκυρο';

  @override
  String get subjectSyntaxTypeNotSupported =>
      'The subject syntax type is not supported.';

  @override
  String get accessDenied => 'Άρνηση πρόσβασης';

  @override
  String get thisRequestIsNotSupported => 'Αυτό το αίτημα δεν υποστηρίζεται';

  @override
  String get unsupportedCredential => 'Μη υποστηριζόμενο πιστοποιητικό';

  @override
  String get aloginIsRequired => 'Απαιτείται σύνδεση';

  @override
  String get userConsentIsRequired => 'Απαιτείται η συγκατάθεση του χρήστη';

  @override
  String get theWalletIsNotRegistered => 'Το πορτοφόλι δεν είναι καταχωρημένο';

  @override
  String get credentialIssuanceDenied => 'Άρνηση έκδοσης πιστοποιητικών';

  @override
  String get thisCredentialFormatIsNotSupported =>
      'Αυτή η μορφή πιστοποιητικών δεν υποστηρίζεται';

  @override
  String get thisFormatIsNotSupported => 'Αυτή η μορφή δεν υποστηρίζεται';

  @override
  String get moreDetails => 'Περισσότερες λεπτομέρειες';

  @override
  String get theCredentialOfferIsInvalid =>
      'Η προσφορά πιστοποιητικού είναι άκυρη';

  @override
  String get dateOfRequest => 'Ημερομηνία αίτησης';

  @override
  String get keyDecentralizedIDP256 => 'did:key P-256';

  @override
  String get jwkDecentralizedIDP256 => 'did:jwk P-256';

  @override
  String get defaultDid => 'Προεπιλογή DID';

  @override
  String get selectOneOfTheDid => 'Επιλέξτε ένα από τα DID';

  @override
  String get theServiceIsNotAvailable => 'Η υπηρεσία δεν είναι διαθέσιμη';

  @override
  String get issuerDID => 'Εκδότης DID';

  @override
  String get subjectDID => 'Θέμα DID';

  @override
  String get type => 'Τύπος';

  @override
  String get credentialExpired => 'Το πιστοποιητικό έχει λήξει';

  @override
  String get incorrectSignature => 'Λανθασμένη υπογραφή';

  @override
  String get revokedOrSuspendedCredential =>
      'Ανακληθέν ή ανασταλμένο πιστοποιητικό';

  @override
  String get display => 'Εμφάνιση';

  @override
  String get download => 'Λήψη';

  @override
  String get successfullyDownloaded => 'Επιτυχής λήψη';

  @override
  String get advancedSecuritySettings => 'Προηγμένες ρυθμίσεις ασφαλείας';

  @override
  String get theIssuanceOfThisCredentialIsPending =>
      'Η έκδοση του εν λόγω πιστοποιητικού εκκρεμεί';

  @override
  String get clientId => 'Ταυτότητα πελάτη';

  @override
  String get clientSecret => 'Μυστικό πελάτη';

  @override
  String get walletProfiles => 'Προφίλ πορτοφολιού';

  @override
  String get walletProfilesDescription =>
      'Επιλέξτε το προφίλ του πορτοφολιού σας ή προσαρμόστε το δικό σας';

  @override
  String get protectYourWallet => 'Προστατέψτε το πορτοφόλι σας';

  @override
  String get protectYourWalletMessage =>
      'Χρησιμοποιήστε το δακτυλικό σας αποτύπωμα, το πρόσωπο ή τον κωδικό PIN για να ασφαλίσετε και να ξεκλειδώσετε το πορτοφόλι σας. Τα δεδομένα σας κρυπτογραφούνται με ασφάλεια σε αυτή τη συσκευή.';

  @override
  String get pinUnlock => 'Ξεκλείδωμα PIN';

  @override
  String get secureWithDevicePINOnly => 'Ασφαλής μόνο με κωδικό PIN';

  @override
  String get biometricUnlock => 'Βιομετρικό ξεκλείδωμα';

  @override
  String get secureWithFingerprint =>
      'Ασφαλίστε με αναγνώριση δακτυλικού αποτυπώματος ή προσώπου';

  @override
  String get pinUnlockAndBiometric2FA => 'PIN + βιομετρικό ξεκλείδωμα (2FA)';

  @override
  String get secureWithFingerprintAndPINBackup =>
      'Ασφαλίστε με αναγνώριση δακτυλικού αποτυπώματος ή προσώπου + κωδικό PIN';

  @override
  String get secureYourWalletWithPINCodeAndBiometrics =>
      'Ασφαλίστε το πορτοφόλι σας με κωδικό PIN και βιομετρικά στοιχεία';

  @override
  String get twoFactorAuthenticationHasBeenEnabled =>
      'Ο έλεγχος ταυτότητας δύο παραγόντων έχει ενεργοποιηθεί.';

  @override
  String get initialization => 'Έναρξη λειτουργίας';

  @override
  String get login => 'Σύνδεση';

  @override
  String get password => 'Κωδικός πρόσβασης';

  @override
  String get pleaseEnterYourEmailAndYourCompanyPasswordToCreateYourAccount =>
      'Εισάγετε το email σας και τον κωδικό πρόσβασης της εταιρείας σας για να δημιουργήσετε το λογαριασμό σας.';

  @override
  String get enterTheSecurityCodeThatWeSentYouByEmail =>
      'Πληκτρολογήστε τον κωδικό ασφαλείας που σας στείλαμε με email';

  @override
  String get enterTheSecurityCode => 'Εισάγετε τον κωδικό ασφαλείας';

  @override
  String get yourEmail => 'Το email σας';

  @override
  String get publicKeyOfWalletInstance => 'Δημόσιο κλειδί του Wallet Instance';

  @override
  String get walletInstanceKey => 'Κλειδί instance πορτοφολιού';

  @override
  String get organizationProfile => 'Προφίλ οργανισμού';

  @override
  String get profileName => 'Όνομα προφίλ';

  @override
  String get companyName => 'Όνομα εταιρείας';

  @override
  String get configFileIdentifier => 'Αναγνωριστικό αρχείου διαμόρφωσης';

  @override
  String get updateYourWalletConfigNow =>
      'Ενημερώστε τη ρύθμιση παραμέτρων του πορτοφολιού σας τώρα';

  @override
  String get updateConfigurationNow => 'Ενημέρωση ρυθμίσεων τώρα';

  @override
  String
  get pleaseEnterYourEmailAndPasswordToUpdateYourOrganizationWalletConfiguration =>
      'Εισάγετε το email και τον κωδικό πρόσβασής σας για να ενημερώσετε τη διαμόρφωση του πορτοφολιού του οργανισμού σας.';

  @override
  String get congrats => 'Συγχαρητήρια!';

  @override
  String get yourWalletConfigurationHasBeenSuccessfullyUpdated =>
      'Η διαμόρφωση του πορτοφολιού σας ενημερώθηκε με επιτυχία';

  @override
  String get continueString => 'Συνεχίστε';

  @override
  String get walletProvider => 'Πάροχος πορτοφολιού';

  @override
  String get clientTypeSubtitle =>
      'Εναλλαγή για να αλλάξετε τον τύπο πελάτη. Προεπιλογή: DID.';

  @override
  String get thisTypeProofCannotBeUsedWithThisVCFormat =>
      'Αυτός ο τύπος απόδειξης δεν μπορεί να χρησιμοποιηθεί με αυτό το VC Format.';

  @override
  String get blockchainCardsDiscoverTitle =>
      'Αποκτήστε μια απόδειξη ιδιοκτησίας λογαριασμού κρυπτογράφησης';

  @override
  String get blockchainCardsDiscoverSubtitle =>
      'Αποκτήστε μια απόδειξη ιδιοκτησίας λογαριασμού κρυπτογράφησης.';

  @override
  String get successfullyAddedEnterpriseAccount =>
      'Επιτυχής προσθήκη εταιρικού λογαριασμού!';

  @override
  String get successfullyUpdatedEnterpriseAccount =>
      'Επιτυχής ενημέρωση εταιρικού λογαριασμού!';

  @override
  String get thisWalleIsAlreadyConfigured =>
      'Αυτό το πορτοφόλι είναι ήδη ρυθμισμένο';

  @override
  String get walletSettings => 'Ρυθμίσεις πορτοφολιού';

  @override
  String get walletSettingsDescription => 'Επιλέξτε τη γλώσσα και το θέμα σας';

  @override
  String get languageSelectorTitle => 'Γλώσσα';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Español';

  @override
  String get catalan => 'Català';

  @override
  String get english => 'English';

  @override
  String get phoneLanguage => 'Γλώσσα τηλεφώνου';

  @override
  String get cardIsValid => 'Η κάρτα είναι έγκυρη';

  @override
  String get cardIsExpired => 'Η κάρτα έχει λήξει';

  @override
  String get signatureIsInvalid => 'Η υπογραφή είναι άκυρη';

  @override
  String get statusIsInvalid => 'Η κατάσταση είναι άκυρη';

  @override
  String get statuslListSignatureFailed =>
      'Η υπογραφή της λίστας κατάστασης απέτυχε';

  @override
  String get statusList => 'Κατάλογος κατάστασης';

  @override
  String get statusListIndex => 'Ευρετήριο καταλόγου κατάστασης';

  @override
  String get theWalletIsSuspended => 'Το πορτοφόλι έχει ανασταλεί.';

  @override
  String get jwkThumbprintP256Key => 'JWK αποτύπωμα αντίχειρα P-256';

  @override
  String get walletBlockedPopupTitle => 'Αποκλεισμός 10 λεπτών';

  @override
  String get walletBlockedPopupDescription =>
      'Πολλές αποτυχημένες προσπάθειες, το πορτοφόλι σας έχει μπλοκαριστεί για την ασφάλειά σας.\nΜπορείτε να επαναφέρετε το πορτοφόλι σας για να το χρησιμοποιήσετε ξανά.';

  @override
  String get deleteMyWalletForWrontPincodeTitle =>
      'Φραγή λογαριασμού μετά από 3 ανεπιτυχείς προσπάθειες';

  @override
  String get deleteMyWalletForWrontPincodeDescription =>
      'Για την ασφάλειά σας, πρέπει να επαναφέρετε το πορτοφόλι σας για να το χρησιμοποιήσετε ξανά.';

  @override
  String get walletBloced => 'Λογαριασμός μπλοκαρισμένος';

  @override
  String get deleteMyWallet => 'Διαγραφή του λογαριασμού μου';

  @override
  String get pincodeRules =>
      'Ο μυστικός σας κωδικός δεν μπορεί να είναι μια ακολουθία ή να έχει 4 ίδια ψηφία.';

  @override
  String get pincodeSerie => 'Δεν μπορείτε να έχετε 4 πανομοιότυπα ψηφία.';

  @override
  String get pincodeSequence => 'Δεν μπορείτε να έχετε μια ακολουθία 4 ψηφίων.';

  @override
  String get pincodeDifferent =>
      'Λανθασμένος κωδικός.\nΟι δύο κωδικοί δεν είναι ίδιοι.';

  @override
  String codeSecretIncorrectDescription(Object count, Object plural) {
    return 'Να είστε προσεκτικοί, $count επιχειρήστε$plural αριστερά.';
  }

  @override
  String get languageSettings => 'Ρυθμίσεις γλώσσας';

  @override
  String get languageSettingsDescription => 'Επιλέξτε τη γλώσσα σας';

  @override
  String get themeSettings => 'Ρυθμίσεις θέματος';

  @override
  String get themeSettingsDescription => 'Επιλέξτε το θέμα σας';

  @override
  String couldNotFindTheAccountWithThisAddress(Object address) {
    return 'Δε βρέθηκε η διεύθυνση $address στη λίστα λογαριασμών σας.';
  }

  @override
  String deleteAccountMessage(Object account) {
    return 'Είστε βέβαιοι ότι θέλετε να διαγράψετε το $account;';
  }

  @override
  String get cannotDeleteCurrentAccount =>
      'Λυπούμαστε, δεν μπορείτε να διαγράψετε τον τρέχοντα λογαριασμό';

  @override
  String get invalidClientErrorDescription =>
      'Το client_id δεν συμμορφώνεται με το client_id_scheme';

  @override
  String get vpFormatsNotSupportedErrorDescription =>
      'Το πορτοφόλι δεν υποστηρίζει καμία από τις μορφές που ζητούνται από τον ελεγκτή, όπως αυτές που περιλαμβάνονται στην παράμετρο καταχώρισης vp_formats.';

  @override
  String get invalidPresentationDefinitionUriErrorDescription =>
      'Η διεύθυνση URL του Ορισμού παρουσίασης δεν είναι προσβάσιμη.';

  @override
  String get toStopDisplayingThisPopupDeactivateTheDeveloperModeInTheSettings =>
      'Για να σταματήσετε να εμφανίζετε αυτό το αναδυόμενο παράθυρο, απενεργοποιήστε τη λειτουργία \'developer mode\' στις ρυθμίσεις.';

  @override
  String get warningDialogSubtitle =>
      'Η φράση ανάκτησης περιέχει ευαίσθητες πληροφορίες. Παρακαλούμε, φροντίστε να τις κρατήσετε απόρρητες.';

  @override
  String get accountPrivateKeyAlert =>
      'Η φράση ανάκτησης περιέχει ευαίσθητες πληροφορίες. Παρακαλούμε, φροντίστε να τις κρατήσετε απόρρητες.';

  @override
  String get etherlinkNetwork => 'Δίκτυο Etherlink';

  @override
  String get etherlinkAccount => 'Λογαριασμός Etherlink';

  @override
  String get etherlinkAccountDescription =>
      'Δημιουργήστε μια νέα διεύθυνση blockchain Etherlink';

  @override
  String get etherlinkAccountCreationCongratulations =>
      'Ο νέος σας λογαριασμός Etherlink δημιουργήθηκε με επιτυχία.';

  @override
  String get etherlinkProofMessage => '';

  @override
  String get notification => 'Ειδοποίηση';

  @override
  String get notifications => 'Ειδοποιήσεις';

  @override
  String get notificationTitle =>
      'Καλώς ήρθατε στην αίθουσα ειδοποιήσεων!\nΜείνετε ενημερωμένοι με σημαντικές ενημερώσεις.';

  @override
  String get chatRoom => 'Δωμάτιο συνομιλίας';

  @override
  String get notificationRoom => 'Αίθουσα ειδοποιήσεων';

  @override
  String get notificationSubtitle => 'Ενεργοποίηση για λήψη ειδοποιήσεων';

  @override
  String get header => 'Κεφαλίδα';

  @override
  String get payload => 'Ωφέλιμο φορτίο';

  @override
  String get data => 'Δεδομένα';

  @override
  String get keyBindingHeader => 'Επικεφαλίδα δέσμευσης κλειδιών';

  @override
  String get keyBindingPayload => 'Payload δέσμευσης κλειδιού';

  @override
  String get ebsiV4DecentralizedId => 'did:κλειδί EBSI V4 P-256';

  @override
  String get noNotificationsYet => 'Δεν υπάρχουν ακόμη ειδοποιήσεις';

  @override
  String get activityLog => 'Ημερολόγιο δραστηριότητας';

  @override
  String get activityLogDescription => 'Δείτε τις δραστηριότητές σας';

  @override
  String get walletInitialized => 'Αρχικοποίηση πορτοφολιού';

  @override
  String get backupCredentials => 'Αντίγραφα ασφαλείας πιστοποιητικών';

  @override
  String get restoredCredentials => 'Αποκατεστημένα πιστοποιητικά';

  @override
  String deletedCredential(Object credential) {
    return 'Διαγραμμένα πιστοποιητικά $credential';
  }

  @override
  String presentedCredential(Object credential, Object domain) {
    return 'Παρουσιασμένο πιστοποιητικό $credential σε $domain';
  }

  @override
  String get keysImported => 'Εισαγόμενα κλειδιά';

  @override
  String get approveProfileTitle => 'Εγκατάσταση διαμόρφωσης';

  @override
  String approveProfileDescription(Object company) {
    return 'Συμφωνείτε να εγκαταστήσετε τη διαμόρφωση του $company;';
  }

  @override
  String get updateProfileTitle => 'Ενημέρωση ρυθμίσεων';

  @override
  String updateProfileDescription(Object company) {
    return 'Συμφωνείτε να ενημερώσετε τη διαμόρφωση του $company;';
  }

  @override
  String get replaceProfileTitle => 'Εγκαταστήστε μια νέα διαμόρφωση';

  @override
  String replaceProfileDescription(Object company) {
    return 'Συμφωνείτε να αντικαταστήσετε την τρέχουσα διαμόρφωση με εκείνη του $company;';
  }

  @override
  String get saveBackupCredentialSubtitle2 =>
      'Για να ανακτήσετε όλα τα πιστοποιητικά σας θα χρειαστείτε αυτό το αρχείο αντιγράφων ασφαλείας.';

  @override
  String get createWallet => 'Δημιουργία πορτοφολιού';

  @override
  String get restoreWallet => 'Επαναφορά πορτοφολιού';

  @override
  String get showWalletRecoveryPhraseSubtitle2 =>
      'Αυτή η φράση αποκατάστασης ζητείται για την αποκατάσταση ενός πορτοφολιού κατά την εγκατάσταση.';

  @override
  String get documentation => 'Τεκμηρίωση';

  @override
  String get restoreACryptoWallet =>
      'Επαναφορά ενός πορτοφολιού κρυπτογράφησης';

  @override
  String restoreAnAppBackup(Object appName) {
    return 'Επαναφορά ενός αντιγράφου ασφαλείας $appName';
  }

  @override
  String get credentialPickShare => 'Μοιραστείτε το';

  @override
  String get credentialPickTitle =>
      'Επιλέξτε τα πιστοποιητικά που θέλετε να αποκτήσετε';

  @override
  String get credentialShareTitle =>
      'Επιλέξτε τα πιστοποιητικά προς κοινή χρήση';

  @override
  String get enterYourSecretCode => 'Εισάγετε τον μυστικό σας κωδικό.';

  @override
  String get jwk => 'JWK';

  @override
  String get typeYourPINCodeToOpenTheWallet =>
      'Πληκτρολογήστε τον κωδικό PIN σας για να ανοίξετε το πορτοφόλι';

  @override
  String get typeYourPINCodeToShareTheData =>
      'Πληκτρολογήστε τον κωδικό PIN σας για να μοιραστείτε δεδομένα';

  @override
  String get typeYourPINCodeToAuthenticate =>
      'Πληκτρολογήστε τον κωδικό PIN σας για να πιστοποιήσετε την ταυτότητά σας';

  @override
  String get credentialIssuanceIsStillPending =>
      'Η έκδοση πιστοποιητικών εκκρεμεί ακόμη';

  @override
  String get bakerFee => 'Αμοιβή Baker';

  @override
  String get storageFee => 'Κόστος αποθήκευσης';

  @override
  String get doYouWantToSetupTheProfile => 'Θέλετε να ρυθμίσετε το προφίλ;';

  @override
  String get thisFeatureIsNotSupportedYetForEtherlink =>
      'Αυτή η λειτουργία δεν υποστηρίζεται ακόμη για την αλυσίδα Etherlink.';

  @override
  String get walletSecurityAndBackup =>
      'Ασφάλεια πορτοφολιού και δημιουργία αντιγράφων ασφαλείας';

  @override
  String addedCredential(Object credential, Object domain) {
    return 'Προστέθηκε το πιστοποιητικό $credential από τον $domain';
  }

  @override
  String get reject => 'Απόρριψη';

  @override
  String get operation => 'Επιχείρηση';

  @override
  String get chooseYourSSIProfileOrCustomizeYourOwn =>
      'Επιλέξτε το προφίλ του πορτοφολιού σας ή προσαρμόστε το δικό σας';

  @override
  String get recoveryPhraseIncorrectErrorMessage =>
      'Παρακαλώ δοκιμάστε ξανά με τη σωστή παραγγελία.';

  @override
  String get invalidCode => 'Μη έγκυρος κωδικός';

  @override
  String get back => 'Πίσω';

  @override
  String get greek => 'Ελληνικά';

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
