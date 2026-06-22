#!/usr/bin/env bash
# pandoc.sh — Instalación de Pandoc, citeproc y pandoc-crossref.

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

# Declara la versión actual de ambos
PANDOC_VERSION="3.9.0.2"
PANDOC_CROSSREF_VERSION="v0.3.24a"

_dir_bin="${HOME}/.local/bin"
_dir_man="${XDG_DATA_HOME:-$HOME/.local/share}/man/man1"

# ── Descarga ──────────────────────────────────────────────────────────────────

instalar_pandoc() {
  local version="$PANDOC_VERSION"
  local binario="$_dir_bin/pandoc"

  if [[ -x "$binario" ]] && "$binario" --version 2>/dev/null | grep -qF "$version"; then
    printf "${BOLD_CYN}Pandoc $version ${CYN}ya está instalado.${NC}\n"
    return
  fi

  printf "${CYN}Instalando ${BOLD_CYN}Pandoc $version${CYN}…${NC}"

  local url="https://github.com/jgm/pandoc/releases/download/${version}/pandoc-${version}-linux-amd64.tar.gz"
  local tmp
  tmp="$(mktemp -d)"

  curl -fL# "$url" | tar -xz -C "$tmp"

  install -Dm755 "$tmp/pandoc-${version}/bin/pandoc"        "$_dir_bin/pandoc"
  install -Dm755 "$tmp/pandoc-${version}/bin/pandoc-lua"    "$_dir_bin/pandoc-lua"
  install -Dm755 "$tmp/pandoc-${version}/bin/pandoc-server" "$_dir_bin/pandoc-server"

  cp "$tmp/pandoc-${version}/share/man/man1/"*.1.gz "$_dir_man/"

  rm -rf "$tmp"
}

instalar_citeproc_man() {
  local destino="$_dir_man/citeproc.1.gz"

  if [[ -f "$destino" ]]; then
    printf "${CYN}La ${BOLD_CYN}página de manual de citeproc${CYN} ya está instalada.${NC}\n"
    return
  fi

  printf "${CYN}Instalando la ${BOLD_CYN}página de manual de citeproc${CYN}…${NC}\n"

  local url="https://raw.githubusercontent.com/jgm/citeproc/master/man/citeproc.1"
  curl -fL# "$url" | gzip > "$destino"
}

instalar_pandoc_crossref() {
  local version="$PANDOC_CROSSREF_VERSION"
  local binario="$_dir_bin/pandoc-crossref"

  if [[ -x "$binario" ]] && "$binario" --version 2>/dev/null | grep -qF "${version%%[a-z]*}"; then
    printf "${BOLD_CYN}pandoc-crossref $version ${CYN}ya está instalado.${NC}\n"
    return
  fi

  printf "${CYN}Instalando ${BOLD_CYN}pandoc-crossref $version${CYN}…${NC}\n"

  local url="https://github.com/lierdakil/pandoc-crossref/releases/download/${version}/pandoc-crossref-Linux-X64.tar.xz"
  local tmp
  tmp="$(mktemp -d)"

  curl -fL# "$url" | tar -xJ -C "$tmp"

  install -Dm755 "$tmp/pandoc-crossref" "$_dir_bin/pandoc-crossref"
  gzip -c "$tmp/pandoc-crossref.1" > "$_dir_man/pandoc-crossref.1.gz"

  rm -rf "$tmp"
}

# ── Ejecución principal ───────────────────────────────────────────────────────

mkdir -p "$_dir_man"
instalar_pandoc
instalar_citeproc_man
instalar_pandoc_crossref
