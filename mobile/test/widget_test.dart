import 'package:agenda_app/core/network/api_exception.dart';
import 'package:agenda_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:agenda_app/features/auth/presentation/pages/forgot_pass_page.dart';
import 'package:agenda_app/features/auth/presentation/pages/login_page.dart';
import 'package:agenda_app/features/auth/presentation/pages/register_page.dart';
import 'package:agenda_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_auth_repository.dart';

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

  testWidgets('El registro avisa si las contrasenas no coinciden', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(2), 'Clave1234');
    await tester.enterText(fields.at(3), 'OtraClave99');
    await tester.pumpAndSettle();

    expect(find.text('Las contrasenas no coinciden'), findsOneWidget);
  });

  testWidgets('Recuperar contrasena confirma tras enviar un correo valido', (
    tester,
  ) async {
    final auth = AuthController(repository: FakeAuthRepository());
    await tester.pumpWidget(MaterialApp(home: ForgotPassPage(controller: auth)));

    await tester.enterText(find.byType(TextFormField).first, 'carlos@correo.com');
    await tester.tap(find.widgetWithText(FilledButton, 'Enviar enlace'));
    await tester.pumpAndSettle();

    expect(find.textContaining('recibiras las instrucciones'), findsOneWidget);
  });

  testWidgets('El login muestra el error que devuelve la API', (tester) async {
    final auth = AuthController(
      repository: FakeAuthRepository(
        error: const ApiException(
          'Correo o contrasena incorrectos',
          statusCode: 401,
        ),
      ),
    );

    await tester.pumpWidget(MaterialApp(home: LoginPage(controller: auth)));

    await tester.enterText(
      find.byType(TextFormField).first,
      'carlos@correo.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'ClaveMala1');
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesion'));
    await tester.pumpAndSettle();

    expect(find.text('Correo o contrasena incorrectos'), findsOneWidget);
  });

  testWidgets('El registro muestra los errores de validacion de la API', (
    tester,
  ) async {
    final auth = AuthController(
      repository: FakeAuthRepository(
        error: const ApiException(
          'Datos invalidos',
          statusCode: 400,
          errors: ['La contrasena debe combinar letras y numeros'],
        ),
      ),
    );

    await tester.pumpWidget(MaterialApp(home: RegisterPage(controller: auth)));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Carlos Prueba');
    await tester.enterText(fields.at(1), 'carlos@correo.com');
    await tester.enterText(fields.at(2), 'Clave1234');
    await tester.enterText(fields.at(3), 'Clave1234');
    final submit = find.widgetWithText(FilledButton, 'Registrarme');
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(
      find.text('La contrasena debe combinar letras y numeros'),
      findsOneWidget,
    );
  });
}
