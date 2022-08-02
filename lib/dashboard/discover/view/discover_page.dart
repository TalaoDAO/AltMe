import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: BackgroundCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Discover will be available soon !',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.messageTitle,
                ),
                const SizedBox(height: 15),
                Text(
                  'Get ready to discover the best deals and offers in Web 3',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.messageSubtitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
