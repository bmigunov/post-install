#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of MPD-related scripts.




function mpd_setup()
{
    MPD_CACHE_DIR="${XDG_CACHE_HOME}/mpd"

    MPD_PLAYLIST_DIRECTORY="${MPD_CACHE_DIR}/playlists"

    MPD_DB_FILE_PATH="${MPD_CACHE_DIR}/tag_cache"
    MPD_LOG_FILE_PATH="${MPD_CACHE_DIR}/mpd.log"
    MPD_STICKER_FILE_PATH="${MPD_CACHE_DIR}/sticker.sql"

    MPD_STATE_FILE_PATH="${XDG_STATE_HOME}/mpd-state"

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Creating mpd files & directories..."

    mkdir -p -v "${MPD_CACHE_DIR}"
    mkdir -p -v "${MPD_PLAYLIST_DIRECTORY}"

    touch "${MPD_DB_FILE_PATH}"
    touch "${MPD_LOG_FILE_PATH}"
    touch "${MPD_STICKER_FILE_PATH}"
    touch "${MPD_STATE_FILE_PATH}"
}
