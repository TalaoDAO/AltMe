import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Returns whether the wallet exists. Without one, shows the [WalletDialog]
/// (create or import) and returns false.
///
/// It reads [HomeCubit] when called, not when the caller was built. Until the
/// splash resolves, [HomeState] defaults to [HomeStatus.hasNoWallet], so a tap
/// on the first frame is guarded as well.
bool ensureWallet(BuildContext context) {
  if (context.read<HomeCubit>().state.homeStatus != HomeStatus.hasNoWallet) {
    return true;
  }
  unawaited(
    showDialog<void>(context: context, builder: (_) => const WalletDialog()),
  );
  return false;
}
