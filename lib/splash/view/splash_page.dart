import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/home/home.dart';
import 'package:ssi_crypto_wallet/splash/view/brand.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (context) => const SplashPage(),
      settings: const RouteSettings(name: '/splash'),
    );
  }

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _controllerScale = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..forward();
  late final Animation<double> _animationScale = CurvedAnimation(
    parent: _controllerScale,
    curve: Curves.easeInQuint,
  );

  late final AnimationController _controllerTransparency = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..forward();
  late final Animation<double> _animationTransparency =
      // ignore: prefer_int_literals
      Tween(begin: 2.0, end: 0.0).animate(_controllerTransparency);

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).push<void>(HomePage.route());
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerScale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animationTransparency,
          child: ScaleTransition(
            scale: _animationScale,
            child: const Brand(),
          ),
        ),
      ),
    );
  }
}
