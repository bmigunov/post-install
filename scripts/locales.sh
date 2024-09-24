#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of scripts to setup system locales.




EN_US_UTF8_LOCALE="en_US.UTF-8 UTF-8"
SUPPORTED_LOCALES_PATH=/usr/share/i18n/SUPPORTED


function locale_add()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Adding locale ${1}"

    if ! grep "${1}" "${SUPPORTED_LOCALES_PATH}"; then
        echo "locales_setup() warning: '${1}' locale is not supported" | \
        systemd-cat -p warning -t $0
        echo "Warning! '${1}' locale is not supported"
    else
        echo ${1} | sudo tee -a /etc/locale.gen
        sudo locale-gen
    fi
}

function locales_setup()
{
    locale_add "${EN_US_UTF8_LOCALE}"

    sudo update-locale LANG=ru_RU.UTF-8
    sudo update-locale LC_CTYPE=ru_RU.UTF-8
    sudo update-locale LC_NUMERIC=ru_RU.UTF-8
    sudo update-locale LC_TIME=ru_RU.UTF-8
    sudo update-locale LC_MONETARY=ru_RU.UTF-8
    sudo update-locale LC_COLLATE=ru_RU.UTF-8
    sudo update-locale LC_MESSAGES=ru_RU.UTF-8
    sudo update-locale LC_PAPER=ru_RU.UTF-8
    sudo update-locale LC_NAME=ru_RU.UTF-8
    sudo update-locale LC_ADDRESS=ru_RU.UTF-8
    sudo update-locale LC_TELEPHONE=ru_RU.UTF-8
    sudo update-locale LC_MEASUREMENT=ru_RU.UTF-8
    sudo update-locale LC_IDENTIFICATION=ru_RU.UTF-8
}
