#!/usr/bin/env bash
# md-pdf.sh — Convierte Markdown a PDF (o TEX) mediante pandoc + LuaLaTeX.

# ── Color ───────────────────────────────────────────────────────────────────

NC=$'\033[0m'
RST="$NC"
RED=$'\033[0;31m'
BOLD_BLU=$'\033[1;34m'

# ── Fatal ───────────────────────────────────────────────────────────────────

fatal() {
  echo -e "${RED}[fatal]${RST} $@" >&2
  exit 1
}

fatal_trap() {
  trap 'fatal "Error en línea $LINENO del script ${BASH_SOURCE[0]}"' ERR
}

fatal_trap

# ── enlace_local ────────────────────────────────────────────────────────────
# Genera hipervínculos clicables en la terminal (OSC 8).

# _urlencode CADENA 
# Codifica CADENA en formato URL.
_urlencode() {
  local encoded=""
  local hex dec

  while IFS= read -r -N 2 hex; do
    dec=$(( 16#$hex ))
    if [[ $dec -ge 45 && $dec -le 57 ]] ||
       [[ $dec -ge 65 && $dec -le 90 ]] ||
       [[ $dec -ge 97 && $dec -le 122 ]] ||
       [[ $dec -eq 95 ]] ||
       [[ $dec -eq 126 ]]; then
      encoded+="$(printf '%b' "\\x$hex")"
    else
      encoded+="%${hex^^}"
    fi
  done < <(printf '%s' "$1" | od -An -tx1 -v | tr -d ' \n')

  printf '%s' "$encoded"
}

# enlace_local RUTA [TEXTO]
# Imprime RUTA como hipervínculo clicable.
# Si se omite TEXTO, usa la propia RUTA.
enlace_local() {
  local ruta="$1"
  local texto="${2:-$ruta}"
  local absoluta
  local encoded

  absoluta="$(realpath -m "$ruta")"
  encoded="$(_urlencode "$absoluta")"

  printf '\033]8;;file://%s\033\\%s\033]8;;\033\\' "$encoded" "$texto"
}

# ── Opciones ────────────────────────────────────────────────────────────────

defaults="memoria"
modo="pdf"
verbosidad=""

usage() {
  cat <<EOF
Uso: md-pdf.sh [-d PLANTILLA] [-t] [-h] DOCUMENTO.md

Opciones:
  -d PLANTILLA  Defaults file a usar (sin extensión). Por defecto: memoria.
                Los defaults files viven en el data-dir de pandoc (defaults/).
  -t            Modo tex: genera .tex en el directorio del Markdown en vez de
                PDF en el Escritorio. Procesa citas y filtros; útil para
                retocar a mano antes de compilar.
  -v            Modo verboso: activa información de depuración de pandoc.
  -h            Muestra esta ayuda y sale.

Ejemplos:
  md-pdf.sh documento.md
  md-pdf.sh -d handout documento.md
  md-pdf.sh -t documento.md
  md-pdf.sh -d handout -t documento.md
EOF
}

while getopts ":d:thv" opt; do
  case $opt in
    d) defaults="$OPTARG" ;;
    t) modo="tex" ;;
    v) verbosidad="--verbose" ;;
    h) usage; exit 0 ;;
    :) echo "Error: la opción -$OPTARG requiere un argumento."; exit 1 ;;
   \?) echo "Error: opción desconocida: -$OPTARG."; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# ── Entrada ─────────────────────────────────────────────────────────────────

entrada="$1"

if [[ -z "$entrada" ]]; then
  echo "Error: falta el archivo de entrada."; usage; exit 1
fi

case "$entrada" in
  *.md|*.markdown) ;;
  *) echo "Error: '$entrada' no parece Markdown."; exit 1 ;;
esac

# ── Rutas ───────────────────────────────────────────────────────────────────

dir_rel="$(dirname "$entrada")"
dir="$(realpath "$dir_rel")"
nombre_base="$(basename "${entrada%.*}")"
escritorio="${XDG_DESKTOP_DIR:-$HOME/Escritorio}"

if [[ "$modo" == "tex" ]]; then
  salida_final="$dir_rel/$nombre_base.tex"
  salida="$dir/$nombre_base.tex"
else
  salida_final="Escritorio/$nombre_base.pdf"
  salida="$escritorio/$nombre_base.pdf"
fi

# ── Compilación ─────────────────────────────────────────────────────────────

(cd "$dir" && pandoc "$(basename "$entrada")" \
  -d "$defaults" \
  $verbosidad \
  -o "$salida")

# ── Salida ──────────────────────────────────────────────────────────────────

printf 'Generado: %s' "$BOLD_BLU"
enlace_local "$salida_final"
printf '%s\n' "$NC"
