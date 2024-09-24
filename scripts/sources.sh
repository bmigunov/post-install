#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of scripts to install binaries from source.




source $(dirname "$0")"/git.sh"

function sources_get()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Getting sources..."

    if [ -n "${1}" ]; then
        PREFIX="${1}"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/git/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/git/${PREFIX}gui.list"

    while read -a REPO; do
        if ! git_repo_clone "${REPO[0]}" ; then
            git_repo_clone "${REPO[1]}"
        fi
    done <"${COMMON_LIST}"

    if [ $NO_GUI = 0 ]; then
        while read -a REPO; do
            if ! git_repo_clone "${REPO[0]}" ; then
                git_repo_clone "${REPO[1]}"
            fi
        done <"${GUI_LIST}"
    fi
}
