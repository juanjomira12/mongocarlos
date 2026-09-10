import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/auth_scaffold.dart';

/// Pantalla de recuperación de contraseña.
/// Fase 1: sólo interfaz y validaciones.
/// En la Fase 3 aquí se llamará a POST /api/auth/forgot-password.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _cargando = false;
  bool _enviado = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _solicitarRecuperacion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    // TODO(Fase 3): reemplazar por la petición HTTP a /api/auth/forgot-password.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _cargando = false;
      _enviado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Recuperar contraseña',
      subtitle: 'Te enviaremos instrucciones a tu correo',
      showBackButton: true,
      children: [
        Form(
          key: _formKey,
          child: AppTextField(
            controller: _emailCtrl,
            label: 'Correo electrónico',
            hint: 'ejemplo@correo.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: Validators.email,
            onFieldSubmitted: (_) => _solicitarRecuperacion(),
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: 'Enviar instrucciones',
          loading: _cargando,
          onPressed: _solicitarRecuperacion,
        ),
        // Mensaje de confirmación visible sólo después de enviar la solicitud.
        if (_enviado) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Si el correo está registrado, recibirás las '
                    'instrucciones para restablecer tu contraseña.',
                    style: TextStyle(color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Volver al inicio de sesión'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
