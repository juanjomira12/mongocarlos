const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');

const Usuario = require('../models/usuario.model');

const SALT_ROUNDS = 10;

/** Genera el JWT que identifica al usuario en las rutas protegidas. */
function generarToken(usuario) {
  return jwt.sign(
    { id: usuario.id, email: usuario.email },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '1d' }
  );
}

/**
 * POST /api/auth/register
 * Crea un usuario nuevo con la contrasena hasheada.
 */
async function register(req, res, next) {
  try {
    const nombre = req.body.nombre.trim();
    const email = req.body.email.trim().toLowerCase();
    const { password } = req.body;

    const existe = await Usuario.findOne({ email });
    if (existe) {
      return res.status(409).json({
        ok: false,
        mensaje: 'El correo ya esta registrado',
      });
    }

    // Nunca se guarda la contrasena en texto plano.
    const hash = await bcrypt.hash(password, SALT_ROUNDS);

    const usuario = await Usuario.create({ nombre, email, password: hash });

    return res.status(201).json({
      ok: true,
      mensaje: 'Usuario registrado correctamente',
      usuario, // toJSON del modelo ya excluye la contrasena
      token: generarToken(usuario),
    });
  } catch (error) {
    return next(error);
  }
}

/**
 * POST /api/auth/login
 * Verifica las credenciales y devuelve un JWT.
 */
async function login(req, res, next) {
  try {
    const email = req.body.email.trim().toLowerCase();
    const { password } = req.body;

    const usuario = await Usuario.findOne({ email });

    // Mismo mensaje para usuario inexistente y contrasena incorrecta:
    // asi no se revela que correos estan registrados.
    const credencialesOk =
      usuario && (await bcrypt.compare(password, usuario.password));

    if (!credencialesOk) {
      return res.status(401).json({
        ok: false,
        mensaje: 'Correo o contrasena incorrectos',
      });
    }

    return res.json({
      ok: true,
      mensaje: 'Inicio de sesion exitoso',
      usuario,
      token: generarToken(usuario),
    });
  } catch (error) {
    return next(error);
  }
}

/**
 * GET /api/auth/profile  (ruta protegida)
 * Devuelve los datos del usuario dueno del token.
 */
async function profile(req, res, next) {
  try {
    const usuario = await Usuario.findById(req.usuario.id);

    if (!usuario) {
      return res.status(404).json({ ok: false, mensaje: 'Usuario no encontrado' });
    }

    return res.json({ ok: true, usuario });
  } catch (error) {
    return next(error);
  }
}

/**
 * POST /api/auth/forgot-password
 * Genera un token temporal de recuperacion.
 * En esta fase el envio de correo no se implementa: en desarrollo
 * el token se devuelve en la respuesta para poder probarlo.
 */
async function forgotPassword(req, res, next) {
  try {
    const email = req.body.email.trim().toLowerCase();

    const usuario = await Usuario.findOne({ email });

    // Respuesta generica siempre, exista o no el correo.
    const respuesta = {
      ok: true,
      mensaje:
        'Si el correo esta registrado, recibiras instrucciones para restablecer tu contrasena',
    };

    if (usuario) {
      const tokenRecuperacion = crypto.randomBytes(32).toString('hex');
      // TODO: enviar este token por correo y guardarlo con su expiracion.
      if (process.env.NODE_ENV !== 'production') {
        respuesta.tokenRecuperacion = tokenRecuperacion;
      }
    }

    return res.json(respuesta);
  } catch (error) {
    return next(error);
  }
}

module.exports = { register, login, profile, forgotPassword };
