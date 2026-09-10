const { Router } = require('express');

const controller = require('../controllers/auth.controller');
const { verificarToken } = require('../middleware/auth.middleware');
const {
  validarRegistro,
  validarLogin,
  validarEmail,
} = require('../middleware/validate.middleware');

const router = Router();

router.post('/register', validarRegistro, controller.register);
router.post('/login', validarLogin, controller.login);
router.get('/profile', verificarToken, controller.profile);
router.post('/forgot-password', validarEmail, controller.forgotPassword);

module.exports = router;
