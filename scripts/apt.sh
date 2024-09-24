#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Functions to use in context of apt initial setup.




APT_KEYS_LIST_PATH=$(dirname "$0")"/../data/deb/apt/keys.list"
APT_KEYRING_LIST_PATH=$(dirname "$0")"/../data/deb/apt/keyring.list"

KEYRINGS_DIR="/usr/share/keyrings"


function apt_keys_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding apt keys from given list..."

    while read -a KEY; do
        echo "Adding repository signing key..."
        wget -qO - "${KEY[0]}" | gpg --dearmor | \
        sudo tee /etc/apt/trusted.gpg.d/"${KEY[1]}" 1&>/dev/null
    done <"${APT_KEYS_LIST_PATH}"
}

function apt_keyring_append()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding apt keyrings from given list..."

    while read -a KEYRING_REMOTE; do
        echo "Fetching repository signing keyring..."

        if [ "${KEYRING_REMOTE[1]}" = "-" ]; then
            sudo wget --no-check-certificate --content-disposition -P \
                      "${KEYRINGS_DIR}" "${KEYRING_REMOTE[0]}"
        else
            sudo wget --no-check-certificate --content-disposition \
                      -O "${KEYRINGS_DIR}/${KEYRING_REMOTE[1]}" \
                      "${KEYRING_REMOTE[0]}"
        fi
    done <"${APT_KEYRING_LIST_PATH}"
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

function apt_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Setting up apt packet manager..."

    apt_keys_add
    apt_keyring_append

    system_update
}
