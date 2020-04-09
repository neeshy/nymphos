#!/bin/bash
if [ $(id -u) != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

gitprefix="https://gitgud.io/cloveros/cloveros/raw/master"
rootpassword=password
username=livecd
userpassword=password

mkdir libre_image/
cd libre_image/

builddate=$(wget -O - http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/ | sed -nr "s/.*href=\"stage3-amd64-([0-9].*).tar.xz\">.*/\1/p")
wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/stage3-amd64-"$builddate".tar.xz
tar pxf stage3*
rm -f stage3*

cp /etc/resolv.conf etc/
mount -t proc none proc
mount --rbind /dev dev
mount --rbind /sys sys

cat <<HEREDOC | chroot .
emerge-webrsync
emerge -1 unsymlink-lib ; unsymlink-lib --analyze ; unsymlink-lib --migrate ; unsymlink-lib --finish
eselect profile set "default/linux/amd64/17.1/hardened"
echo '
CFLAGS="-O3 -march=native -mfpmath=both -pipe -funroll-loops -fgraphite-identity -floop-nest-optimize -malign-data=cacheline -Wl,--hash-style=gnu"
CXXFLAGS="\${CFLAGS}"
CPU_FLAGS_X86="mmx mmxext sse sse2 ssse3 sse3"
MAKEOPTS="-j8"
PORTAGE_NICENESS=19
PORTAGE_BINHOST="https://cloveros.ga"
EMERGE_DEFAULT_OPTS="--jobs=4 --keep-going=y --autounmask-write=y -G"
ACCEPT_KEYWORDS="**"
binhost_mirrors="\$PORTAGE_BINHOST,https://useast.cloveros.ga,https://uswest.cloveros.ga,https://ca.cloveros.ga,https://fr.cloveros.ga,https://nl.cloveros.ga,https://uk.cloveros.ga,https://au.cloveros.ga,https://sg.cloveros.ga,https://jp.cloveros.ga,"
FETCHCOMMAND_HTTPS="sh -c \"aria2c -x2 -s99 -j99 -k1M -d \"\\\${DISTDIR}\" -o \"\\\${FILE}\" \\\\\\\$(sed -e \"s#,#\\\${DISTDIR}/\\\${FILE}\"\ \"#g\" -e \"s#\$PKGDIR##g\" -e \"s#.partial##g\" <<< \$binhost_mirrors) & aria2c --allow-overwrite -d \"\\\${DISTDIR}\" -o \"\\\${FILE}.asc\" \\\\\\\$(sed -e \"s#,#/s/signatures/\\\${DISTDIR}/\\\${FILE}.asc\"\ \"#g\" -e \"s#\$PKGDIR##g\" -e \"s#.partial##g\" <<< \$binhost_mirrors) && wait && gpg --verify \"\\\${DISTDIR}/\\\${FILE}.asc\" \"\\\${DISTDIR}/\\\${FILE}\" && rm \"\\\${DISTDIR}/\\\${FILE}.asc\"\""' >> /etc/portage/make.conf
while ! gpg --list-keys "CloverOS GNU/Linux (Package signing)"; do gpg --keyserver hkp://pool.sks-keyservers.net --recv-key "78F5 AC55 A120 07F2 2DF9 A28A 78B9 3F76 B8E4 2805"; done
FETCHCOMMAND_HTTPS="wget -O \"\\\${DISTDIR}/\\\${FILE}\" \"\\\${URI}\"" emerge aria2

#emerge gentoo-sources genkernel
#wget https://raw.githubusercontent.com/damentz/liquorix-package/master/linux-liquorix/debian/config/kernelarch-x86/config-arch-64
#genkernel --kernel-config=config-arch-64 all
wget https://cloveros.ga/s/kernel-libre.tar.lzma https://cloveros.ga/s/signatures/s/kernel-libre.tar.lzma.asc
gpg --verify kernel-libre.tar.lzma.asc kernel-libre.tar.lzma && tar xf kernel-libre.tar.lzma
rm kernel-libre.tar.lzma kernel-libre.tar.lzma.asc

emerge grub dhcpcd
rc-update add dhcpcd default

echo "root:$rootpassword" | chpasswd
useradd $username
echo "$username:$userpassword" | chpasswd
gpasswd -a $username wheel

emerge -eDv @world xorg-server fvwm spacefm rxvt-unicode nitrogen compton nomacs sudo wpa_supplicant porthole firefox emacs gimp mpv smplayer rtorrent weechat alsa-utils zsh zsh-completions gentoo-zsh-completions liberation-fonts hack vlgothic nano scrot xbindkeys xinput arandr qastools slock xarchiver p7zip games-envd gparted squashfs-tools os-prober exfat-nofuse sshfs curlftpfs
PORTAGE_BINHOST="https://cloveros.ga/s/nodbus" FETCHCOMMAND_HTTPS="wget -O \"\\\${DISTDIR}/\\\${FILE}\" \"\\\${URI}\"" emerge -1 glib qtgui
emerge --depclean
echo "frozen-files=\"/etc/sudoers\"" >> /etc/dispatch-conf.conf
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/" /etc/sudoers
sed -Ei "s@c([2-6]):2345:respawn:/sbin/agetty 38400 tty@#\0@" /etc/inittab
sed -i "s@c1:12345:respawn:/sbin/agetty 38400 tty1 linux@c1:12345:respawn:/sbin/agetty --noclear 38400 tty1 linux@" /etc/inittab
echo -e "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel\nupdate_config=1" > /etc/wpa_supplicant/wpa_supplicant.conf
rc-update add alsasound
eselect fontconfig enable 52-infinality.conf
eselect infinality set infinality
eselect lcdfilter set infinality
cp /usr/share/zoneinfo/UTC /etc/localtime
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale set en_US.utf8
usermod -aG audio,video,games,input $username
binutils-config --linker ld.gold
cd /home/$username/
rm .bash_profile
wget $gitprefix/home/user/{.bash_profile,.zprofile,.zshrc,.fvwm2rc,.Xdefaults,wallpaper.png,wallpaper43.png,wallpaper1610.png,.xbindkeysrc,screenfetch-dev,cloveros_settings.sh,stats.sh,rotate_screen.sh,.emacs,.rtorrent.rc}
chmod +x screenfetch-dev cloveros_settings.sh stats.sh rotate_screen.sh
mkdir -p .emacs.d/backups/ .emacs.d/autosaves/ Downloads/ .rtorrent/ .mpv/ .config/spacefm/ .config/nitrogen/ .config/nomacs/ Desktop/
sed -i "s@/home/user/@/home/$username/@" .rtorrent.rc
wget $gitprefix/home/user/.mpv/config -P .mpv/
wget $gitprefix/home/user/.config/nitrogen/nitrogen.cfg -P .config/nitrogen/
sed -i "s@/home/user/@/home/$username/@" .config/nitrogen/nitrogen.cfg
wget $gitprefix/home/user/.config/nomacs/Image\ Lounge.conf -P .config/nomacs/
mkdir -p .mozilla/firefox/default/
echo -e "[Profile0]\nName=default\nIsRelative=1\nPath=default\nDefault=1" > .mozilla/firefox/profiles.ini
echo -e "[11457493C5A56847]\nDefault=default" > .mozilla/firefox/installs.ini
wget -O - https://spyware.neocities.org/guides/firefox.html | sed '/user_pref/,\$!d; s/<br>//; /devtools.webide.autoinstallADBHelper/q' > .mozilla/firefox/default/user.js
wget $gitprefix/home/user/.config/spacefm/session -P .config/spacefm/
sed -i "s@/home/user/@/home/$username/@" .config/spacefm/session
wget $gitprefix/home/user/.config/mimeapps.list -P .config/
echo -e "[Desktop Entry]\nEncoding=UTF-8\nType=Link\nName=Home\nIcon=user-home\nExec=spacefm ~/" > Desktop/home.desktop
echo -e "[Desktop Entry]\nEncoding=UTF-8\nType=Link\nName=Applications\nIcon=folder\nExec=spacefm /usr/share/applications/" > Desktop/applications.desktop
cp /usr/share/applications/{firefox.desktop,smplayer.desktop,emacs.desktop,zzz-gimp.desktop,porthole.desktop,xarchiver.desktop} Desktop/
echo -e "~rows=0\n1=home.desktop\n2=applications.desktop\n3=firefox.desktop\n4=smplayer.desktop\n5=emacs.desktop\n6=porthole.desktop\n7=zzz-gimp.desktop\n8=xarchiver.desktop" > .config/spacefm/desktop0
chown -R $username /home/$username/

wget $gitprefix/livecd_install.sh -P /home/$username/
chmod +x /home/$username/livecd_install.sh
sed -i "s@c1:12345:respawn:/sbin/agetty --noclear 38400 tty1 linux@c1:12345:respawn:/sbin/agetty -a $username --noclear 38400 tty1 linux@" /etc/inittab
sed -i "s/^/#/" /home/$username/.bash_profile
echo -e 'if [ -z "\$DISPLAY" ] && [ -z "\$SSH_CLIENT" ] && ! pgrep X > /dev/null; then
X &
export DISPLAY=:0
fvwm &
while sleep 0.2; do if [ -d /proc/\$! ]; then ((i++)); [ "\$i" -gt 6 ] && break; else i=0; fvwm & fi; done
nitrogen --set-zoom wallpaper.png &
sleep 2
xrandroutput=\$(xrandr)
urxvt -geometry 80x24+\$(awk "NR==1{print \\\$8/2-283\"+\"\\\$10/2-191}" <<<\$xrandroutput) -e sudo ./livecd_install.sh &
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1 & xinput list --name-only | sed "/Virtual core pointer/,/Virtual core keyboard/"\!"d;//d" | xargs -I{} xinput set-prop {} "libinput Accel Profile Enabled" 0 1 &> /dev/null &
ratio=\$(awk "NR==1{print substr(\\\$8/\\\$10, 0, 4)}" <<<\$xrandroutput); [ \$ratio == 1.6 ] && nitrogen --set-zoom wallpaper1610.png; [ \$ratio == 1.33 ] && nitrogen --set-zoom wallpaper43.png;
fi' >> /home/$username/.bash_profile

rm -Rf /usr/portage/packages/* /var/cache/binpkgs/* /etc/resolv.conf
exit
HEREDOC

cd ..
umount -l libre_image/*
wget https://cloveros.ga/s/kernel-livecd-libre.tar.lzma
tar -C libre_image/lib/modules/ -xf kernel-livecd-libre.tar.lzma --wildcards \*-aufs/\*
mksquashfs libre_image/ libre_image.squashfs -b 1024k -comp xz -Xbcj x86 -Xdict-size 100%
mkdir libre_iso/
builddate=$(wget -O - http://distfiles.gentoo.org/releases/amd64/autobuilds/current-install-amd64-minimal/ | sed -nr "s/.*href=\"install-amd64-minimal-([0-9].*).iso\">.*/\1/p")
wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-install-amd64-minimal/install-amd64-minimal-$builddate.iso -P libre_iso/
xorriso -osirrox on -indev libre_iso/*.iso -extract / libre_iso/
rm libre_iso/*.iso
mv libre_image.squashfs libre_iso/image.squashfs
tar -xOf kernel-livecd-libre.tar.lzma --wildcards ./kernel-genkernel-x86_64-\* > libre_iso/boot/gentoo
tar -xOf kernel-livecd-libre.tar.lzma --wildcards ./initramfs-genkernel-x86_64-\* | xz -d | gzip > libre_iso/boot/gentoo.igz
tar -xOf kernel-livecd-libre.tar.lzma --wildcards ./System.map-genkernel-x86_64-\* > libre_iso/boot/System-gentoo.map
sed -i "s@dokeymap@aufs@g" libre_iso/isolinux/isolinux.cfg
sed -i "s@dokeymap@aufs@g" libre_iso/grub/grub.cfg
xorriso -as mkisofs -r -J \
	-joliet-long -l -cache-inodes \
	-isohybrid-mbr /usr/share/syslinux/isohdpfx.bin \
	-partition_offset 16 -A "Gentoo Live" \
	-b isolinux/isolinux.bin -c isolinux/boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table  \
	-o CloverOS_Libre-x86_64-$(date +"%Y%m%d").iso libre_iso/
rm -Rf libre_image/ libre_iso/ kernel-livecd-libre.tar.lzma
