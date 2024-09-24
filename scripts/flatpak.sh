#!/bin/bash




function flatpak_remotes_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding flatpak remotes..."
    if [ -n "${1}" ]; then
        PREFIX="${1}-"
    fi

    REMOTES_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}/remotes.list"

    while read -a REMOTE; do
        flatpak remote-add --if-not-exists "${REMOTE[0]}" "${REMOTE[1]}"
    done <"${REMOTES_LIST}"
}


function flatpak_packages_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing flatpak packages..."

    if [ -n "${1}" ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}gui.list"

    while read -a PACKAGE; do
        flatpak install "${PACKAGE[0]}" "${PACKAGE[1]}"
    done <"${COMMON_LIST}"

    if [ ${NO_GUI} = 0 ]; then
        while read -a PACKAGE; do
            flatpak install "${PACKAGE[0]}" "${PACKAGE[1]}"
        done <"${GUI_LIST}"
    fi
}
