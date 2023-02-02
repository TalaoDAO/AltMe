import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
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
              if (widget.nftModel is TezosNftModel)
                MyText(
                  (widget.nftModel as TezosNftModel).symbol ?? '--',
                  style: Theme.of(context).textTheme.bodySmall2,
                  maxLines: 1,
                  minFontSize: 12,
                ),
              const SizedBox(height: Sizes.spaceNormal),
              if (widget.nftModel.description?.contains('<p>') ?? false)
                Html(data: widget.nftModel.description ?? '')
              else
                Text(
                  widget.nftModel.description ?? '',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              if (widget.nftModel is TezosNftModel)
                ...buildTezosMoreDetails(l10n),
              // Text(
              //   l10n.seeMoreNFTInformationOn,
              //   style: Theme.of(context).textTheme.bodyText1,
              // ),
              // const SizedBox(height: Sizes.spaceSmall),
              // Row(
              //   children: [
              //     NftUrlWidget(
              //       text: 'Objkt.com',
              //       onPressed: () async {
              //         await LaunchUrl.launch(Urls.objktUrl);
              //       },
              //     ),
              //     const SizedBox(width: 15),
              //     NftUrlWidget(
              //       text: 'Rarible.com',
              //       onPressed: () async {
              //         await LaunchUrl.launch(Urls.raribleUrl);
              //       },
              //     ),
              //   ],
              // )
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
      if (nftModel.identifier != null)
        const SizedBox(height: Sizes.spaceNormal),
      if (nftModel.identifier != null)
        Row(
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
      if (nftModel.creators != null)
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
      if (nftModel.creators != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.creators} : ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Flexible(
              child: Text(
                nftModel.creators?.join(', ') ?? '?',
                style: Theme.of(context).textTheme.bodySmall3,
              ),
            ),
          ],
        ),
      if (nftModel.publishers != null)
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
      if (nftModel.publishers != null)
        Row(
          children: [
            Text(
              '${l10n.publishers} : ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              nftModel.publishers?.join(', ') ?? '?',
              style: Theme.of(context).textTheme.bodySmall3,
            )
          ],
        ),
      if (nftModel.date != null)
        const SizedBox(
          height: Sizes.spaceXSmall,
        ),
      if (nftModel.date != null)
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
    ];
  }
}
