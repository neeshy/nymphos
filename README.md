# cloveros
<img src="https://gitgud.io/cloveros/cloveros/raw/master/artwork/logo.png" alt="CloverOS logo" width="800" />

<img src="https://gitgud.io/cloveros/cloveros/raw/master/artwork/desktop.png" alt="CloverOS GNU/Linux Desktop" width="250" />

These scripts creates CloverOS GNU/Linux; a minimal (middleware-free) and default out-of-the-box Gentoo image (stage4) and a performance-optimized packages repo (Binhost)

Mirrors and binary details: https://useast.cloveros.ga https://uswest.cloveros.ga https://ca.cloveros.ga https://fr.cloveros.ga https://nl.cloveros.ga https://au.cloveros.ga https://uk.cloveros.ga https://sg.cloveros.ga https://jp.cloveros.ga

Objectives: Lowest RAM usage desktop, no changes to Gentoo and kept as default as possible, easily install any package in its ideal form with emerge, easy out-of-the-box desktop, best CFLAGS

## System Requirements
x86_64 CPU that supports SSSE3 (Core 2 Duo, AMD FX and higher), 5GB of disk space, 64-128MB RAM depending on video driver

## Cheat sheet
### Installing program
`sudo emerge filezilla`

### Upgrading system
```
sudo emerge --sync
sudo emerge -uavD @world
sudo emerge --depclean || sudo emerge -u1 virtual/perl-File-Spec dev-perl/Locale-gettext dev-perl/libintl-perl virtual/perl-ExtUtils-MakeMaker dev-libs/icu dev-libs/boost dev-perl/Unicode-EastAsianWidth sys-apps/texinfo virtual/perl-ExtUtils-MakeMaker dev-perl/Text-Unidecode dev-perl/XML-Parser && sudo emerge --depclean
```

### Updating config files after upgrading system (Optional)
`sudo dispatch-conf`

After you run it, it will show you the changes to config files it's going to make:

q To quit without making changes

u To update and make the changes

z To zap and disregard the changes

Hit z if you're not sure or wish to keep your configuration files the same.

### Controlling fvwm
Open Applications menu: right click on desktop

Move windows: alt + left click

Resize Windows: alt + right click

Open Applications menu anywhere: alt + middle click

Switch windows: alt + tab and shift + alt + tab

Switch desktops: ctrl + shift + up/down/left/right (desktops are in a 3x3 grid)

Take screenshot: Print Screen

Lock: super + L

Brightness controls: Laptop (software) Brightness up/down keys

Volume control: Laptop (software) Volume up/down keys

fvwm's settings are in `~/.fvwm2rc`

### Setting default sound device
Run `./cloveros_settings.sh 3`

Or:

Run `alsamixer` and hit F6 to see your audio devices.

To make 1 the default device, edit `~/.asoundrc` and add this:

```
defaults.pcm.card 1
defaults.ctl.card 1
```

### Included software
Window manager - fvwm

Terminal - urxvt

File manager - spacefm

Wifi configuration - wpa_gui

Browser - firefox

Text editor - emacs

Graphic editor - gimp

Video player - smplayer / mpv

Image Viewer - nomacs

Archiver - xarchiver

FTP client - sshfs / curlftpfs

Torrent client - rtorrent

IRC client - weechat

### Listing available packages
Use `porthole` or `eix`

Web interface: https://packages.gentoo.org

List of binaries (no dependencies): https://gitgud.io/cloveros/cloveros/blob/master/binhost_settings/var/lib/portage/world

List of all binaries: https://cloveros.ga/s/packages.html

### Package isn't available
Make an issue so I can add the package to binhost. In the meantime, install from source using `~/cloveros_settings.sh 5 ; sudo emerge [package] ; ~/cloveros_settings.sh 5`

### Switching to source

Switch to source by running `./cloveros_settings.sh 5`

Or:

Edit `/etc/portage/make.conf` and edit the following lines:

```
EMERGE_DEFAULT_OPTS="--keep-going=y --autounmask-write=y --jobs=4 -G"
ACCEPT_KEYWORDS="**"
FETCHCOMMAND_HTTPS="...
```

to

```
#EMERGE_DEFAULT_OPTS="--keep-going=y --autounmask-write=y --jobs=4 -G"
#ACCEPT_KEYWORDS="**"
#FETCHCOMMAND_HTTPS="...
```

This disables the binhost and uses Portage's ebuilds for packages. Now you can emerge from source.

## FAQ
### Table of contents
* [What is CloverOS?](#what-is-cloveros)
* [How do I install systemd/avahi/pulseaudio?](#how-do-i-install-systemdavahipulseaudio)
* [It hangs on boot in VirtualBox](#it-hangs-on-boot-in-virtualbox)
* [Nvidia card crashes on boot with a green screen](#nvidia-card-crashes-on-boot-with-a-green-screen)
* [Using old Radeon card with new video drivers](#using-old-radeon-card-with-new-video-drivers)
* [Installing proprietary Nvidia drivers](#installing-proprietary-nvidia-drivers)
* [Installing bumblebee for laptops](#installing-bumblebee-for-laptops)
* [Installing VirtualBox](#installing-virtualbox)
* [Wine with esync](#wine-with-esync)
* [Steam stops working](#steam-stops-working)
* [What are USE flags?](#what-are-use-flags)
* [What are keywording and unmasking?](#what-are-keywording-and-unmasking)
* [Emerge error relating to openssl](#emerge-error-relating-to-openssl-fix-opengl-34-not-working)
* [GPU passthrough example](#gpu-passthrough-example)
* [Change FVWM titlebar color](#change-fvwm-titlebar-color)
* [KDE theme in qt5 programs without KDE](#kde-theme-in-qt5-programs-without-kde)
* [Firefox and Pulseaudio](#firefox-and-pulseaudio)
* [Vertical tabs in Firefox 57+](#vertical-tabs-in-firefox-57)
* [Enable tap to click on touchpads](#enable-tap-to-click-on-touchpads)
* [Disable mouse acceleration](#disable-mouse-acceleration)
* [Suspend when laptop lid is closed](#suspend-when-laptop-lid-is-closed)
* [Dnscrypt-proxy howto](#dnscrypt-proxy-howto)
* [Clean outdated kernels](#clean-outdated-kernels)
* [Sound in OBS (Open Broadcaster Software) using ALSA](#sound-in-obs-open-broadcaster-software-using-alsa)
* [Bluetooth audio using ALSA](#bluetooth-audio-using-alsa)
* [Install Quake 3](#install-quake-3)
* [What is Gentoo?](#what-is-gentoo)
* [Is this an overlay?](#is-this-an-overlay)
* [Benefits of Gentoo/CloverOS over other distros](#benefits-of-gentoocloveros-over-other-distros)
* [What is CloverOS Libre?](#what-is-cloveros-libre)
* [Turning CloverOS into CloverOS Libre](#turning-cloveros-into-cloveros-libre)
* [Turning CloverOS Libre into CloverOS](#turning-cloveros-libre-into-cloveros)
* [Starting X automatically after login](#starting-x-automatically-after-login)
* [I want to bypass the mixer to play >48KHz audio / DSD](#i-want-to-bypass-the-mixer-to-play-48khz-audio-dsd)
* [Wayland howto](#wayland-howto)
* [Things preventing CloverOS Libre from being 100% free software:](#things-preventing-cloveros-libre-from-being-100-free-software)
* [Does CloverOS have binaries?](#does-cloveros-have-binaries)
* [How often is this updated?](#how-often-is-this-updated)
* [Does everything build with CFLAGS="-Ofast -mssse3 -mfpmath=both -pipe -funroll-loops -flto=8 -fgraphite-identity -floop-nest-optimize -malign-data=cacheline -mtls-dialect=gnu2 -Wl,--hash-style=gnu"](#does-everything-build-with-cflags-ofast-mssse3-mfpmathboth-pipe-funroll-loops-flto8-fgraphite-identity-floop-nest-optimize-malign-datacacheline-mtls-dialectgnu2-wl-hash-stylegnu)
* [The default shell is bash but fvwm launches urxvt -e zsh?](#the-default-shell-is-bash-but-fvwm-launches-urxvt-e-zsh)
* [Which DE does this come with?](#which-de-does-this-come-with)
* [Installing a DE](#installing-a-de)
* [I want to host a mirror](#i-want-to-host-a-mirror)
* [Disabling Intel mitigations for performance](#disabling-intel-mitigations-for-performance)
* [Recompiling all packages and kernel with -march=native for increased performance](#recompiling-all-packages-and-kernel-with-marchnative-for-increased-performance)
* [What if CloverOS dies? Will my install become useless?](#what-if-cloveros-dies-will-my-install-become-useless)

### What is CloverOS?
It's a default Gentoo install with a binary packages repo. I made it to make my life easier.

### How do I install systemd/avahi/pulseaudio?
Switch to source and then emerge

### It hangs on boot in VirtualBox
In VirtualBox 6.x, change Graphics Controller to VBoxSVGA. This fixes the "Setting system clock using the hardware clock [UTC] ..." hang.

![VirtualBox graphics adapters](https://i.imgur.com/pTtWptS.png)

### Nvidia card crashes on boot with a green screen
/etc/modprobe.d/blacklist.conf:

```
blacklist vga16fb
blacklist nouveau
blacklist rivafb
blacklist nvidiafb
blacklist rivatv
```

/boot/grub/grub.cfg:

```
linux   /boot/kernel-genkernel-x86_64-[ver]-gentoo root=UUID=[id] ro nomodeset nouveau.modeset=0
```

### Using old Radeon card with new video drivers
```
sudo rmmod -f radeon && sudo modprobe amdgpu si_support=1
```

### Installing proprietary Nvidia drivers
```
sudo EMERGE_DEFAULT_OPTS="" emerge \=gentoo-sources-$(uname -r | sed 's/-.*//')
sudo eselect kernel set linux-$(uname -r)
sudo wget https://raw.githubusercontent.com/damentz/liquorix-package/$(uname -r | sed 's/\.[^.]*$//')/linux-liquorix/debian/config/kernelarch-x86/config-arch-64 -O /usr/src/linux/.config
sudo sed -i "s/CONFIG_CRYPTO_CRC32C=m/CONFIG_CRYPTO_CRC32C=y/; s/CONFIG_FW_LOADER_USER_HELPER=y/CONFIG_FW_LOADER_USER_HELPER=n/; s/CONFIG_I2C_NVIDIA_GPU=/#CONFIG_I2C_NVIDIA_GPU=/" /usr/src/linux/.config
sudo emerge nvidia-drivers
sudo depmod
sudo eselect opengl set nvidia
sudo eselect opencl set nvidia
sudo sh -c 'echo -e "blacklist nouveau\nblacklist vga16fb\nblacklist rivafb\nblacklist nvidiafb\nblacklist rivatv" >> /etc/modprobe.d/blacklist.conf'
```

Reboot

or

Kill X, `sudo rmmod -f nouveau vga16fb rivafb nvidiafb rivatv && sudo modprobe nvidia` and restart X

### Installing bumblebee for laptops
This is for laptops that have both Intel GPU and Nvidia GPU with Optimus

```
sudo emerge bumblebee
sudo depmod
sudo sed -i 's/^Driver=$/Driver=nvidia/; s/^Bridge=auto$/Bridge=primus/; s/^VGLTransport=proxy$/VGLTransport=rgb/; s/^KernelDriver=$/KernelDriver=nvidia/; s/^PMMethod=auto$/PMMethod=bbswitch/; s@^LibraryPath=$@LibraryPath=/usr/lib64/opengl/nvidia/lib:/usr/lib/opengl/nvidia/lib@; s@^XorgModulePath=$@XorgModulePath=/usr/lib64/opengl/nvidia/lib,/usr/lib64/opengl/nvidia/extensions,/usr/lib64/xorg/modules/drivers,/usr/lib64/xorg/modules@' /etc/bumblebee/bumblebee.conf
```

### Installing VirtualBox
```
sudo emerge virtualbox
sudo depmod
./cloveros_settings.sh 4
sudo useradd -g $USER vboxusers
sudo modprobe -a vboxdrv vboxnetadp vboxnetflt
```

Reboot if your kernel isn't up to date.

### Wine with esync
First run:
```
sudo sh -c "echo $USER\ N524288 >> /etc/limits"
```

To enable esync, use environment variable `export WINEESYNC=1` This can be added to `~/.zshrc` or `~/.bashrc`

### Steam stops working
Start steam with `rm -R ~/.steam/ && steam &`

### What are USE flags?
`/etc/portage/package.use` generally determines what your Gentoo install will look like. The first thing new Gentoo users should do is read the USE flags for their packages.

https://packages.gentoo.org/packages/media-gfx/gimp

There's two types of USE flags that are treated equally: global and local.

Global USE flags are the ones that are in many packages, they generally do the same thing no matter what package uses them.

Local USE flags are the ones that are in a few packages and require you to read https://packages.gentoo.org to read what they do. You can also read the .ebuild to get an even better idea of what it does.

USE flags are basically ./configure parameters made easy.

Examples here:

https://gitgud.io/cloveros/cloveros/blob/master/binhost_settings/etc/portage/make.conf

https://gitgud.io/cloveros/cloveros/blob/master/binhost_settings/etc/portage/package.use

### What are keywording and unmasking?
https://packages.gentoo.org/packages/media-gfx/gimp

See the green and the yellow? Green means you can just `emerge gimp` and get that version. But what if you want 2.9? It's keyworded, which means it isn't stable.

Gentoo Stable is using packages that aren't keyworded, as in they're tested and guaranteed to work.

Just add media-gfx/gimp to /etc/portage/package.keywords and you'll get the latest keyworded (Yellow) version.

Masked (Red) is just another step forward of keywording and the file is at /etc/portage/package.unmask

You can unmask or unkeyword a specific version by doing =media-gfx/gimp-2.9.6

### Emerge error relating to openssl, fix OpenGL 3/4 not working
Add this to `/etc/portage/package.use`:
```
dev-libs/openssl -bindist
net-misc/openssh -bindist
media-libs/mesa -bindist
```

### GPU passthrough example
```
# fallocate -l 32GB drive && lspci

sudo sh -c '
modprobe vfio-pci
devices=(01:00.0 01:00.1 00:12.0 00:12.2)

for devid in ${devices[@]}; do devid=0000:$devid
	echo $(</sys/bus/pci/devices/$devid/vendor) $(</sys/bus/pci/devices/$devid/device) > /sys/bus/pci/drivers/vfio-pci/new_id
	echo $devid > /sys/bus/pci/devices/$devid/driver/unbind
	echo $devid > /sys/bus/pci/drivers/vfio-pci/bind
	echo $(</sys/bus/pci/devices/$devid/vendor) $(</sys/bus/pci/devices/$devid/device) > /sys/bus/pci/drivers/vfio-pci/remove_id
done

qemu-system-x86_64 -enable-kvm -m 4G -cpu host -smp cores=8,threads=1 -vga none -display none -cdrom windows.iso -drive if=pflash,format=raw,readonly,file=/usr/share/edk2-ovmf/OVMF_CODE.fd -drive if=pflash,format=raw,file=/usr/share/edk2-ovmf/OVMF_VARS.fd -drive file=drive,format=raw $(sed "s/ / -device vfio-pci,host=/g" <<< \ ${devices[@]})

for devid in ${devices[@]}; do devid=0000:$devid
	echo 1 > /sys/bus/pci/devices/$devid/remove
	echo 1 > /sys/bus/pci/rescan
done
'
```

### Change FVWM titlebar color
```
color=69aEb6; sed -i "s/\(Style \* BackColor \).*/\1#$color/; s/\(Style \* HilightBack \).*/\1#$color/; s/\(Colorset 1 bg #\)......\(.*\)/\1$color\2/" ~/.fvwm2rc && killall fvwm && fvwm &
```

Alternatively, replace every instance of #056839 (green) manually.

### KDE theme in qt5 programs without KDE
```
sudo emerge qt5ct breeze
QT_QPA_PLATFORMTHEME="qt5ct" qt5ct
QT_QPA_PLATFORMTHEME="qt5ct" your_program
```

Open qt5ct and switch the style and the icon theme to Breeze.

![Breeze theme](https://i.imgur.com/WZLQTV0.png)

### Firefox and Pulseaudio
Firefox 57+ still works with ALSA. If this changes, it will be built with apulse.

### Vertical tabs in Firefox 57+
https://addons.mozilla.org/en-US/firefox/addon/vertical-tabs-reloaded/

`mkdir ~/.mozilla/firefox/*.default/chrome/`

`nano ~/.mozilla/firefox/*.default/chrome/userChrome.css`

```
@namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"); /* set default namespace to XUL */
/* Hide Horizontal TAB Bar */
#TabsToolbar {
 visibility: collapse !important;
}
/* Hide White Header Tab Tree */
#sidebar-header {
 display: none;
}
```

![Firefox](https://i.imgur.com/z6NaM5a.png)

To have built-in tab list button available at all times:

`~/.mozilla/firefox/*.default/chrome/userChrome.css`
```
#alltabs-button {
    visibility: visible !important;
}
```

### Enable tap to click on touchpads
`xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1`

### Disable mouse acceleration
`xinput list --id-only | xargs -I{} xinput set-prop {} "libinput Accel Profile Enabled" 0 1 &>/dev/null`

### Suspend when laptop lid is closed
First run `emerge acpid && /etc/init.d/acpid start`

Edit `/etc/acpi/default.sh`:

```
#!/bin/sh
# /etc/acpi/default.sh
# Default acpi script that takes an entry for all actions

set $*

group=${1%%/*}
action=${1#*/}
device=$2
id=$3
value=$4

log_unhandled() {
	logger "ACPI event unhandled: $*"
}

case "$group" in
	button)
		case "$action" in
			lid)
				case "$id" in
					close) echo -n mem > /sys/power/state;;
				esac
				;;

			power)
				/etc/acpi/actions/powerbtn.sh
				;;

			# if your laptop doesnt turn on/off the display via hardware
			# switch and instead just generates an acpi event, you can force
			# X to turn off the display via dpms.  note you will have to run
			# 'xhost +local:0' so root can access the X DISPLAY.
			#lid)
			#	xset dpms force off
			#	;;

			*)	log_unhandled $* ;;
		esac
		;;

	ac_adapter)
		case "$value" in
			# Add code here to handle when the system is unplugged
			# (maybe change cpu scaling to powersave mode).  For
			# multicore systems, make sure you set powersave mode
			# for each core!
			#*0)
			#	cpufreq-set -g powersave
			#	;;

			# Add code here to handle when the system is plugged in
			# (maybe change cpu scaling to performance mode).  For
			# multicore systems, make sure you set performance mode
			# for each core!
			#*1)
			#	cpufreq-set -g performance
			#	;;

			*)	log_unhandled $* ;;
		esac
		;;

	*)	log_unhandled $* ;;
esac
```

### Dnscrypt-proxy howto
```
sudo emerge dnscrypt-proxy
sudo /etc/init.d/dnscrypt-proxy start
sudo rc-config add dnscrypt-proxy
sudo sh -c 'echo "static domain_name_servers=127.0.0.1" >> /etc/dhcpcd.conf'
sudo /etc/init.d/dhcpcd restart
```

### Clean outdated kernels
`sudo find /boot/ /lib/modules/ -mindepth 1 -maxdepth 1 -name \*gentoo\* ! -name \*$(uname -r) -exec rm -R {} \;`

### Sound in OBS / Open Broadcaster Software using ALSA
Run `sudo modprobe snd_aloop` and edit the following file, replacing `device 0` and `hw:0,0` with your sound device:

`~/.asoundrc`

```
    pcm.!default {
      type asym
      playback.pcm "LoopAndReal"
      capture.pcm "looprec"
    }

    pcm.looprec {
        type hw
        card "Loopback"
        device 0
        subdevice 0
    }

    pcm.LoopAndReal {
      type plug
      slave.pcm mdev
      route_policy "duplicate"
    }

    pcm.mdev {
      type multi
      slaves.a.pcm pcm.MixReale
      slaves.a.channels 2
      slaves.b.pcm pcm.MixLoopback
      slaves.b.channels 2
      bindings.0.slave a
      bindings.0.channel 0
      bindings.1.slave a
      bindings.1.channel 1
      bindings.2.slave b
      bindings.2.channel 0
      bindings.3.slave b
      bindings.3.channel 1
    }

    pcm.MixReale {
      type dmix
      ipc_key 1024
      slave {
        pcm "hw:0,0"
        rate 48000
        periods 128
        period_time 0
        period_size 1024
        buffer_size 8192
      }
    }

    pcm.MixLoopback {
      type dmix
      ipc_key 1025
      slave {
        pcm "hw:Loopback,0,0"
        rate 48000
        periods 128
        period_time 0
        period_size 1024
        buffer_size 8192
      }
    }
```

Start playing something, then run `obs`, then add Audio Capture Device (ALSA) to your Sources.

![OBS with ALSA](https://i.imgur.com/tc1pMRX.png)

### Bluetooth audio using ALSA
```
sudo emerge bluez-alsa
/etc/init.d/bluealsa start
blueman-manager &
```

~/.asoundrc:
```
pcm.!default {
        type bluealsa
        device "RE:PL:AC:E:TH:IS"
        profile "a2dp"
}
```

### Install Quake 3
```
sudo emerge quake3
sudo wget https://github.com/nrempel/q3-server/raw/master/baseq3/pak{0..8}.pk3 -P /usr/share/games/quake3/baseq3/
ioquake3
```

### What is Gentoo?
Gentoo is a meta-distro. You can make any distro you want out of it. You can have a package.use/package.keywords that makes a binary-compatible Debian or Fedora or Arch or whatever. If there's something you don't like about Gentoo, you can just edit /etc/portage/package.use. Using Gentoo is like distro-hopping around the same distro. Also, by building everything yourself, that's one less botnet. If you have a problem with a package or the package doesn't exist, just add an overlay or write an ebuild and put it in your local portage directory and emerge.

### Is this an overlay?
No, this uses regular Gentoo Portage only. Same versions and USE flag options.

### Benefits of Gentoo/CloverOS over other distros
No systemd, maximized CFLAGS, lower RAM usage, it's Gentoo, package versions are stable, it's as default as possible while still being easy, has Infinality, UTF-8 and user groups configured, installs in 2 minutes, saves time by doing all the little things you would've done anyway.

### What is CloverOS Libre?
CloverOS Libre doesn't have the `sys-kernel/linux-firmware` package.

The kernel is the same gentoo-sources with Liquorix config but with https://linux-libre.fsfla.org/pub/linux-libre/releases/5.0.8-gnu/deblob-5.0 ran on it.

### Turning CloverOS into CloverOS Libre
`emerge -C linux-firmware`

`./cloveros_settings.sh` l) Update libre kernel

Reboot; Advanced options, select -gnu kernel

### Turning CloverOS Libre into CloverOS
`emerge linux-firmware`

`./cloveros_settings.sh` 4) Update kernel

Reboot; Advanced options, select -gentoo kernel

### Starting X automatically after login
Edit `~/.bash_profile`

Comment out

`read -erp "Start X? [y/n] " -n 1 choice`

And add in

`choice=y`

### I want to bypass the mixer to play >48KHz audio / DSD
Edit ~/.asoundrc:

```
pcm.!default {
  type hw
  card 0
}
```

Replace card 0 with your device number

### Wayland howto
```
emerge weston
useradd weston-launch
gpasswd -a youruser weston-launch
echo '[core]
modules=xwayland.so' >> ~/.config/weston.ini
XDG_RUNTIME_DIR=. weston-launch
```

### Things preventing CloverOS Libre from being 100% free software:
- LiveCD kernel is taken from Gentoo, it needs to be made from scratch

- /usr/portage/ needs to be filtered to not include the .ebuilds of proprietary software, also requiring a separate Portage mirror

- It needs a cloveros.ga mirror that doesn't host the non-free software packages

### Does CloverOS have binaries?
Yes. It's a pre-setup Gentoo image with `PORTAGE_BINHOST="https://cloveros.ga" emerge -G package` preset in /etc/portage/make.conf. It uses Gentoo for everything (versions, ebuilds, etc.) and gets packages from cloveros.ga instead of building

### How often is this updated?
It's stable rolling release (Gentoo Stable). The binaries reflect current Portage (amd64) about once a week: http://twitter.com/cloveros_ga

### Does everything build with CFLAGS="-Ofast -mssse3 -mfpmath=both -pipe -funroll-loops -flto=8 -fgraphite-identity -floop-nest-optimize -malign-data=cacheline -mtls-dialect=gnu2 -Wl,--hash-style=gnu"
These are all the packages that don't build with the full CFLAGS: https://gitgud.io/cloveros/cloveros/blob/master/binhost_settings/etc/portage/package.env

### The default shell is bash but fvwm launches urxvt -e zsh?
This is done to keep it as default as possible.

### Which DE does this come with?
None, it comes with fvwm and a `~/.bash_profile` that can select/install a DE for you:

![bash profile](https://i.imgur.com/YD4IPRf.png)

### Installing a DE
First, connect to wifi using wpa_gui ('wifi' in fvwm)

Kill X and re-login. After you log in and the "Start X?" dialog pops up, instead of y/n, type one of the WM options and hit y when it asks to install.

### I want to donate/host a mirror
Run `rsync -av --delete rsync://nl.cloveros.ga/cloveros /your/webserver/location/` and link me the https://

### Disabling Intel mitigations for performance
```
sudo GRUB_CMDLINE_LINUX_DEFAULT="kpti=0 l1tf=off pti=off spectre_v2=off spectre_v2_user=off spec_store_bypass_disable=off ssbd=force-off" grub-mkconfig -o /boot/grub/grub.cfg
```

Make sure the computer you run this on has nothing important on it. (Dedicated gaming machines, etc.)

### Recompiling all packages and kernel with -march=native for increased performance
```
./cloveros_settings.sh c
./cloveros_settings.sh o
./cloveros_settings.sh 5
sudo emerge -eDv --jobs=4 --keep-going=y @world

sudo emerge gentoo-sources genkernel lz4
sudo eselect kernel set 1
wget https://raw.githubusercontent.com/damentz/liquorix-package/master/linux-liquorix/debian/config/kernelarch-x86/config-arch-64
sed -i "s/CONFIG_CRYPTO_CRC32C=m/CONFIG_CRYPTO_CRC32C=y/; s/CONFIG_FW_LOADER_USER_HELPER=y/CONFIG_FW_LOADER_USER_HELPER=n/; s/CONFIG_I2C_NVIDIA_GPU=/#CONFIG_I2C_NVIDIA_GPU=/" config-arch-64
echo -e "CONFIG_SND_HDA_INPUT_BEEP=y\nCONFIG_SND_HDA_INPUT_BEEP_MODE=0" >> config-arch-64
wget https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch
sudo sh -c "patch -d /usr/src/linux/ -p1 < enable_additional_cpu_optimizations_for_gcc_v8.1+_kernel_v4.13+.patch" 
sed -i "s/CONFIG_GENERIC_CPU=y/CONFIG_MNATIVE=y/;" config-arch-64
sudo binutils-config --linker ld.bfd
sudo genkernel --kernel-config=config-arch-64 all
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo emerge -b @module-rebuild
sudo binutils-config --linker ld.gold
```

To update the system using source: `./cloveros_settings.sh c && sudo emerge --sync && sudo emerge -uavDN world`

To remove dbus: `sudo USE="-dbus" emerge -1 glib qtgui && sudo emerge --depclean`

### What if CloverOS dies? Will my install become useless?
No. Switch to source by running `./cloveros_settings.sh 5`

Or:

Edit `/etc/portage/make.conf` and edit the following line:

`EMERGE_DEFAULT_OPTS="--keep-going=y --autounmask-write=y --jobs=4 -G"`

to

`EMERGE_DEFAULT_OPTS="--keep-going=y --autounmask-write=y --jobs=4"`

and comment out the following lines, eg:

```
ACCEPT_KEYWORDS="**"
FETCHCOMMAND_HTTPS="...
```

to

```
#ACCEPT_KEYWORDS="**"    
#FETCHCOMMAND_HTTPS="...
```

Your system is now Gentoo Linux.

After emerge determines what it needs to install and checks dependencies, the -G switch tells emerge to check the binhost before it starts building source. Removing -G reverts to regular emerge operation. It's exactly the same as running `PORTAGE_BINHOST="https://cloveros.ga" emerge -G package` on any Gentoo install. Because it still uses Gentoo repo (versions, ebuilds), and only uses CloverOS as a binhost, you still need to run `emerge --sync`.

CloverOS is a default Gentoo install with programs and with the above defaulted in `/etc/portage/make.conf`. There's also some configuration files and scripts in the user's home directory for making things easier. With those files removed, CloverOS becomes a default Gentoo install.

You can see exactly what's done here: https://gitgud.io/cloveros/cloveros/blob/master/livecd_build.sh
