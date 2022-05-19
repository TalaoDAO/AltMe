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
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            MyCollectionText(),
            Padding(
              padding: EdgeInsets.only(top: 8,bottom: 16),
              child: Divider(
                height: 1,
              ),
            ),
            Expanded(child: NftListShimmer()),
          ],
        ),
      ),
    );
  }
}
