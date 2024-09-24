#!/bin/bash




if [ -z "${TARGET_USER}" ]; then
    echo "Please set TARGET_USER variable"
else
    if id "${TARGET_USER}" >/dev/null 2>&1; then
        sed -i.bk '/iface lo inet loopback/q' /etc/network/interfaces

        sed -i.bk '/-security/d;/-updates/d;/# /d' /etc/apt/sources.list
        sed -i 's/trixie/sid/gI' /etc/apt/sources.list
        sed -i 's/main/& contrib non-free/' /etc/apt/sources.list

        wget -P /etc/apt/sources.list.d --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/apt/sources.list.d/post-install.list"

        apt-get update
        apt-get -y dist-upgrade
        apt-get -y install sudo network-manager neovim ssh git curl wget gpg
        apt-get -y autoremove
        apt-get clean

        usermod -a -G sudo "${TARGET_USER}"

        mkdir -p -v "/storage/${TARGET_USER}"
        chown -R "${TARGET_USER}":"${TARGET_USER}" "/storage/${TARGET_USER}"
        mkdir -p -v "/opt/${TARGET_USER}"
        chown -R "${TARGET_USER}":"${TARGET_USER}" "/opt/${TARGET_USER}"

        rm -v /etc/apt/sources.list~ /var/lib/apt/cdroms.list~

        mkdir -p -v /etc/profile.d
        wget -P /etc/profile.d --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/profile.d/xdg-home-path.sh"

        mkdir -p -v /etc/sudoers.d
        wget -P /etc/sudoers.d --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/sudoers.d/disable_admin_flag"

        mkdir -p -v /etc/apt/sources.list.d
        mkdir -p -v /etc/apt/preferences.d
        wget -P /etc/apt/sources.list.d --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/apt/sources.list.d/post-install.list"
        wget -P /etc/apt/preferences.d --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/apt/preferences.d/mozilla"

        mkdir -p -v /home/"${TARGET_USER}"/.config/bash
        mkdir -p -v /home/"${TARGET_USER}"/.local/share/bash
        touch /home/"${TARGET_USER}"/.local/share/bash/history
        wget -P /home/"${TARGET_USER}" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.profile"
        wget -P /home/"${TARGET_USER}" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.bashrc"
        wget -P /home/"${TARGET_USER}/.config/bash" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.config/bash/bash_aliases"
        wget -P /home/"${TARGET_USER}/.config" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.config/dircolors"

        chown -R "${TARGET_USER}":"${TARGET_USER}" "/home/${TARGET_USER}"

        systemctl reboot
    else
        echo "User not found"
    fi
fi
