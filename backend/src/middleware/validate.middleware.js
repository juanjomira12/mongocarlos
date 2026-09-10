const EMAIL_REGEX = /^[\w.\-+]+@([\w-]+\.)+[a-zA-Z]{2,}$/;

function esEmailValido(email) {
  return typeof email === 'string' && EMAIL_REGEX.test(email.trim());
}

/** Valida el cuerpo de POST /api/auth/register */
function validarRegistro(req, res, next) {
  const { nombre, email, password } = req.body || {};
  const errores = [];

  if (!nombre || nombre.trim().length < 3) {
    errores.push('El nombre debe tener al menos 3 caracteres');
  }
  if (!esEmailValido(email)) {
    errores.push('El correo no tiene un formato valido');
  }
  if (!password || password.length < 6) {
    errores.push('La contrasena debe tener al menos 6 caracteres');
  }

  if (errores.length > 0) {
    return res.status(400).json({ ok: false, mensaje: 'Datos invalidos', errores });
  }
  next();
}

/** Valida el cuerpo de POST /api/auth/login */
function validarLogin(req, res, next) {
  const { email, password } = req.body || {};
  const errores = [];

  if (!esEmailValido(email)) {
    errores.push('El correo no tiene un formato valido');
  }
  if (!password) {
    errores.push('La contrasena es obligatoria');
  }

  if (errores.length > 0) {
    return res.status(400).json({ ok: false, mensaje: 'Datos invalidos', errores });
  }
  next();
}

/** Valida el cuerpo de POST /api/auth/forgot-password */
function validarEmail(req, res, next) {
  if (!esEmailValido((req.body || {}).email)) {
    return res.status(400).json({
      ok: false,
      mensaje: 'Datos invalidos',
      errores: ['El correo no tiene un formato valido'],
    });
  }
  next();
}

module.exports = { validarRegistro, validarLogin, validarEmail };
