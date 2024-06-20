import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);
  test('can access AppTheme', () {
    expect(AppTheme, isNotNull);
  });

}
