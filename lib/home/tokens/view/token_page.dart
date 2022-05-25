import 'package:altme/app/app.dart';
import 'package:altme/home/tokens/cubit/tokens_cubit.dart';
import 'package:altme/home/tokens/view/widgets/widgets.dart';
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
    return Scaffold(
      appBar: AppBar(
        // TODO(Taleb): update this widget after homePage widget created
        title: const Text('Tokens page'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyAssetsText(),
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
      ),
    );
  }
}
