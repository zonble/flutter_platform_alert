import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_platform_alert_example/main.dart';

void main() {
  testWidgets('shows alert example actions', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Flutter Platform Alert'), findsOneWidget);
    expect(find.text('Play Alert Sounds'), findsOneWidget);
    expect(find.text('Play Alert Sound (Default)'), findsOneWidget);
    expect(find.text('Standard Alert with Styles'), findsOneWidget);
  });
}
