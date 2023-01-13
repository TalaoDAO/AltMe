import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'faq.g.dart';

@JsonSerializable()
class FaqModel extends Equatable {
  const FaqModel({
    required this.faq,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) =>
      _$FaqModelFromJson(json);

  final List<FaqElement> faq;

  Map<String, dynamic> toJson() => _$FaqModelToJson(this);

  @override
  List<Object> get props => [faq];
}

@JsonSerializable()
class FaqElement extends Equatable {
  const FaqElement({
    required this.que,
    required this.ans,
    this.href,
  });

  factory FaqElement.fromJson(Map<String, dynamic> json) =>
      _$FaqElementFromJson(json);

  final String que;
  final String ans;
  final String? href;

  Map<String, dynamic> toJson() => _$FaqElementToJson(this);

  @override
  List<Object> get props => [que, ans];
}
