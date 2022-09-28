import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_peer_data.g.dart';

@JsonSerializable()
class SavedPeerData {
  SavedPeerData({
    required this.peer,
    required this.walletAddress,
  });

  factory SavedPeerData.fromJson(Map<String, dynamic> json) =>
      _$SavedPeerDataFromJson(json);

  P2PPeer peer;
  String walletAddress;

  Map<String, dynamic> toJson() => _$SavedPeerDataToJson(this);
}
