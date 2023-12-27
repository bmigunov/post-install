#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of pipx-related scripts.




function pipx_packages_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing pipx packages..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/pipx/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/pipx/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/pipx/${PREFIX}games.list"

    for PACKAGE in $(cat ${COMMON_LIST}); do
        pipx install "${PACKAGE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for PACKAGE in $(cat ${GUI_LIST}); do
            pipx install "${PACKAGE}"
        done
    fi

    if [ ${NO_GAMES} = 0 ]; then
        for PACKAGE in $(cat ${GAMES_LIST}); do
            pipx install "${PACKAGE}"
        done
    fi
}
