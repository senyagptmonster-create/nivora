import 'package:flutter_test/flutter_test.dart';
import 'package:nivora/nivora_app.dart';

void main() {
  testWidgets('NivoraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NivoraApp());
    expect(find.byType(NivoraApp), findsOneWidget);
  });
}
