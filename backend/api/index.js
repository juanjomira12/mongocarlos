// Punto de entrada para Vercel.
//
// Vercel no arranca un servidor: invoca esta funcion en cada peticion.
// Una aplicacion de Express ya es una funcion (req, res), asi que se
// exporta tal cual. La conexion a MongoDB la abre el propio app.js.
require('dotenv').config();

const app = require('../src/app');

module.exports = app;
