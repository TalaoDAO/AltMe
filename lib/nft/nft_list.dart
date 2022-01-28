import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NftList extends StatelessWidget {
  const NftList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.flutter_dash_rounded,
              size: 70,
              color: Theme.of(context).tabBarTheme.labelColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'No NFTs yet',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          InkWell(
            onTap: () => _launchURL('www.talao.co'),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Learn more',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Theme.of(context).colorScheme.secondaryVariant),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Don\'t see your NFT?'),
          ),
          InkWell(
            onTap: () => _launchURL('www.talao.co'),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Import NFTs',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Theme.of(context).colorScheme.secondaryVariant),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
