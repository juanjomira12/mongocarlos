import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../agenda/presentation/controllers/agenda_controller.dart';
import '../../../agenda/presentation/widgets/agenda_summary.dart';
import '../../domain/entities/user.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

/// Pantalla de perfil del usuario (Aprendiz B).
///
/// Vive dentro de `features/auth` porque opera sobre la entidad [User], pero
/// pertenece al modulo del Aprendiz B segun el reparto de la Fase 1.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.user, this.agenda});

  /// Usuario a mostrar. Mientras no exista sesion real se usa un demo.
  final User? user;

  /// Permite inyectar un controlador propio en pruebas.
  final AgendaController? agenda;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  late User _user;
  bool _isSaving = false;

  AgendaController get _agenda => widget.agenda ?? AgendaController.instance;

  @override
  void initState() {
    super.initState();
    // TODO(fase-2): tomar el usuario autenticado desde la sesion / API.
    _user = widget.user ??
        const User(
          id: 'demo',
          name: 'Aprendiz B',
          email: 'aprendiz.b@sena.edu.co',
        );
    _nameController = TextEditingController(text: _user.name);
    _emailController = TextEditingController(text: _user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    // TODO(fase-2): PUT /users/me contra la API REST.
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() {
      _user = _user.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );
      _isSaving = false;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado'),
          backgroundColor: AppColors.success,
        ),
      );
  }

  /// Cierra la sesion y regresa al login limpiando el historial.
  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.logoutAction),
        content: const Text('Seguro que quieres cerrar la sesion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.logoutAction),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // TODO(fase-2): limpiar el token almacenado antes de navegar.
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profileTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHeader(user: _user),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _agenda,
                    builder: (context, _) => AgendaSummary(
                      pendingCount: _agenda.pendingCount,
                      doneCount: _agenda.doneCount,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          controller: _nameController,
                          label: AppStrings.fieldName,
                          icon: Icons.person_outline,
                          textInputAction: TextInputAction.next,
                          validator: Validators.name,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          controller: _emailController,
                          label: AppStrings.fieldEmail,
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: Validators.email,
                          onSubmitted: (_) => _save(),
                        ),
                        const SizedBox(height: 28),
                        AuthSubmitButton(
                          label: AppStrings.profileSaveAction,
                          isLoading: _isSaving,
                          onPressed: _save,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _isSaving ? null : _logout,
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text(
                      AppStrings.logoutAction,
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar con las iniciales, nombre y correo del usuario.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  /// Primeras letras del nombre, en mayuscula.
  String get _initials {
    final parts = user.name.trim().split(RegExp(r'\s+'));
    final letters = parts
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
