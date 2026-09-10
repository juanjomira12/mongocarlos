# Agenda App

Aplicacion movil/web en **Flutter** conectada a una **API REST** con base de datos
relacional, desarrollada de forma colaborativa aplicando **GitFlow**.

Plataformas habilitadas: **Android** y **Web**.

---

## Reparto de modulos

| Modulo funcional | Aprendiz A (Dev 1) | Aprendiz B (Dev 2) |
| --- | --- | --- |
| Fase 1: Frontend (Flutter) | Login, Registro y Recuperacion de contrasena | Lista de Agenda, Formulario de Nueva Tarea y Perfil de Usuario |
| Fase 2: Backend & DB | Tablas de Usuario, endpoints de autenticacion (Login/Registro) | Tablas de Agenda/Tareas, endpoints CRUD de actividades |

Este repositorio contiene, en su estado actual, la **Fase 1 completa**: el
modulo de autenticacion (Aprendiz A) y el modulo de agenda y perfil (Aprendiz B).

---

## Estructura del proyecto

```
lib/
├── core/                          # Codigo transversal (compartido)
│   ├── constants/                 # Colores, temas, rutas y URLs base de la API
│   └── utils/                     # Validadores de formularios
│
├── features/
│   ├── auth/                      # APRENDIZ A (Login, Register y recuperacion)
│   │   ├── data/                  # (Fase 2) datasources, models, repositories
│   │   ├── domain/                # entities, repositories, usecases
│   │   └── presentation/
│   │       ├── pages/             # login_page.dart, register_page.dart, forgot_pass_page.dart
│   │       │                      # profile_page.dart (Aprendiz B)
│   │       └── widgets/           # Componentes visuales exclusivos de Auth
│   │
│   └── agenda/                    # APRENDIZ B (Lista, Formulario y Perfil)
│       ├── data/                  # (Fase 2) datasources, models, repositories
│       ├── domain/
│       │   └── entities/          # task.dart, task_status.dart, task_priority.dart
│       └── presentation/
│           ├── controllers/       # agenda_controller.dart (estado en memoria)
│           ├── pages/             # agenda_list_page.dart, task_form_page.dart
│           └── widgets/           # task_card.dart, status_badge.dart, priority_dot.dart,
│                                  # agenda_summary.dart, agenda_empty_state.dart
│
└── main.dart                      # Punto de entrada e inyeccion de dependencias
```

---

## Fase 1 - Aprendiz A (implementado)

- `login_page.dart` - inicio de sesion con validacion de correo, campo de
  contrasena con visibilidad conmutable, "recordarme" y enlaces a registro y
  recuperacion.
- `register_page.dart` - registro con validacion de nombre, correo, contrasena
  fuerte (min. 8 caracteres, letras + numeros), confirmacion y aceptacion de
  terminos.
- `forgot_pass_page.dart` - solicitud de enlace de recuperacion con pantalla de
  confirmacion.
- Widgets reutilizables: `AuthScaffold` (layout responsive web/movil),
  `AuthHeader`, `AuthTextField`, `AuthSubmitButton`.
- `core/constants` - paleta, tema Material 3, rutas y endpoints de la API.
- `core/utils/validators.dart` - validaciones compartidas.

Las llamadas de red estan marcadas con `TODO(fase-2)`: la logica de datos se
implementa en la Fase 2 contra los endpoints declarados en `ApiConstants`.

---

## Fase 1 - Aprendiz B (implementado)

- `agenda_list_page.dart` - lista de actividades con resumen de pendientes y
  completadas, buscador, filtros por estado (Todas / Pendientes / En progreso /
  Completadas), marcar como completada desde la tarjeta y eliminar con opcion
  de deshacer.
- `task_form_page.dart` - formulario de nueva tarea y de edicion: titulo
  validado, descripcion, selector de fecha limite, estado y prioridad. Devuelve
  la tarea con `Navigator.pop` para que la lista la agregue o actualice.
- `profile_page.dart` (dentro de `features/auth/presentation/pages`) - datos del
  usuario con avatar de iniciales, resumen de su agenda, edicion de nombre y
  correo, y cierre de sesion con confirmacion.
- Entidades de dominio: `Task`, `TaskStatus` (pendiente / en progreso /
  completada) y `TaskPriority` (baja / media / alta), con `fromApi` y `apiValue`
  listos para el mapeo de la Fase 2.
- Widgets reutilizables: `TaskCard`, `StatusBadge`, `PriorityDot`,
  `AgendaSummary` y `AgendaEmptyState`.
- `AgendaController` - estado en memoria (lista, filtros, busqueda y CRUD local)
  con datos de ejemplo para revisar la interfaz sin backend.
- `core/utils/date_formatter.dart` - fechas en formato corto, relativo (Hoy /
  Manana / Ayer) e ISO para la API.

Pruebas del modulo en `test/agenda_test.dart` (controlador, entidad, lista y
formulario).

---

## Como ejecutar

```bash
flutter pub get
```

Web:

```bash
flutter run -d chrome
```

Android:

```bash
flutter run -d android
```

La URL base de la API se puede sobrescribir sin tocar el codigo:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000/api
```

Pruebas y analisis estatico:

```bash
flutter test
```

---

## Flujo de trabajo GitFlow

| Rama | Proposito |
| --- | --- |
| `main` | Codigo estable y liberable |
| `develop` | Rama de integracion del equipo |
| `feature/*` | Trabajo de cada aprendiz por modulo |

Ramas usadas en la Fase 1:

- `feature/auth-frontend` - Aprendiz A (esta entrega)
- `feature/agenda-frontend` - Aprendiz B

Ciclo de trabajo:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/mi-modulo
# ... commits ...
git push -u origin feature/mi-modulo
git checkout develop
git merge --no-ff feature/mi-modulo
git push origin develop
```
