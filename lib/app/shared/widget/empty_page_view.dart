import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class EmptyPageView extends StatelessWidget {
  const EmptyPageView({
    Key? key,
    required this.message,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  final String message;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
        ),
        const SizedBox(height: Sizes.spaceSmall),
        Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.errorMessage,
          ),
        ),
        const SizedBox(height: Sizes.spaceSmall),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: MyOutlinedButton(
            text: l10n.tryAgain,
            backgroundColor: Theme.of(context).colorScheme.transparent,
            onPressed: onTap,
            fontSize: 14,
            verticalSpacing: 10,
          ),
        )
      ],
    );
  }
}
