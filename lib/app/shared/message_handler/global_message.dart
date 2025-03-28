import 'package:altme/l10n/l10n.dart';

class GlobalMessage {
  GlobalMessage(this.l10n);

  final AppLocalizations l10n;

  String get RESPONSE_STRING_livenessCardHowToGetIt =>
      l10n.livenessCardHowToGetIt;

  String get RESPONSE_STRING_livenessCardExpirationDate =>
      l10n.livenessCardExpirationDate;

  String get RESPONSE_STRING_livenessCardWhyGetThisCard =>
      l10n.livenessCardWhyGetThisCard;

  String get RESPONSE_STRING_BALANCE_TOO_LOW =>
      l10n.transactionErrorBalanceTooLow;

  String get RESPONSE_STRING_CANNOT_PAY_STORAGE_FEE =>
      l10n.transactionErrorCannotPayStorageFee;

  String get RESPONSE_STRING_FEE_TOO_LOW => l10n.transactionErrorFeeTooLow;

  String get RESPONSE_STRING_FEE_TOO_LOW_FOR_MEMPOOL =>
      l10n.transactionErrorFeeTooLowForMempool;

  String get RESPONSE_STRING_TX_ROLLUP_BALANCE_TOO_LOW =>
      l10n.transactionErrorTxRollupBalanceTooLow;

  String get RESPONSE_STRING_TX_ROLLUP_INVALID_ZERO_TRANSFER =>
      l10n.transactionErrorTxRollupInvalidZeroTransfer;

  String get RESPONSE_STRING_TX_ROLLUP_UNKNOWN_ADDRESS =>
      l10n.transactionErrorTxRollupUnknownAddress;

  String get RESPONSE_STRING_INACTIVE_CHAIN =>
      l10n.transactionErrorInactiveChain;

  String get NETWORK_ERROR_NOT_IMPLEMENTED => l10n.networkErrorNotImplemented;

  String get NETWORK_ERROR_REQUEST_CANCELLED =>
      l10n.networkErrorRequestCancelled;

  String get NETWORK_ERROR_INTERNAL_SERVER_ERROR =>
      l10n.networkErrorInternalServerError;

  String get NETWORK_ERROR_SERVICE_UNAVAILABLE =>
      l10n.networkErrorServiceUnavailable;

  String get NETWORK_ERROR_METHOD_NOT_ALLOWED =>
      l10n.networkErrorMethodNotAllowed;

  String get NETWORK_ERROR_BAD_REQUEST => l10n.networkErrorBadRequest;

  String get NETWORK_ERROR_UNAUTHORIZED_REQUEST =>
      l10n.networkErrorUnauthorizedRequest;

  String get NETWORK_ERROR_UNEXPECTED_ERROR => l10n.networkErrorUnexpectedError;

  String get NETWORK_ERROR_REQUEST_TIMEOUT => l10n.networkErrorRequestTimeout;

  String get NETWORK_ERROR_NO_INTERNET_CONNECTION =>
      l10n.networkErrorNoInternetConnection;

  String get NETWORK_ERROR_CONFLICT => l10n.networkErrorConflict;

  String get NETWORK_ERROR_PRECONDITION_FAILED =>
      l10n.networkErrorPreconditionFailed;

  String get NETWORK_ERROR_SEND_TIMEOUT => l10n.networkErrorSendTimeout;

  String get NETWORK_ERROR_UNABLE_TO_PROCESS =>
      l10n.networkErrorUnableToProcess;

  String get NETWORK_ERROR_NOT_ACCEPTABLE => l10n.networkErrorNotAcceptable;

  String get NETWORK_ERROR_GATEWAY_TIMEOUT => l10n.networkErrorGatewayTimeout;

  String get NETWORK_ERROR_TOO_MANY_REQUESTS =>
      l10n.networkErrorTooManyRequests;

  String get NETWORK_ERROR_UNAUTHENTICATED => l10n.networkErrorUnauthenticated;

  String get NETWORK_ERROR_NOT_FOUND => l10n.networkErrorNotFound;

  String get NETWORK_ERROR_NOT_READY => '';

  String get RESPONSE_STRING_FAILED_TO_LOAD_PROFILE => l10n.failedToLoadProfile;

  String get RESPONSE_STRING_FAILED_TO_DO_OPERATION => l10n.failedToDoOperation;

  String get RESPONSE_STRING_FAILED_TO_SAVE_PROFILE => l10n.failedToSaveProfile;

  String get RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL =>
      l10n.failedToCreateSelfIssuedCredential;

  String get RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL =>
      l10n.failedToVerifySelfIssuedCredential;

  String get RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY =>
      l10n.selfIssuedCreatedSuccessfully;

  String get RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR =>
      l10n.backupCredentialError;

  String get STORAGE_PERMISSION_DENIED_MESSAGE => l10n.needStoragePermission;

  String get RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE =>
      l10n.backupCredentialSuccessMessage;

  String get RESPONSE_STRING_credentialSuccessfullyExported =>
      l10n.credentialSuccessfullyExported;

  String get RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE =>
      l10n.recoveryCredentialJSONFormatErrorMessage;

  String get RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE =>
      l10n.recoveryCredentialAuthErrorMessage;

  String get RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE =>
      l10n.recoveryCredentialDefaultErrorMessage;

  String get RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE =>
      l10n.credentialAddedMessage;

  String get RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE =>
      l10n.credentialDetailEditSuccessMessage;

  String get RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE =>
      l10n.credentialDetailDeleteSuccessMessage;

  String get RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING =>
      l10n.credentialVerificationReturnWarning;

  String get RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL =>
      l10n.failedToVerifyCredential;

  String get RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED =>
      l10n.anUnknownErrorHappened;

  String get RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER =>
      l10n.somethingsWentWrongTryAgainLater;

  String get RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL =>
      l10n.successfullyPresentedYourCredential;

  String get RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID =>
      l10n.successfullyPresentedYourDID;

  String get RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED =>
      l10n.thisQRCodeIsNotSupported;

  String get RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE =>
      l10n.thisUrlDoseNotContainAValidMessage;

  String get RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER =>
      l10n.anErrorOccurredWhileConnectingToTheServer;

  String get RESPONSE_STRING_ERROR_GENERATING_KEY => l10n.errorGeneratingKey;

  String get RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN =>
      l10n.failedToSaveMnemonicPleaseTryAgain;

  String get RESPONSE_STRING_FAILED_TO_LOAD_DID => l10n.failedToLoadDID;

  String get RESPONSE_STRING_SCAN_REFUSE_HOST => l10n.scanRefuseHost;

  String get RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY =>
      l10n.pleaseImportYourRSAKey;

  String get RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY =>
      l10n.pleaseEnterYourDIDKey;

  String get RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY =>
      l10n.rsaNotMatchedWithDIDKey;

  String get RESPONSE_STRING_DID_KEY_NOT_RESOLVED => l10n.didKeyNotResolved;

  String get RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY =>
      l10n.didKeyAndRSAKeyVerifiedSuccessfully;

  String get RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA =>
      l10n.unableToProcessTheData;

  String get RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE =>
      l10n.scanUnsupportedMessage;

  String get RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE =>
      l10n.unimplementedQueryType;

  String get RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE =>
      l10n.personalOpenIdRestrictionMessage;

  String get RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR =>
      l10n.credentialEmptyError;

  String get RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED => l10n.cryptoAddedMessage;

  String get RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON =>
      l10n.connectedWithBeacon;

  String get RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON =>
      l10n.failedToConnectWithBeacon;

  String get RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD => l10n.signedPayload;

  String get RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD =>
      l10n.failedToSignPayload;

  String get RESPONSE_STRING_OPERATION_COMPLETED => l10n.operationCompleted;

  String get RESPONSE_STRING_OPERATION_FAILED => l10n.operationFailed;

  String get RESPONSE_STRING_INSUFFICIENT_BALANCE => l10n.insufficientBalance;

  String get RESPONSE_STRING_SWITCH_NETWORK_MESSAGE =>
      l10n.switchNetworkMessage;

  String get RESPONSE_STRING_DISCONNECTED_FROM_DAPP =>
      l10n.succesfullyDisconnected;

  String get RESPONSE_STRING_emailPassWhyGetThisCard =>
      l10n.emailPassWhyGetThisCard;
  String get RESPONSE_STRING_emailPassExpirationDate =>
      l10n.emailPassExpirationDate;
  String get RESPONSE_STRING_emailPassHowToGetIt => l10n.emailPassHowToGetIt;

  String get RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard =>
      l10n.tezotopiaMembershipWhyGetThisCard;
  String get RESPONSE_STRING_tezotopiaMembershipExpirationDate =>
      l10n.tezotopiaMembershipExpirationDate;
  String get RESPONSE_STRING_tezotopiaMembershipHowToGetIt =>
      l10n.tezotopiaMembershipHowToGetIt;

  String get RESPONSE_STRING_chainbornMembershipWhyGetThisCard =>
      l10n.chainbornMembershipWhyGetThisCard;
  String get RESPONSE_STRING_chainbornMembershipExpirationDate =>
      l10n.chainbornMembershipExpirationDate;
  String get RESPONSE_STRING_chainbornMembershipHowToGetIt =>
      l10n.chainbornMembershipHowToGetIt;

  String get RESPONSE_STRING_twitterWhyGetThisCard =>
      l10n.twitterWhyGetThisCard;
  String get RESPONSE_STRING_twitterExpirationDate =>
      l10n.twitterExpirationDate;
  String get RESPONSE_STRING_twitterHowToGetIt => l10n.twitterHowToGetIt;
  String get RESPONSE_STRING_twitterDummyDesc => l10n.twitterDummyDesc;

  String get RESPONSE_STRING_over18WhyGetThisCard => l10n.over18WhyGetThisCard;
  String get RESPONSE_STRING_over18ExpirationDate => l10n.over18ExpirationDate;
  String get RESPONSE_STRING_over18HowToGetIt => l10n.over18HowToGetIt;
  String get RESPONSE_STRING_over13WhyGetThisCard => l10n.over13WhyGetThisCard;
  String get RESPONSE_STRING_over13ExpirationDate => l10n.over13ExpirationDate;
  String get RESPONSE_STRING_over13HowToGetIt => l10n.over13HowToGetIt;
  String get RESPONSE_STRING_over15WhyGetThisCard => l10n.over15WhyGetThisCard;
  String get RESPONSE_STRING_over15ExpirationDate => l10n.over15ExpirationDate;
  String get RESPONSE_STRING_over15HowToGetIt => l10n.over15HowToGetIt;
  String get RESPONSE_STRING_passportFootprintWhyGetThisCard =>
      l10n.passportFootprintWhyGetThisCard;
  String get RESPONSE_STRING_passportFootprintExpirationDate =>
      l10n.passportFootprintExpirationDate;
  String get RESPONSE_STRING_passportFootprintHowToGetIt =>
      l10n.passportFootprintHowToGetIt;
  String get RESPONSE_STRING_verifiableIdCardWhyGetThisCard =>
      l10n.verifiableIdCardWhyGetThisCard;
  String get RESPONSE_STRING_verifiableIdCardExpirationDate =>
      l10n.verifiableIdCardExpirationDate;
  String get RESPONSE_STRING_verifiableIdCardHowToGetIt =>
      l10n.verifiableIdCardHowToGetIt;
  String get RESPONSE_STRING_phoneProofWhyGetThisCard =>
      l10n.phoneProofWhyGetThisCard;
  String get RESPONSE_STRING_phoneProofExpirationDate =>
      l10n.phoneProofExpirationDate;
  String get RESPONSE_STRING_phoneProofHowToGetIt => l10n.phoneProofHowToGetIt;
  String get RESPONSE_STRING_tezVoucherWhyGetThisCard =>
      l10n.tezVoucherWhyGetThisCard;
  String get RESPONSE_STRING_tezVoucherExpirationDate =>
      l10n.tezVoucherExpirationDate;
  String get RESPONSE_STRING_tezVoucherHowToGetIt => l10n.tezVoucherHowToGetIt;
  String get RESPONSE_STRING_genderWhyGetThisCard => l10n.genderWhyGetThisCard;
  String get RESPONSE_STRING_genderExpirationDate => l10n.genderExpirationDate;
  String get RESPONSE_STRING_genderHowToGetIt => l10n.genderHowToGetIt;
  String get RESPONSE_STRING_nationalityWhyGetThisCard =>
      l10n.nationalityWhyGetThisCard;
  String get RESPONSE_STRING_nationalityExpirationDate =>
      l10n.nationalityExpirationDate;
  String get RESPONSE_STRING_nationalityHowToGetIt =>
      l10n.nationalityHowToGetIt;
  String get RESPONSE_STRING_ageRangeWhyGetThisCard =>
      l10n.ageRangeWhyGetThisCard;
  String get RESPONSE_STRING_ageRangeExpirationDate =>
      l10n.ageRangeExpirationDate;
  String get RESPONSE_STRING_ageRangeHowToGetIt => l10n.ageRangeHowToGetIt;
  String get RESPONSE_STRING_defiComplianceWhyGetThisCard =>
      l10n.defiComplianceWhyGetThisCard;
  String get RESPONSE_STRING_defiComplianceExpirationDate =>
      l10n.defiComplianceExpirationDate;
  String get RESPONSE_STRING_defiComplianceHowToGetIt =>
      l10n.defiComplianceHowToGetIt;

  String get RESPONSE_STRING_payloadFormatErrorMessage =>
      l10n.payloadFormatErrorMessage;
  String get RESPONSE_STRING_thisFeatureIsNotSupportedMessage =>
      l10n.thisFeatureIsNotSupportedMessage;
  String get RESPONSE_STRING_userNotFitErrorMessage =>
      l10n.userNotFitErrorMessage;
  String get RESPONSE_STRING_transactionIsLikelyToFail =>
      l10n.transactionIsLikelyToFail;
  String get RESPONSE_STRING_verifiableIdCardDummyDesc =>
      l10n.verifiableIdCardDummyDesc;
  String get RESPONSE_STRING_tezotopiaMembershipLongDescription =>
      l10n.tezotopiaMembershipLongDescription;
  String get RESPONSE_STRING_chainbornMembershipLongDescription =>
      l10n.chainbornMembershipLongDescription;

  String get RESPONSE_STRING_livenessCardLongDescription =>
      l10n.livenessCardLongDescription;
  String get RESPONSE_STRING_succesfullyAuthenticated =>
      l10n.succesfullyAuthenticated;
  String get RESPONSE_STRING_authenticationFailed => l10n.authenticationFailed;
  String get RESPONSE_STRING_deviceIncompatibilityMessage =>
      l10n.deviceIncompatibilityMessage;
  String get RESPONSE_STRING_downloadingCircuitLoadingMessage =>
      l10n.downloadingCircuitLoadingMessage;
  String get RESPONSE_STRING_CRYPTO_ACCOUNT_ALREADY_EXIST =>
      l10n.cryptoAccountAlreadyExistMessage;
  String get RESPONSE_STRING_errorGeneratingProof => l10n.errorGeneratingProof;
  String get RESPONSE_STRING_successfullyGeneratingProof =>
      l10n.successfullyGeneratingProof;
  String RESPONSE_STRING_pleaseAddXtoConnectToTheDapp(String value) =>
      l10n.pleaseAddXtoConnectToTheDapp(value);
  String RESPONSE_STRING_pleaseSwitchPolygonNetwork(String value) =>
      l10n.pleaseSwitchPolygonNetwork(value);

  String get RESPONSE_STRING_pleaseSwitchToCorrectOIDC4VCProfile =>
      l10n.pleaseSwitchToCorrectOIDC4VCProfile;
  String get RESPONSE_STRING_authenticationSuccess =>
      l10n.authenticationSuccess;

  String RESPONSE_STRING_youcanSelectOnlyXCredential(String value) =>
      l10n.youcanSelectOnlyXCredential(value);
  String get RESPONSE_STRING_theCredentialIsNotReady =>
      l10n.theCredentialIsNotReady;
  String get RESPONSE_STRING_theCredentialIsNoMoreReady =>
      l10n.theCredentialIsNoMoreReady;
  String get RESPONSE_STRING_theRequestIsRejected => l10n.theRequestIsRejected;
  String get RESPONSE_STRING_userPinIsIncorrect => l10n.userPinIsIncorrect;
  String get RESPONSE_STRING_invalidRequest => l10n.invalidRequest;
  String get RESPONSE_STRING_responseTypeNotSupported =>
      l10n.responseTypeNotSupported;
  String get RESPONSE_STRING_subjectSyntaxTypeNotSupported =>
      l10n.subjectSyntaxTypeNotSupported;
  String get RESPONSE_STRING_accessDenied => l10n.accessDenied;
  String get RESPONSE_STRING_thisRequestIsNotSupported =>
      l10n.thisRequestIsNotSupported;
  String get RESPONSE_STRING_unsupportedCredential =>
      l10n.unsupportedCredential;
  String get RESPONSE_STRING_aloginIsRequired => l10n.aloginIsRequired;
  String get RESPONSE_STRING_userConsentIsRequired =>
      l10n.userConsentIsRequired;
  String get RESPONSE_STRING_theWalletIsNotRegistered =>
      l10n.theWalletIsNotRegistered;
  String get RESPONSE_STRING_credentialIssuanceDenied =>
      l10n.credentialIssuanceDenied;
  String get RESPONSE_STRING_credentialIssuanceIsStillPending =>
      l10n.credentialIssuanceIsStillPending;
  String get RESPONSE_STRING_thisCredentialFormatIsNotSupported =>
      l10n.thisCredentialFormatIsNotSupported;
  String get RESPONSE_STRING_thisFormatIsNotSupported =>
      l10n.thisFormatIsNotSupported;
  String get RESPONSE_STRING_theCredentialOfferIsInvalid =>
      l10n.theCredentialOfferIsInvalid;
  String get RESPONSE_STRING_theServiceIsNotAvailable =>
      l10n.theServiceIsNotAvailable;
  String get RESPONSE_STRING_theIssuanceOfThisCredentialIsPending =>
      l10n.theIssuanceOfThisCredentialIsPending;
  String get RESPONSE_STRING_successfullyAddedEnterpriseAccount =>
      l10n.successfullyAddedEnterpriseAccount;
  String get RESPONSE_STRING_successfullyUpdatedEnterpriseAccount =>
      l10n.successfullyUpdatedEnterpriseAccount;
  String get RESPONSE_STRING_thisWalleIsAlreadyConfigured =>
      l10n.thisWalleIsAlreadyConfigured;
  String get RESPONSE_STRING_invalidStatus => l10n.statusIsInvalid;
  String get RESPONSE_STRING_statusListInvalidSignature =>
      l10n.statuslListSignatureFailed;
  String get RESPONSE_STRING_theWalletIsSuspended => l10n.theWalletIsSuspended;
  String RESPONSE_STRING_couldNotFindTheAccountWithThisAddress(String value) =>
      l10n.couldNotFindTheAccountWithThisAddress(value);

  String get RESPONSE_STRING_invalidClientErrorDescription =>
      l10n.invalidClientErrorDescription;

  String get RESPONSE_STRING_vpFormatsNotSupportedErrorDescription =>
      l10n.vpFormatsNotSupportedErrorDescription;

  String get RESPONSE_STRING_invalidPresentationDefinitionUriErrorDescription =>
      l10n.invalidPresentationDefinitionUriErrorDescription;

  String get RESPONSE_STRING_recoveryPhraseIncorrectErrorMessage =>
      l10n.recoveryPhraseIncorrectErrorMessage;

  String get RESPONSE_STRING_invalidCode => l10n.invalidCode;
}
