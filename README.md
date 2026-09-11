# Proyecto Agenda - Taller GitFlow

Aplicacion de agenda personal desarrollada entre dos aprendices.

| Modulo | Responsable |
|--------|-------------|
| Autenticacion (login, registro, recuperacion) y API REST | Aprendiz A |
| Agenda, formulario de tareas y perfil de usuario | Aprendiz B |

## Estructura

- `mobile/`  aplicacion Flutter
- `backend/` API REST Node.js + Express + MongoDB (Mongoose)

El frontend sigue arquitectura limpia:

```
mobile/lib/
├── core/
│   ├── constants/     colores, textos, rutas, tema, URLs de la API
│   └── utils/         validaciones y formato de fechas
└── features/
    ├── auth/          Aprendiz A
    │   ├── domain/entities/
    │   └── presentation/pages|widgets/
    └── agenda/        Aprendiz B
        ├── domain/entities/
        └── presentation/pages|widgets|controllers/
```

El modulo de auth ya tiene su capa de datos completa:

```
core/network/     cliente HTTP y errores de la API
core/storage/     guarda el JWT en el dispositivo
features/auth/
├── data/         datasource, modelo y repositorio contra la API
├── domain/       entidad User y contrato AuthRepository
└── presentation/ pantallas y AuthController (estado de la sesion)
```

Las carpetas `data/` de agenda siguen vacias: ahi van los repositorios
del Aprendiz B cuando existan sus endpoints.

## Ejecutar el Flutter

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

### Apuntar la app a la API

La URL de la API se define al compilar, sin tocar el codigo:

```
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
```

Valor por defecto: `http://10.0.2.2:3000/api`, que es como el emulador de
Android alcanza el `localhost` del computador. En Flutter web o en escritorio
hay que pasar `http://localhost:3000/api`. Al desplegar en Railway se usa la
URL publica (`https://...`).

### Pruebas contra la API real

`flutter test` no necesita backend: las pruebas de `test/integration` se
omiten solas si el servidor no responde. Para ejecutarlas de verdad hay que
levantar el backend y pasarle la misma URL:

```
flutter test test/integration --dart-define=API_BASE_URL=http://localhost:3000/api
```

## Base de datos (MongoDB Atlas)

1. Crear un cluster gratuito en https://cloud.mongodb.com
2. En **Database Access**, crear un usuario con su contrasena.
3. En **Network Access**, permitir la IP propia (o `0.0.0.0/0` para pruebas).
4. En **Connect > Drivers**, copiar la cadena de conexion y pegarla
   en `backend/.env` como `MONGODB_URI`, reemplazando usuario, clave
   y el nombre de la base de datos (`agenda_db`).

No hay que crear la coleccion `usuarios` a mano: Mongoose la crea
automaticamente al registrar el primer usuario.

## Ejecutar el backend

```
cd backend
npm install
cp .env.example .env      # editar con la cadena real de Atlas y el JWT_SECRET
npm run dev
```

## Endpoints

Implementados (Aprendiz A):

| Metodo | Ruta                        | Protegido | Descripcion                       |
|--------|-----------------------------|-----------|-----------------------------------|
| GET    | /                           | No        | Comprobar que la API responde     |
| POST   | /api/auth/register          | No        | Registrar usuario                 |
| POST   | /api/auth/login             | No        | Iniciar sesion y obtener JWT      |
| GET    | /api/auth/profile           | Si (JWT)  | Datos del usuario autenticado     |
| POST   | /api/auth/forgot-password   | No        | Solicitar recuperacion            |

Pendientes (Aprendiz B): los endpoints CRUD de tareas, ya declarados en
`mobile/lib/core/constants/api_constants.dart` como `ApiConstants.tasks`.

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

## Despliegue en Railway (pendiente)

El backend lee sus datos desde variables de entorno, por lo que solo falta
crear el servicio en Railway y cargar estas variables apuntando al mismo
cluster de Atlas:

- `MONGODB_URI`
- `JWT_SECRET` (usar un valor largo y aleatorio, nunca el del ejemplo)
- `NODE_ENV=production`
- `PORT` (Railway lo asigna solo)

`NODE_ENV=production` es importante: sin esa variable, la respuesta de
`/api/auth/forgot-password` incluiria el token de recuperacion, que solo
debe verse en desarrollo.
