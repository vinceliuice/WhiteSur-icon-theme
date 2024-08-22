#! /bin/bash

THEME_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=WhiteSur

_THEME_VARIANTS=('' '-red' '-pink' '-purple' '-green' '-yellow' '-orange' '-grey' '-nord')

if [ ! -z "${THEME_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

Tar_themes() {
for theme in "${_THEME_VARIANTS[@]}"; do
  rm -rf "${THEME_NAME}${theme}.tar.xz"
done

for theme in "${_THEME_VARIANTS[@]}"; do
  tar -Jcvf "${THEME_NAME}${theme}.tar.xz" "${THEME_NAME}${theme}"{'','-light','-dark'}
done
}

Clear_theme() {
for theme in "${_THEME_VARIANTS[@]}"; do
  [[ -d "${THEME_NAME}${theme}" ]] && rm -rf "${THEME_NAME}${theme}"{'','-light','-dark'}
done
}

cd .. && ./install.sh -d $THEME_DIR -t all -a

cd $THEME_DIR && Tar_themes && Clear_theme

