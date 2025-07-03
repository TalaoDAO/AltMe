import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:credential_manifest/credential_manifest.dart';

List<CredentialModel> getCredentialsFromFilterList({
  required List<Field> filterList,
  required List<CredentialModel> credentialList,
  required ProfileType profileType,
}) {
  /// If we have some instructions we filter the wallet's
  /// crendential list whith it
  if (filterList.isNotEmpty) {
    /// remove ldp_vp if jwt_vp is required

    final selectedCredential = <CredentialModel>[];

    for (final credential in credentialList) {
      /// profile should be matched for vc
      final profileLinkedId = credential.profileLinkedId;
      if (profileLinkedId != null && profileLinkedId != profileType.getVCId) {
        continue;
      }

      bool allConditionsSatisfied = false;
      fieldLoop:
      for (final field in filterList) {
        /// if optional not need to compute
        if (field.optional) {
          allConditionsSatisfied = true;
        } else {
          pathLoop:
          for (final path in field.path) {
            final credentialData = valuesJson(
              encryptedJson: credential.data,
              selectiveDisclosure: SelectiveDisclosure(credential),
            );

            final searchList = getTextsFromCredential(path, credentialData);
            if (searchList.isNotEmpty) {
              /// remove unmatched credential
              searchList.removeWhere(
                (searchParameter) {
                  final filter = field.filter;

                  /// condition matched - no further filtration needed
                  if (filter == null) return false;

                  String? pattern = filter.pattern;
                  if (pattern != null) {
                    pattern = filter.pattern;
                  } else if (filter.contains?.containsConst != null) {
                    pattern = filter.contains?.containsConst;
                  } else if (filter.containsConst != null) {
                    pattern = filter.containsConst;
                  } else {
                    /// sd-jwt vc bool case
                    if (searchParameter == 'true') return false;
                  }

                  if (pattern == null) {
                    return false;
                  } else if (pattern.endsWith(r'$')) {
                    final RegExp regEx = RegExp(pattern);
                    final Match? match = regEx.firstMatch(searchParameter);

                    if (match != null) return false;
                  } else {
                    if (searchParameter == pattern) return false;
                  }

                  return true;
                },
              );
            }

            /// if [searchList] is not empty we mark this credential as
            /// a valid candidate
            if (searchList.isNotEmpty) {
              allConditionsSatisfied = true;
              break pathLoop;
            } else {
              allConditionsSatisfied = false;
            }
          }
          // if one field is not satisfied then condition is not satisfied
          if (!allConditionsSatisfied) {
            break fieldLoop;
          }
        }
      }
      if (allConditionsSatisfied) {
        selectedCredential.add(credential);
      }
    }

    final credentials = selectedCredential.toSet().toList();

    credentials.sort(
      (a, b) {
        final firstCredName = a.display?.name ??
            a.credentialPreview.credentialSubjectModel.credentialSubjectType
                .name;
        final secondCredName = b.display?.name ??
            b.credentialPreview.credentialSubjectModel.credentialSubjectType
                .name;

        return firstCredName.compareTo(secondCredName);
      },
    );

    return credentials;
  }

  return credentialList;
}
