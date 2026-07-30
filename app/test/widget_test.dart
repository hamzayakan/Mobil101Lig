import 'package:app/main.dart';
import 'package:app/routes/app_router.dart';
import 'package:app/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AppRouter.router.go(RouteNames.home);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: Mobil101LigApp(),
      ),
    );
    AppRouter.router.go(RouteNames.home);
    await tester.pumpAndSettle();
  }

  testWidgets('Ana ekran yüklenir', (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('Mobil101Lig'), findsOneWidget);
    expect(find.text('101 Yazboz'), findsOneWidget);
    expect(find.text('Giriş Yap'), findsOneWidget);
  });

  testWidgets('Yazboz ekranına navigasyon çalışır', (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('101 Yazboz'));
    await tester.pumpAndSettle();

    expect(find.text('Oyun Kurulumu'), findsOneWidget);
    expect(find.text('Oyunu Başlat'), findsOneWidget);
  });

  testWidgets('Giriş ekranına navigasyon çalışır', (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('home_login_card')));
    await tester.pumpAndSettle();

    expect(find.text('Google ile Giriş Yap'), findsOneWidget);
    expect(find.text('Mobil101Lig\'e Hoş Geldiniz'), findsOneWidget);
  });
}
