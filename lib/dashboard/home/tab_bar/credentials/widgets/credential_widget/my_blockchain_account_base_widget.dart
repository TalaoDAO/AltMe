import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class MyBlockchainAccountBaseWidget extends StatelessWidget {
  const MyBlockchainAccountBaseWidget({
    super.key,
    required this.name,
    required this.walletAddress,
    required this.image,
  });

  final String name;
  final String walletAddress;
  final String image;

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.myAccountCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate:
              MyBlockchainAccountBaseWidgetDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'name',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.14,
                child: MyText(
                  name,
                  style: Theme.of(context).textTheme.subMessage.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ),
            // LayoutId(
            //   id: 'accountName',
            //   child: FractionallySizedBox(
            //     widthFactor: 0.8,
            //     heightFactor: 0.16,
            //     child: MyText(
            //       accountName,
            //       style: Theme.of(context).textTheme.title,
            //     ),
            //   ),
            // ),
            LayoutId(
              id: 'image',
              child: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 0.2,
                child: Image.asset(image),
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
                    style: Theme.of(context).textTheme.subMessage.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
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
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild(
        'name',
        Offset(size.width * 0.06, size.height * 0.27),
      );
    }

    if (hasChild('image')) {
      layoutChild('image', BoxConstraints.loose(size));
      positionChild(
        'image',
        Offset(size.width * 0.8, size.height * 0.05),
      );
    }

    // if (hasChild('accountName')) {
    //   layoutChild('accountName', BoxConstraints.loose(size));
    //   positionChild(
    //     'accountName',
    //     Offset(size.width * 0.06, size.height * 0.5),
    //   );
    // }

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
