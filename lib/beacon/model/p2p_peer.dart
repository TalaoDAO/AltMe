import 'package:json_annotation/json_annotation.dart';

part 'p2p_peer.g.dart';

@JsonSerializable()
class P2PPeer {
  P2PPeer(
    this.id,
    this.name,
    this.publicKey,
    this.relayServer,
    this.version,
    this.icon,
    this.appURL,
  );

  factory P2PPeer.fromJson(Map<String, dynamic> json) =>
      _$P2PPeerFromJson(json);

  final String id;
  final String name;
  final String publicKey;
  final String relayServer;
  final String version;
  final String? icon;
  final String? appURL;

  Map<String, dynamic> toJson() => _$P2PPeerToJson(this);
}
