import 'package:altme/nft/models/index.dart';
import 'package:altme/nft/view/widgets/index.dart';
import 'package:flutter/material.dart';

class NftPage extends StatefulWidget {
  const NftPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const NftPage(),
        settings: const RouteSettings(name: '/nftPage'),
      );

  @override
  _NftPageState createState() => _NftPageState();
}

class _NftPageState extends State<NftPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFT page'),),
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
            Expanded(child: NftList(nftList: NftModel.fakeList(),)),
          ],
        ),
      ),
    );
  }
}
