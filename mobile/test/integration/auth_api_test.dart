@Timeout(Duration(seconds: 60))
library;

import 'dart:io';

import 'package:agenda_app/core/constants/api_constants.dart';
import 'package:agenda_app/core/network/api_exception.dart';
import 'package:agenda_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pruebas contra la API real.
///
/// Necesitan el backend corriendo en local. Se ejecutan asi:
///
///   cd backend && npm run dev
///   cd mobile && flutter test test/integration --dart-define=API_BASE_URL=http://localhost:3000/api
///
/// Si el servidor no responde, las pruebas se omiten en lugar de fallar,
/// para que `flutter test` siga funcionando sin backend.
void main() {
  late bool servidorArriba;

  setUpAll(() async {
    servidorArriba = await _responde();
  });

  setUp(() {
    // Evita depender del almacenamiento real del dispositivo.
    SharedPreferences.setMockInitialValues({});
  });

  test('registro, perfil y login contra la API real', () async {
    if (!servidorArriba) {
      markTestSkipped('El backend no responde en ${ApiConstants.baseUrl}');
      return;
    }

    final repo = AuthRepositoryImpl();
    final email = 'flutter${DateTime.now().millisecondsSinceEpoch}@correo.com';

    // 1. Registro: crea el usuario y guarda el token.
    final registrado = await repo.register(
      nombre: 'Prueba Flutter',
      email: email,
      password: 'Clave1234',
    );
    expect(registrado.email, email);
    expect(registrado.name, 'Prueba Flutter');
    expect(registrado.id, isNotEmpty);
    expect(await repo.hasSession(), isTrue);

    // 2. Perfil: usa el token guardado.
    final perfil = await repo.profile();
    expect(perfil.id, registrado.id);
    expect(perfil.email, email);

    // 3. Login con las mismas credenciales.
    final logueado = await repo.login(email: email, password: 'Clave1234');
    expect(logueado.id, registrado.id);

    // 4. Recuperacion de contrasena.
    await repo.forgotPassword(email);

    // 5. Cierre de sesion: el token deja de existir.
    await repo.logout();
    expect(await repo.hasSession(), isFalse);
  });

  test('la API rechaza credenciales incorrectas', () async {
    if (!servidorArriba) {
      markTestSkipped('El backend no responde en ${ApiConstants.baseUrl}');
      return;
    }

    final repo = AuthRepositoryImpl();

    await expectLater(
      repo.login(email: 'noexiste9999@correo.com', password: 'Clave1234'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 401)
            .having((e) => e.isUnauthorized, 'isUnauthorized', isTrue),
      ),
    );
  });

  test('el perfil falla sin sesion activa', () async {
    if (!servidorArriba) {
      markTestSkipped('El backend no responde en ${ApiConstants.baseUrl}');
      return;
    }

    final repo = AuthRepositoryImpl();

    await expectLater(
      repo.profile(),
      throwsA(isA<ApiException>().having((e) => e.isUnauthorized, 'is401', isTrue)),
    );
  });
}

/// Comprueba si responde el mismo servidor al que apuntan las pruebas.
///
/// Se usa la raiz de [ApiConstants.baseUrl] y no una URL fija, para que la
/// comprobacion y las peticiones vayan siempre al mismo sitio.
Future<bool> _responde() async {
  try {
    final base = Uri.parse(ApiConstants.baseUrl);
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 3);
    final request = await client.getUrl(base.replace(path: '/'));
    final response = await request.close();
    await response.drain<void>();
    client.close();
    return response.statusCode == 200;
  } on Exception {
    return false;
  }
}
