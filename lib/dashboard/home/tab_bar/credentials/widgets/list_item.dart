import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class _BaseItem extends StatefulWidget {
  const _BaseItem({
    Key? key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.color = Colors.white,
    this.isCustom = false,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final Color color;
  final bool isCustom;

  @override
  __BaseItemState createState() => __BaseItemState();
}

class __BaseItemState extends State<_BaseItem>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // controller?.dispose();
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: !widget.enabled ? 0.33 : 1,
        child: GestureDetector(
          onTap: widget.onTap,
          child: IntrinsicHeight(child: widget.child),
        ),
      );
}

class CredentialsListPageItem extends StatelessWidget {
  const CredentialsListPageItem({
    Key? key,
    required this.credentialModel,
    required this.displayInGrid,
    this.onTap,
    this.selected,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final bool displayInGrid;
  final VoidCallback? onTap;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return _BaseItem(
      enabled: true,
      isCustom: true,
      onTap: onTap ??
          () {
            Navigator.of(context)
                .push<void>(CredentialsDetailsPage.route(credentialModel));
          },
      color: credentialModel
          .credentialPreview.credentialSubjectModel.credentialSubjectType
          .backgroundColor(credentialModel),
      child: selected == null
          ? DisplayInList(
              credentialModel: credentialModel,
              displayInGrid: displayInGrid,
            )
          : displaySelectionElement(context),
    );
  }

  Widget displaySelectionElement(BuildContext context) {
    //final credential = Credential.fromJsonOrDummy(credentialModel.data);
    final l10n = context.l10n;
    return CredentialSelectionPadding(
      child: Column(
        children: <Widget>[
          DisplayInSelectionList(credentialModel: credentialModel),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Image.asset(
                        IconStrings.checkCircleGreen,
                        height: 20,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          l10n.inMyWallet,
                          style: Theme.of(context)
                              .textTheme
                              .credentialSurfaceText
                              .copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected! ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 25,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CredentialIcon extends StatelessWidget {
  const CredentialIcon({
    Key? key,
    required this.iconData,
    this.color,
    this.size = 24,
  }) : super(key: key);

  final IconData iconData;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: size,
      color: color ?? Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
