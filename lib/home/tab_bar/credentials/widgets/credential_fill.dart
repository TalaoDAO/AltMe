import 'package:flutter/material.dart';

class CredentialFill extends StatelessWidget {
  const CredentialFill({
    required this.child,
    required this.aspectRatio,
    required this.image,
    this.widthFactor = 0.7,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final double aspectRatio;
  final String image;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(image),
        ),
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}
