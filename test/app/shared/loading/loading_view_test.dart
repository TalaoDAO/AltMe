import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProfileCubit extends Mock implements ProfileCubit {
  @override
  final state = ProfileState(model: ProfileModel.empty());
}

void main() {
  group('LoadingView', () {
    late ProfileCubit profileCubit;

    setUp(() {
      profileCubit = MockProfileCubit();
    });

    testWidgets('shows loading view correctly', (tester) async {
      await tester.pumpWidget(
        BlocProvider<ProfileCubit>(
          create: (context) => profileCubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        LoadingView()
                            .show(context: context, text: 'Loading...');
                      },
                      child: const Text('Show Loading View'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        LoadingView().hide();
                      },
                      child: const Text('Hide Loading View'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(LoadingView), findsNothing);
      expect(find.text('Show Loading View'), findsOneWidget);
    });
  });
}
