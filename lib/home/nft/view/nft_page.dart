import 'package:altme/app/app.dart';
import 'package:altme/home/nft/cubit/nft_cubit.dart';
import 'package:altme/home/nft/view/widgets/widgets.dart';
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
    context.read<NftCubit>().getTezosNftList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO(Taleb): update this widget after homePage widget created
        title: const Text('NFT page'),
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
            const MyCollectionText(),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: Divider(
                height: 1,
              ),
            ),
            Expanded(
              child: BlocBuilder<NftCubit, NftState>(
                bloc: context.read<NftCubit>(),
                builder: (_, state) {
                  if (state.status == AppStatus.loading) {
                    return const NftListShimmer();
                  } else if (state.status == AppStatus.success) {
                    return NftList(nftList: state.data);
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
