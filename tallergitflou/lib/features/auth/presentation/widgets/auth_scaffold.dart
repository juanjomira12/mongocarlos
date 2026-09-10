import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Contenedor responsive para las pantallas de autenticacion.
///
/// En web centra el formulario dentro de una tarjeta de ancho fijo; en Android
/// ocupa el ancho completo con margenes comodos.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.title,
    this.showBackButton = false,
  });

  final Widget child;
  final String? title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (title == null && !showBackButton)
          ? null
          : AppBar(
              title: title == null ? null : Text(title!),
              automaticallyImplyLeading: showBackButton,
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final content = ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: child,
            );

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 24 : 20,
                vertical: 32,
              ),
              child: Center(
                child: isWide
                    ? Card(
                        elevation: 0,
                        color: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: content,
                        ),
                      )
                    : content,
              ),
            );
          },
        ),
      ),
    );
  }
}
