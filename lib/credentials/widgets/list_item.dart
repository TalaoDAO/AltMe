import 'package:altme/app/shared/widget/hero_workaround.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class _BaseItem extends StatefulWidget {
  const _BaseItem({
    Key? key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.selected,
    this.color = Colors.white,
    this.isCustom = false,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final bool? selected;
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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: widget.onTap,
            child: IntrinsicHeight(child: widget.child),
          ),
        ),
      );
}

class CredentialsListPageItem extends StatelessWidget {
  const CredentialsListPageItem({
    Key? key,
    required this.item,
    this.onTap,
    this.selected,
  }) : super(key: key);

  final CredentialModel item;
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
                .push<void>(CredentialsDetailsPage.route(item));
          },
      color: item.backgroundColor,
      child: selected == null
          ? displayListElement(context)
          : displaySelectionElement(context),
    );
  }

  Widget displayListElement(BuildContext context) {
    return item.credentialPreview.credentialSubject
        .displayInList(context, item);
  }

  Widget displaySelectionElement(BuildContext context) {
    final credential = Credential.fromJsonOrDummy(item.data);
    return CredentialSelectionPadding(
      child: Column(
        children: <Widget>[
          CredentialContainer(
            child: item.credentialPreview.credentialSubject
                .displayInSelectionList(context, item),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroFix(
                  tag: 'credential/${item.id}/icon',
                  child: selected == null
                      ? CredentialIcon(credential: credential)
                      : selected!
                          ? const CredentialCheckedBox()
                          : const CredentialUncheckedBox(),
                ),
                const SizedBox(width: 8),
                DisplayStatus(item: item, displayLabel: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CredentialUncheckedBox extends StatelessWidget {
  const CredentialUncheckedBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_box_outline_blank,
      size: 32,
      color: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}

class CredentialCheckedBox extends StatelessWidget {
  const CredentialCheckedBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_box,
      size: 32,
      color: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}

class CredentialIcon extends StatelessWidget {
  const CredentialIcon({
    Key? key,
    required this.credential,
  }) : super(key: key);

  final Credential credential;

  @override
  Widget build(BuildContext context) {
    return Icon(
      credential.credentialSubject.icon.icon,
      size: 24,
      color: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
