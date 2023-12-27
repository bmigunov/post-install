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
declare -a I3BLOCK_BLOCKLETS=("backlight/backlight" "bandwidth3/bandwidth3"    \
                              "battery2/battery2" "cpu_usage/cpu_usage"        \
                              "disk-io/disk-io" "disk/disk" "docker/docker"    \
                              "gpu-load/gpu-load" "iface/iface"                \
                              "memory/memory" "miccontrol/miccontrol"          \
                              "monitor_manager/monitor_manager"                \
                              "rofi-wttr/rofi-wttr" "taskw/taskw"              \
                              "temperature/temperature"                        \
                              "volume-pulseaudio/volume-pulseaudio"            \
                              "wlan-dbm/wlan-dbm" "keyindicator/keyindicator")


function luxdesk_configs_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing LuxDesk configs..."

    cp -rv "$PERSONAL_SRC_DIR"/bmigunov/luxdesk-configs/sparse/home/user/. ~ | systemd-cat -p info -t $0
    sudo cp -rv "$PERSONAL_SRC_DIR"/bmigunov/luxdesk-configs/sparse/root/. /root | systemd-cat -p info -t $0

    mutt_accounts_obtain
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

function srsran_4g_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing srsRAN..."

    pushd "$PERSONAL_SRC_DIR"/srsran/srsRAN_4G
    rm -rf build
    mkdir -p -v build && pushd build
    cmake ..
    make
    make test
    sudo make install
    sudo srsran_install_configs.sh user
    make clean
    rm -rf build
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

function openvpn3_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing openvpn3"

    pushd "${PERSONAL_SRC_DIR}/OpenVPN/openvpn3-linux"
    ./bootstrap.sh
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
    make
    sudo make install
    make clean

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
    pushd "${PERSONAL_SRC_DIR}"/bmigunov/yate
    ./autogen.sh
    ./configure
    make
    sudo make install-noapi
    make clean
    popd

    echo "Building & installing yateBTS..."
    pushd "${PERSONAL_SRC_DIR}"/bmigunov/yatebts
    ./autogen.sh
    ./configure
    make
    sudo make install
    make clean
    popd

    sudo addgroup yate
    sudo usermod -a -G yate "$USER"
}

function ly_build_and_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing ly..."

    pushd "${PERSONAL_SRC_DIR}"/fairyglade/ly
    make
    sudo make install installsystemd
    make clean
    popd
}

function swayfx_build_and_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing swayfx..."

    pushd "${PERSONAL_SRC_DIR}"/WillPower3309/swayfx
    meson build
    ninja -C build
    sudo ninja -C build install
    ninja -C build clean
    sudo mkdir -p -v /usr/share/wayland-sessions
    sudo cp sway.desktop /usr/share/wayland-sessions
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

    git checkout master
    popd
}

function ghidra_build_and_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Building & installing ghidra"

    curl -s "https://get.sdkman.io" | bash
    source "${HOME}"/.bashrc
    sdk install gradle 7.6
    source "${HOME}"/.bashrc
    rm "${HOME}"/.zshrc

    sudo update-alternatives --set java \
                             /usr/lib/jvm/temurin-17-jdk-amd64/bin/java

    pushd "${PERSONAL_SRC_DIR}/NationalSecurityAgency/ghidra"
    gradle -I gradle/support/fetchDependencies.gradle init
    gradle buildGhidra
    sudo 7z x -tzip -o"${HOME}"/.local/opt build/dist/ghidra_*.zip
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
        if [ ${GIT_PREFER_SSH} -eq 1 ]; then
            if [ "${REPO[0]}" != "-" ]; then
                git_repo_clone "${REPO[0]}"
            else
                git_repo_clone "${REPO[1]}"
            fi
        else
            git_repo_clone "${REPO[1]}"
        fi
    done <"${COMMON_LIST}"

    if [ $NO_GUI = 0 ]; then
        while read -a REPO; do
            if [ ${GIT_PREFER_SSH} -eq 1 ]; then
                if [ "${REPO[0]}" != "-" ]; then
                    git_repo_clone "${REPO[0]}"
                else
                    git_repo_clone "${REPO[1]}"
                fi
            else
                git_repo_clone "${REPO[1]}"
            fi
        done <"${GUI_LIST}"
    fi

    if [ $NO_GAMES = 0 ]; then
        while read -a REPO; do
            if [ ${GIT_PREFER_SSH} -eq 1 ]; then
                if [ "${REPO[0]}" != "-" ]; then
                    git_repo_clone "${REPO[0]}"
                else
                    git_repo_clone "${REPO[1]}"
                fi
            else
                git_repo_clone "${REPO[1]}"
            fi
        done <"${GAMES_LIST}"
    fi
}

function build_and_install_from_sources()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    luxdesk_configs_install
    mbedtls_install
    bladerf_binaries_install
    srsran_4g_install
    translate_shell_install
    qdl_install
    xkblayout_state_install
    openvpn3_install
    yate_build_and_install
    ly_build_and_install

    if [ ${NO_GUI} = 0 ]; then
        swayfx_build_and_install
        i3blocks_install
        i3blocks_contrib_install
        ghidra_build_and_install
    fi
}
