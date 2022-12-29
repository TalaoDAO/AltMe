import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:secure_storage/secure_storage.dart';

part 'missing_credentials_cubit.g.dart';
part 'missing_credentials_state.dart';

class MissingCredentialsCubit extends Cubit<MissingCredentialsState> {
  MissingCredentialsCubit({
    required this.repository,
    required this.secureStorageProvider,
    required this.credentialManifest,
  }) : super(MissingCredentialsState()) {
    initialize();
  }

  final CredentialsRepository repository;
  final SecureStorageProvider secureStorageProvider;
  final CredentialManifest credentialManifest;

  Future initialize() async {
    emit(state.loading());

    final List<HomeCredential> homeCredentials = [];
    final PresentationDefinition? presentationDefinition =
        credentialManifest.presentationDefinition;

    if (presentationDefinition != null) {
      for (final descriptor in presentationDefinition.inputDescriptors) {
        /// using JsonPath to find credential Name
        final dynamic json = jsonDecode(jsonEncode(descriptor.constraints));
        final dynamic credentialField =
            JsonPath(r'$..fields').read(json).first.value.toList().first;

        final credentialName = credentialField['filter']['pattern'] as String;

        /// converting string to CredentialSubjectModel
        final Map<String, dynamic> credentialNameJson = <String, dynamic>{
          'type': credentialName
        };

        final CredentialSubjectModel credentialSubjectModel =
            CredentialSubjectModel.fromJson(credentialNameJson);

        /// fetching all the credentials
        final CredentialsRepository repository =
            CredentialsRepository(getSecureStorage);

        final List<CredentialModel> allCredentials = await repository.findAll();

        bool isPresentable = false;

        for (final credential in allCredentials) {
          if (credentialSubjectModel.credentialSubjectType ==
              credential.credentialPreview.credentialSubjectModel
                  .credentialSubjectType) {
            isPresentable = true;
            break;
          } else {
            isPresentable = false;
          }
        }
        if (!isPresentable) {
          homeCredentials.add(
            HomeCredential.isDummy(
              credentialSubjectModel.credentialSubjectType,
            ),
          );
        }
      }
    }
    emit(
      state.copyWith(
        status: AppStatus.idle,
        dummyCredentials: homeCredentials,
      ),
    );
  }
}
