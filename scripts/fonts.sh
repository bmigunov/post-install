#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of bash functions to install & setup fonts.




TRUETYPE_FONTS_DIR_PATH=/usr/share/fonts/truetype

NERD_FONTS_REMOTE=\
"https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/"

declare -a NERD_FONT_ARCHIVES=("3270.zip" "AnonymousPro.zip" "Hack.zip" \
                               "RobotoMono.zip" "SourceCodePro.zip"     \
                               "Terminus.zip")
declare -a NERD_FONT_DIRNAMES=(3270-nerd-font anonymous-pro-nerd-font \
                               hack-nerd-font roboto-mono-nerd-font   \
                               source-code-pro-nerd-font terminus-nerd-font)


function nerd_fonts_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing Nerd fonts..."

    for (( I=0; I<${#NERD_FONT_ARCHIVES[@]}; I++ )); do
        sudo mkdir -p -v "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}"

        sudo wget -q -P "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}" \
                        "${NERD_FONTS_REMOTE}${NERD_FONT_ARCHIVES[${I}]}"

        sudo 7z x -tzip -o"${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}"                        \
                  "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}/${NERD_FONT_ARCHIVES[${I}]}" && \
        sudo rm -f "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}/${NERD_FONT_ARCHIVES[${I}]}"
    done

    fc-cache -fv
}

function fonts_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    nerd_fonts_install
}
