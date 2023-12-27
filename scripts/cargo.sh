#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of scripts to install necessary cargo crates.




function cargo_crates_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing cargo crates..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/cargo/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/cargo/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/cargo/${PREFIX}games.list"

    for CRATE in $(cat ${COMMON_LIST}); do
        cargo install "${CRATE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for CRATE in $(cat ${GUI_LIST}); do
            cargo install "${CRATE}"
        done
    fi

    if [ ${NO_GAMES} = 0 ]; then
        for CRATE in $(cat ${GAMES_LIST}); do
            cargo install "${CRATE}"
        done
    fi
}
