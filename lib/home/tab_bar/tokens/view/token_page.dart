import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:altme/l10n/l10n.dart';
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
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<TokensCubit>().getBalanceOfAssetList();
    });
    super.initState();
  }

  Future<void> onRefresh() async {
    await context.read<TokensCubit>().getBalanceOfAssetList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyAssetsText(),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<TokensCubit, TokensState>(
              bloc: context.read<TokensCubit>(),
              builder: (_, state) {
                if (state.status == AppStatus.loading ||
                    state.status == AppStatus.init) {
                  return TokenListShimmer(onRefresh: onRefresh);
                } else if (state.status == AppStatus.success) {
                  return TokenList(tokenList: state.data, onRefresh: onRefresh);
                } else {
                  String message = '';
                  if (state.message != null) {
                    final MessageHandler messageHandler =
                        state.message!.messageHandler!;
                    message =
                        messageHandler.getMessage(context, messageHandler);
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(message),
                      BaseButton.transparent(
                        context: context,
                        onPressed: onRefresh,
                        margin: const EdgeInsets.all(Sizes.spaceLarge),
                        child: Center(
                          child: Text(l10n.tryAgain),
                        ),
                      ),
                    ],
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
