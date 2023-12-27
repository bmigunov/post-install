#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of scripts to setup bash.




function bash_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Setting up bash history file..."

    BASH_HISTFILE_DIR="${XDG_DATA_HOME}/bash"

    mkdir -p -v "${BASH_HISTFILE_DIR}"
    if [ -e "${HOME}"/.bash_history ]; then
        mv "${HOME}"/.bash_history "${BASH_HISTFILE_DIR}"
    else
        echo                                                                              \
        "${FUNCNAME}(): no .bash_history file in home directory; creating new empty file" \
        | systemd-cat -p debug -t $0
        touch "${BASH_HISTFILE_DIR}/bash_history"
    fi
}
