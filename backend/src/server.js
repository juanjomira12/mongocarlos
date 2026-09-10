require('dotenv').config();

const app = require('./app');
const { conectarDB } = require('./config/database');

// Variables obligatorias: si falta alguna, es mejor fallar al arrancar.
const requeridas = ['MONGODB_URI', 'JWT_SECRET'];
const faltantes = requeridas.filter((clave) => !process.env[clave]);

if (faltantes.length > 0) {
  console.error(`Faltan variables de entorno: ${faltantes.join(', ')}`);
  process.exit(1);
}

const PORT = process.env.PORT || 3000;

// Primero se conecta la base de datos y despues se abre el servidor.
conectarDB().then(() => {
  app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
  });
});
