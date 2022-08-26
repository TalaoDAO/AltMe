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
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) =>
      _$OperationModelFromJson(json);

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

  DateTime get dateTime {
    return DateFormat('y-M-dThh:mm:ssZ').parse(timestamp);
  }

  String get formatedDateTime {
    final formatedDateTime = DateFormat.yMEd().add_jm().format(dateTime);
    return formatedDateTime;
  }

  String get XTZAmount {
    final formatter = NumberFormat('#,###');
    final priceString = amount.toString();
    const decimalsNum = 6;
    if (decimalsNum == 0) {
      final intPart = formatter.format(double.parse(priceString));
      return '$intPart.0';
    } else if (decimalsNum == priceString.length) {
      return '0.$priceString';
    } else if (priceString.length < decimalsNum) {
      final numberOfZero = decimalsNum - priceString.length;
      // ignore: lines_longer_than_80_chars
      return '0.${List.generate(numberOfZero, (index) => '0').join()}$priceString';
    } else {
      final rightPart = formatter.format(
        double.parse(
          priceString.substring(0, priceString.length - decimalsNum),
        ),
      );
      final realDoublePriceInString =
          // ignore: lines_longer_than_80_chars
          '$rightPart.${priceString.substring(priceString.length - decimalsNum, priceString.length)}';
      return realDoublePriceInString;
    }
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
      ];
}
