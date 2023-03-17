import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class ResponseMessage with MessageHandler {
  ResponseMessage(this.message);

  final ResponseString message;

  @override
  String getMessage(BuildContext context, MessageHandler messageHandler) {
    if (messageHandler is ResponseMessage) {
      switch (messageHandler.message) {
        case ResponseString.RESPONSE_STRING_bloometaPassWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_bloometaPassWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_bloometaPassExpirationDate:
          return ResponseString.RESPONSE_STRING_bloometaPassExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_bloometaPassHowToGetIt:
          return ResponseString.RESPONSE_STRING_bloometaPassHowToGetIt.localise(
              context);

        case ResponseString.RESPONSE_STRING_identityProofDummyDescription:
          return ResponseString.RESPONSE_STRING_identityProofDummyDescription
              .localise(context);

        case ResponseString.RESPONSE_STRING_over18DummyDescription:
          return ResponseString.RESPONSE_STRING_over18DummyDescription.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_over13DummyDescription:
          return ResponseString.RESPONSE_STRING_over13DummyDescription.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_passportFootprintDummyDescription:
          return ResponseString
              .RESPONSE_STRING_passportFootprintDummyDescription.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_emailProofDummyDescription:
          return ResponseString.RESPONSE_STRING_emailProofDummyDescription
              .localise(context);

        case ResponseString.RESPONSE_STRING_genderProofDummyDescription:
          return ResponseString.RESPONSE_STRING_genderProofDummyDescription
              .localise(context);

        case ResponseString.RESPONSE_STRING_nationalityProofDummyDescription:
          return ResponseString.RESPONSE_STRING_nationalityProofDummyDescription
              .localise(context);

        case ResponseString.RESPONSE_STRING_ageRangeProofDummyDescription:
          return ResponseString.RESPONSE_STRING_ageRangeProofDummyDescription
              .localise(context);

        case ResponseString.RESPONSE_STRING_phoneProofDummyDescription:
          return ResponseString.RESPONSE_STRING_phoneProofDummyDescription
              .localise(context);

        case ResponseString.RESPONSE_STRING_BALANCE_TOO_LOW:
          return ResponseString.RESPONSE_STRING_BALANCE_TOO_LOW
              .localise(context);

        case ResponseString.RESPONSE_STRING_CANNOT_PAY_STORAGE_FEE:
          return ResponseString.RESPONSE_STRING_CANNOT_PAY_STORAGE_FEE
              .localise(context);

        case ResponseString.RESPONSE_STRING_FEE_TOO_LOW:
          return ResponseString.RESPONSE_STRING_FEE_TOO_LOW.localise(context);

        case ResponseString.RESPONSE_STRING_FEE_TOO_LOW_FOR_MEMPOOL:
          return ResponseString.RESPONSE_STRING_FEE_TOO_LOW_FOR_MEMPOOL
              .localise(context);

        case ResponseString.RESPONSE_STRING_TX_ROLLUP_BALANCE_TOO_LOW:
          return ResponseString.RESPONSE_STRING_TX_ROLLUP_BALANCE_TOO_LOW
              .localise(context);

        case ResponseString.RESPONSE_STRING_TX_ROLLUP_INVALID_ZERO_TRANSFER:
          return ResponseString.RESPONSE_STRING_TX_ROLLUP_INVALID_ZERO_TRANSFER
              .localise(context);

        case ResponseString.RESPONSE_STRING_TX_ROLLUP_UNKNOWN_ADDRESS:
          return ResponseString.RESPONSE_STRING_TX_ROLLUP_UNKNOWN_ADDRESS
              .localise(context);

        case ResponseString.RESPONSE_STRING_INACTIVE_CHAIN:
          return ResponseString.RESPONSE_STRING_INACTIVE_CHAIN
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE:
          return ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE:
          return ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL:
          return ResponseString
              .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL:
          return ResponseString
              .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL
              .localise(context);

        case ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY:
          return ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY
              .localise(context);

        case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR:
          return ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR
              .localise(context);

        case ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE:
          return ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_linkedInBannerSuccessfullyExported:
          return ResponseString
                  .RESPONSE_STRING_linkedInBannerSuccessfullyExported
              .localise(context);

        case ResponseString.RESPONSE_STRING_credentialSuccessfullyExported:
          return ResponseString.RESPONSE_STRING_credentialSuccessfullyExported
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE:
          return ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING:
          return ResponseString
              .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL:
          return ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL
              .localise(context);

        case ResponseString.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED:
          return ResponseString.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER:
          return ResponseString
              .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL:
          return ResponseString
              .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL
              .localise(context);

        case ResponseString.RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID:
          return ResponseString.RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_DID
              .localise(context);

        case ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED:
          return ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER:
          return ResponseString
              .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER
              .localise(context);

        case ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY:
          return ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN:
          return ResponseString
              .RESPONSE_STRING_FAILED_TO_SAVE_MNEMONIC_PLEASE_TRY_AGAIN
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_DID:
          return ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_DID
              .localise(context);

        case ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST:
          return ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST
              .localise(context);

        case ResponseString.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY:
          return ResponseString.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY
              .localise(context);

        case ResponseString.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY:
          return ResponseString.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY
              .localise(context);

        case ResponseString.RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY:
          return ResponseString.RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY
              .localise(context);

        case ResponseString.RESPONSE_STRING_DID_KEY_NOT_RESOLVED:
          return ResponseString.RESPONSE_STRING_DID_KEY_NOT_RESOLVED
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY:
          return ResponseString
              .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY
              .localise(context);

        case ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA:
          return ResponseString.RESPONSE_STRING_UNABLE_TO_PROCESS_THE_DATA
              .localise(context);

        case ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE:
          return ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE:
          return ResponseString.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE
              .localise(context);

        case ResponseString
            .RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE:
          return ResponseString
              .RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR:
          return ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR
              .localise(context);

        case ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED:
          return ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED
              .localise(context);

        case ResponseString.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON:
          return ResponseString.RESPONSE_STRING_SUCCESSFULLY_CONNECTED_TO_BEACON
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON:
          return ResponseString.RESPONSE_STRING_FAILED_TO_CONNECT_WITH_BEACON
              .localise(context);

        case ResponseString.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD:
          return ResponseString.RESPONSE_STRING_SUCCESSFULLY_SIGNED_PAYLOAD
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD:
          return ResponseString.RESPONSE_STRING_FAILED_TO_SIGNED_PAYLOAD
              .localise(context);

        case ResponseString.RESPONSE_STRING_OPERATION_COMPLETED:
          return ResponseString.RESPONSE_STRING_OPERATION_COMPLETED
              .localise(context);

        case ResponseString.RESPONSE_STRING_OPERATION_FAILED:
          return ResponseString.RESPONSE_STRING_OPERATION_FAILED
              .localise(context);

        case ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE:
          return ResponseString.RESPONSE_STRING_INSUFFICIENT_BALANCE
              .localise(context);

        case ResponseString.RESPONSE_STRING_SWITCH_NETWORK_MESSAGE:
          return ResponseString.RESPONSE_STRING_SWITCH_NETWORK_MESSAGE
              .localise(context);

        case ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP:
          return ResponseString.RESPONSE_STRING_DISCONNECTED_FROM_DAPP
              .localise(context);

        case ResponseString.RESPONSE_STRING_FAILED_TO_DO_OPERATION:
          return ResponseString.RESPONSE_STRING_FAILED_TO_DO_OPERATION
              .localise(context);

        case ResponseString.RESPONSE_STRING_emailPassWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_emailPassWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_emailPassExpirationDate:
          return ResponseString.RESPONSE_STRING_emailPassExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_emailPassHowToGetIt:
          return ResponseString.RESPONSE_STRING_emailPassHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard:
          return ResponseString
                  .RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_tezotopiaMembershipExpirationDate:
          return ResponseString
                  .RESPONSE_STRING_tezotopiaMembershipExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_tezotopiaMembershipHowToGetIt:
          return ResponseString.RESPONSE_STRING_tezotopiaMembershipHowToGetIt
              .localise(context);

        case ResponseString.RESPONSE_STRING_chainbornMembershipWhyGetThisCard:
          return ResponseString
                  .RESPONSE_STRING_chainbornMembershipWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_chainbornMembershipExpirationDate:
          return ResponseString
                  .RESPONSE_STRING_chainbornMembershipExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_chainbornMembershipHowToGetIt:
          return ResponseString.RESPONSE_STRING_chainbornMembershipHowToGetIt
              .localise(context);

        case ResponseString.RESPONSE_STRING_twitterWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_twitterWhyGetThisCard.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_twitterExpirationDate:
          return ResponseString.RESPONSE_STRING_twitterExpirationDate.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_twitterHowToGetIt:
          return ResponseString.RESPONSE_STRING_twitterHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_twitterDummyDesc:
          return ResponseString.RESPONSE_STRING_twitterDummyDesc.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_bunnyPassWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_bunnyPassWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_bunnyPassExpirationDate:
          return ResponseString.RESPONSE_STRING_bunnyPassExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_bunnyPassHowToGetIt:
          return ResponseString.RESPONSE_STRING_bunnyPassHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_dogamiPassWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_dogamiPassWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_dogamiPassExpirationDate:
          return ResponseString.RESPONSE_STRING_dogamiPassExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_dogamiPassHowToGetIt:
          return ResponseString.RESPONSE_STRING_dogamiPassHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_matterlightPassWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_matterlightPassWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_matterlightPassExpirationDate:
          return ResponseString.RESPONSE_STRING_matterlightPassExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_matterlightPassHowToGetIt:
          return ResponseString.RESPONSE_STRING_matterlightPassHowToGetIt
              .localise(context);

        case ResponseString.RESPONSE_STRING_pigsPassWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_pigsPassWhyGetThisCard.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_pigsPassExpirationDate:
          return ResponseString.RESPONSE_STRING_pigsPassExpirationDate.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_pigsPassHowToGetIt:
          return ResponseString.RESPONSE_STRING_pigsPassHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_trooperzPassWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_trooperzPassWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_trooperzPassExpirationDate:
          return ResponseString.RESPONSE_STRING_trooperzPassExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_trooperzPassHowToGetIt:
          return ResponseString.RESPONSE_STRING_trooperzPassHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_over18WhyGetThisCard:
          return ResponseString.RESPONSE_STRING_over18WhyGetThisCard.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_over18ExpirationDate:
          return ResponseString.RESPONSE_STRING_over18ExpirationDate.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_over18HowToGetIt:
          return ResponseString.RESPONSE_STRING_over18HowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_over13WhyGetThisCard:
          return ResponseString.RESPONSE_STRING_over13WhyGetThisCard.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_over13ExpirationDate:
          return ResponseString.RESPONSE_STRING_over13ExpirationDate.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_over13HowToGetIt:
          return ResponseString.RESPONSE_STRING_over13HowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_passportFootprintWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_passportFootprintWhyGetThisCard
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_passportFootprintExpirationDate:
          return ResponseString.RESPONSE_STRING_passportFootprintExpirationDate
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_passportFootprintHowToGetIt:
          return ResponseString.RESPONSE_STRING_passportFootprintHowToGetIt
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_verifiableIdCardWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_verifiableIdCardWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_verifiableIdCardExpirationDate:
          return ResponseString.RESPONSE_STRING_verifiableIdCardExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_verifiableIdCardHowToGetIt:
          return ResponseString.RESPONSE_STRING_verifiableIdCardHowToGetIt
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_phoneProofWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_phoneProofWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_phoneProofExpirationDate:
          return ResponseString.RESPONSE_STRING_phoneProofExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_phoneProofHowToGetIt:
          return ResponseString.RESPONSE_STRING_phoneProofHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_tezVoucherWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_tezVoucherWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_tezVoucherExpirationDate:
          return ResponseString.RESPONSE_STRING_tezVoucherExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_tezVoucherHowToGetIt:
          return ResponseString.RESPONSE_STRING_tezVoucherHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_genderWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_genderWhyGetThisCard.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_genderExpirationDate:
          return ResponseString.RESPONSE_STRING_genderExpirationDate.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_genderHowToGetIt:
          return ResponseString.RESPONSE_STRING_genderHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_nationalityWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_nationalityWhyGetThisCard
              .localise(context);

        case ResponseString.RESPONSE_STRING_nationalityExpirationDate:
          return ResponseString.RESPONSE_STRING_nationalityExpirationDate
              .localise(context);

        case ResponseString.RESPONSE_STRING_nationalityHowToGetIt:
          return ResponseString.RESPONSE_STRING_nationalityHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_ageRangeWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_ageRangeWhyGetThisCard.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_ageRangeExpirationDate:
          return ResponseString.RESPONSE_STRING_ageRangeExpirationDate.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_ageRangeHowToGetIt:
          return ResponseString.RESPONSE_STRING_ageRangeHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_payloadFormatErrorMessage:
          return ResponseString.RESPONSE_STRING_payloadFormatErrorMessage
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_thisFeatureIsNotSupportedMessage:
          return ResponseString.RESPONSE_STRING_thisFeatureIsNotSupportedMessage
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_userNotFitErrorMessage:
          return ResponseString.RESPONSE_STRING_userNotFitErrorMessage.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_transactionIsLikelyToFail:
          return ResponseString.RESPONSE_STRING_transactionIsLikelyToFail
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_linkedinCardWhyGetThisCard:
          return ResponseString.RESPONSE_STRING_linkedinCardWhyGetThisCard
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_linkedinCardExpirationDate:
          return ResponseString.RESPONSE_STRING_linkedinCardExpirationDate
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_linkedinCardHowToGetIt:
          return ResponseString.RESPONSE_STRING_linkedinCardHowToGetIt.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_verifiableIdCardDummyDesc:
          return ResponseString.RESPONSE_STRING_verifiableIdCardDummyDesc
              .localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_tezotopiaMembershipLongDescription:
          return ResponseString
              .RESPONSE_STRING_tezotopiaMembershipLongDescription.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_chainbornMembershipLongDescription:
          return ResponseString
              .RESPONSE_STRING_chainbornMembershipLongDescription.localise(
            context,
          );

        case ResponseString.RESPONSE_STRING_bloometaPassLongDescription:
          return ResponseString.RESPONSE_STRING_bloometaPassLongDescription
              .localise(
            context,
          );
      }
    }
    return '';
  }
}
