// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_withdrawal_page_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsertWithdrawalPageState _$InsertWithdrawalPageStateFromJson(
        Map<String, dynamic> json) =>
    InsertWithdrawalPageState(
      selectedToken: json['selectedToken'] == null
          ? const TokenModel(
              contractAddress: '',
              name: 'Tezos',
              symbol: 'XTZ',
              icon:
                  'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
              balance: '00000000',
              decimals: '6',
              standard: 'fa1.2',
              decimalsToShow: 2)
          : TokenModel.fromJson(json['selectedToken'] as Map<String, dynamic>),
      amount: json['amount'] as String? ?? '0',
      isValidWithdrawal: json['isValidWithdrawal'] as bool? ?? false,
    );

Map<String, dynamic> _$InsertWithdrawalPageStateToJson(
        InsertWithdrawalPageState instance) =>
    <String, dynamic>{
      'selectedToken': instance.selectedToken,
      'amount': instance.amount,
      'isValidWithdrawal': instance.isValidWithdrawal,
    };
