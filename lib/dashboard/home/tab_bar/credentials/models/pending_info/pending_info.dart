import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pending_info.g.dart';

@JsonSerializable()
class PendingInfo extends Equatable {
  const PendingInfo({
    required this.encodedCredentialFromOIDC4VC,
    required this.accessToken,
    required this.deferredCredentialEndpoint,
    required this.format,
    required this.url,
    required this.issuer,
    required this.requestedAt,
  });

  factory PendingInfo.fromJson(Map<String, dynamic> json) =>
      _$PendingInfoFromJson(json);

  final Map<String, dynamic> encodedCredentialFromOIDC4VC;
  final String accessToken;
  final String deferredCredentialEndpoint;
  final String format;
  final String url;
  final String? issuer;
  final DateTime? requestedAt;

  Map<String, dynamic> toJson() => _$PendingInfoToJson(this);

  @override
  List<Object?> get props => [
    encodedCredentialFromOIDC4VC,
    accessToken,
    deferredCredentialEndpoint,
    format,
    url,
  ];
}
