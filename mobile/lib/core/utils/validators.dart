/// Validaciones reutilizables para los formularios de autenticación.
/// Cada método devuelve `null` cuando el valor es válido,
/// o un mensaje de error para mostrar bajo el campo.
class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[\w.\-+]+@([\w\-]+\.)+[a-zA-Z]{2,}$',
  );

  static String? nombre(String? value) {
    final texto = (value ?? '').trim();
    if (texto.isEmpty) return 'El nombre es obligatorio';
    if (texto.length < 3) return 'Debe tener al menos 3 caracteres';
    return null;
  }

  static String? email(String? value) {
    final texto = (value ?? '').trim();
    if (texto.isEmpty) return 'El correo es obligatorio';
    if (!_emailRegExp.hasMatch(texto)) return 'Ingresa un correo válido';
    return null;
  }

  static String? password(String? value) {
    final texto = value ?? '';
    if (texto.isEmpty) return 'La contraseña es obligatoria';
    if (texto.length < 6) return 'Debe tener al menos 6 caracteres';
    return null;
  }

  /// Confirma que la segunda contraseña coincida con la primera.
  static String? confirmPassword(String? value, String original) {
    final texto = value ?? '';
    if (texto.isEmpty) return 'Confirma tu contraseña';
    if (texto != original) return 'Las contraseñas no coinciden';
    return null;
  }
}
