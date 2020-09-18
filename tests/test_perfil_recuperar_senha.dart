import 'package:app_constroca/login.dart';
import 'package:app_constroca/recover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Tela de perfil - clicar no botao e ir para a tela recuperacao
Widget makeTestable(Widget widget) => MaterialApp(home: widget);

void main() {
  testWidgets('Teste - Recuperar senha - Tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(LoginUser()));
    final Finder botao = find.byKey(Key("botao"));
    expect(botao, findsOneWidget);
    await tester.tap(botao);
    await tester.pumpAndSettle();
    expect(find.text('Recuperar senha'), findsOneWidget);

    await tester.pump();
  });
}
