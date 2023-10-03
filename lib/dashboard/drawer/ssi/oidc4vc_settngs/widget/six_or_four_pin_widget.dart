import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SixOrForUserPinWidget extends StatelessWidget {
  const SixOrForUserPinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          l10n.six_or_four_digits_user_pin_title,
                          style: Theme.of(context).textTheme.drawerItemTitle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.six_or_four_digits_user_pin_subTitle,
                          style: Theme.of(context).textTheme.drawerItemSubtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      context.read<ProfileCubit>().setUserPinDigitLength(4);
                    },
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xFFDDDDEE),
                        width: 0.5,
                      ),
                    ),
                    title: Text(
                      l10n.four_digits_user_pin,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                    trailing: Icon(
                      state.model.userPinDigitsLength == 4
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
                      context.read<ProfileCubit>().setUserPinDigitLength(6);
                    },
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xFFDDDDEE),
                        width: 0.5,
                      ),
                    ),
                    title: Text(
                      l10n.six_digits_user_pin,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                    trailing: Icon(
                      state.model.userPinDigitsLength == 6
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
    );
  }
}
