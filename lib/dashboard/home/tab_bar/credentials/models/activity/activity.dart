import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity extends Equatable {
  const Activity({
    this.acquisitionAt,
    this.presentation,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  final DateTime? acquisitionAt;
  final Presentation? presentation;

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  List<Object?> get props => [acquisitionAt, presentation];
}

@JsonSerializable()
class Presentation extends Equatable {
  const Presentation({
    required this.issuer,
    required this.presentedAt,
  });

  factory Presentation.fromJson(Map<String, dynamic> json) =>
      _$PresentationFromJson(json);

  final Issuer issuer;
  final DateTime presentedAt;

  Map<String, dynamic> toJson() => _$PresentationToJson(this);

  @override
  List<Object?> get props => [issuer, presentedAt];
}
