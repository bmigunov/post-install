#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of mime-types-related scripts and variables.




export MIME_TYPE_TAR_GZ="application/gzip"
export MIME_TYPE_TAR_XZ="application/x-xz"
export MIME_TYPE_TAR_BZ2="application/x-bzip2"
export MIME_TYPE_ZIP="application/zip"


function mime_types_setup()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    xdg-mime default okularApplication_chm.desktop application/vnd.ms-htmlhelp
    xdg-mime default okularApplication_pdf.desktop application/pdf
    xdg-mime defaul FBReader.desktop application/x-fictionbook+xml
    xdg-mime default darktable.desktop image/x-sony-arw
}
