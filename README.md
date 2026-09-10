# Proyecto Agenda - Aprendiz A

Fase 1 (Frontend Flutter) y Fase 2 (Backend + Base de datos) de autenticacion.

## Estructura

- `mobile/`  aplicacion Flutter (Login, Registro, Recuperar contrasena, Home temporal)
- `backend/` API REST Node.js + Express + MongoDB (Mongoose)

## Ejecutar el Flutter

```
cd mobile
flutter pub get
flutter run
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

| Metodo | Ruta                        | Protegido | Descripcion                       |
|--------|-----------------------------|-----------|-----------------------------------|
| GET    | /                           | No        | Comprobar que la API responde     |
| POST   | /api/auth/register          | No        | Registrar usuario                 |
| POST   | /api/auth/login             | No        | Iniciar sesion y obtener JWT      |
| GET    | /api/auth/profile           | Si (JWT)  | Datos del usuario autenticado     |
| POST   | /api/auth/forgot-password   | No        | Solicitar recuperacion            |

## Despliegue en Railway (pendiente)

El backend lee `MONGODB_URI`, `JWT_SECRET` y `PORT` desde variables de
entorno, por lo que solo falta crear el servicio en Railway y cargar
esas variables apuntando al mismo cluster de Atlas.
