const express = require('express');
const cors = require('cors');

const {
  conectarDB,
  describirFalloDeConexion,
} = require('./config/database');
const authRoutes = require('./routes/auth.routes');

const app = express();

// CORS abierto: la app Flutter consumira esta API desde otro origen.
app.use(cors());
app.use(express.json());

// El healthcheck va ANTES de conectar la base de datos, a proposito:
// asi responde aunque Mongo falle y permite distinguir un servidor caido
// de una base de datos mal configurada.
app.get('/', async (req, res) => {
  try {
    await conectarDB();
    return res.json({
      ok: true,
      mensaje: 'API Agenda funcionando',
      baseDatos: 'conectada',
    });
  } catch (error) {
    console.error(error);
    // Responde 200 a proposito: el servidor si esta vivo. Lo que falla es
    // la base de datos, y la causa se explica en 'detalle'.
    return res.json({
      ok: true,
      mensaje: 'API Agenda funcionando',
      baseDatos: 'desconectada',
      detalle: describirFalloDeConexion(error),
    });
  }
});

// En serverless no hay un arranque unico donde conectar la base de datos,
// asi que cada peticion se asegura de que la conexion exista. Si ya esta
// abierta, esto no cuesta nada.
app.use(async (req, res, next) => {
  try {
    await conectarDB();
    next();
  } catch (error) {
    next(error);
  }
});

app.use('/api/auth', authRoutes);
// El Aprendiz B montara aqui sus rutas: app.use('/api/tareas', tareasRoutes);

// Ruta no encontrada.
app.use((req, res) => {
  res.status(404).json({ ok: false, mensaje: 'Ruta no encontrada' });
});

// Manejador central de errores: evita repetir try/catch en cada respuesta.
app.use((error, req, res, next) => {
  console.error(error);

  // Clave duplicada en Mongo (por ejemplo, dos registros del mismo correo
  // enviados al mismo tiempo). Se responde 409 igual que en el controlador.
  if (error.code === 11000) {
    return res.status(409).json({
      ok: false,
      mensaje: 'El correo ya esta registrado',
    });
  }

  // Datos que no cumplen las reglas del modelo de Mongoose.
  if (error.name === 'ValidationError') {
    return res.status(400).json({
      ok: false,
      mensaje: 'Datos invalidos',
      errores: Object.values(error.errors).map((e) => e.message),
    });
  }

  return res
    .status(500)
    .json({ ok: false, mensaje: 'Error interno del servidor' });
});

module.exports = app;
