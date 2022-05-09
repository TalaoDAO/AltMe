import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/starter/starter.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class StarterScreen extends StatelessWidget {
  const StarterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: SizeHelper.spaceSmall),
              decoration: BoxDecoration(
                gradient: Theme.of(context).darkGradient,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Spacer(
                    flex: 3,
                  ),
                  AltMeLogo(),
                  Spacer(
                    flex: 1,
                  ),
                  StarterTitle(),
                  Spacer(
                    flex: 2,
                  ),
                  CityImage(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(SizeHelper.spaceSmall),
              decoration: BoxDecoration(
                gradient: Theme.of(context).darkGradient,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CreateWalletButton(
                    onPressed: () {
                      // TODO(all): handle navigator
                      Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: SizeHelper.spaceSmall,
                  ),
                  const ImportWalletButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
