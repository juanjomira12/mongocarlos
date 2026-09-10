import 'package:flutter_test/flutter_test.dart';

import 'package:agenda_app/main.dart';

void main() {
  testWidgets('La app inicia en la pantalla de Login', (tester) async {
    await tester.pumpWidget(const AgendaApp());

    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });
}
