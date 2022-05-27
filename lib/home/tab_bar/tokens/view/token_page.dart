import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:altme/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TokenPage extends StatelessWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokensCubit>(
      create: (context) =>
          TokensCubit(client: DioClient(Urls.tezosNftBaseUrl, Dio())),
      child: const TokenView(),
    );
  }
}

class TokenView extends StatefulWidget {
  const TokenView({Key? key}) : super(key: key);

  @override
  _TokenViewState createState() => _TokenViewState();
}

class _TokenViewState extends State<TokenView> {
  @override
  void initState() {
    context.read<TokensCubit>().getBalanceOfAssetList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyAssetsText(),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<TokensCubit, TokensState>(
              bloc: context.read<TokensCubit>(),
              builder: (_, state) {
                if (state.status == AppStatus.loading) {
                  return const TokenListShimmer();
                } else if (state.status == AppStatus.success) {
                  return TokenList(tokenList: state.data);
                } else {
                  final MessageHandler messageHandler =
                      state.message!.messageHandler!;
                  final String message =
                      messageHandler.getMessage(context, messageHandler);
                  return Center(
                    child: Text(message),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
