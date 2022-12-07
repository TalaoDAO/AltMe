import 'package:altme/app/shared/constants/icon_strings.dart';
import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class UploadFile extends StatelessWidget {
  const UploadFile({
    super.key,
    this.filePath,
    this.onTap,
  });

  final String? filePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(Sizes.smallRadius),
      color: Theme.of(context).colorScheme.cardHighlighted,
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: 85,
          decoration: BoxDecoration(
            color: filePath != null
                ? Theme.of(context).colorScheme.cardHighlighted
                : null,
            borderRadius: const BorderRadius.all(
              Radius.circular(Sizes.smallRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (filePath == null)
                Image.asset(
                  IconStrings.upload,
                  width: Sizes.icon,
                  height: Sizes.icon,
                )
              else
                Image.asset(
                  IconStrings.document,
                  width: Sizes.icon,
                  height: Sizes.icon,
                ),
              const SizedBox(
                width: Sizes.space2XSmall,
              ),
              MyText(
                filePath == null ? l10n.uploadFile : filePath!.split('/').last,
                minFontSize: 12,
                style: Theme.of(context).textTheme.uploadFileTitle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
