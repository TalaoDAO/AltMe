import 'package:equatable/equatable.dart';

class KeyStoreModel extends Equatable {
  const KeyStoreModel({
    required this.secretKey,
    required this.publicKey,
    required this.publicKeyHash,
  });

  factory KeyStoreModel.fromJson(Map<String, dynamic> json) {
    return KeyStoreModel(
      secretKey: json['secretKey'] as String,
      publicKey: json['publicKey'] as String,
      publicKeyHash: json['publicKeyHash'] as String,
    );
  }

  final String secretKey;
  final String publicKey;
  final String publicKeyHash;

  Map<String, dynamic> toJson() => {
    'secretKey': secretKey,
    'publicKey': publicKey,
    'publicKeyHash': publicKeyHash,
  };

  @override
  List<Object?> get props => [secretKey, publicKey, publicKeyHash];
}
