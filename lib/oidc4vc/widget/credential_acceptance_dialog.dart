import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/model/credential_acceptance_data.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:flutter/material.dart';

/// "Add credential to your wallet?" - shown once all the offered
/// credentials have been fetched, before any of them are recorded, per
/// ticket #3506. The user picks which of the fetched credentials to keep.
class CredentialAcceptanceDialog extends StatefulWidget {
  const CredentialAcceptanceDialog({
    super.key,
    required this.issuerName,
    required this.isTrusted,
    required this.items,
    this.onSelectionChanged,
  });

  final String issuerName;
  final bool isTrusted;
  final List<CredentialAcceptanceItem> items;
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// Shows the dialog and returns the indexes (into [items]) of the
  /// credentials the user selected. Empty if the user declines or selects
  /// nothing.
  static Future<Set<int>> show({
    required BuildContext context,
    required String issuerName,
    required bool isTrusted,
    required List<CredentialAcceptanceItem> items,
  }) async {
    final selected = <int>{};

    final accepted =
        await showDialog<bool>(
          context: context,
          builder: (_) => CredentialAcceptanceDialog(
            issuerName: issuerName,
            isTrusted: isTrusted,
            items: items,
            onSelectionChanged: (updated) {
              selected
                ..clear()
                ..addAll(updated);
            },
          ),
        ) ??
        false;

    return accepted ? selected : <int>{};
  }

  @override
  State<CredentialAcceptanceDialog> createState() =>
      _CredentialAcceptanceDialogState();
}

class _CredentialAcceptanceDialogState
    extends State<CredentialAcceptanceDialog> {
  final Set<int> _selected = {};

  void _toggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
    widget.onSelectionChanged?.call(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return SafeArea(
      child: ConfirmDialog(
        title: l10n.credentialAcceptTitle,
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.issuedByLabel, style: textTheme.bodyMedium),
                Text(widget.issuerName, style: textTheme.titleMedium),
                const SizedBox(height: 8),
                TrustBadge(
                  isTrusted: widget.isTrusted,
                  trustedLabel: l10n.trustedIssuerLabel,
                  notTrustedLabel: l10n.issuerNotVerifiedLabel,
                  notTrustedDescription: widget.isTrusted
                      ? null
                      : l10n.issuerNotVerifiedDescription,
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < widget.items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TransparentInkWell(
                      onTap: () => _toggle(i),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _selected.contains(i)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: onSurface,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.items[i].credentialDisplayName,
                                  style: textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          if (widget.items[i].claims.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 32),
                              child: ClaimList(claims: widget.items[i].claims),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        yes: widget.isTrusted ? l10n.addToWalletLabel : l10n.addLabel,
        no: l10n.decline,
        invertedCallToAction: !widget.isTrusted,
      ),
    );
  }
}
