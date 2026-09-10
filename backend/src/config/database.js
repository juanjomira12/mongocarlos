const mongoose = require('mongoose');

/**
 * Conecta con MongoDB usando la URI del archivo .env.
 * Si la conexion falla, el proceso termina: es mejor
 * fallar al arrancar que responder peticiones sin base de datos.
 */
async function conectarDB() {
  const uri = process.env.MONGODB_URI;

  try {
    await mongoose.connect(uri);
    console.log('Conectado a MongoDB');
  } catch (error) {
    console.error('Error al conectar con MongoDB:', error.message);
    process.exit(1);
  }
}

module.exports = { conectarDB };
