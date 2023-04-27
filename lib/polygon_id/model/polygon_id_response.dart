import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'polygon_id_response.g.dart';

@JsonSerializable()
class PolygonIdResponse extends Equatable {
  const PolygonIdResponse({
    this.id,
    this.typ,
    this.type,
    this.thid,
    this.body,
    this.from,
    this.to,
  });

  factory PolygonIdResponse.fromJson(Map<String, dynamic> json) =>
      _$PolygonIdResponseFromJson(json);

  final String? id;
  final String? typ;
  final String? type;
  final String? thid;
  final Body? body;
  final String? from;
  final String? to;

  Map<String, dynamic> toJson() => _$PolygonIdResponseToJson(this);

  @override
  List<Object?> get props => [id, typ, type, body, from, to];
}

@JsonSerializable()
class Body extends Equatable {
  const Body({
    this.callbackUrl,
    this.reason,
    this.scope,
    this.url,
    this.credentials,
  });

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);

  final String? callbackUrl;
  final String? reason;
  final List<Scope>? scope;
  final String? url;
  final List<PolygonIdCredential>? credentials;

  Map<String, dynamic> toJson() => _$BodyToJson(this);

  @override
  List<Object?> get props => [callbackUrl, reason, scope, url, credentials];
}

@JsonSerializable()
class PolygonIdCredential extends Equatable {
  const PolygonIdCredential({
    this.id,
    this.description,
  });

  factory PolygonIdCredential.fromJson(Map<String, dynamic> json) =>
      _$PolygonIdCredentialFromJson(json);

  final String? id;
  final String? description;

  Map<String, dynamic> toJson() => _$PolygonIdCredentialToJson(this);

  @override
  List<Object?> get props => [id, description];
}

@JsonSerializable()
class Scope extends Equatable {
  const Scope({
    this.id,
    this.circuitId,
    this.query,
  });

  factory Scope.fromJson(Map<String, dynamic> json) => _$ScopeFromJson(json);

  final int? id;
  final String? circuitId;
  final Querry? query;

  @override
  List<Object?> get props => [id, circuitId, query];
}

@JsonSerializable()
class Querry extends Equatable {
  const Querry({
    this.allowedIssuers,
    this.context,
    this.type,
  });

  factory Querry.fromJson(Map<String, dynamic> json) => _$QuerryFromJson(json);

  final List<String>? allowedIssuers;
  final String? context;
  final String? type;

  Map<String, dynamic> toJson() => _$QuerryToJson(this);

  @override
  List<Object?> get props => [allowedIssuers, context, type];
}
