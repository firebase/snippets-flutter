import 'package:firebase_snippets_app/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets(
        'run the app, which calls all firebase snippet functions on start',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
    });
  });
}
