import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/auth_scaffold.dart';

/// Pantalla de inicio de sesión.
/// Fase 1: sólo interfaz y validaciones.
/// En la Fase 3 aquí se llamará al endpoint POST /api/auth/login.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _cargando = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    // Si algún campo es inválido, el propio Form muestra los mensajes.
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    // TODO(Fase 3): reemplazar por la petición HTTP a /api/auth/login.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _cargando = false);

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Bienvenido',
      subtitle: 'Inicia sesión para continuar',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emailCtrl,
                label: 'Correo electrónico',
                hint: 'ejemplo@correo.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordCtrl,
                label: 'Contraseña',
                icon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: Validators.password,
                onFieldSubmitted: (_) => _iniciarSesion(),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.forgotPassword,
            ),
            child: const Text('¿Olvidaste tu contraseña?'),
          ),
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Iniciar sesión',
          loading: _cargando,
          onPressed: _iniciarSesion,
        ),
        const SizedBox(height: 20),
        // Wrap en lugar de Row: en pantallas estrechas el enlace baja
        // a la siguiente línea en vez de desbordarse.
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '¿No tienes cuenta?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              child: const Text('Crear cuenta'),
            ),
          ],
        ),
      ],
    );
  }
}
