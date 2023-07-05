import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

part 'saved_dapp_data.g.dart';

@JsonSerializable()
class SavedDappData extends Equatable {
  const SavedDappData({
    this.peer,
    this.walletAddress,
    this.sessionData,
  });

  factory SavedDappData.fromJson(Map<String, dynamic> json) =>
      _$SavedDappDataFromJson(json);

  final P2PPeer? peer;
  final String? walletAddress;
  final SessionData? sessionData;

  Map<String, dynamic> toJson() => _$SavedDappDataToJson(this);

  @override
  List<Object?> get props => [
        peer,
        walletAddress,
        sessionData,
      ];
}
