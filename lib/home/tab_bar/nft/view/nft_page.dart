import 'package:altme/app/app.dart';
import 'package:altme/home/bottom_bar/profile/cubit/profile_cubit.dart';
import 'package:altme/home/tab_bar/nft/cubit/nft_cubit.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/my_collection_text.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/nft_list.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/nft_list_shimmer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class NftPage extends StatelessWidget {
  const NftPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NftCubit>(
      create: (context) => NftCubit(
        client: DioClient(
          context.read<ProfileCubit>().state.model.tezosNetwork.tzktUrl,
          Dio(),
        ),
        secureStorageProvider: getSecureStorage,
        walletCubit: context.read<WalletCubit>(),
      ),
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
  OverlayEntry? _overlay;
  int _offset = 0;
  final _limit = 15;

  Future<void> onRefresh() async {
    _offset = 0;
    await context.read<NftCubit>().getTezosNftList(offset: _offset);
  }

  Future<void> onScrollEnded() async {
    _offset += _limit;
    _overlay =
        OverlayEntry(builder: (_) => const LoadingDialog());
    Overlay.of(context)!.insert(_overlay!);

    await context.read<NftCubit>().getTezosNftList(offset: _offset);

    _overlay?.remove();
    _overlay = null;
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
            child: BlocConsumer<NftCubit, NftState>(
              listener: (context, state) {
                if (state.status == AppStatus.loading) {
                  _overlay =
                      OverlayEntry(builder: (_) => const LoadingDialog());
                  Overlay.of(context)!.insert(_overlay!);
                } else {
                  _overlay?.remove();
                  _overlay = null;
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
              builder: (_, state) {
                String message = '';
                if (state.message != null) {
                  final MessageHandler messageHandler =
                      state.message!.messageHandler!;
                  message = messageHandler.getMessage(context, messageHandler);
                }

                if (state.status == AppStatus.fetching) {
                  return const NftListShimmer();
                } else if (state.status == AppStatus.populate) {
                  if (state.data.isEmpty) {
                    return EmptyPageView(
                      imagePath: 'assets/image/nft.png',
                      message: l10n.noNftProvidedWithYourAccount,
                      onTap: onRefresh,
                    );
                  } else {
                    return NftList(
                      nftList: state.data,
                      onRefresh: onRefresh,
                      onScrollEnded: onScrollEnded,
                    );
                  }
                } else if (state.status == AppStatus.errorWhileFetching) {
                  return ErrorView(message: message, onTap: onRefresh);
                } else {
                  return NftList(nftList: const [], onRefresh: onRefresh);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
