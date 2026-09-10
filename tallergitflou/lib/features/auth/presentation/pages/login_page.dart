import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

/// Pantalla de inicio de sesion.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    // TODO(fase-2): reemplazar por AuthRepository.login() contra la API REST.
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sesion iniciada como ${_emailController.text.trim()}'),
        backgroundColor: AppColors.success,
      ),
    );

    // Fase 1 - Aprendiz B: al iniciar sesion se entra a la agenda.
    Navigator.of(context).pushReplacementNamed(AppRoutes.agendaList);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              title: AppStrings.loginTitle,
              subtitle: AppStrings.loginSubtitle,
            ),
            const SizedBox(height: 32),
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
              hint: 'Tu contrasena',
              icon: Icons.lock_outline,
              obscure: true,
              textInputAction: TextInputAction.done,
              validator: (value) =>
                  Validators.required(value, field: 'La contrasena'),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) =>
                      setState(() => _rememberMe = value ?? false),
                ),
                const Expanded(
                  child: Text('Recordarme', overflow: TextOverflow.ellipsis),
                ),
                Flexible(
                  child: TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRoutes.forgotPassword),
                    child: const Text(
                      'Olvide mi contrasena',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AuthSubmitButton(
              label: AppStrings.loginAction,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'No tienes cuenta?',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.register),
                  child: const Text('Registrate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
