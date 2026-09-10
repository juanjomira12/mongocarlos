import 'package:agenda_app/features/auth/presentation/pages/login_page.dart';
import 'package:agenda_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La app arranca en la pantalla de login', (tester) async {
    await tester.pumpWidget(const AgendaApp());

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Iniciar sesion'), findsOneWidget);
  });

  testWidgets('El login valida el formato del correo', (tester) async {
    await tester.pumpWidget(const AgendaApp());

    await tester.enterText(find.byType(TextFormField).first, 'correo-invalido');
    await tester.pumpAndSettle();

    expect(find.text('Ingresa un correo valido'), findsOneWidget);
  });

  testWidgets('Se puede navegar de login a registro', (tester) async {
    await tester.pumpWidget(const AgendaApp());

    final registerLink = find.widgetWithText(TextButton, 'Registrate');
    await tester.ensureVisible(registerLink);
    await tester.pumpAndSettle();

    await tester.tap(registerLink);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Registrarme'), findsOneWidget);
  });
}
