import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawerCubit(),
      child: DrawerView(localAuthApi: LocalAuthApi()),
    );
  }
}

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key, required this.localAuthApi}) : super(key: key);

  final LocalAuthApi localAuthApi;

  //method for set new pin code
  Future<void> setNewPinCode(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    await Navigator.of(context).push<void>(
      EnterNewPinCodePage.route(
        isValidCallback: () {
          Navigator.of(context).pop();
          AlertMessage.showStringMessage(
            context: context,
            message: l10n.yourPinCodeChangedSuccessfully,
            messageType: MessageType.success,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.drawerBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<DrawerCubit, DrawerState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const DrawerCloseButton(),
                      const SizedBox(height: 5),
                      const AltMeLogo(size: 75),
                      const DidKey(),
                      const SizedBox(height: 15),
                      ManageItems(
                        localAuthApi: localAuthApi,
                        drawerState: state,
                      ),
                      const SizedBox(height: 15),
                      const WalletItems(),
                      const SizedBox(height: 15),
                      const SecurityItems(),
                      const SizedBox(height: 15),
                      const NetworkItems(),
                      const SizedBox(height: 15),
                      const IssuerItems(),
                      const SizedBox(height: 15),
                      const AboutItems(),
                      const SizedBox(height: 15),
                      const DrawerAppVersion(),
                      const SizedBox(height: 15),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
