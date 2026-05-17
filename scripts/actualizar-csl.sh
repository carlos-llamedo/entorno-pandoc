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

dir_csl="$(chezmoi source-path ~/.local/share/pandoc/csl)"
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
  printf '%s%s%s\n' "$YEL" "Actualizando estilos CSL…" "$NC"

  for estilo in "${estilos[@]}"; do
    local archivo="${estilo}.csl"
    curl -sSL "$url_base/$archivo" -o "$dir_csl/$archivo" \
      || fatal "no se pudo descargar $archivo"
    printf '%s%s%s\n' "$YEL" "  ✓ $archivo" "$NC"
  done
}

# ── Ejecución principal ───────────────────────────────────────────────────────

actualizar_csl

printf '%s%s%s\n' "$BOLD_GRN" "Estilos CSL actualizados correctamente." "$NC"
