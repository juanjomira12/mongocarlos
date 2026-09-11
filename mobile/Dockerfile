# Despliegue de la app Flutter Web en Railway.
#
# Se compila en una imagen que ya trae Flutter y despues solo se copian
# los archivos resultantes a un nginx, para que la imagen final sea
# pequena y no cargue con el SDK.

# ---------- Etapa 1: compilar ----------
# Se usa "stable" y no una version fija porque las etiquetas con numero
# de esta imagen van por detras de Flutter 3.47, que es la que pide el
# pubspec de este proyecto.
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# La URL de la API se inyecta al compilar: en Flutter es una constante
# de compilacion, no algo que se pueda leer al arrancar el contenedor.
# Railway pasa las variables del servicio como argumentos de build.
ARG API_BASE_URL

# Primero solo los pubspec, para aprovechar la cache de Docker:
# si no cambian las dependencias, no se vuelven a descargar.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Sin esta variable la app compilaria apuntando al valor por defecto
# (10.0.2.2, el emulador de Android) y en produccion no conectaria con
# nada. Es preferible que falle aqui, de forma visible, y no despues.
RUN test -n "$API_BASE_URL" || \
    (echo "ERROR: falta la variable API_BASE_URL en el servicio de Railway" && exit 1)

RUN flutter build web --release --dart-define=API_BASE_URL=$API_BASE_URL

# ---------- Etapa 2: servir ----------
FROM nginx:alpine

# nginx sustituye las variables de los archivos .template al arrancar.
# El filtro limita la sustitucion a PORT para no tocar por error las
# variables propias de nginx como $uri.
ENV NGINX_ENVSUBST_FILTER=^PORT$
# Valor por defecto; Railway lo reemplaza por el puerto que asigne.
ENV PORT=8080

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/templates/default.conf.template
