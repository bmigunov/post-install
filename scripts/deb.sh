#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of functions to control deb-packages installation process.




REMOTE_DEB_TMPDIR=/tmp/remote_deb


function is_package_installed()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t ${0}

    sudo dpkg-query -W --showformat='${Status}\n' $@ | \
    grep "install ok installed" &> /dev/null
    echo $?
}

function packages_list_apt_install_loop()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t ${0}

    for PACKAGE in $(cat "${1}"); do
        if [ $(is_package_installed ${PACKAGE}) != 0 ]; then
            echo "Package '$PACKAGE' is not installed. Installing..." | \
            systemd-cat -p debug -t ${0}
            sudo apt-get -y install ${PACKAGE}

            if [[ $? != 0 ]]; then
                echo "packages_list_apt_install_loop() failure: issue installing package '${PACKAGE}'" | \
                systemd-cat -p warning -t ${0}
                echo "Issue installing '$PACKAGE'."
            fi
        else
            echo "Package '$PACKAGE' is installed."
        fi
    done
}

function deb_packages_install_from_lists()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t ${0}

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "${0}")"/../data/deb/${PREFIX}common.list"
    GUI_LIST=$(dirname "${0}")"/../data/deb/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "${0}")"/../data/deb/${PREFIX}games.list"

    packages_list_apt_install_loop "${COMMON_LIST}"

    if [ ${NO_GUI} = 0 ]; then
        packages_list_apt_install_loop "${GUI_LIST}"
    fi

    if [ ${NO_GAMES} = 0 ]; then
        packages_list_apt_install_loop "${GAMES_LIST}"
    fi
}

function remote_deb_packages_install_from_lists()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t ${0}
    echo "Installing remote packages..."

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "${0}")"/../data/deb/remote/${PREFIX}common.list"
    GUI_LIST=$(dirname "${0}")"/../data/deb/remote/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "${0}")"/../data/deb/remote/${PREFIX}games.list"

    mkdir -p -v "${REMOTE_DEB_TMPDIR}"

    for REMOTE in $(cat "${COMMON_LIST}"); do
        wget --content-disposition -P "${REMOTE_DEB_TMPDIR}" "${REMOTE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for REMOTE in $(cat "${GUI_LIST}"); do
            wget --content-disposition -P "${REMOTE_DEB_TMPDIR}" "${REMOTE}"
        done
    fi

    if [ ${NO_GAMES} = 0 ]; then
        for REMOTE in $(cat "${GAMES_LIST}"); do
            wget --content-disposition -P "${REMOTE_DEB_TMPDIR}" "${REMOTE}"
        done
    fi

    sudo dpkg -i "${REMOTE_DEB_TMPDIR}"/*
    sudo apt-get -f -y install

    rm -rf "${REMOTE_DEB_TMPDIR}"
}

function prerequisites_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t ${0}

    packages_list_apt_install_loop $(dirname "${0}")"/../data/deb/prerequisites.list"
}

function deb_packages_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t ${0}
    echo "Installing deb packages..."

    deb_packages_install_from_lists ${1}
    remote_deb_packages_install_from_lists ${1}
}

function deb_cleanup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t ${0}
    echo "deb cleanup..."

    sudo apt-get -y autoremove
    sudo apt-get clean
    sudo dpkg --purge \
              $(COLUMNS=200 dpkg -l | grep '^rc' | tr -s ' ' | cut -d ' ' -f 2)
}
