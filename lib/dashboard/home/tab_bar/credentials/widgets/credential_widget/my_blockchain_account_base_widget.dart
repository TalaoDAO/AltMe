import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:flutter/material.dart';

class MyBlockchainAccountBaseWidget extends StatelessWidget {
  const MyBlockchainAccountBaseWidget({
    super.key,
    required this.proofMessage,
    required this.walletAddress,
    required this.background,
  });

  final String proofMessage;
  final String walletAddress;
  final String background;

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: background,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: MyBlockchainAccountBaseWidgetDelegate(
            position: Offset.zero,
          ),
          children: [
            LayoutId(
              id: 'proofMessage',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.14,
                child: MyText(
                  proofMessage,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            LayoutId(
              id: 'walletAddress',
              child: FractionallySizedBox(
                widthFactor: 0.88,
                heightFactor: 0.26,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: MyText(
                    walletAddress,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                    minFontSize: 8,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBlockchainAccountBaseWidgetDelegate extends MultiChildLayoutDelegate {
  MyBlockchainAccountBaseWidgetDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('proofMessage')) {
      layoutChild('proofMessage', BoxConstraints.loose(size));
      positionChild(
        'proofMessage',
        Offset(size.width * 0.06, size.height * 0.5),
      );
    }

    if (hasChild('image')) {
      layoutChild('image', BoxConstraints.loose(size));
      positionChild('image', Offset(size.width * 0.8, size.height * 0.05));
    }

    if (hasChild('walletAddress')) {
      layoutChild('walletAddress', BoxConstraints.loose(size));
      positionChild(
        'walletAddress',
        Offset(size.width * 0.06, size.height * 0.70),
      );
    }
  }

  @override
  bool shouldRelayout(MyBlockchainAccountBaseWidgetDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
