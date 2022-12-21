import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
@immutable
abstract class NftModel extends Equatable {
  const NftModel();
}
