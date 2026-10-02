import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class ResponseMessage with MessageHandler {
  ResponseMessage({this.message, this.data});

  final ResponseString? message;
  final dynamic data;

  @override
  String getMessage(
    BuildContext context,
    MessageHandler messageHandler, {
    String? injectedMessage,
  }) {
    if (messageHandler is ResponseMessage && messageHandler.message != null) {
      switch (messageHandler.message!) {
        case ResponseString.RESPONSE_STRING_livenessCardWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_livenessCardWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_livenessCardExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_livenessCardExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_livenessCardHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_livenessCardHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_BALANCE_TOO_LOW:
          final message = ResponseString.RESPONSE_STRING_BALANCE_TOO_LOW
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_CANNOT_PAY_STORAGE_FEE:
          final message = ResponseString.RESPONSE_STRING_CANNOT_PAY_STORAGE_FEE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_FEE_TOO_LOW:
          final message = ResponseString.RESPONSE_STRING_FEE_TOO_LOW.localise(
            context,
          );
          return message;

        case ResponseString.RESPONSE_STRING_FEE_TOO_LOW_FOR_MEMPOOL:
          final message = ResponseString.RESPONSE_STRING_FEE_TOO_LOW_FOR_MEMPOOL
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_TX_ROLLUP_BALANCE_TOO_LOW:
          final message = ResponseString
              .RESPONSE_STRING_TX_ROLLUP_BALANCE_TOO_LOW
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_TX_ROLLUP_INVALID_ZERO_TRANSFER:
          final message = ResponseString
              .RESPONSE_STRING_TX_ROLLUP_INVALID_ZERO_TRANSFER
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_TX_ROLLUP_UNKNOWN_ADDRESS:
          final message = ResponseString
              .RESPONSE_STRING_TX_ROLLUP_UNKNOWN_ADDRESS
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_INACTIVE_CHAIN:
          final message = ResponseString.RESPONSE_STRING_INACTIVE_CHAIN
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE:
          final message = ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE:
          final message = ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL:
          final message = ResponseString
              .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL:
          final message = ResponseString
              .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY:
          final message = ResponseString
              .RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR:
          final message = ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR
              .localise(context);
          return message;

        case ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE:
          final message = ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_credentialSuccessfullyExported:
          final message = ResponseString
              .RESPONSE_STRING_credentialSuccessfullyExported.localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING:
          final message = ResponseString
              .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL:
          final message = ResponseString
              .RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED:
          final message = ResponseString
              .RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER:
          final message = ResponseString
              .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL:
          final message = ResponseString
              .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID:
          final message = ResponseString
              .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED:
          final message = ResponseString
              .RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER:
          final message = ResponseString
              .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY:
          final message = ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN:
          final message = ResponseString
              .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_DID:
          final message = ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_DID
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST:
          final message = ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY:
          final message = ResponseString
              .RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY:
          final message = ResponseString
              .RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY:
          final message = ResponseString
              .RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_DID_KEY_NOT_RESOLVED:
          final message = ResponseString.RESPONSE_STRING_DID_KEY_NOT_RESOLVED
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY:
          final message = ResponseString
              .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA:
          final message = ResponseString
              .RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE:
          final message = ResponseString
              .RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE
              .localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE:
          final message = ResponseString
              .RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR:
          final message = ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED:
          final message = ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON:
          final message = ResponseString
              .RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON:
          final message = ResponseString
              .RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD:
          final message = ResponseString
              .RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD:
          final message = ResponseString
              .RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_OPERATION_COMPLETED:
          final message = ResponseString.RESPONSE_STRING_OPERATION_COMPLETED
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_OPERATION_FAILED:
          final message = ResponseString.RESPONSE_STRING_OPERATION_FAILED
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE:
          final message = ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_SWITCH_NETWORK_MESSAGE:
          final message = ResponseString.RESPONSE_STRING_SWITCH_NETWORK_MESSAGE
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP:
          final message = ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_FAILED_TO_DO_OPERATION:
          final message = ResponseString.RESPONSE_STRING_FAILED_TO_DO_OPERATION
              .localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_emailPassWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_emailPassWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_emailPassExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_emailPassExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_emailPassHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_emailPassHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard:
          final message =
              ResponseString
                  .RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_tezotopiaMembershipExpirationDate:
          final message =
              ResponseString
                  .RESPONSE_STRING_tezotopiaMembershipExpirationDate.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_tezotopiaMembershipHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_tezotopiaMembershipHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_chainbornMembershipWhyGetThisCard:
          final message =
              ResponseString
                  .RESPONSE_STRING_chainbornMembershipWhyGetThisCard.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_chainbornMembershipExpirationDate:
          final message =
              ResponseString
                  .RESPONSE_STRING_chainbornMembershipExpirationDate.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_chainbornMembershipHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_chainbornMembershipHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_twitterWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_twitterWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_twitterExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_twitterExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_twitterHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_twitterHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_twitterDummyDesc:
          final message =
              ResponseString.RESPONSE_STRING_twitterDummyDesc.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over18WhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_over18WhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over18ExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_over18ExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over18HowToGetIt:
          final message =
              ResponseString.RESPONSE_STRING_over18HowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over13WhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_over13WhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over13ExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_over13ExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over13HowToGetIt:
          final message =
              ResponseString.RESPONSE_STRING_over13HowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over15WhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_over15WhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over15ExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_over15ExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_over15HowToGetIt:
          final message =
              ResponseString.RESPONSE_STRING_over15HowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_passportFootprintWhyGetThisCard:
          final message =
              ResponseString
                  .RESPONSE_STRING_passportFootprintWhyGetThisCard.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_passportFootprintExpirationDate:
          final message =
              ResponseString
                  .RESPONSE_STRING_passportFootprintExpirationDate.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_passportFootprintHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_passportFootprintHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_verifiableIdCardWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_verifiableIdCardWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_verifiableIdCardExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_verifiableIdCardExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_verifiableIdCardHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_verifiableIdCardHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_phoneProofWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_phoneProofWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_phoneProofExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_phoneProofExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_phoneProofHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_phoneProofHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_tezVoucherWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_tezVoucherWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_tezVoucherExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_tezVoucherExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_tezVoucherHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_tezVoucherHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_genderWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_genderWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_genderExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_genderExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_genderHowToGetIt:
          final message =
              ResponseString.RESPONSE_STRING_genderHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_nationalityWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_nationalityWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_nationalityExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_nationalityExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_nationalityHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_nationalityHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_ageRangeWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_ageRangeWhyGetThisCard.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_ageRangeExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_ageRangeExpirationDate.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_ageRangeHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_ageRangeHowToGetIt.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_payloadFormatErrorMessage:
          final message = ResponseString
              .RESPONSE_STRING_payloadFormatErrorMessage.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_thisFeatureIsNotSupportedMessage:
          final message =
              ResponseString
                  .RESPONSE_STRING_thisFeatureIsNotSupportedMessage.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_userNotFitErrorMessage:
          final message = ResponseString
              .RESPONSE_STRING_userNotFitErrorMessage.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_transactionIsLikelyToFail:
          final message = ResponseString
              .RESPONSE_STRING_transactionIsLikelyToFail.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_verifiableIdCardDummyDesc:
          final message = ResponseString
              .RESPONSE_STRING_verifiableIdCardDummyDesc.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_tezotopiaMembershipLongDescription:
          final message =
              ResponseString
                  .RESPONSE_STRING_tezotopiaMembershipLongDescription.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_chainbornMembershipLongDescription:
          final message =
              ResponseString
                  .RESPONSE_STRING_chainbornMembershipLongDescription.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_livenessCardLongDescription:
          final message = ResponseString
              .RESPONSE_STRING_livenessCardLongDescription.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_succesfullyAuthenticated:
          final message = ResponseString
              .RESPONSE_STRING_succesfullyAuthenticated.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_authenticationFailed:
          final message = ResponseString
              .RESPONSE_STRING_authenticationFailed.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_deviceIncompatibilityMessage:
          final message = ResponseString
              .RESPONSE_STRING_deviceIncompatibilityMessage.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_downloadingCircuitLoadingMessage:
          final message =
              ResponseString
                  .RESPONSE_STRING_downloadingCircuitLoadingMessage.localise(
                context,
              );
          return message;
        case ResponseString.RESPONSE_STRING_defiComplianceWhyGetThisCard:
          final message = ResponseString
              .RESPONSE_STRING_defiComplianceWhyGetThisCard.localise(context);
          return message;
        case ResponseString.RESPONSE_STRING_defiComplianceExpirationDate:
          final message = ResponseString
              .RESPONSE_STRING_defiComplianceExpirationDate.localise(context);
          return message;
        case ResponseString.RESPONSE_STRING_defiComplianceHowToGetIt:
          final message = ResponseString
              .RESPONSE_STRING_defiComplianceHowToGetIt.localise(context);
          return message;
        case ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ALREADY_EXIST:
          final message = ResponseString
              .RESPONSE_STRING_CRYPTO_ACCOUNT_ALREADY_EXIST
              .localise(context);
          return message;
        case ResponseString.RESPONSE_STRING_errorGeneratingProof:
          final message = ResponseString
              .RESPONSE_STRING_errorGeneratingProof.localise(context);
          return message;
        case ResponseString.RESPONSE_STRING_successfullyGeneratingProof:
          final message = ResponseString
              .RESPONSE_STRING_successfullyGeneratingProof.localise(context);
          return message;
        case ResponseString.RESPONSE_STRING_pleaseAddXtoConnectToTheDapp:
          final message =
              ResponseString
                  .RESPONSE_STRING_pleaseAddXtoConnectToTheDapp.localise(
                context,
                injectedMessage: injectedMessage,
              );
          return message;
        case ResponseString.RESPONSE_STRING_pleaseSwitchPolygonNetwork:
          final message =
              ResponseString
                  .RESPONSE_STRING_pleaseSwitchPolygonNetwork.localise(
                context,
                injectedMessage: injectedMessage,
              );
          return message;

        case ResponseString.RESPONSE_STRING_pleaseSwitchToRightOIDC4VCProfile:
          final message =
              ResponseString
                  .RESPONSE_STRING_pleaseSwitchToRightOIDC4VCProfile.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_authenticationSuccess:
          final message = ResponseString
              .RESPONSE_STRING_authenticationSuccess.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_youcanSelectOnlyXCredential:
          final message =
              ResponseString
                  .RESPONSE_STRING_youcanSelectOnlyXCredential.localise(
                context,
                injectedMessage: injectedMessage,
              );
          return message;

        case ResponseString.RESPONSE_STRING_theCredentialIsNotReady:
          final message = ResponseString
              .RESPONSE_STRING_theCredentialIsNotReady.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_theCredentialIsNoMoreReady:
          final message = ResponseString
              .RESPONSE_STRING_theCredentialIsNoMoreReady.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_theRequestIsRejected:
          final message = ResponseString
              .RESPONSE_STRING_theRequestIsRejected.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_userPinIsIncorrect:
          final message = ResponseString
              .RESPONSE_STRING_userPinIsIncorrect.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_responseTypeNotSupported:
          final message = ResponseString
              .RESPONSE_STRING_responseTypeNotSupported.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_invalidRequest:
          final message =
              ResponseString.RESPONSE_STRING_invalidRequest.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_subjectSyntaxTypeNotSupported:
          final message = ResponseString
              .RESPONSE_STRING_subjectSyntaxTypeNotSupported.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_accessDenied:
          final message = ResponseString.RESPONSE_STRING_accessDenied.localise(
            context,
          );
          return message;

        case ResponseString.RESPONSE_STRING_thisRequestIsNotSupported:
          final message = ResponseString
              .RESPONSE_STRING_thisRequestIsNotSupported.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_unsupportedCredential:
          final message = ResponseString
              .RESPONSE_STRING_unsupportedCredential.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_aloginIsRequired:
          final message =
              ResponseString.RESPONSE_STRING_aloginIsRequired.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_userConsentIsRequired:
          final message = ResponseString
              .RESPONSE_STRING_userConsentIsRequired.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_theWalletIsNotRegistered:
          final message = ResponseString
              .RESPONSE_STRING_theWalletIsNotRegistered.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_credentialIssuanceDenied:
          final message = ResponseString
              .RESPONSE_STRING_credentialIssuanceDenied.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_credentialIssuanceIsStillPending:
          final message =
              ResponseString
                  .RESPONSE_STRING_credentialIssuanceIsStillPending.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_thisCredentialFormatIsNotSupported:
          final message =
              ResponseString
                  .RESPONSE_STRING_thisCredentialFormatIsNotSupported.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_thisFormatIsNotSupported:
          final message = ResponseString
              .RESPONSE_STRING_thisFormatIsNotSupported.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_theCredentialOfferIsInvalid:
          final message = ResponseString
              .RESPONSE_STRING_theCredentialOfferIsInvalid.localise(context);
          return message;

        case ResponseString.RESPONSE_STRING_theServiceIsNotAvailable:
          final message = ResponseString
              .RESPONSE_STRING_theServiceIsNotAvailable.localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_theIssuanceOfThisCredentialIsPending:
          final message =
              ResponseString
                  // ignore: lines_longer_than_80_chars
                  .RESPONSE_STRING_theIssuanceOfThisCredentialIsPending.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_successfullyAddedEnterpriseAccount:
          final message =
              ResponseString
                  // ignore: lines_longer_than_80_chars
                  .RESPONSE_STRING_successfullyAddedEnterpriseAccount.localise(
                context,
              );
          return message;

        case ResponseString
            .RESPONSE_STRING_successfullyUpdatedEnterpriseAccount:
          final message =
              ResponseString
                  // ignore: lines_longer_than_80_chars
                  .RESPONSE_STRING_successfullyUpdatedEnterpriseAccount.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_thisWalleIsAlreadyConfigured:
          final message = ResponseString
              .RESPONSE_STRING_thisWalleIsAlreadyConfigured.localise(context);
          return message;
        case ResponseString.RESPONSE_STRING_invalidStatus:
          final message = ResponseString.RESPONSE_STRING_invalidStatus.localise(
            context,
          );
          return message;
        case ResponseString.RESPONSE_STRING_statusListInvalidSignature:
          final message = ResponseString
              .RESPONSE_STRING_statusListInvalidSignature.localise(context);
          return message;
        case ResponseString.RESPONSE_STRING_theWalletIsSuspended:
          final message = ResponseString
              .RESPONSE_STRING_theWalletIsSuspended.localise(context);
          return message;
        case ResponseString
            .RESPONSE_STRING_couldNotFindTheAccountWithThisAddress:
          final message =
              ResponseString
                  // ignore: lines_longer_than_80_chars
                  .RESPONSE_STRING_couldNotFindTheAccountWithThisAddress.localise(
                context,
                injectedMessage: injectedMessage,
              );
          return message;

        case ResponseString.RESPONSE_STRING_invalidClientErrorDescription:
          final message = ResponseString
              .RESPONSE_STRING_invalidClientErrorDescription.localise(context);
          return message;

        case ResponseString
            .RESPONSE_STRING_vpFormatsNotSupportedErrorDescription:
          final message =
              ResponseString
                  // ignore: lines_longer_than_80_chars
                  .RESPONSE_STRING_vpFormatsNotSupportedErrorDescription.localise(
                context,
              );
          return message;

        case ResponseString
            .RESPONSE_STRING_invalidPresentationDefinitionUriErrorDescription:
          final message =
              ResponseString
                  // ignore: lines_longer_than_80_chars
                  .RESPONSE_STRING_invalidPresentationDefinitionUriErrorDescription.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_recoveryPhraseIncorrectErrorMessage:
          final message =
              ResponseString
                  .RESPONSE_STRING_recoveryPhraseIncorrectErrorMessage.localise(
                context,
              );
          return message;

        case ResponseString.RESPONSE_STRING_invalidCode:
          final message = ResponseString.RESPONSE_STRING_invalidCode.localise(
            context,
          );
          return message;
      }
    }
    return '';
  }
}

class ErrorMessage extends ResponseMessage {
  ErrorMessage({required super.message, super.data});
}
