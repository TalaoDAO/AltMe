import 'package:altme/home/home.dart';
import 'package:flutter/material.dart';

class CredentialImage extends StatelessWidget {
  const CredentialImage({
    required this.child,
    required this.image,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final String image;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Container(
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
