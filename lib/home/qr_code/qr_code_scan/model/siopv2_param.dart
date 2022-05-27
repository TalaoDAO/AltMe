import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'siopv2_param.g.dart';

@JsonSerializable()
class SIOPV2Param extends Equatable {
  const SIOPV2Param({
    this.nonce,
    this.redirect_uri,
    this.request_uri,
    this.claims,
    this.requestUriPayload,
  });

  factory SIOPV2Param.fromJson(Map<String, dynamic> json) =>
      _$SIOPV2ParamFromJson(json);

  final String? nonce;
  final String? redirect_uri;
  final String? request_uri;
  final String? claims;
  final String? requestUriPayload;

  Map<String, dynamic> toJson() => _$SIOPV2ParamToJson(this);

  @override
  List<Object?> get props =>
      [nonce, redirect_uri, request_uri, claims, requestUriPayload];
}
