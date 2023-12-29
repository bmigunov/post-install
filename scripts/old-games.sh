#!/bin/bash
#
# Author:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of bash functions to download games from "Old-games.ru".




function old_games_fetch()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Fetching from 'Old-games.ru'..."

    for URI in $(cat $(dirname "${0}")"/../data/old-games/dos.list"); do
        wget --content-disposition -P "${DOS_GAMES_DIR}" "${URI}"
    done

    for URI in $(cat $(dirname "${0}")"/../data/old-games/windows.list"); do
        wget --content-disposition -P "${WINDOWS_GAMES_DIR}" "${URI}"
    done
}
