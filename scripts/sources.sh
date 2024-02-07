#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of scripts to install binaries from source.




source $(dirname "${0}")"/git.sh"
source $(dirname "${0}")"/mutt.sh"


I3_BLOCKS_BLOCKLETS_DIR="/usr/share/i3blocks"
declare -a I3BLOCK_BLOCKLETS=("disk-io" "memory" "cpu_usage" "temperature" \
                              "metars" "volume-pipewire")


function make_build_install_clean()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    make
    sudo make install
    make clean
}

function ninja_build_install_clean()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    ninja -C build
    sudo ninja -C build install
    ninja -C build clean
}

function luxdesk_configs_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing LuxDesk configs..."

    cp --backup=none -rv                                            \
       "${SRC_DIR}"/bmigunov/luxdesk-configs/sparse/home/user/. ~ | \
       systemd-cat -p info -t $0
    sudo cp --backup=none -rv                                         \
            "${SRC_DIR}"/bmigunov/luxdesk-configs/sparse/etc/. /etc | \
            systemd-cat -p info -t $0
    sudo cp --backup=none -rv                                         \
            "${SRC_DIR}"/bmigunov/luxdesk-configs/sparse/usr/. /usr | \
            systemd-cat -p info -t $0

    mutt_accounts_obtain
}

function mbedtls_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing mbedTLS..."

    pushd "${SRC_DIR}/ARMmbed/mbedtls"
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

function bladerf_binaries_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing bladeRF binaries..."

    pushd "${SRC_DIR}/Nuand/bladeRF/host"
    rm -rf build
    mkdir -p -v build && pushd build
    cmake ..
    make_build_install_clean
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

    pushd "${SRC_DIR}/soimort/translate-shell"
    make_build_install_clean
    popd
}

function qdl_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing qdl..."

    pushd "${SRC_DIR}/qualcomm/qdl"
    make_build_install_clean
    popd
}

function xkblayout_state_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing xkblayout-state..."

    pushd "${SRC_DIR}/nonpop/xkblayout-state"
    make_build_install_clean
    popd
}

function openvpn3_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing openvpn3"

    pushd "${SRC_DIR}/OpenVPN/openvpn3-linux"
    ./bootstrap.sh
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
    make_build_install_clean

    sudo groupadd -r openvpn
    sudo useradd -r -s /sbin/nologin -g openvpn openvpn
    sudo chown -R openvpn:openvpn /var/lib/openvpn3
    systemctl reload dbus
    popd
}

function yate_build_and_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    echo "Building & installing yate..."
    pushd "${SRC_DIR}/bmigunov/yate"
    ./autogen.sh
    ./configure
    make_build_install_clean
    popd

    echo "Building & installing yateBTS..."
    pushd "${SRC_DIR}/bmigunov/yatebts"
    ./autogen.sh
    ./configure
    make_build_install_clean
    popd

    sudo addgroup yate
    sudo usermod -a -G yate "${CURRENT_USER}"
}

function ly_build_and_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing ly..."

    pushd "${SRC_DIR}/fairyglade/ly"
    make
    sudo make install installsystemd
    make clean
    popd
}

function vim_plug_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing vim-plug..."

    mkdir -p -v "${XDG_DATA_HOME}/nvim/site/autoload"
    cp --backup=none -v "${SRC_DIR}/junegunn/vim-plug/plug.vim" \
       "${XDG_DATA_HOME}/nvim/site/autoload/plug.vim"
}

function swayfx_build_and_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing swayfx..."

    pushd "${SRC_DIR}/WillPower3309/swayfx"
    meson build
    ninja_build_install_clean
    sudo mkdir -p -v /usr/share/wayland-sessions
    sudo cp sway.desktop /usr/share/wayland-sessions
    popd
}

function i3blocks_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing i3blocks..."

    pushd "${SRC_DIR}/vivien/i3blocks"
    git remote add bmigunov-github git@github.com:bmigunov/i3blocks.git
    git fetch --all
    git checkout ticker-support
    git pull
    ./autogen.sh
    ./configure
    make_build_install_clean
    popd
}

function i3blocks_contrib_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing i3blocks 'blocklets' from 'i3blocks-contrib' git repo"

    pushd "${SRC_DIR}/vivien/i3blocks-contrib"
    git remote add bmigunov-github git@github.com:bmigunov/i3blocks-contrib.git
    git fetch --all
    git pull

    sudo mkdir -p -v "${I3_BLOCKS_BLOCKLETS_DIR}"

    for BLOCKLET in "${I3BLOCK_BLOCKLETS[@]}"; do
        sudo cp ${BLOCKLET}/${BLOCKLET} ${I3_BLOCKS_BLOCKLETS_DIR}
    done

    git checkout bmigunov-sway_calendar
    sudo cp sway_calendar/sway_calendar ${I3_BLOCKS_BLOCKLETS_DIR}

    git checkout bmigunov-sway_klayout
    sudo cp sway_klayout/sway_klayout ${I3_BLOCKS_BLOCKLETS_DIR}

    git checkout master
    popd
}

function swaylock_effects_build_and_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing swaylock-effects"

    pushd "${SRC_DIR}/mortie/swaylock-effects"
    meson build
    ninja_build_install_clean
    popd
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

    if [ $NO_GAMES = 0 ]; then
        while read -a REPO; do
            if ! git_repo_clone "${REPO[0]}" ; then
                git_repo_clone "${REPO[1]}"
            fi
        done <"${GAMES_LIST}"
    fi
}

function build_and_install_from_sources()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    mbedtls_install
    bladerf_binaries_install
    translate_shell_install
    qdl_install
    xkblayout_state_install
    openvpn3_install
    yate_build_and_install
    ly_build_and_install
    vim_plug_install

    if [ ${NO_GUI} = 0 ]; then
        swayfx_build_and_install
        i3blocks_install
        i3blocks_contrib_install
        swaylock_effects_build_and_install
    fi

    luxdesk_configs_install
}
