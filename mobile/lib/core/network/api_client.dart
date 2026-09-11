import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'api_exception.dart';

/// Cliente HTTP de la aplicacion.
///
/// Centraliza tres cosas para no repetirlas en cada pantalla:
/// cabeceras, tiempo de espera y traduccion de errores a [ApiException].
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Envia un POST con cuerpo JSON.
  Future<Map<String, dynamic>> post(
    String url, {
    required Map<String, dynamic> body,
    String? token,
  }) {
    return _send(
      () => _client.post(
        Uri.parse(url),
        headers: _headers(token),
        body: jsonEncode(body),
      ),
    );
  }

  /// Envia un GET.
  Future<Map<String, dynamic>> get(String url, {String? token}) {
    return _send(
      () => _client.get(Uri.parse(url), headers: _headers(token)),
    );
  }

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Ejecuta la peticion y convierte cualquier fallo en [ApiException].
  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    late final http.Response response;

    try {
      response = await request().timeout(ApiConstants.timeout);
    } on SocketException {
      throw const ApiException(
        'No se pudo conectar con el servidor. Revisa tu conexion.',
      );
    } on TimeoutException {
      throw const ApiException('El servidor tardo demasiado en responder.');
    }

    return _parse(response);
  }

  Map<String, dynamic> _parse(http.Response response) {
    Map<String, dynamic> data;

    try {
      // El backend responde siempre JSON; si no, es un error inesperado.
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw ApiException(
        'Respuesta invalida del servidor.',
        statusCode: response.statusCode,
      );
    }

    final isOk = response.statusCode >= 200 && response.statusCode < 300;
    if (isOk) return data;

    throw ApiException(
      (data['mensaje'] as String?) ?? 'Ocurrio un error inesperado.',
      statusCode: response.statusCode,
      errors: (data['errores'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  void close() => _client.close();
}
