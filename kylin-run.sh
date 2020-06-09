#!/bin/bash

if [ -z "$1" ]; then
    echo "kylin-app name is empty"
    exit 8
fi

username=$(users)
app_path="/kylin-container"
app_name=$1


function unionfs
{
        echo  "unionfs  $app_path/$app_name/unionfs/$1"
        sudo mount -t aufs -o  dirs=$app_path/$app_name/$1=rw:/$1=ro none $app_path/$app_name/unionfs/$1
}


unionfs "etc"
unionfs "var"
unionfs "usr"


#    --bind /home /home  --bind $app_path/$1/unionfs/etc /etc  --bind $app_path/$1/unionfs/var /var    --bind $app_path/$1/unionfs/usr /usr \

(
    exec bwrap \
    --ro-bind /mnt /mnt --ro-bind /opt /opt   --bind /run /run  --ro-bind /media /media --bind /tmp /tmp --ro-bind /srv /srv --ro-bind /boot /boot --ro-bind /root /root  --ro-bind /dev /dev --ro-bind /proc /proc  --ro-bind /cdrom /cdrom  --ro-bind /snap /snap --ro-bind /sys /sys \
    --ro-bind $app_path/$1 /app \
    --bind /home /home  --bind $app_path/$1/unionfs/etc /etc  --bind $app_path/$1/unionfs/var /var    --ro-bind /$app_path/$1/unionfs/usr /usr \
    --symlink usr/lib /lib \
    --symlink usr/lib64 /lib64 \
    --symlink usr/bin /bin \
    --symlink usr/sbin /sbin \
    --unshare-pid \
    --setenv LD_LIBRARY_PATH /app/usr/lib:/usr/lib/GL \
    --setenv DCONF_USER_CONFIG_DIR .config/dconf \
    --setenv PATH /app/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin \
    --setenv XDG_CONFIG_DIRS /app/etc/xdg:/etc/xdg \
    --setenv XDG_DATA_DIRS /app/usr/share:/usr/share \
    /bin/sh) \
    11< <(getent passwd $UID 65534 ) \
    12< <(getent group $(id -g) 65534)  \
    10<<EOF
[Application]
name=org.videolan.VLC
runtime=runtime/org.kde.Platform/x86_64/5.14
EOF
    #--unshare-pid \
