#!/usr/bin/env bash
# Dev: instala o pacote no cache local do Typst (@preview), compila o template
# de exemplo e gera build/main.pdf, PNGs por pagina e thumbnail.png (capa).
set -e
cd "$(dirname "$0")"

name=$(sed -n 's/^name *= *"\(.*\)".*/\1/p' typst.toml | head -1)
version=$(sed -n 's/^version *= *"\(.*\)".*/\1/p' typst.toml | head -1)
cache="$HOME/Library/Application Support/typst/packages/preview/$name/$version"

# Liga o repo ao cache de pacotes para resolver @preview/$name:$version localmente.
mkdir -p "$(dirname "$cache")"
rm -rf "$cache"
ln -s "$PWD" "$cache"

mkdir -p build/png
typst compile template/main.typ build/main.pdf

rm -f build/png/out-*.png
pdftoppm -r 110 -png build/main.pdf build/png/out

# Thumbnail do Universe: 1a pagina (capa), >=1080px na borda maior, <=3 MiB.
typst compile template/main.typ thumbnail.png --pages 1 --ppi 250

echo "ok: $(ls build/png/out-*.png | wc -l | tr -d ' ') paginas; thumbnail.png atualizado ($(du -h thumbnail.png | cut -f1))"
