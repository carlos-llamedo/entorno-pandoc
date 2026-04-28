#!/usr/bin/env bash
# actualizar-locales.sh — Descarga los locales CSL desde el repositorio oficial.
#
# Los locales son extraordinariamente estables (el estándar CSL lleva años sin
# cambios sustanciales), pero este script permite actualizarlos manualmente
# cuando sea necesario. Ejecútalo desde el directorio raíz del repositorio
# de pandoc o desde cualquier ubicación.

# ── Colores y gestión de errores ──────────────────────────────────────────────

NC=$'\033[0m'
RST="$NC"
RED=$'\033[0;31m'
YEL=$'\033[0;33m'
BOLD_GRN=$'\033[1;32m'

fatal() {
  echo -e "${RED}[fatal]${RST} $@" >&2
  exit 1
}

fatal_trap() {
  trap 'fatal "Error en línea $LINENO del script ${BASH_SOURCE[0]}"' ERR
}

fatal_trap

# ── Variables ─────────────────────────────────────────────────────────────────

dir_locales="${XDG_DATA_HOME:-$HOME/.local/share}/pandoc/locales"
url_base="https://raw.githubusercontent.com/citation-style-language/locales/master"

locales=(
  en-GB
  en-US
  es-ES
  fr-FR
)

# ── Descarga ──────────────────────────────────────────────────────────────────

actualizar_locales() {
  mkdir -p "$dir_locales"
  printf '%s%s%s\n' "$YEL" "Actualizando locales CSL…" "$NC"

  for locale in "${locales[@]}"; do
    local archivo="locales-${locale}.xml"
    curl -sSL "$url_base/$archivo" -o "$dir_locales/$archivo" \
      || fatal "no se pudo descargar $archivo"
    printf '%s%s%s\n' "$YEL" "  ✓ $archivo" "$NC"
  done
}

# ── Ejecución principal ───────────────────────────────────────────────────────

actualizar_locales

printf '%s%s%s\n' "$BOLD_GRN" "Locales CSL actualizados correctamente." "$NC"
