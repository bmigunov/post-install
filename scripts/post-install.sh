#!/bin/bash
#
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   A post-installation bash script for Linux




REQUIRED_OS_NAME=Linux
REQUIRED_DISTRO_NAME=Debian

NO_GUI=0
NO_GAMES=0
KDE=0
SSH_KEY_PASS=""
GITHUB_KEY_RW_TOKEN=
MUTT_ACCOUNTS_GPG_REMOTE=

LONGOPT_HELP="--help"
SHORTOPT_HELP="-h"
LONGOPT_NO_GAMES="--no_games"
LONGOPT_NO_GUI="--no_gui"
LONGOPT_KDE="--install_kde"
LONGOPT_KEY_RW_TOKEN="--key_rw_token"
LONGOPT_SSH_KEY_PASS="--ssh_key_pass"
LONGOPT_MUTT_ACCOUNTS_REMOTE="--mutt_accounts_remote"

USAGE="post-install.sh\nA script to set up a freshly installed system.\n\t\
$LONGOPT_HELP, $SHORTOPT_HELP: Print help message.\n\t$LONGOPT_NO_GAMES: Do \
not install games.\n\t$LONGOPT_NO_GUI: Do not install GUI applications and X \
server.\n\t$LONGOPT_KDE: Install 'kde-standard'.\n\t$LONGOPT_KEY_RW_TOKEN: \
GitHub personal access token to read and write public keys.\n\t\
$LONGOPT_SSH_KEY_PASS: New SSH key passphrase (empty by default).\n\t\
$LONGOPT_MUTT_ACCOUNTS_REMOTE: Link to the mutt 'accounts.gpg' file to download\
\n"

AUDIO_DIR=~/Audio
BOOKS_DIR=~/Books
DOCUMENTS_DIR=~/Documents
DOWNLOADS_DIR=~/Downloads
GAMES_DIR=~/Games
PICTURES_DIR=~/Pictures
TORRENTS_DIR=~/Torrents
VIDEO_DIR=~/Video
WORKSPACE_DIR=~/workspace
MUSIC_DIR="${AUDIO_DIR}"/Music
JOB_DOCUMENTS_DIR="${DOCUMENTS_DIR}"/job
PERSONAL_DOCUMENTS_DIR="${DOCUMENTS_DIR}"/personal
TELEGRAM_DOWNLOADS_DIR="${DOWNLOADS_DIR}"/Telegram
TORRENT_DOWNLOADS_DIR="${DOWNLOADS_DIR}"/Torrent
ARTWORK_DIR="${PICTURES_DIR}"/Artwork
ICONS_DIR="${PICTURES_DIR}"/Icons
GIF_DIR="${PICTURES_DIR}"/gif
PHOTO_DIR="${PICTURES_DIR}"/Photo
SAVED_PICTURES_DIR="${PICTURES_DIR}"/Saved
SCREENSHOTS_DIR="${PICTURES_DIR}"/Screenshots
WALLPAPERS_DIR="${PICTURES_DIR}"/Wallpapers
FINISHED_TORRENTS_DIR="${TORRENTS_DIR}"/finished
PERSONAL_VIDEO_DIR="${VIDEO_DIR}"/personal
SAVED_VIDEO_DIR="${VIDEO_DIR}"/saved
MOVIES_DIR="${VIDEO_DIR}"/Movies
SERIES_DIR="${VIDEO_DIR}"/Series
PERSONAL_SRC_DIR="${WORKSPACE_DIR}"/personal/src
PERSONAL_VAR_DIR="${WORKSPACE_DIR}"/personal/var
PERSONAL_BACKUP_DIR="${PERSONAL_VAR_DIR}"/backup
PERSONAL_IMAGES_DIR="${PERSONAL_VAR_DIR}"/images
PERSONAL_LOG_DIR="${PERSONAL_VAR_DIR}"/log
NES_GAMES_DIR="${GAMES_DIR}"/NES
SEGA_GAMES_DIR="${GAMES_DIR}"/SEGA
SNES_GAMES_DIR="${GAMES_DIR}"/SNES
N64_GAMES_DIR="${GAMES_DIR}"/N64
PS_GAMES_DIR="${GAMES_DIR}"/PS
PS2_GAMES_DIR="${GAMES_DIR}"/PS2
ZXS_GAMES_DIR="${GAMES_DIR}"/ZXS
DOS_GAMES_DIR="${GAMES_DIR}"/DOS
PS_BIOS_IMAGES_DIR="${PERSONAL_IMAGES_DIR}"/PS/BIOS
PS2_BIOS_IMAGES_DIR="${PERSONAL_IMAGES_DIR}"/PS2/BIOS
BLADERF_X40_IMAGES_DIR="${PERSONAL_IMAGES_DIR}"/bladerf/x40

POST_INSTALL_BACKUP_DIR="${PERSONAL_BACKUP_DIR}"/post-install

RUTRACKER_HOSTS="\n\n# RuTracker\n185.15.211.203 bt.t-ru.org\n185.15.211.203 \
bt2.t-ru.org\n185.15.211.203 bt3.t-ru.org\n185.15.211.203 bt4.t-ru.org"

EN_US_UTF8_LOCALE="en_US.UTF-8 UTF-8"
SUPPORTED_LOCALES_PATH=/usr/share/i18n/SUPPORTED

APT_KEYS_LIST_PATH=$(dirname "$0")"/../data/apt/keys.list"
APT_REPOS_LIST_PATH=$(dirname "$0")'/../data/apt/repos.list'

REPO_COMPONENTS_WILDCARD="/^deb http.*main$\|^deb-src http.*main$/ s/$/ \
contrib non-free/"

declare -a ARCHIVE_KEYRING_REMOTES=("https://geti2p.net/_static/i2p-archive-keyring.gpg" \
                                    "https://cli.github.com/packages/githubcli-archive-keyring.gpg")
ARCHIVE_KEYRINGS_DIR=/usr/share/keyrings
I2P_ARCHIVE_KEYRING_KEY_FINGERPRINT=\
"7840 E761 0F28 B904 7535  49D7 67EC E560 5BCF 1346"

BLADERF_FX3_IMAGE_LATEST_REMOTE=\
"https://www.nuand.com/fx3/bladeRF_fw_latest.img"
BLADERF_X40_FPGA_BITSTREAM_LATEST_REMOTE=\
"https://www.nuand.com/fpga/hostedx40-latest.rbf"
BLADERF_FX3_2_3_2_IMAGE_REMOTE="https://www.nuand.com/fx3/bladeRF_fw_v2.3.2.img"
BLADERF_X40_FPGA_BITSTREAM_0_11_1_REMOTE=\
"https://www.nuand.com/fpga/v0.11.1/hostedx40.rbf"
BLADERF_FX3_IMAGE_LATEST_PATH=\
"${BLADERF_X40_IMAGES_DIR}/bladeRF_fw_latest.img"
BLADERF_X40_FPGA_BITSTREAM_LATEST_PATH=\
"${BLADERF_X40_IMAGES_DIR}/hostedx40-latest.rbf"
BLADERF_FX3_2_3_2_IMAGE_PATH="${BLADERF_X40_IMAGES_DIR}/bladeRF_fw-2.3.2.img"
BLADERF_X40_FPGA_BITSTREAM_0_11_1_PATH=\
"${BLADERF_X40_IMAGES_DIR}/hostedx40-0.11.1.rbf"

PS_BIOS_REMOTE="http://www.emu-land.net/consoles/psx/bios?act=getfile&id=4986"
PS2_BIOS_REMOTE="http://www.emu-land.net/consoles/ps2/bios?act=getfile&id=5017"

BRUTAL_DOOM_REMOTE=\
"https://www.moddb.com/downloads/mirror/95667/123/cf2617048e3641a1d9ee675fd134b7f5"

YOUTUBE_DL_PATH=/usr/local/bin/youtube-dl
YOUTUBE_DL_REMOTE="https://yt-dl.org/downloads/latest/youtube-dl"

YATE_SVN_REPO="http://voip.null.ro/svn/yate/trunk"
YATEBTS_SVN_REPO="http://voip.null.ro/svn/yatebts/trunk"

TRUETYPE_FONTS_DIR_PATH=/usr/share/fonts/truetype

declare -a NERD_FONT_ARCHIVES=("3270.zip" "AnonymousPro.zip" "Hack.zip" \
                               "RobotoMono.zip" "SourceCodePro.zip"     \
                               "Terminus.zip")
declare -a NERD_FONT_DIRNAMES=(3270-nerd-font anonymous-pro-nerd-font \
                               hack-nerd-font roboto-mono-nerd-font   \
                               source-code-pro-nerd-font terminus-nerd-font)
NERD_FONTS_REMOTE=\
"https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/"

I3_BLOCKS_BLOCKLETS_DIR="/usr/share/i3blocks"
declare -a I3BLOCK_BLOCKLETS=("backlight/backlight" "bandwidth3/bandwidth3" \
                              "battery2/battery2" "cpu_usage/cpu_usage"     \
                              "disk-io/disk-io" "disk/disk" "docker/docker" \
                              "gpu-load/gpu-load" "iface/iface"             \
                              "memory/memory" "miccontrol/miccontrol"       \
                              "monitor_manager/monitor_manager"             \
                              "rofi-wttr/rofi-wttr" "taskw/taskw"           \
                              "temperature/temperature"                     \
                              "volume-pulseaudio/volume-pulseaudio"         \
                              "wlan-dbm/wlan-dbm")

REMOTE_DEB_TMPDIR=/tmp/remote_deb

VIM_DIR=~/.vim
VIM_BUNDLE_DIR="${VIM_DIR}"/bundle
VIM_PLUGIN_DIR="${VIM_DIR}"/plugin
VIM_COLORS_DIR="${VIM_DIR}"/colors
VIM_DOC_DIR="${VIM_DIR}"/doc
VIM_AUTOLOAD_DIR="${VIM_DIR}"/autoload

YCM_REPO_URI="git@github.com:ycm-core/YouCompleteMe.git"
VIM_PATHOGEN_REPO_URI="git@github.com:tpope/vim-pathogen.git"
VIM_TAGLIST_REPO_URI="git@github.com:vim-scripts/taglist.vim.git"
VIM_DRACULA_REPO_URI="git@github.com:dracula/vim.git"

LUXDESK_CONFIGS_DELL_G3_REPO_URI=\
"git@github.com:bmigunov/luxdesk-configs-dell-g3"
LUXDESK_CONFIGS_RYZEN7_DESKTOP_REPO_URI=\
"git@github.com:bmigunov/luxdesk-configs-ryzen7-desktop"

MIME_TYPE_TAR_GZ="application/gzip"
MIME_TYPE_TAR_XZ="application/x-xz"
MIME_TYPE_TAR_BZ2="application/x-bzip2"
MIME_TYPE_ZIP="application/zip"

function options_check()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    while [ true ]; do
        if [ ${1} = ${LONGOPT_HELP} -o ${1} = ${SHORTOPT_HELP} ]; then
            printf "${USAGE}"
            exit 0
        elif [ ${1} = ${LONGOPT_NO_GAMES} ]; then
            NO_GAMES=1
            shift 1
        elif [ ${1} = ${LONGOPT_NO_GUI} ]; then
            NO_GUI=1
            shift 1
        elif [ ${1} = ${LONGOPT_KDE} ]; then
            KDE=1
            shift 1
        elif [ ${1} = ${LONGOPT_KEY_RW_TOKEN} ]; then
            GITHUB_KEY_RW_TOKEN="${2}"
            shift 2
        elif [ ${1} = ${LONGOPT_SSH_KEY_PASS} ]; then
            SSH_KEY_PASS="${2}"
            shift 2
        elif [ ${1} = ${LONGOPT_MUTT_ACCOUNTS_REMOTE} ]; then
            MUTT_ACCOUNTS_GPG_REMOTE="${2}"
            shift 2
        else
            break;
        fi
    done

    ARG=( "${@}" )
}

function os_check()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Checking which OS you are using..."

    if [[ $(uname) != "${REQUIRED_OS_NAME}" ]]; then
        echo "You don't appear to be using '${REQUIRED_OS_NAME}'! Aborting."
        echo "${FUNCNAME}() failure: current OS is not supported by this script" | \
        systemd-cat -p err -t $0
        exit 1
    else
        echo "You are using '${REQUIRED_OS_NAME}'."
    fi

    if [[ $(which lsb_release &>/dev/null; echo $?) != 0 ]]; then
        echo "Can't check which distribution you are using! Aborting."
        echo "os_check() failure: failed to check distribution" | \
        systemd-cat -p err -t $0
        exit 1
    else
        if lsb_release -ds | grep -q "${REQUIRED_DISTRO_NAME}"; then
            echo 'Current distribution is: '$(lsb_release -ds)
            echo "You are using '${REQUIRED_DISTRO_NAME}'."
        else
            echo "${FUNCNAME}() warning: presumably invalid OS distribution" | \
            systemd-cat -p warning -t $0
            echo "You are using a distribution that may not be compatible with this script set."

            read -t 10 -p "Are you sure you want to continue? [y/n]: "
            REPLY=${REPLY:-n}
            case ${REPLY} in
            [Yy] )
                echo "You have been warned."
                ;;
            [Nn] )
                echo "Exiting..."
                exit 0
                ;;
            * )
                echo "os_check() warning: wrong option" | \
                systemd-cat -p warning -t $0
                echo "Sorry, try again." && os_check
                ;;
            esac
        fi
    fi
}

function privileges_check()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Checking privileges."

    if [[ ${EUID} != 0 ]]; then
        if [[ $(groups ${USER} | grep -q 'sudo'; echo $?) != 0 ]]; then
            echo "privileges_check() failure: no admin privileges" | \
            systemd-cat -p err -t $0
            echo "This user account doesn't have admin privileges."
            exit 13
        else
            echo "Current user has sudo privileges."
        fi
    else
        echo "privileges_check() warning: logged in as root" | \
        systemd-cat -p warning -t $0
        echo "You are logged in as the root user. This is not recommended."

        read -t 4 -p "Are you sure you want to proceed? [y/n]: "
        REPLY=${REPLY:-n}
        case ${REPLY} in
        [Yy] )
            echo "Proceeding..."
            ;;
        [Nn] )
            echo "Exiting..."
            exit 1
            ;;
        * )
            echo "${FUNCNAME}() warning: wrong option" | \
            systemd-cat -p warning -t $0
            echo "Sorry, try again" && privileges_check
            ;;
        esac
    fi
}

function is_package_installed()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    sudo dpkg-query -W --showformat='${Status}\n' $@ | \
    grep "install ok installed" &> /dev/null
    echo $?
}

function packages_list_install_loop()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    for PACKAGE in $(cat "${1}"); do
        if [ $(is_package_installed ${PACKAGE}) != 0 ]; then
            echo "Package '$PACKAGE' is not installed. Installing..." | \
            systemd-cat -p debug -t $0
            sudo apt-get -y install ${PACKAGE}

            if [[ $? != 0 ]]; then
                echo "packages_list_install_loop() failure: error installing package '${PACKAGE}'" | \
                systemd-cat -p err -t $0
                echo "Error installing '$PACKAGE'."
            fi
        else
            echo "Package '$PACKAGE' is installed."
        fi
    done
}

function prerequisites_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    packages_list_install_loop $(dirname "$0")"/../data/apt/deb/prerequisites.list"
}

function home_directories_create()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Creating home directories..."

    mkdir -p -v "${AUDIO_DIR}" "${BOOKS_DIR}" "${DOCUMENTS_DIR}"               \
                "${DOWNLOADS_DIR}" "${GAMES_DIR}" "${PICTURES_DIR}"            \
                "${TORRENTS_DIR}" "${VIDEO_DIR}" "${WORKSPACE_DIR}"            \
                "${MUSIC_DIR}" "${JOB_DOCUMENTS_DIR}"                          \
                "${PERSONAL_DOCUMENTS_DIR}" "${TELEGRAM_DOWNLOADS_DIR}"        \
                "${TORRENT_DOWNLOADS_DIR}" "${ARTWORK_DIR}" "${ICONS_DIR}"     \
                "${GIF_DIR}" "${PHOTO_DIR}" "${SAVED_PICTURES_DIR}"            \
                "${SCREENSHOTS_DIR}" "${WALLPAPERS_DIR}"                       \
                "${FINISHED_TORRENTS_DIR}" "${PERSONAL_VIDEO_DIR}"             \
                "${SAVED_VIDEO_DIR}" "${MOVIES_DIR}" "${SERIES_DIR}"           \
                "${PERSONAL_SRC_DIR}" "${PERSONAL_VAR_DIR}"                    \
                "${PERSONAL_BACKUP_DIR}" "${PERSONAL_IMAGES_DIR}"              \
                "${PERSONAL_LOG_DIR}" "${NES_GAMES_DIR}" "${SEGA_GAMES_DIR}"   \
                "${SNES_GAMES_DIR}" "${N64_GAMES_DIR}" "${PS_GAMES_DIR}"       \
                "${PS2_GAMES_DIR}" "${ZXS_GAMES_DIR}" "${DOS_GAMES_DIR}"       \
                "${PS_BIOS_IMAGES_DIR}" "${PS2_BIOS_IMAGES_DIR}"               \
                "${BLADERF_X40_IMAGES_DIR}"
}

function rutracker_hosts_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding RuTracker hosts..."

    mkdir -p -v ${POST_INSTALL_BACKUP_DIR}/etc
    cp /etc/hosts "${POST_INSTALL_BACKUP_DIR}"/etc
    printf "${RUTRACKER_HOSTS}" | sudo tee -a /etc/hosts
}

function locale_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding locale ${1}"

    if ! grep "${1}" "${SUPPORTED_LOCALES_PATH}"; then
        echo "locales_setup() warning: '${1}' locale is not supported" | \
        systemd-cat -p warning -t $0
        echo "Warning! '${1}' locale is not supported"
    else
        mkdir -p -v ${POST_INSTALL_BACKUP_DIR}/etc
        cp /etc/locale.gen "${POST_INSTALL_BACKUP_DIR}"/etc
        echo ${1} | sudo tee -a /etc/locale.gen
        sudo locale-gen
    fi
}

function apt_keys_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding apt keys from given list..."

    while read -a KEY; do
        echo "Adding repository signing key..."
        wget -qO - "${KEY[0]}" | gpg --dearmor | \
        sudo tee /etc/apt/trusted.gpg.d/"${KEY[1]}"
    done <"${APT_KEYS_LIST_PATH}"
}

function apt_repos_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding apt repos from given list..."

    while read -r; do
        echo "Adding repository..."
        echo "${REPLY}" | sudo tee -a /etc/apt/sources.list.d/post-install.list
    done <"${APT_REPOS_LIST_PATH}"
}

function system_update()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Updating system..."

    sudo apt-get -y update
    if [ $(apt list --upgradeable | wc -l) = 1 ]; then
        echo "System is up to date."
    else
        sudo apt-get -y dist-upgrade
    fi
}

function apt_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Setting up apt packet manager..."

    echo "Appending sources.list with 'contrib' & 'non-free' repo components..." | \
    systemd-cat -p debug -t $0
    echo "Appending sources.list with 'contrib' & 'non-free' repo components..."
    mkdir -p -v "${POST_INSTALL_BACKUP_DIR}"/etc/apt
    cp /etc/apt/sources.list "${POST_INSTALL_BACKUP_DIR}"/etc/apt
    sudo sed -i "${REPO_COMPONENTS_WILDCARD}" /etc/apt/sources.list

    echo "Adding i386 dpkg arch..."
    sudo dpkg --add-architecture i386

    apt_keys_add

    for ARCHIVE_KEYRING_REMOTE in "${ARCHIVE_KEYRING_REMOTES[@]}"; do
        sudo wget -q --no-check-certificate -P "${ARCHIVE_KEYRINGS_DIR}" \
                  "${ARCHIVE_KEYRING_REMOTE}"
    done

    sudo chmod go+r "${ARCHIVE_KEYRINGS_DIR}/githubcli-archive-keyring.gpg"

    if ! gpg --keyid-format long --import --import-options show-only \
             --with-fingerprint                                      \
             "${ARCHIVE_KEYRINGS_DIR}/i2p-archive-keyring.gpg" |     \
         grep "${I2P_ARCHIVE_KEYRING_KEY_FINGERPRINT}"; then
        echo "Warning! i2p keyring fingerprint mismatch. Removing keyring"
        echo "Warning! i2p keyring fingerprint mismatch. Removing keyring" | \
        systemd-cat -p err -t $0
        sudo rm -f "${ARCHIVE_KEYRINGS_DIR}"/i2p-archive-keyring.gpg
    fi

    apt_repos_add

    system_update
}

function deb_packages_install_from_lists()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/apt/deb/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/apt/deb/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/apt/deb/${PREFIX}games.list"

    packages_list_install_loop "${COMMON_LIST}"

    if [ ${NO_GUI} = 0 ]; then
        packages_list_install_loop "${GUI_LIST}"
    fi

    if [ ${NO_GAMES} = 0 ]; then
        packages_list_install_loop "${GAMES_LIST}"
    fi

    if [ ${KDE} = 1 ]; then
        sudo apt-get -y install kde-standard
    fi
}

function remote_deb_packages_install_from_lists()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing remote packages..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/apt/deb/${PREFIX}remote-common.list"
    GUI_LIST=$(dirname "$0")"/../data/apt/deb/${PREFIX}remote-gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/apt/deb/${PREFIX}remote-games.list"

    mkdir -p -v "${REMOTE_DEB_TMPDIR}"

    for REMOTE in $(cat "${COMMON_LIST}"); do
        wget -q -P "${REMOTE_DEB_TMPDIR}" "${REMOTE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for REMOTE in $(cat "${GUI_LIST}"); do
            wget -q -P "${REMOTE_DEB_TMPDIR}" "${REMOTE}"
        done
    fi

    if [ ${NO_GAMES} = 0 ]; then
        for REMOTE in $(cat "${GAMES_LIST}"); do
            wget -q -P "${REMOTE_DEB_TMPDIR}" "${REMOTE}"
        done
    fi

    sudo dpkg -i "${REMOTE_DEB_TMPDIR}"/*
    sudo apt-get -f -y install
    rm -rf "${REMOTE_DEB_TMPDIR}"
}

function deb_packages_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing deb packages..."

    deb_packages_install_from_lists ${1}
    remote_deb_packages_install_from_lists ${1}
}

function deb_cleanup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "deb cleanup..."

    sudo apt-get -y autoremove
    sudo apt-get -y clean
    sudo dpkg --purge \
              $(COLUMNS=200 dpkg -l | grep '^rc' | tr -s ' ' | cut -d ' ' -f 2)
}

function flatpak_remotes_add()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding flatpak repos..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi
    REPOS_LIST=$(dirname "$0")'/../data/flatpak/'${PREFIX}'repos.list'

    while read -r; do
        sudo flatpak remote-add --if-not-exists $REPLY
    done <${REPOS_LIST}
}

function flatpak_packages_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing flatpak packages..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/flatpak/${PREFIX}games.list"

    while read -r; do
        flatpak install ${REPLY}
    done <${COMMON_LIST}

    if [ ${NO_GUI} = 0 ]; then
        while read -r; do
            flatpak install ${REPLY}
        done <${GUI_LIST}
    fi

    if [ ${NO_GAMES} = 0 ]; then
        while read -r; do
            flatpak install ${REPLY}
        done <${GAMES_LIST}
    fi
}

function snap_packages_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing snap packages..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/snap/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/snap/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/snap/${PREFIX}games.list"

    for PACKAGE in $(cat ${COMMON_LIST}); do
        sudo snap install "${PACKAGE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for PACKAGE in $(cat ${GUI_LIST}); do
            sudo snap install "${PACKAGE}"
        done
    fi

    if [ ${NO_GAMES} = 0 ]; then
        for PACKAGE in $(cat ${GAMES_LIST}); do
            sudo snap install "${PACKAGE}"
        done
    fi
}

function remote_install_from_archive()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing from the archive..."

    sudo wget -q -O /opt/archive "${1}"

    if file --mime-type /opt/archive | grep "${MIME_TYPE_TAR_GZ}"; then
        sudo tar -v -z -C /opt -x -f /opt/archive
    elif file --mime-type /opt/archive | grep "${MIME_TYPE_TAR_XZ}"; then
        sudo tar -v -J -C /opt -x -f /opt/archive
    elif file --mime-type /opt/archive | grep "${MIME_TYPE_TAR_BZ2}"; then
        sudo tar -v -j -C /opt -x -f /opt/archive
    elif file --mime-type /opt/archive | grep "${MIME_TYPE_ZIP}"; then
        sudo 7z x -tzip -o/opt /opt/archive
    else
        echo "${FUNCNAME}() warning: unknown archive type" | \
        systemd-cat -p warning -t $0
        echo "Unknown archive type"
    fi

    sudo rm -f /opt/archive
}

function install_from_archives()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing remote apps from archives..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/remote_archives/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/remote_archives/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/remote_archives/${PREFIX}games.list"

    for REMOTE in $(cat ${COMMON_LIST}); do
        remote_install_from_archive "${REMOTE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for REMOTE in $(cat ${GUI_LIST}); do
            remote_install_from_archive "${REMOTE}"
        done
    fi

    if [ ${NO_GAMES} = 0 ]; then
        for REMOTE in $(cat ${GAMES_LIST}); do
            remote_install_from_archive "${REMOTE}"
        done
    fi
}

function youtube_dl_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    sudo wget -q -O "${YOUTUBE_DL_PATH}" "${YOUTUBE_DL_REMOTE}"
    sudo chmod 0755 "${YOUTUBE_DL_PATH}"
}

function ssh_keys_store()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    SSH_ID_RSA_PUB=$(cat ~/.ssh/id_rsa.pub)

    curl -X POST -H "Accept: application/vnd.github+json"  \
         -H "Authorization: Bearer ${GITHUB_KEY_RW_TOKEN}" \
         -H "X-GitHub-Api-Version: 2022-11-28"             \
         https://api.github.com/user/keys                  \
         -d "{\"title\":\"${HOSTNAME}\",\"key\":\"${SSH_ID_RSA_PUB}\"}"
}

function git_repo_clone()
{
    TARGET=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Cloning git repo..."

    GIT_REPO_NAME=$(basename ${1})
    REPO_DIRNAME=${GIT_REPO_NAME%.*}
    REPO_PARENT_DIRNAME=$(echo "${1}" | awk -F[/:] '{print $(NF - 1)}')

    if [ "${2}" ]; then
        TARGET="${2}"/"${REPO_DIRNAME}"
    else
        TARGET="${PERSONAL_SRC_DIR}"/"${REPO_PARENT_DIRNAME}"/"${REPO_DIRNAME}"
    fi

    git clone --recurse-submodules "${1}" "${TARGET}"
}

function sources_get()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Getting sources..."

    if [ "${1}" ]; then
        PREFIX="${1}"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/git/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/git/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/git/${PREFIX}games.list"

    for REPO in $(cat ${COMMON_LIST}); do
        git_repo_clone "${REPO}"
    done

    if [ $NO_GUI = 0 ]; then
        for REPO in $(cat ${GUI_LIST}); do
            git_repo_clone "${REPO}"
        done
    fi

    if [ $NO_GAMES = 0 ]; then
        for REPO in $(cat ${GAMES_LIST}); do
            git_repo_clone "${REPO}"
        done
    fi
}

function i3_gaps_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing i3-gaps..."

    pushd "$PERSONAL_SRC_DIR"/Airblader/i3
    rm -rf build
    mkdir -p -v build && pushd build
    meson ..
    ninja
    sudo ninja install
    ninja clean
    popd
    rm -rf build
    popd
}

function i3blocks_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing i3blocks..."

    pushd "$PERSONAL_SRC_DIR"/vivien/i3blocks
    git remote add bmigunov-github git@github.com:bmigunov/i3blocks.git
    git fetch --all
    git checkout ticker-support
    git pull
    ./autogen.sh
    ./configure
    make
    sudo make install
    make clean
    popd
}

function bladerf_binaries_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing bladeRF binaries..."

    pushd "$PERSONAL_SRC_DIR"/Nuand/bladeRF/host
    rm -rf build
    mkdir -p -v build && pushd build
    cmake ..
    make
    sudo make install
    make clean
    printf "/usr/local/lib\n/usr/local/lib64\n" | \
    sudo tee /etc/ld.so.conf.d/local.conf
    sudo ldconfig
    popd
    popd
}

function translate_shell_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing translate-shell..."

    pushd "$PERSONAL_SRC_DIR"/soimort/translate-shell
    make
    sudo make install
    make clean
    popd
}

function qdl_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing qdl..."

    pushd "$PERSONAL_SRC_DIR"/qualcomm/qdl
    make
    sudo make install
    make clean
    popd
}

function mbedtls_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing mbedTLS..."

    pushd "$PERSONAL_SRC_DIR"/ARMmbed/mbedtls
    git checkout master
    git fetch
    git pull
    git submodule update --recursive
    rm -rf build
    mkdir -p -v build && pushd build
    cmake ..
    cmake --build .
    sudo make install
    make clean
    popd
    popd
}

function i3lock_color_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing i3lock-color..."

    pushd "$PERSONAL_SRC_DIR"/Raymo111/i3lock-color
    sudo ./install-i3lock-color.sh
    popd
}

function xkblayout_state_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing xkblayout-state..."

    pushd "$PERSONAL_SRC_DIR"/nonpop/xkblayout-state
    make
    sudo make install
    make clean
    popd
}

function srsran_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing srsRAN..."

    pushd "$PERSONAL_SRC_DIR"/srsran/srsRAN
    rm -rf build
    mkdir -p -v build && pushd build
    cmake ..
    make
    make test
    sudo make install
    sudo srsran_install_configs.sh user
    make clean
    popd
    popd
}

function i3blocks_contrib_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing i3blocks 'blocklets' from 'i3blocks-contrib' git repo"

    pushd "$PERSONAL_SRC_DIR"/vivien/i3blocks-contrib
    git remote add bmigunov-github git@github.com:bmigunov/i3blocks-contrib.git
    git fetch --all
    git pull

    sudo mkdir -p -v "${I3_BLOCKS_BLOCKLETS_DIR}"

    for BLOCKLET in "${I3BLOCK_BLOCKLETS[@]}"; do
        sudo cp "${BLOCKLET}" "${I3_BLOCKS_BLOCKLETS_DIR}"
    done

    git checkout bmigunov-github/mpd
    sudo cp mpd/scripts/* "${I3_BLOCKS_BLOCKLETS_DIR}"

    git checkout bmigunov-github/weather-util
    sudo cp weather-util/weather-util "${I3_BLOCKS_BLOCKLETS_DIR}"

    git checkout master
    popd
}

function openvpn3_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing openvpn3"

    pushd "${PERSONAL_SRC_DIR}/OpenVPN/openvpn3-linux"
    ./bootstrap.sh
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
    make
    sudo make install

    sudo groupadd -r openvpn
    sudo useradd -r -s /sbin/nologin -g openvpn openvpn
    sudo chown -R openvpn:openvpn /var/lib/openvpn3
    systemctl reload dbus
    popd
}

function build_and_install_from_sources()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    luxdesk_configs_install
    mbedtls_install
    bladerf_binaries_install
    srsran_install
    translate_shell_install
    qdl_install
    i3_gaps_install
    i3blocks_install
    i3blocks_contrib_install
    i3lock_color_install
    xkblayout_state_install
    openvpn3_install
}

function mutt_accounts_obtain()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    mkdir -p -v ~/.mutt

    if [ ${MUTT_ACCOUNTS_GPG_REMOTE} ]; then
        wget -q -O ~/.mutt/accounts.gpg "${MUTT_ACCOUNTS_GPG_REMOTE}"
    else
        echo "${FUNCNAME}() issue: accounts.gpg link is not provided" | \
        systemd-cat -p warning -t $0
    fi
}

function luxdesk_configs_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing LuxDesk configs..."

    cp -rv "$PERSONAL_SRC_DIR"/bmigunov/luxdesk-configs/sparse/home/user/. ~ | systemd-cat -p info -t $0
    sudo cp -rv "$PERSONAL_SRC_DIR"/bmigunov/luxdesk-configs/sparse/root/. /root | systemd-cat -p info -t $0

    mutt_accounts_obtain
}

function yate_build_and_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    mkdir -p -v "${PERSONAL_SRC_DIR}"/yate
    pushd "${PERSONAL_SRC_DIR}"/yate
    svn checkout "${YATE_SVN_REPO}" yate
    svn checkout "${YATEBTS_SVN_REPO}" yatebts

    echo "Building & installing yate..."
    pushd yate
    ./autogen.sh
    ./configure
    make
    sudo make install-noapi
    make clean
    popd

    echo "Building & installing yateBTS..."
    pushd yatebts
    ./autogen.sh
    ./configure
    make
    sudo make install
    make clean
    popd
    popd

    sudo addgroup yate
    sudo usermod -a -G yate "$USER"
}

function vim_plugins_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing vim plugins..."

    mkdir -p -v "${VIM_DIR}"/{bundle,plugin,colors,doc,autoload}

    VIM_PLUGINS_REPOS_LIST=$(dirname "$0")"/../data/git/vim.list"

    for REPO in $(cat ${VIM_PLUGINS_REPOS_LIST}); do
        git_repo_clone "${REPO}" "${VIM_BUNDLE_DIR}"
    done

    git_repo_clone ${YCM_REPO_URI} "${VIM_BUNDLE_DIR}"
    pushd "${VIM_BUNDLE_DIR}"/YouCompleteMe
    python3 install.py
    popd

    git_repo_clone "${VIM_PATHOGEN_REPO_URI}"
    cp "${PERSONAL_SRC_DIR}"/tpope/vim-pathogen/autoload/pathogen.vim \
       "${VIM_AUTOLOAD_DIR}"

    git_repo_clone "${VIM_TAGLIST_REPO_URI}"
    cp "${PERSONAL_SRC_DIR}/vim-scripts/taglist.vim/plugin/taglist.vim" \
       "${VIM_PLUGIN_DIR}"

    git_repo_clone "${VIM_DRACULA_REPO_URI}"
    cp -rv "${PERSONAL_SRC_DIR}/dracula/vim/after" "${VIM_DIR}"
    cp -rv "${PERSONAL_SRC_DIR}/dracula/vim/autoload/"* "${VIM_AUTOLOAD_DIR}"
    cp -rv "${PERSONAL_SRC_DIR}/dracula/vim/colors/"* "${VIM_COLORS_DIR}"
    cp -rv "${PERSONAL_SRC_DIR}/dracula/vim/doc/"* "${VIM_DOC_DIR}"
}

function bash_histfile_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Setting up bash history file..."

    if [ ${XDG_DATA_HOME} ]; then
        BASH_HISTFILE_DIR="${XDG_DATA_HOME}/bash"
    else
        BASH_HISTFILE_DIR="${HOME}/.local/share/bash"
    fi

    mkdir -p -v "${BASH_HISTFILE_DIR}"
    if [ -e ~/.bash_history ]; then
        mv ~/.bash_history "${BASH_HISTFILE_DIR}"
    else
        echo                                                                              \
        "${FUNCNAME}(): no .bash_history file in home directory; creating new empty file" \
        | systemd-cat -p debug -t $0
        touch "${BASH_HISTFILE_DIR}/bash_history"
    fi
}

function mpd_setup()
{
    if [ ${XDG_CACHE_DIR} ]; then
        MPD_CACHE_DIR="${XDG_CACHE_HOME}/mpd"
    else
        MPD_CACHE_DIR="${HOME}/.cache/mpd"
    fi

    MPD_PLAYLIST_DIRECTORY="${MPD_CACHE_DIR}/playlists"

    MPD_DB_FILE_PATH="${MPD_CACHE_DIR}/tag_cache"
    MPD_LOG_FILE_PATH="${MPD_CACHE_DIR}/mpd.log"
    MPD_STATE_FILE_PATH="${MPD_CACHE_DIR}/state"
    MPD_STICKER_FILE_PATH="${MPD_CACHE_DIR}/sticker.sql"

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Creating mpd files & directories..."

    mkdir -p -v "$MPD_PLAYLIST_DIRECTORY"

    touch "$MPD_DB_FILE_PATH"
    touch "$MPD_LOG_FILE_PATH"
    touch "$MPD_STATE_FILE_PATH"
    touch "$MPD_STICKER_FILE_PATH"
}

function bladerf_x40_images_download()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Downloading bladeRF x40 images..."

    wget -q -O "${BLADERF_FX3_IMAGE_LATEST_PATH}" \
         "${BLADERF_FX3_IMAGE_LATEST_REMOTE}"
    wget -q -O "${BLADERF_X40_FPGA_BITSTREAM_LATEST_PATH}" \
         "${BLADERF_X40_FPGA_BITSTREAM_LATEST_REMOTE}"
    wget -q -O "${BLADERF_FX3_2_3_2_IMAGE_PATH}" \
         "${BLADERF_FX3_2_3_2_IMAGE_REMOTE}"
    wget -q -O "${BLADERF_X40_FPGA_BITSTREAM_0_11_1_PATH}" \
    "${BLADERF_X40_FPGA_BITSTREAM_0_11_1_REMOTE}"
}

function playstation_bios_download()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Downloading PSOne and PS2 BIOS images..."

    wget -q -O "${PS_BIOS_IMAGES_DIR}/ps_bios.7z" "${PS_BIOS_REMOTE}"
    wget -q -O "${PS2_BIOS_IMAGES_DIR}/ps2_bios.7z" "${PS2_BIOS_REMOTE}"
}

function brutal_doom_download()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Downloading Brutal Doom mod..."

    wget -q -O "${GAMES_DIR}/brutal_doom.rar" "${BRUTAL_DOOM_REMOTE}"
}

function nerd_fonts_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing fonts..."

    for (( I=0; I<${#NERD_FONT_ARCHIVES[@]}; I++ )); do
        sudo mkdir -p -v "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}"

        sudo wget -q -P "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}" \
                        "${NERD_FONTS_REMOTE}${NERD_FONT_ARCHIVES[${I}]}"

        sudo 7z x -tzip -o"${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}"                        \
                  "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}/${NERD_FONT_ARCHIVES[${I}]}" && \
        sudo rm -f "${TRUETYPE_FONTS_DIR_PATH}/${NERD_FONT_DIRNAMES[${I}]}/${NERD_FONT_ARCHIVES[${I}]}"
    done

    fc-cache -fv
}

function device_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Device setup"

    while [ true ]; do
        read -p "Choose preferred device: 1) dell-g3; 2) ryzen-7-desktop; any other option would skip this step >"
        case $REPLY in
        1)
            git_repo_clone "${LUXDESK_CONFIGS_DELL_G3_REPO_URI}"
            cp -rv "${PERSONAL_SRC_DIR}"/bmigunov/luxdesk-configs-dell-g3/sparse/home/user/. ~ | \
            systemd-cat -p info -t $0
            sudo cp -rv "${PERSONAL_SRC_DIR}"/bmigunov/luxdesk-configs-dell-g3/sparse/etc/. /etc | \
            systemd-cat -p info -t $0
            cp -rnv "${PERSONAL_SRC_DIR}"/bmigunov/luxdesk-configs-dell-g3/post-install/* \
                    $(dirname "$0")'/..'
            break
            ;;
        2)
            git_repo_clone "${LUXDESK_CONFIGS_RYZEN7_DESKTOP_REPO_URI}"
            cp -rv "${PERSONAL_SRC_DIR}"/bmigunov/luxdesk-configs-ryzen7-desktop/sparse/home/user/. ~ | \
            systemd-cat -p info -t $0
            sudo cp -rv "${PERSONAL_SRC_DIR}"/bmigunov/luxdesk-configs-ryzen7-desktop/sparse/etc/. /etc | \
            systemd-cat -p info -t $0
            cp -rnv "${PERSONAL_SRC_DIR}"/bmigunov/luxdesk-configs-ryzen7-desktop/post-install/* \
                    $(dirname "$0")'/..'
            break
            ;;
        *)
            echo "Presumably wrong option"
            echo "${FUNCNAME}() warning: presumably wrong option" | \
            systemd-cat -p warning -t $0
            ;;
        esac
    done

    deb_packages_install device

    flatpak_remotes_add device
    flatpak_packages_install device

    snap_packages_install device

    install_from_archives device

    sources_get device

    ./device-post-install.sh
}

function root_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    sudo ln -s ~/.vim /root/.vim
    sudo ln -s ~/.vimrc /root/.vimrc
    sudo ln -s ~/.config/dircolors /root/.config/dircolors
}

function systemd_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    sudo systemctl stop ModemManager.service
    sudo systemctl stop mpd.service
    sudo systemctl disable ModemManager.service

    sudo systemctl --system disable mpd.service
    systemctl --user enable mpd.service

    sudo systemctl daemon-reload
}

function mime_types_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    xdg-mime default okularApplication_chm.desktop application/vnd.ms-htmlhelp
    xdg-mime default okularApplication_pdf.desktop application/pdf
    xdg-mime default sxiv.desktop {"image/png","image/jpeg","image/tiff"}
    xdg-mime default sxiv_gif.desktop image/gif
    xdg-mime defaul FBReader.desktop application/x-fictionbook+xml
    xdg-mime default darktable.desktop image/x-sony-arw
}

tabs 4
clear

options_check "$@"
os_check
privileges_check
prerequisites_install

home_directories_create

rutracker_hosts_add
locale_add "${EN_US_UTF8_LOCALE}"

apt_setup
deb_packages_install
deb_cleanup

flatpak_remotes_add
flatpak_packages_install

snap_packages_install

install_from_archives

youtube_dl_install

if [ -n "${GITHUB_KEY_RW_TOKEN}" ]; then
    ssh-keygen -q -f ~/.ssh/id_rsa -N ${SSH_KEY_PASS}
    ssh_keys_store

    eval $(ssh-agent)
    ssh-add

    sources_get
    build_and_install_from_sources

    vim_plugins_install
fi

yate_build_and_install

bash_histfile_setup
mpd_setup

bladerf_x40_images_download

if [ $NO_GAMES = 0 ]; then
    playstation_bios_download
    brutal_doom_download
fi

nerd_fonts_install

device_setup

root_setup

systemd_setup

mime_types_setup

while [ true ]; do
    read -p "Would you like to reboot your system? [y/n]: "
    case $REPLY in
    [Yy] )
        echo "Trying to reboot system..."
        systemctl reboot
        break
        ;;
    [Nn] )
        echo "It is recommended to reboot your system after post-install script execution"
        exit 0
        ;;
    * )
        echo "Wrong answer"
        ;;
    esac
done

exit 0
