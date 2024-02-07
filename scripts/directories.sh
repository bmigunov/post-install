#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description
#   Directories management functions.




if [ ! ${XDG_CONFIG_HOME} ]; then
    export XDG_CONFIG_HOME="${HOME}/.config"
fi

if [ ! ${XDG_DATA_HOME} ]; then
    export XDG_DATA_HOME="${HOME}/.local/share"
fi

if [ ! ${XDG_STATE_HOME} ]; then
    export XDG_STATE_HOME="${HOME}/.local/state"
fi

if [ ! ${XDG_CACHE_HOME} ]; then
    export XDG_CACHE_HOME="${HOME}/.cache"
fi

AUDIO_DIR="${HOME}/Audio"
MUSIC_DIR="${AUDIO_DIR}/Music"

BOOKS_DIR="${HOME}/Books"

DOCUMENTS_DIR="${HOME}/Documents"
DOCUMENTS_JOB_DIR="${DOCUMENTS_DIR}/job"

DOWNLOADS_DIR="${HOME}/Downloads"
TELEGRAM_DOWNLOADS_DIR="${DOWNLOADS_DIR}/Telegram"
TORRENT_DOWNLOADS_DIR="${DOWNLOADS_DIR}/Torrent"

GAMES_DIR="${HOME}/Games"

export NES_GAMES_DIR="${GAMES_DIR}/NES"
export SEGA_MEGA_DRIVE_GAMES_DIR="${GAMES_DIR}/SEGA_Mega_Drive"
export SNES_GAMES_DIR="${GAMES_DIR}/SNES"
export N64_GAMES_DIR="${GAMES_DIR}/N64"
export ZXS_GAMES_DIR="${GAMES_DIR}/ZXS"
export DOS_GAMES_DIR="${GAMES_DIR}/DOS"
export WINDOWS_GAMES_DIR="${GAMES_DIR}/WIN"

PS_GAMES_DIR="${GAMES_DIR}/PS"
PS2_GAMES_DIR="${GAMES_DIR}/PS2"

PICTURES_DIR="${HOME}/Pictures"
ARTWORK_DIR="${PICTURES_DIR}/artwork"
GIF_DIR="${PICTURES_DIR}/gif"
PHOTO_DIR="${PICTURES_DIR}/photo"
SAVED_PICTURES_DIR="${PICTURES_DIR}/saved"
SCREENSHOTS_DIR="${PICTURES_DIR}/screenshots"
WALLPAPERS_DIR="${PICTURES_DIR}/wallpapers"

TORRENTS_DIR="${HOME}/Torrents"
FINISHED_TORRENTS_DIR="${TORRENTS_DIR}/finished"

VIDEO_DIR="${HOME}/Video"
PERSONAL_VIDEO_DIR="${VIDEO_DIR}/personal"
SAVED_VIDEO_DIR="${VIDEO_DIR}/saved"
MOVIES_DIR="${VIDEO_DIR}/movies"
SERIES_DIR="${VIDEO_DIR}/series"

WORKSPACE_DIR="${HOME}/workspace"
WORKSPACE_JOB_DIR="${WORKSPACE_DIR}/job"
GHIDRA_DIR="${WORKSPACE_DIR}/ghidra"
ANDROID_STUDIO_SDK_DIR="${WORKSPACE_DIR}/android_studio/sdk"
ANDROID_STUDIO_PROJECTS_DIR="${WORKSPACE_DIR}/android_studio/projects"
OBSIDIAN_DIR="${WORKSPACE_DIR}/obsidian"

export SRC_DIR="${WORKSPACE_DIR}/src"

VAR_DIR="${WORKSPACE_DIR}/var"
SAVED_LOGS_DIR="${VAR_DIR}/log"

export IMG_DIR="${VAR_DIR}/img"

BACKUP_DIR="${VAR_DIR}/backup"
NEOVIM_BACKUP_DIR="${BACKUP_DIR}/nvim"

export POST_INSTALL_BACKUP_DIR="${BACKUP_DIR}/post-install"


LESSHST_DIR="${XDG_STATE_HOME}/less"


function directories_create()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Creating home directories..."

    if [ -d /workspace ]; then
        echo "/workpace partition exists"
        sudo chown -R ${CURRENT_USER}:${CURRENT_USER} /mnt/workspace
        ln -s /workspace "${WORKSPACE_DIR}"
    fi

    mkdir -p -v "${AUDIO_DIR}" "${MUSIC_DIR}" "${BOOKS_DIR}"                   \
                "${DOCUMENTS_DIR}" "${DOCUMENTS_JOB_DIR}" "${DOWNLOADS_DIR}"   \
                "${TELEGRAM_DOWNLOADS_DIR}" "${TORRENT_DOWNLOADS_DIR}"         \
                "${GAMES_DIR}" "${NES_GAMES_DIR}"                              \
                "${SEGA_MEGA_DRIVE_GAMES_DIR}" "${SNES_GAMES_DIR}"             \
                "${N64_GAMES_DIR}" "${PS_GAMES_DIR}" "${PS2_GAMES_DIR}"        \
                "${ZXS_GAMES_DIR}" "${DOS_GAMES_DIR}" "${WINDOWS_GAMES_DIR}"   \
                "${PICTURES_DIR}" "${ARTWORK_DIR}" "${GIF_DIR}" "${PHOTO_DIR}" \
                "${SAVED_PICTURES_DIR}" "${SCREENSHOTS_DIR}"                   \
                "${WALLPAPERS_DIR}" "${TORRENTS_DIR}"                          \
                "${FINISHED_TORRENTS_DIR}" "${VIDEO_DIR}"                      \
                "${PERSONAL_VIDEO_DIR}" "${MOVIES_DIR}" "${SERIES_DIR}"        \
                "${WORKSPACE_DIR}" "${WORKSPACE_JOB_DIR}" "${GHIDRA_DIR}"      \
                "${ANDROID_STUDIO_SDK_DIR}" "${ANDROID_STUDIO_PROJECTS_DIR}"   \
                "${OBSIDIAN_DIR}" "${SRC_DIR}" "${VAR_DIR}"                    \
                "${SAVED_LOGS_DIR}" "${IMG_DIR}" "${BACKUP_DIR}"               \
                "${NEOVIM_BACKUP_DIR}" "${POST_INSTALL_BACKUP_DIR}"            \
                "${LESSHST_DIR}" "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}"       \
                "${XDG_STATE_HOME}" "${XDG_CACHE_HOME}" "${SAVED_VIDEO_DIR}"
}
