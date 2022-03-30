import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffffffff),
      scrollView: false,
      body: Center(
        child: SizedBox.square(
          dimension: MediaQuery.of(context).size.width * 0.4,
          child: Image.asset(ImageStrings.splash),
        ),
      ),
    );
  }
}
