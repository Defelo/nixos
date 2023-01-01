#!/bin/zsh

usage() {
    echo "usage: mnt <device> <mnt>"
}

if ! (return 0 2>/dev/null)
then
    usage
    exit 1
fi

if [[ $# -ne 2 ]]
then
    usage
    return 1
fi

uid=$(id -u)
gid=$(id -g)

if ! lsblk $1 &> /dev/null
then
    echo "'$1' is not a block device"
    return 3
fi

fs=$(lsblk -f $1 | tail -1 | awk '{print $2}')

case $fs in
    ext4 )
        sudo mount $1 $2
        ;;

    vfat | exfat )
        sudo mount -o uid=$uid,gid=$gid $1 $2
        ;;

    * )
        echo "filesystem '$fs' is not supported"
        return 2
        ;;
esac

sudo chown $uid:$gid $2
cd $2
