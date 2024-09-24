#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of snap-related scripts.




function snap_packages_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing snap packages..."

    if [ -n "${1}" ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/snap/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/snap/${PREFIX}gui.list"

    for PACKAGE in $(cat ${COMMON_LIST}); do
        sudo snap install "${PACKAGE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for PACKAGE in $(cat ${GUI_LIST}); do
            sudo snap install "${PACKAGE}"
        done
    fi
}
