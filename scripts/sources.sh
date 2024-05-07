#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of scripts to install binaries from source.




source $(dirname "${0}")"/git.sh"
source $(dirname "${0}")"/mutt.sh"


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

    pushd "${SRC_DIR}/qcomlt/qdl"
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

function vim_plug_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing vim-plug..."

    mkdir -p -v "${XDG_DATA_HOME}/nvim/site/autoload"
    cp --backup=none -v "${SRC_DIR}/junegunn/vim-plug/plug.vim" \
       "${XDG_DATA_HOME}/nvim/site/autoload/plug.vim"
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
    openvpn3_install
    yate_build_and_install
    vim_plug_install

    luxdesk_configs_install
}
