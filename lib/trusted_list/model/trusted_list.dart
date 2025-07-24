import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trusted_list.g.dart';

@JsonSerializable(explicitToJson: true)
class TrustedList extends Equatable {

  const TrustedList({
    required this.ecosystem,
    required this.lastUpdated,
    required this.entities,
  });

  factory TrustedList.fromJson(Map<String, dynamic> json) =>
      _$TrustedListFromJson(json);
  final String ecosystem;
  final String lastUpdated;
  final List<TrustedEntity> entities;
  
  Map<String, dynamic> toJson() => _$TrustedListToJson(this);

  @override
  List<Object?> get props => [ecosystem, lastUpdated, entities];
}
