#!/bin/bash
#
# Author:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of bash functions to download games & other stuff from "Emu-Land.net".




PS_BIOS_REMOTE="http://www.emu-land.net/consoles/psx/bios?act=getfile&id=4986"
PS2_BIOS_REMOTE="http://www.emu-land.net/consoles/ps2/bios?act=getfile&id=5017"

PS_BIOS_IMAGES_DIR="${PERSONAL_IMAGES_DIR}/PS/BIOS"
PS2_BIOS_IMAGES_DIR="${PERSONAL_IMAGES_DIR}/PS2/BIOS"


function ps_and_ps2_bios_download()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Downloading PSOne and PS2 BIOS images..."

    wget -q --content-disposition -P "${PS_BIOS_IMAGES_DIR}" "${PS_BIOS_REMOTE}"
    wget -q --content-disposition -P "${PS2_BIOS_IMAGES_DIR}" \
         "${PS2_BIOS_REMOTE}"
}

function emu_land_fetch()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Fetching from 'Emu-Land.net'..."

    ps_and_ps2_bios_download

    for URI in $(cat $(dirname "${0}")"/../data/emu-land/nes.list"); do
        wget -q --content-disposition -P "${NES_GAMES_DIR}" "${URI}"
    done

    for URI in $(cat $(dirname "${0}")"/../data/emu-land/sega_mega_drive.list"); do

        wget -q --content-disposition -P "${SEGA_MEGA_DRIVE_GAMES_DIR}" "${URI}"
    done

    for URI in $(cat $(dirname "${0}")"/../data/emu-land/snes.list"); do
        wget -q --content-disposition -P "${SNES_GAMES_DIR}" "${URI}"
    done

    for URI in $(cat $(dirname "${0}")"/../data/emu-land/n64.list"); do
        wget -q --content-disposition -P "${N64_GAMES_DIR}" "${URI}"
    done

    for URI in $(cat $(dirname "${0}")"/../data/emu-land/zx_spectrum.list"); do
        wget -q --content-disposition -P "${ZXS_GAMES_DIR}" "${URI}"
    done
}
