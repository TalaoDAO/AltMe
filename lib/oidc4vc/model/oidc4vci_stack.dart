import 'package:altme/oidc4vc/model/oidc4vci_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'oidc4vci_stack.g.dart';

@JsonSerializable(explicitToJson: true)
class Oidc4VCIStack {
  Oidc4VCIStack({this.stack = const <Oidc4VCIState>[]});

  factory Oidc4VCIStack.fromJson(Map<String, dynamic> json) =>
      _$Oidc4VCIStackFromJson(json);

  factory Oidc4VCIStack.initial() => Oidc4VCIStack(stack: const []);

  final List<Oidc4VCIState> stack;

  Map<String, dynamic> toJson() => _$Oidc4VCIStackToJson(this);
}
