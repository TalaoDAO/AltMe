import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/nft/cubit/nft_cubit.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/my_collection_text.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/nft_list.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/nft_list_shimmer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NftPage extends StatelessWidget {
  const NftPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NftCubit>(
      create: (context) =>
          NftCubit(client: DioClient(Urls.tezosNftBaseUrl, Dio())),
      child: const NftView(),
    );
  }
}

class NftView extends StatefulWidget {
  const NftView({Key? key}) : super(key: key);

  @override
  _NftViewState createState() => _NftViewState();
}

class _NftViewState extends State<NftView> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<NftCubit>().getTezosNftList();
    });
    super.initState();
  }

  Future<void> onRefresh() async {
    await context.read<NftCubit>().getTezosNftList();
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
          const MyCollectionText(),
          Expanded(
            child: BlocBuilder<NftCubit, NftState>(
              bloc: context.read<NftCubit>(),
              builder: (_, state) {
                if (state.status == AppStatus.loading ||
                    state.status == AppStatus.init) {
                  return NftListShimmer(onRefresh: onRefresh);
                } else if (state.status == AppStatus.success) {
                  return NftList(
                    nftList: state.data,
                    onRefresh: onRefresh,
                  );
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
