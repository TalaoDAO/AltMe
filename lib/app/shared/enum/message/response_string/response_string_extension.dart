part of 'response_string.dart';

extension ResponseStringX on ResponseString {
  String localise(BuildContext context, {String? injectedMessage}) {
    final GlobalMessage globalMessage = GlobalMessage(context.l10n);
    switch (this) {
      case ResponseString.RESPONSE_STRING_livenessCardHowToGetIt:
        return globalMessage.RESPONSE_STRING_livenessCardHowToGetIt;

      case ResponseString.RESPONSE_STRING_livenessCardExpirationDate:
        return globalMessage.RESPONSE_STRING_livenessCardExpirationDate;

      case ResponseString.RESPONSE_STRING_livenessCardWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_livenessCardWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_BALANCE_TOO_LOW:
        return globalMessage.RESPONSE_STRING_BALANCE_TOO_LOW;

      case ResponseString.RESPONSE_STRING_CANNOT_PAY_STORAGE_FEE:
        return globalMessage.RESPONSE_STRING_CANNOT_PAY_STORAGE_FEE;

      case ResponseString.RESPONSE_STRING_FEE_TOO_LOW:
        return globalMessage.RESPONSE_STRING_FEE_TOO_LOW;

      case ResponseString.RESPONSE_STRING_FEE_TOO_LOW_FOR_MEMPOOL:
        return globalMessage.RESPONSE_STRING_FEE_TOO_LOW_FOR_MEMPOOL;

      case ResponseString.RESPONSE_STRING_TX_ROLLUP_BALANCE_TOO_LOW:
        return globalMessage.RESPONSE_STRING_TX_ROLLUP_BALANCE_TOO_LOW;

      case ResponseString.RESPONSE_STRING_TX_ROLLUP_INVALID_ZERO_TRANSFER:
        return globalMessage.RESPONSE_STRING_TX_ROLLUP_INVALID_ZERO_TRANSFER;

      case ResponseString.RESPONSE_STRING_TX_ROLLUP_UNKNOWN_ADDRESS:
        return globalMessage.RESPONSE_STRING_TX_ROLLUP_UNKNOWN_ADDRESS;

      case ResponseString.RESPONSE_STRING_INACTIVE_CHAIN:
        return globalMessage.RESPONSE_STRING_INACTIVE_CHAIN;

      case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE:
        return globalMessage.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE;

      case ResponseString.RESPONSE_STRING_FAILED_TO_DO_OPERATION:
        return globalMessage.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE;

      case ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE:
        return globalMessage.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE;

      case ResponseString
            .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL:
        return globalMessage
            .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL;

      case ResponseString
            .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL:
        return globalMessage
            .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL;

      case ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY:
        return globalMessage.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY;

      case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR:
        return globalMessage.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR;

      case ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE:
        return globalMessage.STORAGE_PERMISSION_DENIED_MESSAGE;

      case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE:
        return globalMessage.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE;

      case ResponseString.RESPONSE_STRING_credentialSuccessfullyExported:
        return globalMessage.RESPONSE_STRING_credentialSuccessfullyExported;

      case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE;

      case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE;

      case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE;

      case ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE:
        return globalMessage.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE;

      case ResponseString
            .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE;

      case ResponseString
            .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE;

      case ResponseString
            .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING:
        return globalMessage
            .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING;

      case ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL:
        return globalMessage.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL;

      case ResponseString.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED:
        return globalMessage.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED;

      case ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER:
        return globalMessage
            .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER;

      case ResponseString
            .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL:
        return globalMessage
            .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL;

      case ResponseString.RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID:
        return globalMessage.RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID;

      case ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED:
        return globalMessage.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED;

      case ResponseString
            .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE;

      case ResponseString
            .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER:
        return globalMessage
            .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER;

      case ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY:
        return globalMessage.RESPONSE_STRING_ERROR_GENERATING_KEY;

      case ResponseString
            .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN:
        return globalMessage
            .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN;

      case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_DID:
        return globalMessage.RESPONSE_STRING_FAILED_TO_LOAD_DID;

      case ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST:
        return globalMessage.RESPONSE_STRING_SCAN_REFUSE_HOST;

      case ResponseString.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY:
        return globalMessage.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY;

      case ResponseString.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY:
        return globalMessage.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY;

      case ResponseString.RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY:
        return globalMessage.RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY;

      case ResponseString.RESPONSE_STRING_DID_KEY_NOT_RESOLVED:
        return globalMessage.RESPONSE_STRING_DID_KEY_NOT_RESOLVED;

      case ResponseString
            .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY:
        return globalMessage
            .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY;

      case ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA:
        return globalMessage.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA;

      case ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE:
        return globalMessage.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE;

      case ResponseString.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE:
        return globalMessage.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE;

      case ResponseString.RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE:
        return globalMessage
            .RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE;

      case ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR:
        return globalMessage.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR;

      case ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED:
        return globalMessage.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED;

      case ResponseString.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON:
        return globalMessage.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON;

      case ResponseString.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON:
        return globalMessage.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON;

      case ResponseString.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD:
        return globalMessage.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD;

      case ResponseString.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD:
        return globalMessage.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD;

      case ResponseString.RESPONSE_STRING_OPERATION_COMPLETED:
        return globalMessage.RESPONSE_STRING_OPERATION_COMPLETED;

      case ResponseString.RESPONSE_STRING_OPERATION_FAILED:
        return globalMessage.RESPONSE_STRING_OPERATION_FAILED;

      case ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE:
        return globalMessage.RESPONSE_STRING_INSUFFICIENT_BALANCE;

      case ResponseString.RESPONSE_STRING_SWITCH_NETWORK_MESSAGE:
        return globalMessage.RESPONSE_STRING_SWITCH_NETWORK_MESSAGE;

      case ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP:
        return globalMessage.RESPONSE_STRING_DISCONNECTED_FROM_DAPP;

      case ResponseString.RESPONSE_STRING_emailPassWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_emailPassWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_emailPassExpirationDate:
        return globalMessage.RESPONSE_STRING_emailPassExpirationDate;

      case ResponseString.RESPONSE_STRING_emailPassHowToGetIt:
        return globalMessage.RESPONSE_STRING_emailPassHowToGetIt;

      case ResponseString.RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_tezotopiaMembershipExpirationDate:
        return globalMessage.RESPONSE_STRING_tezotopiaMembershipExpirationDate;

      case ResponseString.RESPONSE_STRING_tezotopiaMembershipHowToGetIt:
        return globalMessage.RESPONSE_STRING_tezotopiaMembershipHowToGetIt;

      case ResponseString.RESPONSE_STRING_chainbornMembershipWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_chainbornMembershipWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_chainbornMembershipExpirationDate:
        return globalMessage.RESPONSE_STRING_chainbornMembershipExpirationDate;

      case ResponseString.RESPONSE_STRING_chainbornMembershipHowToGetIt:
        return globalMessage.RESPONSE_STRING_chainbornMembershipHowToGetIt;

      case ResponseString.RESPONSE_STRING_twitterWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_twitterWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_twitterDummyDesc:
        return globalMessage.RESPONSE_STRING_twitterDummyDesc;

      case ResponseString.RESPONSE_STRING_twitterExpirationDate:
        return globalMessage.RESPONSE_STRING_twitterExpirationDate;

      case ResponseString.RESPONSE_STRING_twitterHowToGetIt:
        return globalMessage.RESPONSE_STRING_twitterHowToGetIt;

      case ResponseString.RESPONSE_STRING_over18WhyGetThisCard:
        return globalMessage.RESPONSE_STRING_over18WhyGetThisCard;

      case ResponseString.RESPONSE_STRING_over18ExpirationDate:
        return globalMessage.RESPONSE_STRING_over18ExpirationDate;

      case ResponseString.RESPONSE_STRING_over18HowToGetIt:
        return globalMessage.RESPONSE_STRING_over18HowToGetIt;

      case ResponseString.RESPONSE_STRING_over13WhyGetThisCard:
        return globalMessage.RESPONSE_STRING_over13WhyGetThisCard;

      case ResponseString.RESPONSE_STRING_over13ExpirationDate:
        return globalMessage.RESPONSE_STRING_over13ExpirationDate;

      case ResponseString.RESPONSE_STRING_over13HowToGetIt:
        return globalMessage.RESPONSE_STRING_over13HowToGetIt;

      case ResponseString.RESPONSE_STRING_over15WhyGetThisCard:
        return globalMessage.RESPONSE_STRING_over15WhyGetThisCard;

      case ResponseString.RESPONSE_STRING_over15ExpirationDate:
        return globalMessage.RESPONSE_STRING_over15ExpirationDate;

      case ResponseString.RESPONSE_STRING_over15HowToGetIt:
        return globalMessage.RESPONSE_STRING_over15HowToGetIt;

      case ResponseString.RESPONSE_STRING_passportFootprintWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_passportFootprintWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_passportFootprintExpirationDate:
        return globalMessage.RESPONSE_STRING_passportFootprintExpirationDate;

      case ResponseString.RESPONSE_STRING_passportFootprintHowToGetIt:
        return globalMessage.RESPONSE_STRING_passportFootprintHowToGetIt;

      case ResponseString.RESPONSE_STRING_verifiableIdCardWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_verifiableIdCardWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_verifiableIdCardExpirationDate:
        return globalMessage.RESPONSE_STRING_verifiableIdCardExpirationDate;

      case ResponseString.RESPONSE_STRING_verifiableIdCardHowToGetIt:
        return globalMessage.RESPONSE_STRING_verifiableIdCardHowToGetIt;

      case ResponseString.RESPONSE_STRING_phoneProofWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_phoneProofWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_phoneProofExpirationDate:
        return globalMessage.RESPONSE_STRING_phoneProofExpirationDate;

      case ResponseString.RESPONSE_STRING_phoneProofHowToGetIt:
        return globalMessage.RESPONSE_STRING_phoneProofHowToGetIt;

      case ResponseString.RESPONSE_STRING_tezVoucherWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_tezVoucherWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_tezVoucherExpirationDate:
        return globalMessage.RESPONSE_STRING_tezVoucherExpirationDate;

      case ResponseString.RESPONSE_STRING_tezVoucherHowToGetIt:
        return globalMessage.RESPONSE_STRING_tezVoucherHowToGetIt;

      case ResponseString.RESPONSE_STRING_genderWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_genderWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_genderExpirationDate:
        return globalMessage.RESPONSE_STRING_genderExpirationDate;

      case ResponseString.RESPONSE_STRING_genderHowToGetIt:
        return globalMessage.RESPONSE_STRING_genderHowToGetIt;

      case ResponseString.RESPONSE_STRING_nationalityWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_nationalityWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_nationalityExpirationDate:
        return globalMessage.RESPONSE_STRING_nationalityExpirationDate;

      case ResponseString.RESPONSE_STRING_nationalityHowToGetIt:
        return globalMessage.RESPONSE_STRING_nationalityHowToGetIt;

      case ResponseString.RESPONSE_STRING_ageRangeWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_ageRangeWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_ageRangeExpirationDate:
        return globalMessage.RESPONSE_STRING_ageRangeExpirationDate;

      case ResponseString.RESPONSE_STRING_ageRangeHowToGetIt:
        return globalMessage.RESPONSE_STRING_ageRangeHowToGetIt;

      case ResponseString.RESPONSE_STRING_defiComplianceWhyGetThisCard:
        return globalMessage.RESPONSE_STRING_defiComplianceWhyGetThisCard;

      case ResponseString.RESPONSE_STRING_defiComplianceExpirationDate:
        return globalMessage.RESPONSE_STRING_defiComplianceExpirationDate;

      case ResponseString.RESPONSE_STRING_defiComplianceHowToGetIt:
        return globalMessage.RESPONSE_STRING_defiComplianceHowToGetIt;

      case ResponseString.RESPONSE_STRING_payloadFormatErrorMessage:
        return globalMessage.RESPONSE_STRING_payloadFormatErrorMessage;

      case ResponseString.RESPONSE_STRING_thisFeatureIsNotSupportedMessage:
        return globalMessage.RESPONSE_STRING_thisFeatureIsNotSupportedMessage;

      case ResponseString.RESPONSE_STRING_userNotFitErrorMessage:
        return globalMessage.RESPONSE_STRING_userNotFitErrorMessage;

      case ResponseString.RESPONSE_STRING_transactionIsLikelyToFail:
        return globalMessage.RESPONSE_STRING_transactionIsLikelyToFail;

      case ResponseString.RESPONSE_STRING_verifiableIdCardDummyDesc:
        return globalMessage.RESPONSE_STRING_verifiableIdCardDummyDesc;

      case ResponseString.RESPONSE_STRING_tezotopiaMembershipLongDescription:
        return globalMessage.RESPONSE_STRING_tezotopiaMembershipLongDescription;

      case ResponseString.RESPONSE_STRING_chainbornMembershipLongDescription:
        return globalMessage.RESPONSE_STRING_chainbornMembershipLongDescription;

      case ResponseString.RESPONSE_STRING_livenessCardLongDescription:
        return globalMessage.RESPONSE_STRING_livenessCardLongDescription;

      case ResponseString.RESPONSE_STRING_succesfullyAuthenticated:
        return globalMessage.RESPONSE_STRING_succesfullyAuthenticated;

      case ResponseString.RESPONSE_STRING_authenticationFailed:
        return globalMessage.RESPONSE_STRING_authenticationFailed;

      case ResponseString.RESPONSE_STRING_deviceIncompatibilityMessage:
        return globalMessage.RESPONSE_STRING_deviceIncompatibilityMessage;

      case ResponseString.RESPONSE_STRING_downloadingCircuitLoadingMessage:
        return globalMessage.RESPONSE_STRING_downloadingCircuitLoadingMessage;

      case ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ALREADY_EXIST:
        return globalMessage.RESPONSE_STRING_CRYPTO_ACCOUNT_ALREADY_EXIST;

      case ResponseString.RESPONSE_STRING_errorGeneratingProof:
        return globalMessage.RESPONSE_STRING_errorGeneratingProof;

      case ResponseString.RESPONSE_STRING_successfullyGeneratingProof:
        return globalMessage.RESPONSE_STRING_successfullyGeneratingProof;

      case ResponseString.RESPONSE_STRING_pleaseAddXtoConnectToTheDapp:
        return globalMessage.RESPONSE_STRING_pleaseAddXtoConnectToTheDapp(
          injectedMessage ?? '',
        );

      case ResponseString.RESPONSE_STRING_pleaseSwitchPolygonNetwork:
        return globalMessage.RESPONSE_STRING_pleaseSwitchPolygonNetwork(
          injectedMessage ?? '',
        );

      case ResponseString.RESPONSE_STRING_pleaseSwitchToRightOIDC4VCProfile:
        return globalMessage
            .RESPONSE_STRING_pleaseSwitchToCorrectOIDC4VCProfile;

      case ResponseString.RESPONSE_STRING_authenticationSuccess:
        return globalMessage.RESPONSE_STRING_authenticationSuccess;

      case ResponseString.RESPONSE_STRING_youcanSelectOnlyXCredential:
        return globalMessage.RESPONSE_STRING_youcanSelectOnlyXCredential(
          injectedMessage ?? '',
        );

      case ResponseString.RESPONSE_STRING_theCredentialIsNotReady:
        return globalMessage.RESPONSE_STRING_theCredentialIsNotReady;

      case ResponseString.RESPONSE_STRING_theCredentialIsNoMoreReady:
        return globalMessage.RESPONSE_STRING_theCredentialIsNoMoreReady;

      case ResponseString.RESPONSE_STRING_theRequestIsRejected:
        return globalMessage.RESPONSE_STRING_theRequestIsRejected;

      case ResponseString.RESPONSE_STRING_userPinIsIncorrect:
        return globalMessage.RESPONSE_STRING_userPinIsIncorrect;

      case ResponseString.RESPONSE_STRING_responseTypeNotSupported:
        return globalMessage.RESPONSE_STRING_responseTypeNotSupported;

      case ResponseString.RESPONSE_STRING_invalidRequest:
        return globalMessage.RESPONSE_STRING_invalidRequest;

      case ResponseString.RESPONSE_STRING_subjectSyntaxTypeNotSupported:
        return globalMessage.RESPONSE_STRING_subjectSyntaxTypeNotSupported;

      case ResponseString.RESPONSE_STRING_accessDenied:
        return globalMessage.RESPONSE_STRING_accessDenied;

      case ResponseString.RESPONSE_STRING_thisRequestIsNotSupported:
        return globalMessage.RESPONSE_STRING_thisRequestIsNotSupported;

      case ResponseString.RESPONSE_STRING_unsupportedCredential:
        return globalMessage.RESPONSE_STRING_unsupportedCredential;

      case ResponseString.RESPONSE_STRING_aloginIsRequired:
        return globalMessage.RESPONSE_STRING_aloginIsRequired;

      case ResponseString.RESPONSE_STRING_userConsentIsRequired:
        return globalMessage.RESPONSE_STRING_userConsentIsRequired;

      case ResponseString.RESPONSE_STRING_theWalletIsNotRegistered:
        return globalMessage.RESPONSE_STRING_theWalletIsNotRegistered;

      case ResponseString.RESPONSE_STRING_credentialIssuanceDenied:
        return globalMessage.RESPONSE_STRING_credentialIssuanceDenied;

      case ResponseString.RESPONSE_STRING_credentialIssuanceIsStillPending:
        return globalMessage.RESPONSE_STRING_credentialIssuanceIsStillPending;

      case ResponseString.RESPONSE_STRING_thisCredentialFormatIsNotSupported:
        return globalMessage.RESPONSE_STRING_thisCredentialFormatIsNotSupported;

      case ResponseString.RESPONSE_STRING_thisFormatIsNotSupported:
        return globalMessage.RESPONSE_STRING_thisFormatIsNotSupported;

      case ResponseString.RESPONSE_STRING_theCredentialOfferIsInvalid:
        return globalMessage.RESPONSE_STRING_theCredentialOfferIsInvalid;

      case ResponseString.RESPONSE_STRING_theServiceIsNotAvailable:
        return globalMessage.RESPONSE_STRING_theServiceIsNotAvailable;

      case ResponseString.RESPONSE_STRING_theIssuanceOfThisCredentialIsPending:
        return globalMessage
            .RESPONSE_STRING_theIssuanceOfThisCredentialIsPending;

      case ResponseString.RESPONSE_STRING_successfullyAddedEnterpriseAccount:
        return globalMessage.RESPONSE_STRING_successfullyAddedEnterpriseAccount;

      case ResponseString.RESPONSE_STRING_successfullyUpdatedEnterpriseAccount:
        return globalMessage
            .RESPONSE_STRING_successfullyUpdatedEnterpriseAccount;

      case ResponseString.RESPONSE_STRING_thisWalleIsAlreadyConfigured:
        return globalMessage.RESPONSE_STRING_thisWalleIsAlreadyConfigured;

      case ResponseString.RESPONSE_STRING_invalidStatus:
        return globalMessage.RESPONSE_STRING_invalidStatus;

      case ResponseString.RESPONSE_STRING_statusListInvalidSignature:
        return globalMessage.RESPONSE_STRING_statusListInvalidSignature;

      case ResponseString.RESPONSE_STRING_theWalletIsSuspended:
        return globalMessage.RESPONSE_STRING_theWalletIsSuspended;

      case ResponseString.RESPONSE_STRING_couldNotFindTheAccountWithThisAddress:
        return globalMessage
            .RESPONSE_STRING_couldNotFindTheAccountWithThisAddress(
          injectedMessage ?? '',
        );

      case ResponseString.RESPONSE_STRING_invalidClientErrorDescription:
        return globalMessage.RESPONSE_STRING_invalidClientErrorDescription;

      case ResponseString.RESPONSE_STRING_vpFormatsNotSupportedErrorDescription:
        return globalMessage
            .RESPONSE_STRING_vpFormatsNotSupportedErrorDescription;

      case ResponseString
            .RESPONSE_STRING_invalidPresentationDefinitionUriErrorDescription:
        return globalMessage
            .RESPONSE_STRING_invalidPresentationDefinitionUriErrorDescription;

      case ResponseString.RESPONSE_STRING_recoveryPhraseIncorrectErrorMessage:
        return globalMessage
            .RESPONSE_STRING_recoveryPhraseIncorrectErrorMessage;

      case ResponseString.RESPONSE_STRING_invalidCode:
        return globalMessage.RESPONSE_STRING_invalidCode;
    }
  }
}
