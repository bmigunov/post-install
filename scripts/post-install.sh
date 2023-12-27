#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   A post-installation bash script for Linux.




export NO_GUI=0
export NO_GAMES=0
export GITHUB_KEY_RW_TOKEN=
export MUTT_ACCOUNTS_GPG_REMOTE=
SSH_KEY_PASS=""

export GIT_PREFER_SSH=0

REQUIRED_OS_NAME=Linux
REQUIRED_DISTRO_NAME=Debian

LONGOPT_HELP="--help"
SHORTOPT_HELP="-h"
LONGOPT_NO_GAMES="--no_games"
LONGOPT_NO_GUI="--no_gui"
LONGOPT_KEY_RW_TOKEN="--key_rw_token"
LONGOPT_SSH_KEY_PASS="--ssh_key_pass"
LONGOPT_MUTT_ACCOUNTS_REMOTE="--mutt_accounts_remote"
LONGOPT_GIT_PREFER_SSH="--git_prefer_ssh"

USAGE="post-install.sh\nA script to set up a freshly installed system.\n\t\
$LONGOPT_HELP, $SHORTOPT_HELP: Print help message.\n\t$LONGOPT_NO_GAMES: Do \
not install games.\n\t$LONGOPT_NO_GUI: Do not install GUI applications and X \
server.\n\t$LONGOPT_KEY_RW_TOKEN: GitHub personal access token to read and \
write public keys.\n\t$LONGOPT_SSH_KEY_PASS: New SSH key passphrase (empty by \
default).\n\t$LONGOPT_MUTT_ACCOUNTS_REMOTE: Link to the mutt 'accounts.gpg' \
file to download\n\t$LONGOPT_GIT_PREFER_SSH: Prefer ssh method of fetching \
sources via git.\n"


function options_check()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    while [ true ]; do
        if [ ${1} = ${LONGOPT_HELP} ] || [ ${1} = ${SHORTOPT_HELP} ]; then
            printf "${USAGE}"
            exit 0
        elif [ ${1} = ${LONGOPT_NO_GAMES} ]; then
            export NO_GAMES=1
            shift 1
        elif [ ${1} = ${LONGOPT_NO_GUI} ]; then
            export NO_GUI=1
            shift 1
        elif [ ${1} = ${LONGOPT_KEY_RW_TOKEN} ]; then
            export GITHUB_KEY_RW_TOKEN="${2}"
            shift 2
        elif [ ${1} = ${LONGOPT_SSH_KEY_PASS} ]; then
            export SSH_KEY_PASS="${2}"
            shift 2
        elif [ ${1} = ${LONGOPT_MUTT_ACCOUNTS_REMOTE} ]; then
            export MUTT_ACCOUNTS_GPG_REMOTE="${2}"
            shift 2
        elif [ ${1} = ${LONGOPT_GIT_PREFER_SSH} ]; then
            export GIT_PREFER_SSH=1
            shift 1
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

function init()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    source $(dirname "$0")"/apt.sh"
    source $(dirname "$0")"/bash_setup.sh"
    source $(dirname "$0")"/bladerf.sh"
    source $(dirname "$0")"/cargo.sh"
    source $(dirname "$0")"/deb.sh"
    source $(dirname "$0")"/device.sh"
    source $(dirname "$0")"/directories.sh"
    source $(dirname "$0")"/emu-land.sh"
    source $(dirname "$0")"/flatpak.sh"
    source $(dirname "$0")"/fonts.sh"
    source $(dirname "$0")"/git.sh"
    source $(dirname "$0")"/language_servers.sh"
    source $(dirname "$0")"/locales.sh"
    source $(dirname "$0")"/mime.sh"
    source $(dirname "$0")"/mpd.sh"
    source $(dirname "$0")"/npm.sh"
    source $(dirname "$0")"/old-games.sh"
    source $(dirname "$0")"/opt.sh"
    source $(dirname "$0")"/pipx.sh"
    source $(dirname "$0")"/root.sh"
    source $(dirname "$0")"/snap.sh"
    source $(dirname "$0")"/sources.sh"
    source $(dirname "$0")"/systemd.sh"

    tabs 4
    clear

    os_check
    privileges_check

    prerequisites_install
}


options_check "$@"

init

directories_create

locales_setup

apt_setup
deb_packages_install
deb_cleanup

flatpak_repos_add
flatpak_packages_install

snap_packages_install

cargo_crates_install

pipx_packages_install

npm_packages_install

opt_install

ssh-keygen -q -f ~/.ssh/id_rsa -N ${SSH_KEY_PASS}

if [ -n "${GITHUB_KEY_RW_TOKEN}" ]; then
    github_ssh_keys_store

    eval $(ssh-agent)
    ssh-add
fi

sources_get
build_and_install_from_sources

bash_setup
mpd_setup

bladerf_x40_images_download

if [ $NO_GAMES = 0 ]; then
    emu_land_fetch
    old_games_fetch
fi

fonts_install

device_setup

root_setup

systemd_setup

mime_types_setup

language_servers_setup

sudo sensors-detect

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
