// Servidor para desarrollo local (npm run dev / npm start).
//
// En Vercel este archivo no se usa: alli el punto de entrada es
// api/index.js, porque la plataforma no arranca un servidor propio.
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

// Se conecta antes de escuchar para detectar de una vez una cadena de
// conexion mal puesta, en lugar de fallar en la primera peticion.
conectarDB()
  .then(() => {
    console.log('Conectado a MongoDB');
    app.listen(PORT, () => {
      console.log(`Servidor escuchando en http://localhost:${PORT}`);
    });
  })
  .catch((error) => {
    console.error('Error al conectar con MongoDB:', error.message);
    process.exit(1);
  });
