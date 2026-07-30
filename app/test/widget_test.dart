import 'package:app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Ana ekran yüklenir', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: Mobil101LigApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mobil101Lig'), findsOneWidget);
    expect(find.text('101 Yazboz'), findsOneWidget);
  });

  testWidgets('Yazboz ekranına navigasyon çalışır', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: Mobil101LigApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('101 Yazboz'));
    await tester.pumpAndSettle();

    expect(find.text('Oyun Kurulumu'), findsOneWidget);
    expect(find.text('Oyunu Başlat'), findsOneWidget);
  });
}
