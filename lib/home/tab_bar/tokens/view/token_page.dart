import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:altme/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class TokenPage extends StatelessWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokensCubit>(
      create: (context) => TokensCubit(
        client: DioClient(
          context.read<ProfileCubit>().state.model.tezosNetwork.tzktUrl,
          Dio(),
        ),
        secureStorageProvider: getSecureStorage,
      ),
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
  OverlayEntry? _overlay;

  Future<void> onRefresh() async {
    await context.read<TokensCubit>().getBalanceOfAssetList();
  }

  @override
  Widget build(BuildContext context) {
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
            child: BlocConsumer<TokensCubit, TokensState>(
              listener: (context, state) {
                if (state.status == AppStatus.loading) {
                  _overlay =
                      OverlayEntry(builder: (_) => const LoadingDialog());
                  Overlay.of(context)!.insert(_overlay!);
                } else {
                  if (_overlay != null) {
                    _overlay!.remove();
                    _overlay = null;
                  }
                }

                if (state.message != null &&
                    state.status != AppStatus.errorWhileFetching) {
                  AlertMessage.showStateMessage(
                    context: context,
                    stateMessage: state.message!,
                  );
                }

                if (state.status == AppStatus.success) {
                  //some action
                }
              },
              builder: (context, state) {
                String message = '';
                if (state.message != null) {
                  final MessageHandler messageHandler =
                      state.message!.messageHandler!;
                  message = messageHandler.getMessage(context, messageHandler);
                }

                if (state.status == AppStatus.fetching) {
                  return const TokenListShimmer();
                } else if (state.status == AppStatus.populate) {
                  return TokenList(tokenList: state.data, onRefresh: onRefresh);
                } else if (state.status == AppStatus.errorWhileFetching) {
                  return ErrorView(message: message, onTap: onRefresh);
                } else {
                  return TokenList(tokenList: const [], onRefresh: onRefresh);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
