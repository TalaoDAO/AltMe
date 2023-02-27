import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class NftDetailsPage extends StatelessWidget {
  const NftDetailsPage({
    super.key,
    required this.nftModel,
  });

  final NftModel nftModel;

  static Route<dynamic> route({required NftModel nftModel}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/nftDetailsPage'),
      builder: (_) => NftDetailsPage(
        nftModel: nftModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NftDetailsView(
      nftModel: nftModel,
    );
  }
}

class NftDetailsView extends StatefulWidget {
  const NftDetailsView({
    super.key,
    required this.nftModel,
  });

  final NftModel nftModel;

  @override
  State<NftDetailsView> createState() => _NftDetailsViewState();
}

class _NftDetailsViewState extends State<NftDetailsView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isTezos = widget.nftModel is TezosNftModel;
    return BasePage(
      title: l10n.nftDetails,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceNormal),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: CachedImageFromNetwork(
                  widget.nftModel.displayUrl ??
                      (widget.nftModel.thumbnailUrl ?? ''),
                  fit: BoxFit.fill,
                  errorMessage: l10n.nftTooBigToLoad,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Sizes.largeRadius),
                  ),
                ),
              ),
              const SizedBox(
                height: Sizes.spaceSmall,
              ),
              MyText(
                '${widget.nftModel.name} ${widget.nftModel.tokenId}',
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                minFontSize: 16,
              ),
              MyText(
                widget.nftModel.symbol ?? '--',
                style: Theme.of(context).textTheme.bodySmall2,
                maxLines: 1,
                minFontSize: 12,
              ),
              if (widget.nftModel.description != null &&
                  widget.nftModel.description!.isNotEmpty) ...[
                const SizedBox(height: Sizes.spaceNormal),
                if (widget.nftModel.description?.contains('<p>') ?? false)
                  Html(data: widget.nftModel.description ?? '')
                else
                  Text(
                    widget.nftModel.description ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
              if (widget.nftModel is TezosNftModel)
                ...buildTezosMoreDetails(l10n)
              else
                ...buildEthereumMoreDetails(l10n),
            ],
          ),
        ),
      ),
      navigation: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: MyGradientButton(
            text: l10n.send,
            onPressed: widget.nftModel.isTransferable == false
                ? null
                : () {
                    Navigator.of(context).push<void>(
                      ConfirmTokenTransactionPage.route(
                        selectedToken: isTezos
                            ? (widget.nftModel as TezosNftModel).getToken()
                            : (widget.nftModel as EthereumNftModel).getToken(),
                        withdrawalAddress: '',
                        amount: 1,
                        isNFT: true,
                      ),
                    );
                  },
          ),
        ),
      ),
    );
  }

  List<Widget> buildTezosMoreDetails(AppLocalizations l10n) {
    final nftModel = widget.nftModel as TezosNftModel;
    return [
      const SizedBox(height: Sizes.spaceNormal),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.contractAddress} : ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  nftModel.contractAddress,
                  style: Theme.of(context).textTheme.bodySmall3,
                ),
              ),
              IconButton(
            icon: const Icon(
              Icons.open_in_new,
              size: Sizes.icon,
            ),
            onPressed: () {
              openAddressBlockchainExplorer(
                context.read<ManageNetworkCubit>().state.network,
                nftModel.contractAddress,
              );
            },
          ),
            ],
          ),
        ],
      ),
      if (nftModel.identifier != null) ...[
        const SizedBox(height: Sizes.spaceNormal),
        Column(
          children: [
            Text(
              '${l10n.identifier} : ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              nftModel.identifier ?? '?',
              style: Theme.of(context).textTheme.bodySmall3,
            )
          ],
        ),
      ],
      if (nftModel.creators != null && nftModel.creators!.isNotEmpty) ...[
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
        Text(
          '${l10n.creators} : ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                nftModel.creators?.join(', ') ?? '?',
                style: Theme.of(context).textTheme.bodySmall3,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.open_in_new,
                size: Sizes.icon,
              ),
              onPressed: () {
                openAddressBlockchainExplorer(
                  context.read<ManageNetworkCubit>().state.network,
                  nftModel.creators!.first,
                );
              },
            ),
          ],
        ),
      ],
      if (nftModel.publishers != null && nftModel.publishers!.isNotEmpty) ...[
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
        Text(
          '${l10n.publishers} : ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                nftModel.publishers?.join(', ') ?? '?',
                style: Theme.of(context).textTheme.bodySmall3,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.open_in_new,
                size: Sizes.icon,
              ),
              onPressed: () {
                openAddressBlockchainExplorer(
                  context.read<ManageNetworkCubit>().state.network,
                  nftModel.publishers!.first,
                );
              },
            ),
          ],
        ),
      ],
      if (nftModel.date != null) ...[
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
        Row(
          children: [
            Text(
              '${l10n.createDate} : ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              UiDate.normalFormat(nftModel.date) ?? '?',
              style: Theme.of(context).textTheme.bodySmall3,
            ),
          ],
        ),
      ]
    ];
  }

  List<Widget> buildEthereumMoreDetails(AppLocalizations l10n) {
    final nftModel = widget.nftModel as EthereumNftModel;
    return [
      const SizedBox(height: Sizes.spaceNormal),
      Text(
        '${l10n.contractAddress} : ',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Row(
        children: [
          Flexible(
            child: Text(
              nftModel.contractAddress,
              style: Theme.of(context).textTheme.bodySmall3,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.open_in_new,
              size: Sizes.icon,
            ),
            onPressed: () {
              openAddressBlockchainExplorer(
                context.read<ManageNetworkCubit>().state.network,
                nftModel.contractAddress,
              );
            },
          ),
        ],
      ),
      if (nftModel.minterAddress != null && nftModel.type != 'ERC1155') ...[
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
        Text(
          '${l10n.creator} : ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                nftModel.minterAddress ?? '?',
                style: Theme.of(context).textTheme.bodySmall3,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.open_in_new,
                size: Sizes.icon,
              ),
              onPressed: () {
                openAddressBlockchainExplorer(
                  context.read<ManageNetworkCubit>().state.network,
                  nftModel.minterAddress!,
                );
              },
            ),
          ],
        ),
      ],
      if (nftModel.lastMetadataSync != null) ...[
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
        Row(
          children: [
            Text(
              '${l10n.lastMetadataSync} : ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              UiDate.normalFormat(nftModel.lastMetadataSync) ?? '?',
              style: Theme.of(context).textTheme.bodySmall3,
            ),
          ],
        ),
      ]
    ];
  }
}
