import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class JsonViewerPage extends StatelessWidget {
  const JsonViewerPage({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  static Route<dynamic> route({
    required String title,
    required String data,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => JsonViewerPage(
          title: title,
          data: data,
        ),
        settings: const RouteSettings(name: '/JsonViewerPage'),
      );

  @override
  Widget build(BuildContext context) {
    return JsonViewerView(
      title: title,
      data: data,
    );
  }
}

class JsonViewerView extends StatelessWidget {
  const JsonViewerView({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      titleAlignment: Alignment.topCenter,
      scrollView: true,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      body: Text(
        data,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
