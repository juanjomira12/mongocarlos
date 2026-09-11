import '../../domain/entities/user.dart';

/// Traduce el JSON del backend a la entidad [User] del dominio.
///
/// La API devuelve el usuario asi:
/// `{ "id": "...", "nombre": "...", "email": "...", "fecha_creacion": "..." }`
class UserModel {
  const UserModel._();

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['nombre']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}
