import 'package:equatable/equatable.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// A document type a reader request starts from, with the claims it is known
/// to carry. The user can still type any document type, name space and claim.
class ReaderDocumentPreset extends Equatable {
  /// Creates a preset.
  const ReaderDocumentPreset({
    required this.name,
    required this.docType,
    required this.nameSpace,
    required this.claims,
  });

  /// What the user picks, e.g. `PID`.
  final String name;

  /// The mdoc document type.
  final String docType;

  /// The name space of [claims].
  final String nameSpace;

  /// The data element identifiers of the document.
  final List<String> claims;

  @override
  List<Object?> get props => [name, docType, nameSpace, claims];
}

/// The documents the editor suggests.
const readerDocumentPresets = [
  ReaderDocumentPreset(
    name: 'PID',
    docType: eudiPidDocType,
    nameSpace: eudiPidDocType,
    claims: [
      'family_name',
      'given_name',
      'birth_date',
      'birth_place',
      'nationality',
      'sex',
      'portrait',
      'family_name_birth',
      'given_name_birth',
      'resident_address',
      'resident_street',
      'resident_house_number',
      'resident_postal_code',
      'resident_city',
      'resident_state',
      'resident_country',
      'personal_administrative_number',
      'email_address',
      'mobile_phone_number',
      'document_number',
      'issuing_authority',
      'issuing_country',
      'issuing_jurisdiction',
      'issue_date',
      'expiry_date',
      'age_over_18',
      'age_in_years',
      'age_birth_year',
    ],
  ),
  ReaderDocumentPreset(
    name: 'mDL',
    docType: 'org.iso.18013.5.1.mDL',
    nameSpace: 'org.iso.18013.5.1',
    claims: [
      'family_name',
      'given_name',
      'birth_date',
      'portrait',
      'issue_date',
      'expiry_date',
      'issuing_country',
      'issuing_authority',
      'issuing_jurisdiction',
      'document_number',
      'driving_privileges',
      'un_distinguishing_sign',
      'administrative_number',
      'sex',
      'height',
      'weight',
      'eye_colour',
      'hair_colour',
      'birth_place',
      'resident_address',
      'resident_city',
      'resident_state',
      'resident_postal_code',
      'resident_country',
      'nationality',
      'age_in_years',
      'age_birth_year',
      'age_over_18',
      'age_over_21',
    ],
  ),
  ReaderDocumentPreset(
    name: 'Age verification',
    docType: 'eu.europa.ec.av.1',
    nameSpace: 'eu.europa.ec.av.1',
    claims: ['age_over_18', 'age_over_21'],
  ),
];
