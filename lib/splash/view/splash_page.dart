import 'package:altme/app/app.dart';
import 'package:altme/flavor/cubit/flavor_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/splash/cubit/splash_cubit.dart';
import 'package:altme/temp/temp.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(secure_storage.getSecureStorage),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((AnimationStatus status) async {
        await context.read<ThemeCubit>().getCurrentTheme();
        if (status == AnimationStatus.completed) {
          // TODO(all): remove_later
          // MessageHandler a =
          // NetworkException(NetworkError.NETWORK_ERROR_UNABLE_TO_PROCESS);
          // print(a.getErrorMessage(context, a));

          //ignore: use_build_context_synchronously
          await context.read<SplashCubit>().initialiseApp();
        }
      });
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FlavorCubit flavorCubit = context.read<FlavorCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashStatus>(
          listener: (context, state) {
            if (state == SplashStatus.onboarding) {
              Navigator.of(context).push<void>(OnBoardingStartPage.route());
            }
            if (state == SplashStatus.bypassOnboarding) {
              Navigator.of(context).push<void>(CredentialsListPage.route());
            }
          },
        ),
        BlocListener<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state.message != null) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: state.message!,
              );
            }
            if (state.status == WalletStatus.delete) {
              Navigator.of(context).pop();
            }
            if (state.status == WalletStatus.reset) {
              Navigator.of(context)
                  .pushReplacement<void, void>(ChooseWalletTypePage.route());
            }
          },
        ),
      ],
      child: BasePage(
        backgroundColor: const Color(0xffffffff),
        scrollView: false,
        body: Center(
          child: SizedBox.square(
            dimension: MediaQuery.of(context).size.width * 0.4,
            child: ScaleTransition(
              key: const Key('scaleTransition'),
              scale: _scaleAnimation,
              child: Image.asset(
                flavorCubit.state == FlavorMode.development
                    ? ImageStrings.splashDev
                    : flavorCubit.state == FlavorMode.staging
                        ? ImageStrings.splashStage
                        : ImageStrings.splash,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
