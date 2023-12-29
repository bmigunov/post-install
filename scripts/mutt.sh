#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of mutt-related scripts.




function mutt_accounts_obtain()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    mkdir -p -v "${XDG_CONFIG_HOME}"/mutt

    if [ ${MUTT_ACCOUNTS_GPG_REMOTE} ]; then
        wget -O "${XDG_CONFIG_HOME}"/mutt/accounts.gpg "${MUTT_ACCOUNTS_GPG_REMOTE}"
    else
        echo "${FUNCNAME}() issue: accounts.gpg link is not provided" | \
        systemd-cat -p warning -t $0
    fi
}
