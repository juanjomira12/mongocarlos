import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_error_message.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

/// Pantalla de registro de usuario (Aprendiz A).
///
/// Envia los datos a POST /api/auth/register y, si el registro funciona,
/// deja la sesion iniciada.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.controller});

  /// Permite inyectar un controlador propio en las pruebas.
  final AuthController? controller;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  AuthController get _auth => widget.controller ?? AuthController.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.register(
        nombre: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta creada correctamente'),
          backgroundColor: AppColors.success,
        ),
      );
      // El registro ya deja la sesion iniciada, asi que se entra directo.
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.agendaList,
        (route) => false,
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.detail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              title: AppStrings.registerTitle,
              subtitle: AppStrings.registerSubtitle,
              icon: Icons.person_add_alt_outlined,
            ),
            const SizedBox(height: 32),
            AuthErrorMessage(_errorMessage),
            AuthTextField(
              controller: _nameController,
              label: AppStrings.fieldName,
              hint: 'Tu nombre completo',
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: Validators.name,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _emailController,
              label: AppStrings.fieldEmail,
              hint: 'nombre@correo.com',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _passwordController,
              label: AppStrings.fieldPassword,
              hint: 'Minimo 8 caracteres',
              icon: Icons.lock_outline,
              obscure: true,
              textInputAction: TextInputAction.next,
              validator: Validators.password,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _confirmController,
              label: AppStrings.fieldConfirmPassword,
              hint: 'Repite tu contrasena',
              icon: Icons.lock_reset_outlined,
              obscure: true,
              textInputAction: TextInputAction.done,
              // Se compara contra la contrasena escrita arriba.
              validator: (value) =>
                  Validators.confirmPassword(value, _passwordController.text),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 28),
            AuthSubmitButton(
              label: AppStrings.registerAction,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  AppStrings.hasAccountQuestion,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.loginLink),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
