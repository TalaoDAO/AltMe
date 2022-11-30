import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DeviceInfoDisplayInList extends StatelessWidget {
  const DeviceInfoDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DeviceInfoRecto(
      credentialModel: credentialModel,
    );
  }
}

class DeviceInfoDisplayInSelectionList extends StatelessWidget {
  const DeviceInfoDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DeviceInfoRecto(
      credentialModel: credentialModel,
    );
  }
}

class DeviceInfoDisplayDetail extends StatelessWidget {
  const DeviceInfoDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DeviceInfoRecto(
      credentialModel: credentialModel,
    );
  }
}

class DeviceInfoRecto extends Recto {
  const DeviceInfoRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final deviceInfo = credentialModel.credentialPreview.credentialSubjectModel
        as DeviceInfoModel;
    return CredentialImage(
      // TODO(Taleb): change card image when design provided
      image: ImageStrings.phoneProof,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: DeviceInfoRectoDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'deviceInfo',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.14,
                child: MyText(
                  l10n.deviceInfo,
                  style: Theme.of(context).textTheme.subMessage.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ),
            LayoutId(
              id: 'systemName',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.16,
                child: MyText(
                  deviceInfo.systemName ?? '',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            LayoutId(
              id: 'identifier',
              child: FractionallySizedBox(
                widthFactor: 0.88,
                heightFactor: 0.26,
                child: MyText(
                  deviceInfo.identifier ?? '',
                  style: Theme.of(context).textTheme.subMessage.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  minFontSize: 8,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceInfoRectoDelegate extends MultiChildLayoutDelegate {
  DeviceInfoRectoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('deviceInfo')) {
      layoutChild('deviceInfo', BoxConstraints.loose(size));
      positionChild(
        'deviceInfo',
        Offset(size.width * 0.06, size.height * 0.27),
      );
    }

    if (hasChild('systemName')) {
      layoutChild('systemName', BoxConstraints.loose(size));
      positionChild(
        'systemName',
        Offset(size.width * 0.06, size.height * 0.5),
      );
    }

    if (hasChild('identifier')) {
      layoutChild('identifier', BoxConstraints.loose(size));
      positionChild(
        'identifier',
        Offset(size.width * 0.06, size.height * 0.70),
      );
    }
  }

  @override
  bool shouldRelayout(DeviceInfoRectoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
