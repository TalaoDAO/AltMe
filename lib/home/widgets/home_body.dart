import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(SizeHelper.spaceNormal),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(SizeHelper.radiusNormal),
          ),
        ),
        child: const Center(child: Text('Home')),
      ),
    );
  }
}
