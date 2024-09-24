#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of device-specific scripts.




source $(dirname "${0}")"/deb.sh"
source $(dirname "${0}")"/snap.sh"
source $(dirname "${0}")"/flatpak.sh"
source $(dirname "${0}")"/pip.sh"
source $(dirname "${0}")"/pipx.sh"
source $(dirname "${0}")"/npm.sh"
source $(dirname "${0}")"/opt.sh"
source $(dirname "${0}")"/sources.sh"

LUXDESK_CONFIGS_DELL_G3_REPO_URI=\
"git@github.com:bmigunov/luxdesk-configs-dell-g3"
LUXDESK_CONFIGS_RYZEN7_DESKTOP_REPO_URI=\
"git@github.com:bmigunov/luxdesk-configs-ryzen7-desktop"


function device_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Device setup"

    while [ true ]; do
        read -p "Choose preferred device: 1) dell-g3; 2) ryzen-7-desktop; n) skip this step >"
        case $REPLY in
        1)
            git_repo_clone "${LUXDESK_CONFIGS_DELL_G3_REPO_URI}"
            cp --backup=none -rv "${LXD_SRC_DIR}/bmigunov/luxdesk-configs-dell-g3/sparse/home/user/.config" "${HOME}" | \
            systemd-cat -p info -t $0

            cp -rnv "${LXD_SRC_DIR}/bmigunov/luxdesk-configs-dell-g3/post-install/"* \
                    $(dirname "$0")'/..'
            break
            ;;
        2)
            git_repo_clone "${LUXDESK_CONFIGS_RYZEN7_DESKTOP_REPO_URI}"
            cp --backup=none -rv "${LXD_SRC_DIR}/bmigunov/luxdesk-configs-ryzen7-desktop/sparse/home/user/.config" "${HOME}" | \
            systemd-cat -p info -t $0

            cp -rnv "${LXD_SRC_DIR}/bmigunov/luxdesk-configs-ryzen7-desktop/post-install/"* \
                    $(dirname "$0")'/..'
            break
            ;;
        n)
            echo "Skip device setup"
            echo "${FUNCNAME}() skipping this step..." | \
            systemd-cat -p debug -t $0
            return
            ;;
        *)
            echo "Presumably wrong option"
            echo "${FUNCNAME}() warning: presumably wrong option" | \
            systemd-cat -p warning -t $0
            ;;
        esac
    done

    sources_get device

    deb_packages_install device

    snap_packages_install device

    flatpak_remotes_add device
    flatpak_packages_install device

    pip_packages_install device
    pipx_packages_install device

    npm_packages_install device

    opt_install device

    ./device-post-install.sh
}
