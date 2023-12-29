#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Functions to use in context of apt initial setup.




APT_KEYS_LIST_PATH=$(dirname "$0")"/../data/deb/apt/keys.list"
APT_KEYRING_LIST_PATH=$(dirname "$0")"/../data/deb/apt/keyring.list"
APT_REPOS_LIST_PATH=$(dirname "$0")'/../data/deb/apt/repos.list'

I2P_ARCHIVE_KEYRING_KEY_FINGERPRINT=\
"7840 E761 0F28 B904 7535  49D7 67EC E560 5BCF 1346"

REPO_COMPONENTS_WILDCARD="/^deb http.*main$\|^deb-src http.*main$/ s/$/ \
contrib non-free/"

KEYRINGS_DIR="/usr/share/keyrings"


function repo_components_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Appending sources.list with 'contrib' & 'non-free' repo components..." | \
    systemd-cat -p debug -t $0
    echo "Appending sources.list with 'contrib' & 'non-free' repo components..."

    mkdir -p -v "${POST_INSTALL_BACKUP_DIR}/etc/apt"
    cp /etc/apt/sources.list "${POST_INSTALL_BACKUP_DIR}/etc/apt"

    sudo sed -i "${REPO_COMPONENTS_WILDCARD}" /etc/apt/sources.list
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

function apt_keyring_append()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding apt keys from given list..."

    for KEYRING_REMOTE in $(cat "${APT_KEYRING_LIST_PATH}"); do
        echo "Fetching repository signing key..."
        sudo wget --no-check-certificate --content-disposition -P \
                  "${KEYRINGS_DIR}" "${KEYRING_REMOTE}"
    done

    sudo chmod go+r "${KEYRINGS_DIR}/githubcli-archive-keyring.gpg"

    if ! gpg --keyid-format long --import --import-options show-only \
             --with-fingerprint                                      \
             "${KEYRINGS_DIR}/i2p-archive-keyring.gpg" |     \
         grep "${I2P_ARCHIVE_KEYRING_KEY_FINGERPRINT}"; then
        echo "Warning! i2p keyring fingerprint mismatch. Removing keyring"
        echo "Warning! i2p keyring fingerprint mismatch. Removing keyring" | \
        systemd-cat -p warning -t $0
        sudo rm -f "${KEYRINGS_DIR}"/i2p-archive-keyring.gpg
    fi
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

    sudo apt-get update
    if [ $(apt list --upgradeable | wc -l) = 1 ]; then
        echo "System is up to date."
    else
        sudo apt-get -y dist-upgrade
    fi
}

function repo_components_check()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Checking 'sources.list'..."

    if ! grep ' contrib ' /etc/apt/sources.list || ! grep ' non-free ' /etc/apt/sources.list; then
        echo "Failure. 'contrib' or 'non-free' repo components are missing"
        exit 1
    else
        echo "Ok. 'contrib' and 'non-free' repo components are present"
    fi
}

function apt_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Setting up apt packet manager..."

#     repo_components_add

    echo "Adding i386 dpkg arch..."
    sudo dpkg --add-architecture i386

    apt_keys_add
    apt_keyring_append

    apt_repos_add

    system_update
}
