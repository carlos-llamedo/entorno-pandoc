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
CYN=$'\033[0;36m'
BOLD_GRN=$'\033[1;32m'
BOLD_CYN=$'\033[1;36m'

fatal() {
  echo -e "${RED}[fatal]${RST} $@" >&2
  exit 1
}

fatal_trap() {
  trap 'fatal "Error en línea $LINENO del script ${BASH_SOURCE[0]}"' ERR
}

fatal_trap

# ── Variables ─────────────────────────────────────────────────────────────────

if command -v chezmoi &>/dev/null; then
  dir_locales="$(chezmoi source-path ~/.local/share/pandoc/locales/)"
else
  dir_locales="${XDG_DATA_HOME:-$HOME/.local/share}/pandoc/locales/"
fi
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
  printf "${CYN}Actualizando ${BOLD_CYN}locales CSL${CYN}…${NC}\n"

  for locale in "${locales[@]}"; do
    local archivo="locales-${locale}.xml"
    curl -sSL "$url_base/$archivo" -o "$dir_locales/$archivo" \
      || fatal "no se pudo descargar $archivo"
    printf "${CYN}  ✓ ${BOLD_CYN}%s${NC}\n" "$archivo"
  done
}

# ── Ejecución principal ───────────────────────────────────────────────────────

actualizar_locales

printf "${BOLD_GRN}Locales CSL actualizados correctamente.${NC}\n"
