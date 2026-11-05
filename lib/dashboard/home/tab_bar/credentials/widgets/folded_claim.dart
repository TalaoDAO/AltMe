import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

/// The label of one shared claim, with its value one tap away, as the
/// presentation screens list what a verifier or reader asks for. [note], when
/// given, reads under the label, e.g. that the reader keeps the value.
class FoldedClaim extends StatelessWidget {
  const FoldedClaim({
    super.key,
    required this.title,
    required this.value,
    this.note,
  });

  final String title;
  final String value;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final note = this.note;
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: EdgeInsets.zero,
      dense: true,
      // Rows as tall as their label, not a Material tile's 48 dp minimum.
      minTileHeight: 0,
      visualDensity: VisualDensity.compact,
      title: Text(title, style: textTheme.titleSmall),
      subtitle: note == null ? null : Text(note, style: textTheme.bodySmall),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      // CredentialField shows a data: URI image as a picture.
      children: [
        CredentialField(
          value: value,
          showVertically: true,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

/// The radio mark under a credential's card when the user picks one of
/// several credentials answering the same query.
class CredentialSelectionMark extends StatelessWidget {
  const CredentialSelectionMark({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
