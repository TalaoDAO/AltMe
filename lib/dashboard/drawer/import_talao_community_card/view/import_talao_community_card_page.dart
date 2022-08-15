import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportTalaoCommunityCardPage extends StatelessWidget {
  const ImportTalaoCommunityCardPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const ImportTalaoCommunityCardPage(),
        settings: const RouteSettings(name: '/importTalaoCommunityCardPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImportTalaoCommunityCardCubit(
        walletCubit: context.read<WalletCubit>(),
      ),
      child: const ImportTalaoCommunityCardView(),
    );
  }
}

class ImportTalaoCommunityCardView extends StatefulWidget {
  const ImportTalaoCommunityCardView({Key? key}) : super(key: key);

  @override
  _ImportTalaoCommunityCardViewState createState() =>
      _ImportTalaoCommunityCardViewState();
}

class _ImportTalaoCommunityCardViewState
    extends State<ImportTalaoCommunityCardView> {
  late TextEditingController privateKeyController;

  @override
  void initState() {
    super.initState();
    privateKeyController = TextEditingController();
    privateKeyController.addListener(() {
      context
          .read<ImportTalaoCommunityCardCubit>()
          .isPrivateKeyValid(privateKeyController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ImportTalaoCommunityCardCubit,
        ImportTalaoCommunityCardState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }

        if (state.status == AppStatus.success) {}
      },
      builder: (context, state) {
        return BasePage(
          title: l10n.drawerTalaoCommunityCard,
          titleLeading: const BackLeadingButton(),
          scrollView: false,
          body: Column(
            children: [
              Expanded(
                child: BackgroundCard(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          children: [
                            Text(
                              l10n.drawerTalaoCommunityCardTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.infoTitle,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              l10n.drawerTalaoCommunityCardSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .infoSubtitle
                                  .copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Stack(
                          alignment: Alignment.bottomRight,
                          fit: StackFit.loose,
                          children: [
                            BaseTextField(
                              hint: l10n.drawerTalaoCommunityCardTextBoxMessage,
                              fillColor: Colors.transparent,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .hintTextFieldStyle,
                              controller: privateKeyController,
                              error: state.isTextFieldEdited &&
                                      !state.isPrivateKeyValid
                                  ? l10n.drawerTalaoCommunityCardKeyError
                                  : null,
                              height: 160,
                              borderRadius: Sizes.normalRadius,
                              maxLines: 10,
                            ),
                            if (state.isPrivateKeyValid)
                              Container(
                                alignment: Alignment.center,
                                width: Sizes.icon2x,
                                height: Sizes.icon2x,
                                padding: const EdgeInsets.all(2),
                                margin: const EdgeInsets.all(Sizes.spaceNormal),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .checkMarkColor,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: Sizes.icon,
                                  color: Colors.white,
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.drawerTalaoCommunityCardSubtitle2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .infoSubtitle
                              .copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          navigation: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              child: MyGradientButton(
                onPressed: !state.isPrivateKeyValid ? null : () async {},
                text: l10n.import,
              ),
            ),
          ),
        );
      },
    );
  }
}
