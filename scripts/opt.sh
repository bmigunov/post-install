#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of opt applications installation scripts.




source $(dirname "${0}")"/mime.sh"


USER_OPT_DIR=/opt/${USER}
LOCAL_OPT_DIR="${HOME}/.local/opt"


function opt_fetch()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Fetching opt application..."

    wget --content-disposition -P "${LOCAL_OPT_DIR}" "${1}"
}

function opt_extract()
{
    OPT_FILES="${LOCAL_OPT_DIR}"/*

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Extracting opt applications..."

    for OPT_FILE in ${OPT_FILES}; do
        OPT_FILENAME=$(basename "${OPT_FILE}")
        APPNAME="${OPT_FILENAME%%.*}"
        OPT_FILE_MIME_TYPE=$(file --mime-type "${OPT_FILE}")

        if [[ "${OPT_FILE_MIME_TYPE}" == *"${MIME_TYPE_TAR_GZ}"* ]]; then
            if [ $(tar --exclude="*/*" -ztf "${OPT_FILE}" | wc -l) -lt 2 ]; then
                tar -v -z -C "${LOCAL_OPT_DIR}" -x -f "${OPT_FILE}"
            else
                mkdir -p -v "${LOCAL_OPT_DIR}"/"${APPNAME}"
                tar -v -z -C "${LOCAL_OPT_DIR}"/"${APPNAME}" -x -f "${OPT_FILE}"
            fi
        elif [[ "${OPT_FILE_MIME_TYPE}" == *"${MIME_TYPE_TAR_XZ}"* ]]; then
            if [ $(tar --exclude="*/*" -Jtf "${OPT_FILE}" | wc -l) -lt 2 ]; then
                tar -v -J -C "${LOCAL_OPT_DIR}" -x -f "${OPT_FILE}"
            else
                mkdir -p -v "${LOCAL_OPT_DIR}"/"${APPNAME}"
                tar -v -J -C "${LOCAL_OPT_DIR}"/"${APPNAME}" -x -f "${OPT_FILE}"
            fi
        elif [[ "${OPT_FILE_MIME_TYPE}" == *"${MIME_TYPE_TAR_BZ2}"* ]]; then
            if [ $(tar --exclude="*/*" -jtf "${OPT_FILE}" | wc -l) -lt 2 ]; then
                tar -v -j -C "${LOCAL_OPT_DIR}" -x -f "${OPT_FILE}"
            else
                mkdir -p -v "${LOCAL_OPT_DIR}"/"${APPNAME}"
                tar -v -j -C "${LOCAL_OPT_DIR}"/"${APPNAME}" -x -f "${OPT_FILE}"
            fi
        elif file --mime-type "${OPT_FILE}" | grep "${MIME_TYPE_ZIP}"; then
            if [ $(7z l -tzip -ba -x'!*/*' "${OPT_FILE}" | wc -l) -lt 2 ]; then
                7z x -tzip -o"${LOCAL_OPT_DIR}" "${OPT_FILE}"
            else
                mkdir -p -v "${LOCAL_OPT_DIR}"/"${APPNAME}"
                7z x -tzip -o"${LOCAL_OPT_DIR}"/"${APPNAME}" "${OPT_FILE}"
            fi
        else
            echo "${FUNCNAME}() warning: unknown archive type" | \
            systemd-cat -p warning -t $0
            echo "Unknown archive type. Skipping without extraction"
        fi

        rm -f "${OPT_FILE}"
    done
}

function opt_install()
{
    PREFIX=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Installing opt apps from the archives..."

    sudo mkdir -p -v ${USER_OPT_DIR}
    sudo chown -r ${USER}:${USER} ${USER_OPT_DIR}
    ln -s "${USER_OPT_DIR}" "${LOCAL_OPT_DIR}"

    if [ ${1} ]; then
        PREFIX="${1}-"
    fi

    COMMON_LIST=$(dirname "$0")"/../data/opt/${PREFIX}common.list"
    GUI_LIST=$(dirname "$0")"/../data/opt/${PREFIX}gui.list"
    GAMES_LIST=$(dirname "$0")"/../data/opt/${PREFIX}games.list"

    for REMOTE in $(cat ${COMMON_LIST}); do
        opt_fetch "${REMOTE}"
    done

    if [ ${NO_GUI} = 0 ]; then
        for REMOTE in $(cat ${GUI_LIST}); do
            opt_fetch "${REMOTE}"
        done
    fi

    if [ ${NO_GAMES} = 0 ]; then
        for REMOTE in $(cat ${GAMES_LIST}); do
            opt_fetch "${REMOTE}"
        done
    fi

    opt_extract
}
