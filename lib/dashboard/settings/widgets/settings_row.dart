import 'package:flutter/material.dart';
import 'package:wallet_ui/wallet_ui.dart';

/// A row of the Settings pages: an icon, a title, an optional subtitle and a
/// chevron.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
  });

  /// Asset path of the leading icon.
  final String icon;
  final String title;
  final String? subtitle;

  /// Replaces the chevron, for example with an unread badge.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return WalletListItem(
      leading: WalletIcon(icon),
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      showChevron: true,
      showDivider: true,
      onTap: onTap,
    );
  }
}
