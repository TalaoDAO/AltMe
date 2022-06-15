import 'package:altme/app/app.dart';
import 'package:altme/home/bottom_bar/profile/cubit/profile_cubit.dart';
import 'package:altme/home/tab_bar/nft/cubit/nft_cubit.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/my_collection_text.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/nft_list.dart';
import 'package:altme/home/tab_bar/nft/view/widgets/nft_list_shimmer.dart';
import 'package:altme/theme/theme.dart';
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
            Dio()),
        secureStorageProvider: getSecureStorage,
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

  Future<void> onRefresh() async {
    await context.read<NftCubit>().getTezosNftList();
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
          const MyCollectionText(),
          Expanded(
            child: BlocConsumer<NftCubit, NftState>(
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
                  return NftList(nftList: state.data, onRefresh: onRefresh);
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
