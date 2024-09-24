#!/bin/bash




function flatpak_remotes_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding flatpak remotes..."
    if [ -n "${1}" ]; then
        PREFIX="${1}-"
    fi

    REMOTES_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}/remotes.list"

    for REMOTE in $(cat ${REMOTES_LIST}); do
        flatpak remote-add --if-not-exists "${REMOTE}"
    done
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

    for PACKAGE in $(cat ${COMMON_LIST}); do
        flatpak install "${PACKAGE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for PACKAGE in $(cat ${GUI_LIST}); do
            flatpak install "${PACKAGE}"
        done
    fi
}
