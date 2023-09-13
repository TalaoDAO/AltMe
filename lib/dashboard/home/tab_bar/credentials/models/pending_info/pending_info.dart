import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pending_info.g.dart';

@JsonSerializable()
class PendingInfo extends Equatable {
  const PendingInfo({
    required this.acceptanceToken,
    required this.deferredCredentialEndpoint,
    required this.format,
    required this.url,
  });

  factory PendingInfo.fromJson(Map<String, dynamic> json) =>
      _$PendingInfoFromJson(json);

  final String acceptanceToken;
  final String deferredCredentialEndpoint;
  final String format;
  final String url;

  Map<String, dynamic> toJson() => _$PendingInfoToJson(this);

  @override
  List<Object?> get props => [
        acceptanceToken,
        deferredCredentialEndpoint,
        format,
        url,
      ];
}
