#!/usr/bin/env bash
# Instala Flutter durante el build de Vercel.
#
# La imagen de build de Vercel no trae Flutter, asi que se clona el canal
# stable. Se usa --depth 1 para bajar solo el ultimo commit: el repositorio
# completo pesa cientos de megas y aqui no hace falta el historial.
set -euo pipefail

FLUTTER_DIR="$HOME/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  git clone https://github.com/flutter/flutter.git \
    --branch stable --depth 1 "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# Flutter ejecuta git sobre su propia carpeta; sin esto puede quejarse de
# que el directorio pertenece a otro usuario y abortar.
git config --global --add safe.directory "$FLUTTER_DIR"

flutter --version
flutter pub get
