import 'package:app_constroca/login.dart';
import 'package:app_constroca/recover_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Tela de recuperacao - checar se todos os itens estão presentes na tela de recuperação
Widget makeTestable(Widget widget) => MaterialApp(home: widget);

void main() {
  testWidgets('Teste - Recuperar senha - Tela de recuperação', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(Recover()));
    final Finder botao = find.byKey(Key("recuperar"));

    expect(botao, findsOneWidget);
    // deve ter o título 'Recuperar senha'
    expect(find.text('Recuperar senha'), findsOneWidget);
    // deve ter o texto 'Digite seu email para receber uma nova senha'
    expect(find.text('Digite seu email para receber uma nova senha'), findsOneWidget);
    // deve ter o texto 'Enviar nova senha'
    expect(find.text('Enviar nova senha'), findsOneWidget);
    // Checar se o botão existe e é clicável
    final Finder txtEmail = find.byKey(Key("txtEmail"));

    await tester.enterText(find.byType(TextFormField), 'mail@');

    await tester.tap(botao);

    expect(find.byType(AlertDialog), findsOneWidget);

    expect(find.text('Sua nova senha foi encaminhada para o seu e-mail'), findsOneWidget);

    await tester.pumpAndSettle();

    await tester.pump();
  });
}
