#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of systemd-related scripts.




function systemd_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    sudo systemctl stop ModemManager.service
    sudo systemctl disable ModemManager.service

    sudo systemctl enable ly.service

    sudo systemctl stop mpd.service
    sudo systemctl --system disable mpd.service
    systemctl --user enable mpd.service

    sudo systemctl daemon-reload
}
