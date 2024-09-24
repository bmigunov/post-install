#!/bin/bash




if [ -z "${TARGET_USER}" ]; then
    echo "Please set TARGET_USER variable"
else
    if id "${TARGET_USER}" >/dev/null 2>&1; then

        apt-get install wget

        mkdir -p -v "/home/${TARGET_USER}/.config/bash"
        mkdir -p -v "/home/${TARGET_USER}/.local/share/bash"
        mkdir -p -v "/etc/profile.d"
        mkdir -p -v "/etc/sudoers.d"
        mkdir -p -v "/etc/apt/sources.list.d"
        mkdir -p -v "/etc/apt/preferences.d"

        mkdir -p -v "/storage/${TARGET_USER}"
        chown -R "${TARGET_USER}":"${TARGET_USER}" "/storage/${TARGET_USER}"
        mkdir -p -v "/opt/${TARGET_USER}"
        chown -R "${TARGET_USER}":"${TARGET_USER}" "/opt/${TARGET_USER}"

        wget -O "/home/${TARGET_USER}/.profile" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.profile"
        wget -O "/home/${TARGET_USER}/.bashrc" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.bashrc"
        wget -O "/home/${TARGET_USER}/.bash_logout" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.bash_logout"
        wget -O "/home/${TARGET_USER}/.config/bash" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.config/bash/bash_aliases"
        wget -O "/home/${TARGET_USER}/.config/dircolors" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/home/user/.config/dircolors"
        wget -O "/etc/profile.d/xdg-home-path.sh" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/profile.d/xdg-home-path.sh"
        wget -O "/etc/sudoers.d/disable_admin_flag" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/sudoers.d/disable_admin_flag"
        wget -O "/etc/apt/sources.list.d/post-install.list" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/apt/sources.list.d/post-install.list"
        wget -O "/etc/apt/preferences.d/mozilla" --content-disposition "https://raw.githubusercontent.com/bmigunov/luxdesk-configs/refs/heads/master/sparse/etc/apt/preferences.d/mozilla"

        touch /home/"${TARGET_USER}"/.local/share/bash/history

        sed -i.bk '/-security/d;/-updates/d;/# /d' /etc/apt/sources.list
        sed -i 's/trixie/sid/gI' /etc/apt/sources.list
        sed -i 's/main/& contrib non-free/' /etc/apt/sources.list

        apt-get update
        apt-get -y dist-upgrade
        apt-get -y install sudo network-manager neovim ssh git curl gpg
        apt-get -y autoremove
        apt-get clean

        usermod -a -G sudo "${TARGET_USER}"

        rm -v /etc/apt/sources.list~ /var/lib/apt/cdroms.list~

        sed -i.bk '/iface lo inet loopback/q' /etc/network/interfaces

        chown -R "${TARGET_USER}":"${TARGET_USER}" "/home/${TARGET_USER}"

        systemctl reboot
    else
        echo "User not found"
    fi
fi
