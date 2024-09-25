#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of bash functions to install & setup fonts.




TRUETYPE_FONTS_DIR_PATH="/usr/share/fonts/truetype"


function nerd_fonts_install()
{
    NERD_FONTS_REMOTE="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/"

    declare -a NERD_FONT_ARCHIVES=("3270.zip" "AnonymousPro.zip" "Hack.zip" \
                                   "RobotoMono.zip" "SourceCodePro.zip" \
                                   "Terminus.zip" "Gohu.zip" "JetBrainsMono.zip" \
                                   "Monoid.zip" "ShareTechMono.zip")

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing Nerd fonts..."

    for ARCHIVE in "${NERD_FONT_ARCHIVES[@]}"; do
        NERD_FONT_DIRNAME="${ARCHIVE%.*}"

        sudo mkdir -p -v "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAME}"

        sudo wget --content-disposition -P "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAME}" \
                        "${NERD_FONTS_REMOTE}${ARCHIVE}"

        sudo 7z x -tzip -o"${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAME}" \
                  "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAME}/${ARCHIVE}" && \
        sudo rm -f "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAME}/${ARCHIVE}"
    done
}

function segoe_ui_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    sudo mkdir -p "${TRUETYPE_FONTS_DIR_PATH}/segoe-ui"
    sudo cp "${LXD_SRC_DIR}"/mrbvrz/segoe-ui-linux/font/*.ttf $TRUETYPE_FONTS_DIR_PATH/segoe-ui
}

function fonts_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    nerd_fonts_install
#     segoe_ui_install

#     fc-cache -fv
}
