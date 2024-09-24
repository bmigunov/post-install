#!/bin/bash
#
# Authors:
#   Bogdan Migunov <bogdanmigunov@yandex.ru>
#
# Description:
#   Set of scripts to manage source code downloads via git.




function github_ssh_keys_store()
{
    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0

    SSH_ID_RSA_PUB=$(cat ~/.ssh/main.pub)

    curl -X POST -H "Accept: application/vnd.github+json"  \
         -H "Authorization: Bearer ${GITHUB_KEY_RW_TOKEN}" \
         -H "X-GitHub-Api-Version: 2022-11-28"             \
         https://api.github.com/user/keys                  \
         -d "{\"title\":\"${USER}@${HOSTNAME}\",\"key\":\"${SSH_ID_RSA_PUB}\"}"
}

function git_repo_clone()
{
    TARGET=

    echo "${FUNCNAME}()" | systemd-cat -p debug -t $0
    echo "Cloning git repo..."

    GIT_REPO_NAME=$(basename ${1})
    REPO_DIRNAME=${GIT_REPO_NAME%.*}
    REPO_PARENT_DIRNAME=$(echo "${1}" | awk -F[/:] '{print $(NF - 1)}')

    if [ "${2}" ]; then
        TARGET="${2}"/"${REPO_DIRNAME}"
    else
        TARGET="${LXD_SRC_DIR}"/"${REPO_PARENT_DIRNAME}"/"${REPO_DIRNAME}"
    fi

    git clone --recurse-submodules "${1}" "${TARGET}"
}
