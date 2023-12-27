#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of language servers-related bash functions.




function language_servers_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

if [ ! -x /usr/local/bin/qmlls ]; then
    sudo ln -s /usr/lib/qt6/bin/qmlls /usr/local/bin/qmlls
fi

sudo cpan Perl::LanguageServer

composer update
}
