const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth.routes');

const app = express();

// CORS abierto: la app Flutter consumira esta API desde otro origen.
app.use(cors());
app.use(express.json());

// Ruta de prueba para verificar que el servidor responde.
app.get('/', (req, res) => {
  res.json({ ok: true, mensaje: 'API Agenda funcionando' });
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
  res.status(500).json({ ok: false, mensaje: 'Error interno del servidor' });
});

module.exports = app;
