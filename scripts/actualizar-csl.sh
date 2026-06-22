#!/usr/bin/env bash
# actualizar-csl.sh — Descarga los estilos CSL desde el repositorio oficial.
#
# Los estilos Chicago y MHRA son estables, pero este script permite
# actualizarlos manualmente cuando sea necesario. Ejecútalo desde el
# directorio raíz del repositorio de pandoc o desde cualquier ubicación.

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
  dir_csl="$(chezmoi source-path ~/.local/share/pandoc/csl/)"
else
  dir_csl="${XDG_DATA_HOME:-$HOME/.local/share}/pandoc/csl/"
fi
url_base="https://raw.githubusercontent.com/citation-style-language/styles/master"

estilos=(
  apa
  chicago-author-date
  chicago-notes-bibliography
  chicago-shortened-notes-bibliography
  mhra-author-date
  mhra-notes
  mhra-shortened-notes
)

# ── Descarga ──────────────────────────────────────────────────────────────────

actualizar_csl() {
  mkdir -p "$dir_csl"
  printf "${CYN}Actualizando ${BOLD_CYN}estilos CSL${CYN}…${NC}\n"

  for estilo in "${estilos[@]}"; do
    local archivo="${estilo}.csl"
    curl -sSL "$url_base/$archivo" -o "$dir_csl/$archivo" \
      || fatal "no se pudo descargar $archivo"
    printf "${CYN}  ✓ ${BOLD_CYN}%s${NC}\n" "$archivo"
  done
}

# ── Ejecución principal ───────────────────────────────────────────────────────

actualizar_csl

printf "${BOLD_GRN}Estilos CSL actualizados correctamente.${NC}\n"
