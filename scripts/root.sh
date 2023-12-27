#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Bash functions to setup root user.




function root_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    sudo cp --backup=none ~/.config/dircolors /root/.config/dircolors
}
