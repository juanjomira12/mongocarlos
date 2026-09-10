import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/auth_scaffold.dart';

/// Pantalla de registro de usuario.
/// Fase 1: sólo interfaz y validaciones.
/// En la Fase 3 aquí se llamará al endpoint POST /api/auth/register.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _cargando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    // TODO(Fase 3): reemplazar por la petición HTTP a /api/auth/register.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _cargando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cuenta creada correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Crear cuenta',
      subtitle: 'Completa tus datos para registrarte',
      showBackButton: true,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _nombreCtrl,
                label: 'Nombre',
                hint: 'Tu nombre completo',
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: Validators.nombre,
              ),
              const SizedBox(height: 16),
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
                textInputAction: TextInputAction.next,
                validator: Validators.password,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmCtrl,
                label: 'Confirmar contraseña',
                icon: Icons.lock_reset_outlined,
                isPassword: true,
                textInputAction: TextInputAction.done,
                // Compara con la contraseña escrita arriba.
                validator: (value) => Validators.confirmPassword(
                  value,
                  _passwordCtrl.text,
                ),
                onFieldSubmitted: (_) => _registrar(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: 'Registrarse',
          loading: _cargando,
          onPressed: _registrar,
        ),
        const SizedBox(height: 20),
        // Wrap en lugar de Row: en pantallas estrechas el enlace baja
        // a la siguiente línea en vez de desbordarse.
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '¿Ya tienes cuenta?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ],
    );
  }
}
