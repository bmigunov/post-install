#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of flatpak-related scripts.




function flatpak_remotes_add()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding flatpak repos..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi
    REPOS_LIST=$(dirname "$0")'/../data/flatpak/'${PREFIX}'repos.list'

    while read -r; do
        sudo flatpak remote-add --if-not-exists $REPLY
    done <${REPOS_LIST}
}

function flatpak_packages_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing flatpak packages..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}games.list"

    while read -r; do
        flatpak install ${REPLY}
    done <${COMMON_LIST}

    if [ ${NO_GUI} = 0 ]; then
        while read -r; do
            flatpak install ${REPLY}
        done <${GUI_LIST}
    fi

    if [ ${NO_GAMES} = 0 ]; then
        while read -r; do
            flatpak install ${REPLY}
        done <${GAMES_LIST}
    fi
}
