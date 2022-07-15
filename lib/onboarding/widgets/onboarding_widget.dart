import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/widgets/widgets.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.index,
    required this.image,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final int index;
  final String image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const AltMeLogo(size: 80),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.onBoardingTitleStyle,
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.onBoardingSubTitleStyle,
        ),
        Image.asset(
          image,
          fit: BoxFit.fitHeight,
          height: MediaQuery.of(context).size.longestSide * 0.4,
        ),
        const Spacer(),
        PageTracker(index: index),
        const SizedBox(height: 20),
        MyGradientButton(
          text: l10n.onBoardingStart,
          onPressed: () {
            /// Removes every stack except first route (splashPage)
            Navigator.pushAndRemoveUntil<void>(
              context,
              HomePage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          },
        ),
        const SizedBox(height: 20),
        GestureDetector(
          child: Text(
            l10n.learnMoreAboutAltme,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.learnMoreTextStyle,
          ),
          onTap: () async {
            await LaunchUrl.launch(Urls.appContactWebsiteUrl);
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
