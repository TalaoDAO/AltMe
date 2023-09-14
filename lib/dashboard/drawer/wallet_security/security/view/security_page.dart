import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const SecurityPage(),
      settings: const RouteSettings(name: '/SecurityPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.security,
      useSafeArea: true,
      scrollView: false,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      titleLeading: const BackLeadingButton(),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(Sizes.spaceSmall),
                margin: const EdgeInsets.all(Sizes.spaceXSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.cardHighlighted,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Sizes.largeRadius),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        context
                            .read<ProfileCubit>()
                            .setSecurityLevel(isSecurityLow: true);
                      },
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xFFDDDDEE),
                          width: 0.5,
                        ),
                      ),
                      title: Text(
                        l10n.lowSecurity,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      trailing: Icon(
                        state.model.isSecurityLow
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: Sizes.icon2x,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.spaceSmall,
                        vertical: Sizes.spaceXSmall,
                      ),
                      child: Divider(
                        height: 0,
                        color: Theme.of(context).colorScheme.borderColor,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        context
                            .read<ProfileCubit>()
                            .setSecurityLevel(isSecurityLow: false);
                      },
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xFFDDDDEE),
                          width: 0.5,
                        ),
                      ),
                      title: Text(
                        l10n.highSecurity,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      trailing: Icon(
                        !state.model.isSecurityLow
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: Sizes.icon2x,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
