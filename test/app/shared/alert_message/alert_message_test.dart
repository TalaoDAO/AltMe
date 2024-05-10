import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  testWidgets('AlertMessage shows SnackBar', (WidgetTester tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: const StateMessage(
                    messageHandler: null,
                    stringMessage: 'Test Message',
                    injectedMessage: null,
                    showDialog: false,
                    duration: Duration(seconds: 2),
                    type: MessageType.info,
                  ),
                );
              },
              child: const Text('Show SnackBar'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show SnackBar'));
    await tester.pumpAndSettle();

    expect(find.text('Test Message'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(SnackBarContent), findsOneWidget);
  });

  testWidgets('AlertMessage shows Dialog', (WidgetTester tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: const StateMessage(
                    messageHandler: null,
                    stringMessage: 'Test Message',
                    injectedMessage: null,
                    showDialog: true,
                    type: MessageType.info,
                  ),
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Test Message'), findsOneWidget);
    expect(find.byType(ErrorDialog), findsOneWidget);
  });
  testWidgets('SnackBarContent is displayed correctly',
      (WidgetTester tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: SnackBarContent(
          message: 'Test Message',
          iconPath: 'assets/icon/add.png',
        ),
      ),
    );

    expect(find.text('Test Message'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('AlertMessage shows Network error properly',
      (WidgetTester tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: StateMessage(
                    messageHandler: NetworkException(
                      data: 'Netwok Test',
                    ),
                    injectedMessage: null,
                    showDialog: false,
                    duration: const Duration(seconds: 2),
                    type: MessageType.info,
                  ),
                );
              },
              child: const Text('Show SnackBar'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show SnackBar'));
    await tester.pumpAndSettle();

    expect(find.text('Netwok Test'), findsOneWidget);
  });

  testWidgets('AlertMessage shows default message when nothing is provided',
      (WidgetTester tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: const StateMessage(
                    messageHandler: null,
                    injectedMessage: null,
                    showDialog: false,
                    duration: Duration(seconds: 2),
                    type: MessageType.info,
                  ),
                );
              },
              child: const Text('Show SnackBar'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show SnackBar'));
    await tester.pumpAndSettle();

    expect(find.text('This request is not supported'), findsOneWidget);
  });
  testWidgets('AlertMessage shows ResponseMessage correctly',
      (WidgetTester tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: StateMessage(
                    messageHandler: ResponseMessage(
                      message: ResponseString
                          .RESPONSE_STRING_AN_ERROR_OCCURRED_WHILE_CONNECTING_TO_THE_SERVER,
                    ),
                    injectedMessage: null,
                    showDialog: false,
                    duration: const Duration(seconds: 2),
                    type: MessageType.info,
                  ),
                );
              },
              child: const Text('Show SnackBar'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show SnackBar'));
    await tester.pumpAndSettle();

    expect(
      find.text('An error occurred while connecting to the server.'),
      findsOneWidget,
    );
  });
}
