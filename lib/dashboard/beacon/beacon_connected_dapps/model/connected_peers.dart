import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connected_peers.g.dart';

@JsonSerializable()
class ConnectedPeers {
  ConnectedPeers({
    this.peer,
  });

  factory ConnectedPeers.fromJson(Map<String, dynamic> json) =>
      _$ConnectedPeersFromJson(json);

  List<P2PPeer>? peer;

  Map<String, dynamic> toJson() => _$ConnectedPeersToJson(this);
}
