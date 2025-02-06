#!/usr/bin/env bash

set -eo pipefail

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

THEME_NAME=WhiteSur
COLOR_VARIANTS=('' '-light' '-dark')
THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey' '-nord')

themes=()
colors=()

usage() {
cat << EOF
  Usage: $0 [OPTION]...

  OPTIONS:
    -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
    -n, --name NAME         Specify theme name (Default: $THEME_NAME)
    -t, --theme VARIANT     Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|grey|nord|all] (Default: blue)
    -a, --alternative       Install alternative icons for software center and file-manager
    -b, --bold              Install bolder panel icons version (1.5px size)

    -r, --remove,
    -u, --uninstall         Uninstall (remove) icon themes

    -h, --help              Show help
EOF
}

install() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}

  local THEME_DIR=${dest}/${name}${theme}${color}

  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"

  echo "Installing '${THEME_DIR}'..."

  mkdir -p                                                                                   "${THEME_DIR}"
  cp -r "${SRC_DIR}"/{COPYING,AUTHORS}                                                       "${THEME_DIR}"
  cp -r "${SRC_DIR}"/src/index.theme                                                         "${THEME_DIR}"

  #cd "${THEME_DIR}"
  sed -i "s/${name}/${name}${theme}${color}/g" "${THEME_DIR}"/index.theme

  if [[ ${color} == '' ]]; then
    mkdir -p                                                                                 "${THEME_DIR}"/status
    cp -r "${SRC_DIR}"/src/{actions,animations,apps,categories,devices,emotes,emblems,mimes,places,preferences} "${THEME_DIR}"
    cp -r "${SRC_DIR}"/src/status/{16,22,24,32,symbolic}                                     "${THEME_DIR}"/status

    if [[ ${black:-} == 'true' ]]; then
      sed -i "s/#f2f2f2/#363636/g" "${THEME_DIR}"/status/{16,22,24}/*
    fi

    if [[ ${bold:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/bold/*                                                              "${THEME_DIR}"
    fi

    if [[ $DESKTOP_SESSION == '/usr/share/xsessions/budgie-desktop' ]]; then
      cp -r "${SRC_DIR}"/src/status/symbolic-budgie/*.svg                                    "${THEME_DIR}"/status/symbolic
    fi

    if [[ ${alternative:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/alternative/*                                                       "${THEME_DIR}"
    fi

    if [[ ${theme} != '' ]]; then
      cp -r "${SRC_DIR}"/colors/color${theme}/*.svg                                          "${THEME_DIR}"/places/scalable
    fi

    rm -rf "${THEME_DIR}"/places/scalable/user-trash{'','-full'}-dark.svg

    cp -r "${SRC_DIR}"/links/{actions,apps,categories,devices,emotes,emblems,mimes,places,status,preferences} "${THEME_DIR}"
    ln -s "${THEME_DIR}"/preferences/32 "${THEME_DIR}"/preferences/22
  fi

  if [[ ${color} == '-light' ]]; then
    mkdir -p                                                                                 "${THEME_DIR}"/status
    cp -r ${SRC_DIR}/src/status/{16,22,24,32}                                                "${THEME_DIR}"/status

    if [[ ${bold:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/bold/status/{16,22,24}                                              "${THEME_DIR}"/status
    fi

    # Change icon color for light theme
    sed -i "s/#f2f2f2/#363636/g" "${THEME_DIR}"/status/{16,22,24,32}/*
    cp -r "${SRC_DIR}"/links/status/{16,22,24,32}                                            "${THEME_DIR}"/status

    cd ${dest}
    ln -s ../${name}${theme}/actions ${name}${theme}-light/actions
    ln -s ../${name}${theme}/animations ${name}${theme}-light/animations
    ln -s ../${name}${theme}/apps ${name}${theme}-light/apps
    ln -s ../${name}${theme}/categories ${name}${theme}-light/categories
    ln -s ../${name}${theme}/devices ${name}${theme}-light/devices
    ln -s ../${name}${theme}/emotes ${name}${theme}-light/emotes
    ln -s ../${name}${theme}/emblems ${name}${theme}-light/emblems
    ln -s ../${name}${theme}/mimes ${name}${theme}-light/mimes
    ln -s ../${name}${theme}/places ${name}${theme}-light/places
    ln -s ../${name}${theme}/preferences ${name}${theme}-light/preferences
    ln -s ../../${name}${theme}/status/symbolic ${name}${theme}-light/status/symbolic
  fi

  if [[ ${color} == '-dark' ]]; then
    mkdir -p                                                                                 "${THEME_DIR}"/{apps,categories,emblems,devices,mimes,places,status}

    cp -r "${SRC_DIR}"/src/actions                                                           "${THEME_DIR}"
    cp -r "${SRC_DIR}"/src/apps/{22,32,symbolic}                                             "${THEME_DIR}"/apps
    cp -r "${SRC_DIR}"/src/categories/{22,symbolic}                                          "${THEME_DIR}"/categories
    cp -r "${SRC_DIR}"/src/emblems/symbolic                                                  "${THEME_DIR}"/emblems
    cp -r "${SRC_DIR}"/src/mimes/symbolic                                                    "${THEME_DIR}"/mimes
    cp -r "${SRC_DIR}"/src/devices/{16,22,24,32,symbolic}                                    "${THEME_DIR}"/devices
    cp -r "${SRC_DIR}"/src/places/{16,22,24,scalable,symbolic}                               "${THEME_DIR}"/places
    cp -r "${SRC_DIR}"/src/status/symbolic                                                   "${THEME_DIR}"/status

    if [[ ${bold:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/bold/actions/symbolic/*.svg                                         "${THEME_DIR}"/actions/symbolic
      cp -r "${SRC_DIR}"/bold/apps/symbolic/*.svg                                            "${THEME_DIR}"/apps/symbolic
      cp -r "${SRC_DIR}"/bold/devices/symbolic/*.svg                                         "${THEME_DIR}"/devices/symbolic
      cp -r "${SRC_DIR}"/bold/status/symbolic/*.svg                                          "${THEME_DIR}"/status/symbolic
    fi

    if [[ ${alternative:-} == 'true' ]]; then
      cp -r "${SRC_DIR}"/alternative/apps/symbolic/*.svg                                     "${THEME_DIR}"/apps/symbolic
      cp -r "${SRC_DIR}"/alternative/places/scalable/*.svg                                   "${THEME_DIR}"/places/scalable
    fi

    if [[ ${theme} != '' ]]; then
      cp -r "${SRC_DIR}"/colors/color${theme}/*.svg                                          "${THEME_DIR}"/places/scalable
    fi

    if [[ $DESKTOP_SESSION == '/usr/share/xsessions/budgie-desktop' ]]; then
      cp -r "${SRC_DIR}"/src/status/symbolic-budgie/*.svg                                    "${THEME_DIR}"/status/symbolic
    fi

    mv -f "${THEME_DIR}"/places/scalable/user-trash-dark.svg "${THEME_DIR}"/places/scalable/user-trash.svg
    mv -f "${THEME_DIR}"/places/scalable/user-trash-full-dark.svg "${THEME_DIR}"/places/scalable/user-trash-full.svg

    # Change icon color for dark theme
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,devices,places}/{16,22,24}/*.svg
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/apps/{22,32}/*.svg
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/categories/22/*.svg
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,devices}/32/*.svg
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,apps,categories,emblems,devices,mimes,places,status}/symbolic/*.svg

    cp -r "${SRC_DIR}"/links/actions/{16,22,24,32,symbolic}                                  "${THEME_DIR}"/actions
    cp -r "${SRC_DIR}"/links/devices/{16,22,24,32,symbolic}                                  "${THEME_DIR}"/devices
    cp -r "${SRC_DIR}"/links/places/{16,22,24,scalable,symbolic}                             "${THEME_DIR}"/places
    cp -r "${SRC_DIR}"/links/apps/symbolic                                                   "${THEME_DIR}"/apps
    cp -r "${SRC_DIR}"/links/categories/{22,symbolic}                                        "${THEME_DIR}"/categories
    cp -r "${SRC_DIR}"/links/mimes/symbolic                                                  "${THEME_DIR}"/mimes
    cp -r "${SRC_DIR}"/links/status/symbolic                                                 "${THEME_DIR}"/status

    cd ${dest}
    ln -s ../${name}${theme}/animations ${name}${theme}-dark/animations
    ln -s ../${name}${theme}/emotes ${name}${theme}-dark/emotes
    ln -s ../${name}${theme}/preferences ${name}${theme}-dark/preferences
    ln -s ../../${name}${theme}/categories/32 ${name}${theme}-dark/categories/32
    ln -s ../../${name}${theme}/emblems/16 ${name}${theme}-dark/emblems/16
    ln -s ../../${name}${theme}/emblems/22 ${name}${theme}-dark/emblems/22
    ln -s ../../${name}${theme}/emblems/24 ${name}${theme}-dark/emblems/24
    ln -s ../../${name}${theme}/mimes/16 ${name}${theme}-dark/mimes/16
    ln -s ../../${name}${theme}/mimes/22 ${name}${theme}-dark/mimes/22
    ln -s ../../${name}${theme}/mimes/scalable ${name}${theme}-dark/mimes/scalable
    ln -s ../../${name}${theme}/apps/scalable ${name}${theme}-dark/apps/scalable
    ln -s ../../${name}${theme}/devices/scalable ${name}${theme}-dark/devices/scalable
    ln -s ../../${name}${theme}/status/16 ${name}${theme}-dark/status/16
    ln -s ../../${name}${theme}/status/22 ${name}${theme}-dark/status/22
    ln -s ../../${name}${theme}/status/24 ${name}${theme}-dark/status/24
    ln -s ../../${name}${theme}/status/32 ${name}${theme}-dark/status/32
  fi

  (
    cd "${THEME_DIR}"
    ln -sf actions actions@2x
    ln -sf animations animations@2x
    ln -sf apps apps@2x
    ln -sf categories categories@2x
    ln -sf devices devices@2x
    ln -sf emotes emotes@2x
    ln -sf emblems emblems@2x
    ln -sf mimes mimes@2x
    ln -sf places places@2x
    ln -sf preferences preferences@2x
    ln -sf status status@2x
  )

  gtk-update-icon-cache "${THEME_DIR}"
}

uninstall() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}

  local THEME_DIR=${dest}/${name}${theme}${color}

  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"

  echo "Uninstalling '"${THEME_DIR}"'..."
}

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -d|--dest)
      dest="$2"
      mkdir -p "$dest"
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -a|--alternative)
      alternative='true'
      echo "Installing 'alternative' version..."
      shift
      ;;
    -b|--bold)
      bold='true'
      echo "Installing 'bold' version..."
      shift
      ;;
    -r|--remove|-u|--uninstall)
      remove='true'
      shift
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          default)
            themes+=("${THEME_VARIANTS[0]}")
            shift
            ;;
          purple)
            themes+=("${THEME_VARIANTS[1]}")
            shift
            ;;
          pink)
            themes+=("${THEME_VARIANTS[2]}")
            shift
            ;;
          red)
            themes+=("${THEME_VARIANTS[3]}")
            shift
            ;;
          orange)
            themes+=("${THEME_VARIANTS[4]}")
            shift
            ;;
          yellow)
            themes+=("${THEME_VARIANTS[5]}")
            shift
            ;;
          green)
            themes+=("${THEME_VARIANTS[6]}")
            shift
            ;;
          grey)
            themes+=("${THEME_VARIANTS[7]}")
            shift
            ;;
          nord)
            themes+=("${THEME_VARIANTS[8]}")
            shift
            ;;
          all)
            themes+=("${THEME_VARIANTS[@]}")
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized theme variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
        # echo "Installing '${theme}' folder version..."
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#themes[@]}" -eq 0 ]]; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]]; then
  colors=("${COLOR_VARIANTS[@]}")
fi

install_theme() {
  for theme in "${themes[@]}"; do
    for color in "${colors[@]}"; do
      install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

uninstall_theme() {
  for theme in "${THEME_VARIANTS[@]}"; do
    for color in "${COLOR_VARIANTS[@]}"; do
      uninstall "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

if [[ "${remove}" == 'true' ]]; then
  uninstall_theme
else
  install_theme
fi

#exit 0
