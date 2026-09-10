/// Textos fijos de la aplicacion.
class AppStrings {
  const AppStrings._();

  static const String appName = 'Agenda App';

  // Login
  static const String loginTitle = 'Bienvenido de nuevo';
  static const String loginSubtitle = 'Ingresa a tu cuenta para ver tu agenda';
  static const String loginAction = 'Iniciar sesion';

  // Registro
  static const String registerTitle = 'Crear cuenta';
  static const String registerSubtitle = 'Registrate para organizar tus tareas';
  static const String registerAction = 'Registrarme';

  // Recuperacion
  static const String forgotTitle = 'Recuperar contrasena';
  static const String forgotSubtitle =
      'Te enviaremos un enlace de recuperacion a tu correo';
  static const String forgotAction = 'Enviar enlace';

  // Campos
  static const String fieldName = 'Nombre completo';
  static const String fieldEmail = 'Correo electronico';
  static const String fieldPassword = 'Contrasena';
  static const String fieldConfirmPassword = 'Confirmar contrasena';

  // Agenda (Aprendiz B)
  static const String agendaTitle = 'Mi agenda';
  static const String agendaSearchHint = 'Buscar tarea';
  static const String agendaEmptyTitle = 'Sin tareas por aqui';
  static const String agendaEmptyMessage =
      'Crea tu primera actividad con el boton Nueva tarea.';
  static const String newTaskAction = 'Nueva tarea';

  // Formulario de tarea (Aprendiz B)
  static const String taskCreateTitle = 'Nueva tarea';
  static const String taskEditTitle = 'Editar tarea';
  static const String taskTitleField = 'Titulo';
  static const String taskDescriptionField = 'Descripcion';
  static const String taskDueDate = 'Fecha limite';
  static const String taskStatusField = 'Estado';
  static const String taskPriorityField = 'Prioridad';
  static const String taskCreateAction = 'Crear tarea';
  static const String taskSaveAction = 'Guardar cambios';

  // Perfil (Aprendiz B)
  static const String profileTitle = 'Mi perfil';
  static const String profileSaveAction = 'Guardar cambios';
  static const String logoutAction = 'Cerrar sesion';
}
