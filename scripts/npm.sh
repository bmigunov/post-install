#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of npm-related scripts.




function npm_packages_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing npm packages..."

    if [ -n "${1}" ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/npm/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/npm/${PREFIX}gui.list"

    for PACKAGE in $(cat ${COMMON_LIST}); do
        sudo npm install --global "${PACKAGE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for PACKAGE in $(cat ${GUI_LIST}); do
            sudo npm install --global "${PACKAGE}"
        done
    fi
}
