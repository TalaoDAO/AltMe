import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(accountName: 'account #1'),
      backgroundColor: const Color(0xFF0A0421),
      body: Padding(
        padding: const EdgeInsets.all(SizeHelper.spaceSmall),
        child: Column(
          children: const [
            SizedBox(height: SizeHelper.spaceNormal),
            HeaderMenu(),
            SizedBox(height: SizeHelper.spaceNormal),
            HomeBody(),
            SizedBox(height: SizeHelper.spaceNormal)
          ],
        ),
      ),
    );
  }
}
