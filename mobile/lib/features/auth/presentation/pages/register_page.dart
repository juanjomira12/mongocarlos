import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

/// Pantalla de registro de usuario (Aprendiz A).
///
/// Fase 1: solo interfaz y validaciones.
/// En la Fase 3 aqui se llamara al endpoint POST /api/auth/register.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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

    setState(() => _isLoading = true);
    // TODO(fase-3): reemplazar por la peticion HTTP a ApiConstants.register.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cuenta creada correctamente'),
        backgroundColor: AppColors.success,
      ),
    );
    // Se vuelve al login para que el usuario entre con su cuenta nueva.
    Navigator.of(context).pop();
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
