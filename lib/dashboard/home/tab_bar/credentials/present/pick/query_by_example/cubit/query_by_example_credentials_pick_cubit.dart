import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/query_by_example/model/credential_query.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query_by_example_credentials_pick_state.dart';

part 'query_by_example_credentials_pick_cubit.g.dart';

class QueryByExampleCredentialPickCubit
    extends Cubit<QueryByExampleCredentialPickState> {
  QueryByExampleCredentialPickCubit({
    List<CredentialModel> credentialList = const <CredentialModel>[],
    required CredentialQuery? credentialQuery,
  }) : super(
          const QueryByExampleCredentialPickState(filteredCredentialList: []),
        ) {
    if (credentialQuery == null) {
      /// Display your VP and VC case
      emit(state.copyWith(filteredCredentialList: credentialList));
    } else {
      /// Query by Example case
      filterList(
        credentialList: credentialList,
        credentialQuery: credentialQuery,
      );
    }
  }

  void filterList({
    required List<CredentialModel> credentialList,
    required CredentialQuery? credentialQuery,
  }) {
    final filteredCredentialList = List<CredentialModel>.from(credentialList);
    if (credentialQuery != null) {
      /// filter credential list if there are type restrictions
      if (credentialQuery.example?.type != null) {
        filteredCredentialList.removeWhere((credential) {
          /// A credential must satisfy each field to be candidate
          /// for presentation
          var isPresentationCandidate = false;
          final searchList = getTextsFromCredential(r'$.type', credential.data);
          if (searchList.isNotEmpty) {
            /// I remove credential not
            searchList.removeWhere(
              (element) {
                if (element == credentialQuery.example?.type) {
                  return false;
                } else {
                  return true;
                }
              },
            );

            /// if [searchList] is not empty we mark this credential
            /// as a valid candidate
            if (searchList.isNotEmpty) {
              isPresentationCandidate = true;
            }
          }

          /// Remove non candidate credential from the list
          return !isPresentationCandidate;
        });
      }

      /// filter credential list if there are issuer restrictions
      final issuerList = credentialQuery.example?.trustedIssuer;
      if (issuerList != null) {
        filteredCredentialList.removeWhere((credential) {
          var isPresentationCandidate = false;
          for (final issuer in issuerList) {
            /// A credential must satisfy one issuer value to be candidate
            /// for presentation
            final searchList =
                getTextsFromCredential(r'$.issuer', credential.data);
            if (searchList.isNotEmpty) {
              /// I remove element not matching requested issuer
              searchList.removeWhere(
                (element) {
                  if (element == issuer.issuer) {
                    return false;
                  } else {
                    return true;
                  }
                },
              );

              /// if [searchList] is not empty we mark this credential
              /// as a valid candidate
              if (searchList.isNotEmpty) {
                isPresentationCandidate = true;
              }
            }
          }

          /// Remove non candidate credential from the list
          return !isPresentationCandidate;
        });
      }
    }

    emit(state.copyWith(filteredCredentialList: filteredCredentialList));
  }

  void toggle(int index) {
    emit(state.copyWith(selected: index));
  }
}
