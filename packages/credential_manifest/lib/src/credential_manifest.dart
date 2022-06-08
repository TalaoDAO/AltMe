import 'package:credential_manifest/src/models/output_descriptor.dart';
import 'package:credential_manifest/src/models/presentation_definition.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_manifest.g.dart';

/// Abstract from https://identity.foundation/credential-manifest/
/// For User Agents (e.g. wallets) and other service that wish to engage with
/// Issuers to acquire credentials, there must exist a mechanism for assessing
/// what inputs are required from a Subject to process a request for
/// credential(s) issuance. The Credential Manifest is a common data format for
/// describing the inputs a Subject must provide to an Issuer for
/// subsequent evaluation and issuance of the credential(s) indicated in the
/// Credential Manifest.

/// Credential Manifests do not themselves define the contents of the output
/// credential(s), the process the Issuer uses to evaluate the submitted inputs,
/// or the protocol Issuers, Subjects, and their User Agents rely on
/// to negotiate credential issuance.
@JsonSerializable(explicitToJson: true)
class CredentialManifest {
  /// Initialyze [id] and [outputDescriptors]
  CredentialManifest(
    this.id,
    this.outputDescriptors,
    this.presentationDefinition,
  );

  /// Create object from json definition
  factory CredentialManifest.fromJson(Map<String, dynamic> json) =>
      _$CredentialManifestFromJson(json);

  ///
  final String? id;

  /// An array of OutputDescriptor which are objects used to describe the Claims
  /// an Issuer is offering to a Holder.
  @JsonKey(name: 'output_descriptors')
  final List<OutputDescriptor>? outputDescriptors;

  /// A PresentationDefinition which is a list of presentations
  @JsonKey(
    name: 'presentation_definition',
    fromJson: presentationDefinitionFromJson,
  )
  final PresentationDefinition? presentationDefinition;

  /// Create json object from instance
  Map<String, dynamic> toJson() => _$CredentialManifestToJson(this);

  static PresentationDefinition? presentationDefinitionFromJson(dynamic json) {
    if (json == null || json['input_descriptors'] == null) {
      return null;
    }
    return PresentationDefinition.fromJson(json as Map<String, dynamic>);
  }
}
