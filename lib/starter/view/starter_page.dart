import 'package:altme/app/app.dart';
import 'package:altme/starter/view/widgets/widgets.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({Key? key}) : super(key: key);

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
                  const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.darkGradientStartColor,
                    Theme.of(context).colorScheme.darkGradientEndColor
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
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
              // TODO(Taleb): replace loading widget and version widget here
              // padding: const EdgeInsets.all(SizeHelper.spaceSmall),
              // decoration: BoxDecoration(
              //   gradient: AppTheme.darkGradient,
              // ),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     CreateWalletButton(
              //       onPressed: () {
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (_) => const HomeScreen()));
              //       },
              //     ),
              //     const SizedBox(
              //       height: SizeHelper.spaceSmall,
              //     ),
              //     const ImportWalletButton(),
              //   ],
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
