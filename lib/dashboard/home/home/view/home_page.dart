import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, homeState) {
        if (homeState.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (homeState.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: homeState.message!,
          );
        }

        if (homeState.status == AppStatus.success) {}
      },
      // Setting to hide gallery when on ios
      // child: isAndroid()
      //     ? const TabControllerPage()
      //     : const IosTabControllerPage(),
      child: const TabControllerPage(),
    );
  }
}
