#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description
#   Directories management functions.




function directories_create()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Creating LXD directories..."

    mkdir -p -v "${LXD_STORAGE_DIR}/Audio" "${LXD_STORAGE_DIR}/Documents" \
                "${LXD_STORAGE_DIR}/Downloads" "${LXD_STORAGE_DIR}/Torrents" \
                "${LXD_STORAGE_DIR}/Games" "${LXD_STORAGE_DIR}/Video" \
                "${LXD_STORAGE_DIR}/Workspace" "${LXD_STORAGE_DIR}/Pictures"

    ln -s "${LXD_STORAGE_DIR}/Audio" "${LXD_AUDIO_DIR}"
    ln -s "${LXD_STORAGE_DIR}/Documents" "${LXD_DOCS_DIR}"
    ln -s "${LXD_STORAGE_DIR}/Downloads" "${LXD_DL_DIR}"
    ln -s "${LXD_STORAGE_DIR}/Torrents" "${LXD_TORRENTS_DIR}"
    ln -s "${LXD_STORAGE_DIR}/Games" "${LXD_GAMES_DIR}"
    ln -s "${LXD_STORAGE_DIR}/Video" "${LXD_VIDEO_DIR}"
    ln -s "${LXD_STORAGE_DIR}/Workspace" "${LXD_WORKSPACE_DIR}"
    ln -s "${LXD_STORAGE_DIR}/Pictures" "${LXD_PICTURES_DIR}"
    ln -s "/opt/${CURRENT_USER}" "${HOME}/.local/opt"

    mkdir -p -v "${LXD_MUSIC_DIR}" "${LXD_AUDIO_REC_DIR}" \
                "${LXD_PODCASTS_DIR}" "${LXD_VOICE_MSG_DIR}" \
                "${LXD_SOUNDS_DIR}" "${LXD_JOB_DOCS_DIR}" \
                "${LXD_OBSIDIAN_VAULTS_DIR}" "${LXD_BOOKS_DIR}" \
                "${LXD_TELEGRAM_DL_DIR}" "${LXD_TORRENT_DL_DIR}" \
                "${LXD_MOVIES_TORRENTS_DIR}" "${LXD_SERIES_TORRENTS_DIR}" \
                "${LXD_MUSIC_TORRENTS_DIR}" "${LXD_BOOKS_TORRENTS_DIR}" \
                "${LXD_GAMES_TORRENTS_DIR}" "${LXD_NES_GAMES_DIR}" \
                "${LXD_SEGA_GAMES_DIR}" "${LXD_SNES_GAMES_DIR}" \
                "${LXD_N64_GAMES_DIR}" "${LXD_PS_GAMES_DIR}" \
                "${LXD_PS2_GAMES_DIR}" "${LXD_XBOX_GAMES_DIR}" \
                "${LXD_PS3_GAMES_DIR}" "${LXD_XBOX360_GAMES_DIR}" \
                "${LXD_ZX_SPECTRUM_GAMES_DIR}" "${LXD_DOS_GAMES_DIR}" \
                "${LXD_WIN_GAMES_DIR}" "${LXD_SAVED_VIDEOS_DIR}" \
                "${LXD_PERSONAL_VIDEOS_DIR}" "${LXD_MOVIES_DIR}" \
                "${LXD_SERIES_DIR}" "${LXD_SHOTCUT_DIR}" \
                "${LXD_JOB_WORKSPACE_DIR}" "${LXD_GHIDRA_DIR}" \
                "${LXD_ANDROID_STUDIO_SDK_DIR}" \
                "${LXD_ANDROID_STUDIO_PROJECTS_DIR}" "${LXD_SRC_DIR}" \
                "${LXD_VAR_DIR}" "${LXD_LOG_DIR}" "${LXD_IMG_DIR}" \
                "${LXD_BACKUP_DIR}" "${LXD_ARTWORK_DIR}" "${LXD_GIF_DIR}" \
                "${LXD_PHOTOS_DIR}" "${LXD_SAVED_PICTURES_DIR}" \
                "${LXD_SCREENSHOTS_DIR}" "${LXD_WALLPAPERS_DIR}" \
                "${LXD_PIC_ASSETS_DIR}" "${LXD_STEAMLIB_STORAGE_DIR}"

    mkdir -p -v "${XDG_DATA_HOME}/gnupg" "${XDG_DATA_HOME}/gradle" \
                "${XDG_DATA_HOME}/go" "${XDG_DATA_HOME}/android" \
                "${XDG_DATA_HOME}/electrum" "${XDG_DATA_HOME}/sdkman" \
                "${XDG_DATA_HOME}/less" "${XDG_CONFIG_HOME}/gtk-2.0" \
                "${XDG_CONFIG_HOME}/npm" "${XDG_CONFIG_HOME}/subversion" \
                "${XDG_CONFIG_HOME}/irssi" "${XDG_CONFIG_HOME}/dosbox" \
                "${XDG_CACHE_HOME}/ncmpcpp/lyrics" "${XDG_CONFIG_HOME}/mutt" \
                "${XDG_CACHE_HOME}/mpd/playlists" "${HOME}/.local/bin"
}
