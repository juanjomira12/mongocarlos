import 'package:flutter/material.dart';

import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'features/auth/presentation/pages/forgot_pass_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/agenda/presentation/pages/agenda_list_page.dart';
import 'features/agenda/presentation/pages/task_form_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'features/auth/presentation/pages/register_page.dart';

void main() {
  runApp(const AgendaApp());
}

/// Punto de entrada e inyeccion de dependencias.
class AgendaApp extends StatelessWidget {
  const AgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      routes: {
        // --- Auth (Aprendiz A) ---
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.register: (_) => const RegisterPage(),
        AppRoutes.forgotPassword: (_) => const ForgotPassPage(),

        // --- Agenda (Aprendiz B) ---
        AppRoutes.agendaList: (_) => const AgendaListPage(),
        AppRoutes.taskForm: (_) => const TaskFormPage(),
        AppRoutes.profile: (_) => const ProfilePage(),
      },
    );
  }
}
