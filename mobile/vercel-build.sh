#!/usr/bin/env bash
# Compila la app para web. Vercel publica lo que quede en build/web.
set -euo pipefail

export PATH="$HOME/flutter/bin:$PATH"

# Sin esta variable la app apuntaria al valor por defecto (10.0.2.2, el
# emulador de Android) y en produccion no conectaria con nada. Mejor
# fallar aqui, visible, que publicar una web rota en silencio.
if [ -z "${API_BASE_URL:-}" ]; then
  echo "ERROR: falta la variable API_BASE_URL en el proyecto de Vercel"
  exit 1
fi

flutter build web --release --dart-define=API_BASE_URL="$API_BASE_URL"
