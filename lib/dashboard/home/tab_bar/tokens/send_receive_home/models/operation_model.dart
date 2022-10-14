import 'dart:math';

import 'package:altme/dashboard/dashboard.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_model.g.dart';

@JsonSerializable()
class OperationModel extends Equatable {
  const OperationModel({
    required this.type,
    required this.id,
    required this.level,
    required this.timestamp,
    required this.block,
    required this.hash,
    required this.counter,
    required this.sender,
    required this.gasLimit,
    required this.gasUsed,
    required this.storageLimit,
    required this.storageUsed,
    required this.bakerFee,
    required this.storageFee,
    required this.allocationFee,
    required this.target,
    required this.amount,
    required this.status,
    required this.hasInternals,
    this.parameter,
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) =>
      _$OperationModelFromJson(json);

  factory OperationModel.fromFa2Json(Map<String, dynamic> json) {
    return OperationModel(
      type: json['token']['standard'] as String,
      id: json['id'] as int,
      level: json['level'] as int,
      timestamp: json['timestamp'] as String,
      block: (json['transactionId'] as int).toString(),
      hash: (json['transactionId'] as int).toString(),
      counter: -1,
      sender: OperationAddressModel(
        address: (json['from']?['address'] as String?) ?? '',
      ),
      gasLimit: 0,
      gasUsed: 0,
      storageLimit: 0,
      storageUsed: 0,
      bakerFee: 0,
      storageFee: 0,
      allocationFee: 0,
      target: OperationAddressModel(
        address: (json['to']?['address'] as String?) ?? '',
      ),
      amount: int.parse(json['amount'] as String),
      status: 'applied',
      hasInternals: true,
    );
  }

  final String type;
  final int id;
  final int level;
  final String timestamp;
  final String block;
  final String hash;
  final int counter;
  final OperationAddressModel sender;
  final int gasLimit;
  final int gasUsed;
  final int storageLimit;
  final int storageUsed;
  final int bakerFee;
  final int storageFee;
  final int allocationFee;
  final OperationAddressModel target;
  final int amount;
  final String status;
  final bool hasInternals;
  final OperationParameterModel? parameter;

  DateTime get dateTime {
    return DateFormat('y-M-dTHH:mm:ssZ').parse(timestamp,true).toLocal();
  }

  String get formatedDateTime {
    final formatedDateTime = DateFormat.yMEd().add_jm().format(dateTime);
    return formatedDateTime;
  }

  double calcAmount({required int decimal, required String value}) {
    final double realValue = double.parse(value) / (pow(10, decimal));
    return realValue;
  }

  bool isSender({required String walletAddress}) {
    return sender.address == walletAddress;
  }

  Map<String, dynamic> toJson() => _$OperationModelToJson(this);

  @override
  List<Object?> get props => [
        type,
        id,
        level,
        timestamp,
        block,
        hash,
        counter,
        sender,
        gasLimit,
        gasUsed,
        storageLimit,
        storageUsed,
        bakerFee,
        storageFee,
        allocationFee,
        target,
        amount,
        status,
        hasInternals,
        parameter,
      ];
}
