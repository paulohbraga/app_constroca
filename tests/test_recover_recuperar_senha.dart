import 'package:app_constroca/login.dart';
import 'package:app_constroca/recover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Função auxiliar para envolver os widgets a serem testados.
Widget makeTestable(Widget widget) => MaterialApp(home: widget);

void main() {
  testWidgets('Teste - Recuperar senha - Tela de recuperação', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(Recover()));
    final Finder botao = find.byKey(Key("recuperar"));
    expect(botao, findsOneWidget);
    await tester.tap(botao);
    await tester.pumpAndSettle();
    expect(find.text('Recuperar senha'), findsOneWidget);
    expect(find.text('Digite seu email para receber uma nova senha'), findsOneWidget);
    expect(find.text('Enviar nova senha'), findsOneWidget);
    expect(find.text('Digite seu email para receber uma nova senha'), findsOneWidget);

    await tester.pump();
  });
}
