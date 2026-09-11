import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

/// Pantalla de inicio de sesion (Aprendiz A).
///
/// Fase 1: solo interfaz y validaciones.
/// En la Fase 3 aqui se llamara al endpoint POST /api/auth/login.
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Si algun campo es invalido, el propio Form muestra los mensajes.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    // TODO(fase-3): reemplazar por la peticion HTTP a ApiConstants.login.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Al iniciar sesion se entra a la agenda (Aprendiz B).
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
              // En el login solo se exige que no este vacia: las reglas de
              // formato se validan al registrarse, no al volver a entrar.
              validator: (value) =>
                  Validators.required(value, field: 'La contrasena'),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                child: const Text(AppStrings.forgotLink),
              ),
            ),
            const SizedBox(height: 12),
            AuthSubmitButton(
              label: AppStrings.loginAction,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
            // Wrap y no Row: en pantallas estrechas el enlace baja de linea
            // en vez de desbordarse.
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  AppStrings.noAccountQuestion,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.register),
                  child: const Text(AppStrings.registerLink),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
