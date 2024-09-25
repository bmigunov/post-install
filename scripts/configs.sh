#!/bin/bash




function mutt_accounts_obtain()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    if [ -n ${MUTT_ACCOUNTS_GPG_REMOTE} ]; then
        wget -O "${XDG_CONFIG_HOME}/mutt/accounts.gpg" "${MUTT_ACCOUNTS_GPG_REMOTE}"
    else
        echo "${FUNCNAME}() issue: accounts.gpg link is not provided" | \
        systemd-cat -p warning -t $0
    fi
}

function configs_install()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing LuxDesk configs..."

    cp --backup=none -rv \
       "${LXD_SRC_DIR}/bmigunov/luxdesk-configs/sparse/home/user/.config" "${HOME}" | \
       systemd-cat -p info -t $0

    sudo cp --backup=none -rv \
            "${LXD_SRC_DIR}/bmigunov/luxdesk-configs/sparse/etc/ly" "/etc" | \
    systemd-cat -p info -t $0

    mutt_accounts_obtain

    touch "${XDG_CONFIG_HOME}/dosbox/dosbox.conf"

    touch "${XDG_CACHE_HOME}/mpd/tag_cache"
    touch "${XDG_CACHE_HOME}/mpd/sticker.sql"
    touch "${XDG_STATE_HOME}/mpd-state"
}
