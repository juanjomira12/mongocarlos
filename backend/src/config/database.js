const mongoose = require('mongoose');

/**
 * Conexion a MongoDB preparada para entornos serverless (Vercel).
 *
 * En serverless cada peticion puede ejecutarse en un proceso nuevo, pero
 * la plataforma reutiliza procesos ya calientes. Por eso la conexion se
 * guarda en una variable global: si se abriera una conexion por peticion,
 * Atlas agotaria su limite de conexiones en poco tiempo.
 *
 * En local (npm run dev) funciona igual: la primera llamada conecta y las
 * siguientes devuelven la conexion que ya existe.
 */
let cache = global._mongooseCache;

if (!cache) {
  cache = global._mongooseCache = { conn: null, promise: null };
}

async function conectarDB() {
  if (cache.conn) return cache.conn;

  // Mensaje explicito: el error que da Mongoose cuando la URI es undefined
  // no dice que falta configurar la variable, y cuesta entenderlo en los
  // registros de la plataforma.
  if (!process.env.MONGODB_URI) {
    throw new Error(
      'Falta la variable de entorno MONGODB_URI. En Vercel se define en ' +
        'Settings > Environment Variables, y despues hay que volver a desplegar.'
    );
  }

  if (!cache.promise) {
    cache.promise = mongoose
      .connect(process.env.MONGODB_URI, {
        // Sin buffering: si no hay conexion, la consulta falla enseguida
        // en lugar de quedarse esperando hasta agotar el tiempo limite.
        bufferCommands: false,
      })
      .then((m) => m.connection);
  }

  try {
    cache.conn = await cache.promise;
  } catch (error) {
    // Se limpia para que la siguiente peticion pueda reintentar.
    cache.promise = null;
    throw error;
  }

  return cache.conn;
}

module.exports = { conectarDB };
