const mongoose = require('mongoose');

/**
 * Coleccion "usuarios".
 * Corresponde al Aprendiz A. Las colecciones de Agenda/Tareas
 * las creara el Aprendiz B en esta misma carpeta.
 */
const usuarioSchema = new mongoose.Schema(
  {
    nombre: {
      type: String,
      required: true,
      trim: true,
      minlength: 3,
      maxlength: 100,
    },
    email: {
      type: String,
      required: true,
      unique: true, // no puede haber dos usuarios con el mismo correo
      trim: true,
      lowercase: true,
    },
    password: {
      type: String,
      required: true, // se guarda siempre hasheada con bcrypt
    },
    fecha_creacion: {
      type: Date,
      default: Date.now,
    },
  },
  {
    collection: 'usuarios',
    versionKey: false,
  }
);

/**
 * Da forma a la respuesta JSON: expone `id` en lugar de `_id`
 * y nunca incluye la contrasena.
 */
usuarioSchema.methods.toJSON = function () {
  const { _id, password, ...resto } = this.toObject();
  return { id: _id, ...resto };
};

module.exports = mongoose.model('Usuario', usuarioSchema);
