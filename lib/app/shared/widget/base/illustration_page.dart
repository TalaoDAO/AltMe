import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseIllustrationPage extends StatelessWidget {
  const BaseIllustrationPage({
    Key? key,
    required this.asset,
    this.description,
    required this.action,
    this.onPressed,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  final String asset;
  final String? description;
  final String action;

  final VoidCallback? onPressed;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 1.2,
          color: backgroundColor,
          child: SvgPicture.asset(asset),
        ),
        BasePage(
          scrollView: false,
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (description != null && description!.isNotEmpty)
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.illustrationPageDescription,
                ),
              Expanded(child: Container()),
              MyOutlinedButton(
                onPressed: onPressed,
                text: action,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
