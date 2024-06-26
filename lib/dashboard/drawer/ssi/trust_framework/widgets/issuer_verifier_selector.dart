import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IssuerVerifierSelector extends StatelessWidget {
  const IssuerVerifierSelector({
    super.key,
    required this.title,
    required this.isChecked,
    this.onTap,
  });

  final bool isChecked;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          onTap: onTap,
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Icon(
            isChecked ? Icons.check_circle : Icons.circle_outlined,
            size: Sizes.icon2x,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }
}
