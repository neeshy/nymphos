#!/bin/bash
if [ $(id -u) != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

while :; do
	echo
	read -erp "Automatic partitioning (a) or manual partitioning? (m) [a/m] " -n 1 partitioning
	if [[ $partitioning = "a" ]]; then
		read -erp "Enter drive for CloverOS installation: " -i "/dev/sda" drive
		partition=${drive}1
	elif [[ $partitioning = "m" ]]; then
		gparted &> /dev/null &
		read -erp "Enter partition for CloverOS installation: " -i "/dev/sda1" partition
		read -erp "Enter drive that contains install partition: " -i ${partition%${partition##*[!0-9]}} drive
	else
		echo "Invalid option"
		continue
	fi
	drive=${drive#*/dev/}
	partition=${partition#*/dev/}
	read -erp "Partitioning: $partitioning
Drive: /dev/$drive
Partition: /dev/$partition
Is this correct? [y/n] " -n 1 yn
	if [[ $yn == "y" ]]; then
		break
	fi
done

while :; do
	echo
	read -erp "Enter preferred root password " rootpassword
	read -erp "Enter preferred username " username
	newuser=$(echo "$username" | tr A-Z a-z | tr -cd "[:alpha:][:digit:]" | sed "s/^[0-9]\+//" | cut -c -31)
	if [[ "$newuser" != "$username" ]]; then
		username=$newuser
		echo username changed to $username
	fi
	read -erp "Enter preferred user password " userpassword
	read -erp "Is this correct? [y/n] " -n 1 yn
	if [[ $yn == "y" ]]; then
		break
	fi
done

livecduser=livecd

mkdir gentoo/

if [[ $partitioning = "a" ]]; then
	echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/$drive
	mkfs.ext4 -F /dev/$partition
fi
mount /dev/$partition gentoo

unsquashfs -f -d gentoo /mnt/cdrom/image.squashfs

cd gentoo/
mount -t proc none proc
mount --rbind /dev dev
mount --rbind /sys sys

cat <<HEREDOC | chroot .
echo "root:$rootpassword" | chpasswd
useradd -M $username
echo "$username:$userpassword" | chpasswd
gpasswd -a $username wheel

grub-install --target=i386-pc /dev/$drive &> /dev/null
grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null
sed -i "s/set timeout=5/set timeout=0/" /boot/grub/grub.cfg

sed -i "s@c1:12345:respawn:/sbin/agetty -a $livecduser --noclear 38400 tty1 linux@c1:12345:respawn:/sbin/agetty --noclear 38400 tty1 linux@" /etc/inittab
sed -i '/^#/!d' /home/$livecduser/.bash_profile
sed -i "s/^#\(.*\)/\1/g" /home/$livecduser/.bash_profile
rm -Rf /home/$livecduser/livecd_install.sh /lib/modules/*aufs*

sed -i "s@/home/$livecduser/@/home/$username/@" /home/$livecduser/.rtorrent.rc
sed -i "s@/home/$livecduser/@/home/$username/@" /home/$livecduser/.config/nitrogen/nitrogen.cfg
sed -i "s@/home/$livecduser/@/home/$username/@" /home/$livecduser/.config/spacefm/session
mv /home/$livecduser/ /home/$username/
chown -R $username /home/$username/
if [[ $username != $livecduser ]]; then
	userdel $livecduser
fi
usermod -aG audio,video,games,input $username

exit
HEREDOC

cd ..
umount -l gentoo/*
umount gentoo/
sync
echo Installed, you can reboot and remove install media now
exec sudo -u $livecduser zsh
