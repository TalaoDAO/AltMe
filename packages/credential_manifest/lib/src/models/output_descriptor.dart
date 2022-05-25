import 'package:credential_manifest/src/models/display_object.dart';
import 'package:credential_manifest/src/models/styles.dart';
import 'package:json_annotation/json_annotation.dart';

part 'output_descriptor.g.dart';

/// Output Descriptor Objects contain type URI that links to the type of
/// the offered output data, and information about how to display the output
///  to the Holder.
/// See https://identity.foundation/credential-manifest/#output-descriptor for more information
@JsonSerializable(explicitToJson: true)
class OutputDescriptor {
  /// Initialyze components of Output Descriptor
  OutputDescriptor(
    this.id,
    this.schema,
    this.name,
    this.description,
    this.styles,
    this.display,
  );

  /// Create object from json definition
  factory OutputDescriptor.fromJson(Map<String, dynamic> json) =>
      _$OutputDescriptorFromJson(json);

  /// [id] property MUST be a string that does not conflict with the id
  ///  of another
  ///  Output Descriptor Object in the same Credential Manifest.
  final String id;

  /// String specifying the schema of the credential to be issued.
  final String schema;

  /// Its value SHOULD be a human-friendly name that describes
  /// what the credential represents.
  final String? name;

  /// its value MUST be a string that describes
  /// what the credential is in greater detail.
  final String? description;

  /// It defines images and colors to use when displayin credential
  /// Its value MUST be an object or URI,
  /// as defined by the DIF Entity Styles specification.
  /// See https://identity.foundation/wallet-rendering/v0.0.1/#entity-styles
  final Styles? styles;

  /// It define data to display
  final DisplayObject? display;

  /// Create json object from instance
  Map<String, dynamic> toJson() => _$OutputDescriptorToJson(this);
}
