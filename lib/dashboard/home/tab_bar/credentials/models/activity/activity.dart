import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity extends Equatable {
  const Activity({
    required this.issuer,
    required this.presentedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  final Issuer issuer;
  final DateTime presentedAt;

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  List<Object?> get props => [issuer, presentedAt];
}
