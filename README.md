# Proyecto Agenda - Taller GitFlow

Aplicacion de agenda personal desarrollada entre dos aprendices.

## Integrantes

| Aprendiz | Nombre | Modulo a cargo |
|----------|--------|----------------|
| Aprendiz A | Juan Jose Mira | Autenticacion (login, registro, recuperacion), perfil de sesion y API REST |
| Aprendiz B | Juan Jose Mazo | Agenda, formulario de tareas y pantalla de perfil de usuario |

## Enlaces del proyecto

| Recurso | URL |
|---------|-----|
| Repositorio (GitHub) | https://github.com/juanjomira12/mongocarlos |
| API REST (Vercel) | https://mongocarlos-seven.vercel.app |
| App web (Render) | https://tallerfinalcarlos.onrender.com |

Para comprobar que la API esta viva:

```
curl https://mongocarlos-seven.vercel.app/
```

Responde `{"ok":true,"mensaje":"API Agenda funcionando","baseDatos":"conectada"}`.

## Tecnologias

| Capa | Stack |
|------|-------|
| Movil / Web | Flutter (Dart), arquitectura limpia |
| Backend | Node.js + Express 5 |
| Base de datos | MongoDB Atlas con Mongoose |
| Autenticacion | JWT + bcryptjs |
| Despliegue | Vercel (API) y Render (app web) |

---

## Estructura del proyecto

El repositorio tiene dos proyectos independientes en la raiz:

```
mongocarlos/
├── backend/          API REST Node.js + Express + MongoDB
├── mobile/           Aplicacion Flutter (Android y web)
├── .gitignore
└── README.md
```

### Encarpetado del backend

```
backend/
├── api/
│   └── index.js                      punto de entrada para Vercel (serverless)
├── src/
│   ├── config/
│   │   └── database.js               conexion a MongoDB (cacheada entre invocaciones)
│   ├── controllers/
│   │   └── auth.controller.js        registro, login, perfil, recuperacion
│   ├── middleware/
│   │   ├── auth.middleware.js        verifica el JWT de las rutas protegidas
│   │   └── validate.middleware.js    valida el cuerpo de las peticiones
│   ├── models/
│   │   └── usuario.model.js          esquema Mongoose de la coleccion usuarios
│   ├── routes/
│   │   └── auth.routes.js            rutas /api/auth/*
│   ├── app.js                        instancia de Express (cors, json, rutas)
│   └── server.js                     punto de entrada local (abre el puerto)
├── .env.example                      plantilla de variables de entorno
├── .gitignore
├── .vercelignore
├── package.json
├── package-lock.json
└── vercel.json                       enruta todas las peticiones a api/index.js
```

**Por que dos puntos de entrada:** Vercel no arranca un servidor, ejecuta una
funcion por peticion. `src/server.js` es para desarrollo local (`npm run dev`) y
abre un puerto; `api/index.js` solo exporta la app de Express para Vercel.

### Encarpetado del mobile (Flutter)

```
mobile/
├── android/                          proyecto nativo Android
│   ├── app/
│   │   ├── src/
│   │   │   ├── debug/AndroidManifest.xml
│   │   │   ├── main/
│   │   │   │   ├── AndroidManifest.xml
│   │   │   │   ├── kotlin/com/taller/agenda_app/MainActivity.kt
│   │   │   │   └── res/              iconos, splash y estilos
│   │   │   └── profile/AndroidManifest.xml
│   │   └── build.gradle.kts
│   ├── gradle/wrapper/
│   ├── build.gradle.kts
│   ├── gradle.properties
│   └── settings.gradle.kts
│
├── lib/
│   ├── core/                         codigo compartido por los dos modulos
│   │   ├── constants/
│   │   │   ├── api_constants.dart    URLs de la API (incluye las de tareas)
│   │   │   ├── app_colors.dart
│   │   │   ├── app_routes.dart
│   │   │   ├── app_strings.dart
│   │   │   └── app_theme.dart
│   │   ├── network/
│   │   │   ├── api_client.dart       cliente HTTP
│   │   │   └── api_exception.dart    errores de la API
│   │   ├── storage/
│   │   │   └── token_storage.dart    guarda el JWT en el dispositivo
│   │   └── utils/
│   │       ├── date_formatter.dart
│   │       └── validators.dart
│   │
│   ├── features/
│   │   ├── auth/                     >>> Aprendiz A: Juan Jose Mira
│   │   │   ├── data/
│   │   │   │   ├── datasources/auth_remote_datasource.dart
│   │   │   │   ├── models/user_model.dart
│   │   │   │   └── repositories/auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/user.dart
│   │   │   │   ├── repositories/auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── controllers/auth_controller.dart
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   ├── forgot_pass_page.dart
│   │   │       │   └── profile_page.dart
│   │   │       └── widgets/
│   │   │           ├── auth_error_message.dart
│   │   │           ├── auth_header.dart
│   │   │           ├── auth_scaffold.dart
│   │   │           ├── auth_submit_button.dart
│   │   │           └── auth_text_field.dart
│   │   │
│   │   └── agenda/                   >>> Aprendiz B: Juan Jose Mazo
│   │       ├── data/                 (vacia: espera los endpoints de tareas)
│   │       │   ├── datasources/
│   │       │   ├── models/
│   │       │   └── repositories/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── task.dart
│   │       │   │   ├── task_priority.dart
│   │       │   │   └── task_status.dart
│   │       │   ├── repositories/
│   │       │   └── usecases/
│   │       └── presentation/
│   │           ├── controllers/agenda_controller.dart
│   │           ├── pages/
│   │           │   ├── agenda_list_page.dart
│   │           │   └── task_form_page.dart
│   │           └── widgets/
│   │               ├── agenda_empty_state.dart
│   │               ├── agenda_summary.dart
│   │               ├── priority_dot.dart
│   │               ├── status_badge.dart
│   │               └── task_card.dart
│   │
│   └── main.dart                     arranque de la app
│
├── test/
│   ├── integration/auth_api_test.dart   se omite solo si no hay backend
│   ├── support/fake_auth_repository.dart
│   ├── agenda_test.dart
│   └── widget_test.dart
│
├── web/                              recursos de la version web
│   ├── icons/
│   ├── favicon.png
│   ├── index.html
│   └── manifest.json
│
├── Dockerfile                        build para Render / cualquier contenedor
├── nginx.conf                        sirve build/web dentro del contenedor
├── vercel-install.sh                 instala Flutter en el build de Vercel
├── vercel-build.sh                   compila la app web
├── vercel.json
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

### Como se reparte el trabajo en el codigo

Cada aprendiz trabaja dentro de su carpeta de `features/` y nadie toca la del
otro. `core/` es territorio compartido: si hay que cambiar algo ahi, se avisa
antes para no romper el trabajo del companero.

Las carpetas `data/` de agenda siguen vacias (con `.gitkeep`): ahi van los
repositorios del Aprendiz B cuando existan sus endpoints en la API.

---

## Ejecutar el proyecto

### Flutter

```
cd mobile
flutter pub get
flutter run
```

Pruebas:

```
cd mobile
flutter test
```

#### Apuntar la app a la API

La URL de la API se define al compilar, sin tocar el codigo:

```
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
```

Valor por defecto: `http://10.0.2.2:3000/api`, que es como el emulador de
Android alcanza el `localhost` del computador. En Flutter web o en escritorio
hay que pasar `http://localhost:3000/api`. En produccion se usa la URL publica
de Vercel: `https://mongocarlos-seven.vercel.app/api`.

#### Pruebas contra la API real

`flutter test` no necesita backend: las pruebas de `test/integration` se
omiten solas si el servidor no responde. Para ejecutarlas de verdad hay que
levantar el backend y pasarle la misma URL:

```
flutter test test/integration --dart-define=API_BASE_URL=http://localhost:3000/api
```

### Backend

```
cd backend
npm install
cp .env.example .env      # editar con la cadena real de Atlas y el JWT_SECRET
npm run dev
```

---

## Base de datos (MongoDB Atlas)

1. Crear un cluster gratuito en https://cloud.mongodb.com
2. En **Database Access**, crear un usuario con su contrasena.
3. En **Network Access**, permitir la IP propia (o `0.0.0.0/0` para pruebas).
4. En **Connect > Drivers**, copiar la cadena de conexion y pegarla
   en `backend/.env` como `MONGODB_URI`, reemplazando usuario, clave
   y el nombre de la base de datos (`agenda_db`).

No hay que crear la coleccion `usuarios` a mano: Mongoose la crea
automaticamente al registrar el primer usuario.

## Endpoints

Implementados (Aprendiz A - Juan Jose Mira):

| Metodo | Ruta                        | Protegido | Descripcion                       |
|--------|-----------------------------|-----------|-----------------------------------|
| GET    | /                           | No        | Comprobar que la API responde     |
| POST   | /api/auth/register          | No        | Registrar usuario                 |
| POST   | /api/auth/login             | No        | Iniciar sesion y obtener JWT      |
| GET    | /api/auth/profile           | Si (JWT)  | Datos del usuario autenticado     |
| POST   | /api/auth/forgot-password   | No        | Solicitar recuperacion            |

Pendientes (Aprendiz B - Juan Jose Mazo): los endpoints CRUD de tareas, ya
declarados en `mobile/lib/core/constants/api_constants.dart` como
`ApiConstants.tasks`.

## Reglas de contrasena

El formulario de registro en Flutter y la API aplican la misma regla:
minimo 8 caracteres, combinando letras y numeros.

## Estado por fases

- **Fase 1 (Frontend):** completa.
- **Fase 2 (Backend & DB):** completa para autenticacion. Faltan los
  endpoints de tareas del Aprendiz B.
- **Fase 3 (Integracion):** completa para autenticacion. Login, registro,
  recuperacion y perfil consumen la API real. La agenda sigue con datos
  en memoria porque sus endpoints todavia no existen.
- **Fase 4 (Despliegue):** API en Vercel y app web en Render, ambas en linea.

---

## Despliegue

### La API en Vercel

**URL:** https://mongocarlos-seven.vercel.app

Vercel no arranca un servidor: ejecuta una funcion por cada peticion. Por eso
el backend tiene dos puntos de entrada:

- `src/server.js` para desarrollo local (`npm run dev`), que si abre un puerto.
- `api/index.js` para Vercel, que solo exporta la aplicacion de Express.

La conexion a MongoDB se guarda en una variable global (`src/config/database.js`)
y se reutiliza entre invocaciones. Sin eso se abriria una conexion por peticion
y Atlas agotaria su limite.

**Pasos:**

1. **Add New > Project** y elegir este repositorio.
2. **Root Directory**: `backend`
   El repositorio tiene dos proyectos; sin esto Vercel mira la raiz y no
   encuentra el `package.json`.
3. **Environment Variables**:

   | Variable | Valor |
   |----------|-------|
   | `MONGODB_URI` | la cadena de conexion de Atlas |
   | `JWT_SECRET` | un valor largo y aleatorio, nunca el del ejemplo |
   | `NODE_ENV` | `production` |

   `PORT` no se define: en serverless no hay un puerto propio.

   Para generar el `JWT_SECRET`:

   ```
   node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"
   ```

4. **Deploy**.
5. En Atlas, **Network Access** debe permitir `0.0.0.0/0`: las IP de salida
   de Vercel cambian y no se pueden poner en una lista.

**Comprobar:**

```
curl https://mongocarlos-seven.vercel.app/
```

Debe responder `{"ok":true,"mensaje":"API Agenda funcionando","baseDatos":"conectada"}`.

Y verificar que el token de recuperacion no se filtra:

```
curl -X POST https://mongocarlos-seven.vercel.app/api/auth/forgot-password ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"alguien@correo.com\"}"
```

La respuesta **no** debe incluir `tokenRecuperacion`. Si aparece, falta
`NODE_ENV=production`.

### La app web en Render

**URL:** https://tallerfinalcarlos.onrender.com

Render construye la imagen del `Dockerfile` de `mobile/`: compila la app con
Flutter y sirve `build/web` con nginx (`nginx.conf`).

1. **New > Web Service** y elegir este repositorio.
2. **Root Directory**: `mobile`
3. **Runtime**: Docker.
4. **Environment Variables**:

   | Variable | Valor |
   |----------|-------|
   | `API_BASE_URL` | `https://mongocarlos-seven.vercel.app/api` |

   Con `/api` al final y sin barra despues.

5. **Create Web Service**.

> **Importante:** en Flutter la URL de la API es una constante de compilacion,
> no se lee al arrancar. Si se cambia `API_BASE_URL` hay que volver a
> desplegar; con reiniciar no basta.

En el plan gratuito de Render el servicio se duerme tras un rato sin uso, asi
que la primera carga despues de un tiempo inactivo tarda varios segundos.

`mobile/` tambien conserva `vercel.json`, `vercel-install.sh` y
`vercel-build.sh` por si se quiere publicar la web en Vercel en lugar de Render.

### Orden

Primero la API, porque su URL es la que necesita la app web.

La API acepta peticiones de cualquier origen (`cors()`), asi que el navegador
no bloquea las llamadas desde el dominio de la app web. Ambas quedan en HTTPS,
que es necesario: una pagina servida por HTTPS no puede llamar a una API por
HTTP.

### Comprobacion final

Abrir https://tallerfinalcarlos.onrender.com y registrar una cuenta. Si entra a
la agenda, los dos despliegues y Atlas estan conectados.
