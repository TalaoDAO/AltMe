import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class CityImage extends StatelessWidget {
  const CityImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageStrings.splashCity,
      fit: BoxFit.fitWidth,
    );
  }
}
