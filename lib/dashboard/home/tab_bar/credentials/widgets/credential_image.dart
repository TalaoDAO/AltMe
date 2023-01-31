import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class CredentialImage extends StatelessWidget {
  const CredentialImage({
    this.child,
    required this.image,
    super.key,
  });
  final Widget? child;
  final String image;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(image),
          ),
        ),
        child: child,
      ),
    );
  }
}
