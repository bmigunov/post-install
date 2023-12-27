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
        mkdir -p -v ${POST_INSTALL_BACKUP_DIR}/etc
        cp /etc/locale.gen "${POST_INSTALL_BACKUP_DIR}"/etc
        echo ${1} | sudo tee -a /etc/locale.gen
        sudo locale-gen
    fi
}

function locales_setup()
{
    locale_add "${EN_US_UTF8_LOCALE}"
}
