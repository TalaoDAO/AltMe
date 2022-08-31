import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalWalletBalance extends StatelessWidget {
  const TotalWalletBalance({
    Key? key,
    required this.tokensCubit,
  }) : super(key: key);

  final TokensCubit tokensCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokensCubit, TokensState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: InkWell(
                onTap: tokensCubit.toggleIsSecure,
                child: MyText(
                  state.isSecure
                      ? '****'
                      : '''${state.totalBalanceInUSD.toStringAsFixed(2).formatNumber()} \$''',
                  minFontSize: 8,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
