/// Validaciones reutilizables para los formularios de autenticacion.
class Validators {
  const Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[\w\.\-\+]+@([\w\-]+\.)+[a-zA-Z]{2,}$',
  );

  static String? required(String? value, {String field = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field es obligatorio';
    }
    return null;
  }

  static String? name(String? value) {
    final empty = required(value, field: 'El nombre');
    if (empty != null) return empty;
    if (value!.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }

  static String? email(String? value) {
    final empty = required(value, field: 'El correo');
    if (empty != null) return empty;
    if (!_emailRegExp.hasMatch(value!.trim())) {
      return 'Ingresa un correo valido';
    }
    return null;
  }

  static String? password(String? value) {
    final empty = required(value, field: 'La contrasena');
    if (empty != null) return empty;
    if (value!.length < 8) {
      return 'La contrasena debe tener al menos 8 caracteres';
    }
    if (!value.contains(RegExp(r'[A-Za-z]')) ||
        !value.contains(RegExp(r'[0-9]'))) {
      return 'Debe combinar letras y numeros';
    }
    return null;
  }

  /// Titulo de una actividad de la agenda (Aprendiz B).
  static String? taskTitle(String? value) {
    final empty = required(value, field: 'El titulo');
    if (empty != null) return empty;
    if (value!.trim().length < 4) {
      return 'El titulo debe tener al menos 4 caracteres';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final empty = required(value, field: 'La confirmacion');
    if (empty != null) return empty;
    if (value != original) {
      return 'Las contrasenas no coinciden';
    }
    return null;
  }
}
