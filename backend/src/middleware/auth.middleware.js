const jwt = require('jsonwebtoken');

/**
 * Protege rutas privadas.
 * Espera la cabecera: Authorization: Bearer <token>
 * Si el token es valido, deja los datos del usuario en req.usuario.
 */
function verificarToken(req, res, next) {
  const header = req.headers.authorization || '';

  if (!header.startsWith('Bearer ')) {
    return res.status(401).json({
      ok: false,
      mensaje: 'Token no proporcionado',
    });
  }

  const token = header.slice(7);

  try {
    req.usuario = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch (error) {
    return res.status(401).json({
      ok: false,
      mensaje: 'Token invalido o expirado',
    });
  }
}

module.exports = { verificarToken };
