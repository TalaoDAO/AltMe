import 'package:flutter/material.dart';

void sensibleRoute({
  required BuildContext context,
  required Route route,
  required bool isSameRoute,
}) {
  if (isSameRoute) {
    Navigator.of(context).pushReplacement<void, void>(route);
  } else {
    Navigator.of(context).push<void>(route);
  }
}
